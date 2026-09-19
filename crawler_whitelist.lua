local crawler_whitelist = {}

local helpers =
    require(
        'scripts/ezlibs-scripts/helpers'
    )

local ezmemory =
    require(
        'scripts/ezlibs-scripts/ezmemory'
    )

local enums =
    require(
        'scripts/libs/enums'
    )

local AssetType =
    enums.AssetType

local PackageType =
    enums.PackageType


-- ============================================================
-- CONFIG
-- ============================================================

local BASE_WHITELIST_DISK_PATH =
    "./assets/whitelist.txt"

local GENERATED_WHITELIST_DIR =
    "/server/assets/generated_whitelists"


-- Temporary prototype behavior.
--
-- Bubbler stays locked in default and depth 0.
-- Reaching depth 1 unlocks it for the current run.
--
-- REMOVE this after the whitelist prototype is verified.
local DEBUG_UNLOCK_CARD =
    "bubbler"

local DEBUG_UNLOCK_DEPTH =
    1


-- ============================================================
-- CARD REGISTRY
-- ============================================================

-- Anything registered here is LOCKED BY DEFAULT.
--
-- Chips that should always be usable simply remain in
-- assets/whitelist.txt and DO NOT need to be registered here.
--
-- We will expand this table when you decide which chips belong
-- to Blue Mystery Data, virus drops, and shops.
crawler_whitelist.CARDS = {
    bubbler = {
        package_id =
            "rune.wcity.legacy.bubbler",

        asset_path =
            "/server/assets/chips/EXE3-Bubbler.zip",

        code = "P",

        -- We are intentionally NOT assigning its real reward
        -- source yet. This chip is only our whitelist test.
        sources = {},
    },
}


-- ============================================================
-- PACKAGE INDEXES
-- ============================================================

local card_key_by_package_id = {}
local locked_by_default = {}

for card_key, card_def in
    pairs(crawler_whitelist.CARDS)
do
    card_def.card_key =
        card_key

    local package_id =
        card_def.package_id

    if
        package_id and
        package_id ~= ""
    then
        card_key_by_package_id[
            package_id
        ] = card_key

        locked_by_default[
            package_id
        ] = true
    end
end


-- ============================================================
-- CACHE
-- ============================================================

local cached_whitelist = {}


-- ============================================================
-- FILE HELPERS
-- ============================================================

local function read_text_file(path)
    local file =
        io.open(
            path,
            "rb"
        )

    if not file then
        return nil
    end

    local text =
        file:read("*a")

    file:close()

    return text
end


local function whitelist_text_hash(text)
    local hash = 0

    for i = 1, #text do
        hash =
            (
                hash * 131 +
                text:byte(i)
            ) % 2147483647
    end

    return tostring(hash)
end


-- ============================================================
-- PLAYER RUN STATE
-- ============================================================

local function get_player_memory(
    player_id
)
    local safe_secret =
        helpers.get_safe_player_secret(
            player_id
        )

    if
        not safe_secret or
        safe_secret == ""
    then
        return nil, nil
    end

    local player_memory =
        ezmemory.get_player_memory(
            safe_secret
        )

    if
        type(player_memory) ~=
        "table"
    then
        return nil, safe_secret
    end

    return player_memory, safe_secret
end


local function get_current_run_unlocks(
    player_id
)
    local player_memory,
          safe_secret =
        get_player_memory(
            player_id
        )

    if not player_memory then
        return {}, safe_secret, false
    end

    local area_id =
        Net.get_player_area(
            player_id
        )

    if not area_id then
        return {}, safe_secret, false
    end

    local area_run_id =
        Net.get_area_custom_property(
            area_id,
            "dungeon_run_id"
        )

    if
        not area_run_id or
        tostring(area_run_id) == "" or
        tostring(area_run_id) == "pool"
    then
        -- Outside a dungeon run, earned run chips are locked.
        return {}, safe_secret, false
    end

    local stored_run_id =
        player_memory.meta and
        player_memory.meta.crawler_run_id

    if
        tostring(stored_run_id or "") ~=
        tostring(area_run_id)
    then
        return {}, safe_secret, false
    end

    if
        type(
            player_memory.crawler_chip_unlocks
        ) ~= "table"
    then
        player_memory.crawler_chip_unlocks =
            {}
    end

    return
        player_memory.crawler_chip_unlocks,
        safe_secret,
        true
end


-- ============================================================
-- WHITELIST GENERATION
-- ============================================================

local function build_player_whitelist_text(
    player_id
)
    local unlocks =
        select(
            1,
            get_current_run_unlocks(
                player_id
            )
        )

    local base_text =
        read_text_file(
            BASE_WHITELIST_DISK_PATH
        )

    if not base_text then
        print(
            "[crawler_whitelist] could not read " ..
            BASE_WHITELIST_DISK_PATH
        )

        return nil
    end

    local out_lines = {}

    for line in
        (base_text .. "\n"):gmatch(
            "(.-)\n"
        )
    do
        local _,
              package_id =
            line:match(
                "^%s*(%S+)%s+(%S+)%s*$"
            )

        if not package_id then
            out_lines[
                #out_lines + 1
            ] = line

        elseif
            not locked_by_default[
                package_id
            ]
        then
            -- Ordinary whitelist entry:
            -- always allowed.
            out_lines[
                #out_lines + 1
            ] = line

        else
            local card_key =
                card_key_by_package_id[
                    package_id
                ]

            if
                card_key and
                unlocks[
                    card_key
                ] == true
            then
                -- Earned during the current run.
                out_lines[
                    #out_lines + 1
                ] = line
            end
        end
    end

    return table.concat(
        out_lines,
        "\n"
    )
end


function crawler_whitelist.apply_for_player(
    player_id
)
    local safe_secret =
        helpers.get_safe_player_secret(
            player_id
        )

    if
        not safe_secret or
        safe_secret == ""
    then
        return false
    end

    local text =
        build_player_whitelist_text(
            player_id
        )

    if not text then
        return false
    end

    local hash =
        whitelist_text_hash(
            text
        )

    local asset_path =
        string.format(
            "%s/%s_%s.txt",
            GENERATED_WHITELIST_DIR,
            safe_secret,
            hash
        )

    local cached =
        cached_whitelist[
            safe_secret
        ]

    if
        not cached or
        cached.text ~= text or
        cached.path ~= asset_path
    then
        Net.update_asset(
            asset_path,
            text
        )

        cached_whitelist[
            safe_secret
        ] = {
            text = text,
            path = asset_path,
        }
    end

    Net.provide_asset_for_player(
        player_id,
        asset_path
    )

    Net.set_mod_whitelist_for_player(
        player_id,
        asset_path
    )

    return true
end


-- ============================================================
-- CARD API
-- ============================================================

function crawler_whitelist.get_card_def(
    card_key
)
    if not card_key then
        return nil
    end

    return crawler_whitelist.CARDS[
        tostring(card_key)
    ]
end


function crawler_whitelist.card_allows_source(
    card_key,
    source
)
    local card_def =
        crawler_whitelist.get_card_def(
            card_key
        )

    if
        not card_def or
        type(card_def.sources) ~=
        "table"
    then
        return false
    end

    return
        card_def.sources[
            source
        ] == true
end


function crawler_whitelist.player_has_card_unlocked(
    player_id,
    card_key
)
    local unlocks,
          _,
          active_run =
        get_current_run_unlocks(
            player_id
        )

    if not active_run then
        return false
    end

    return
        unlocks[
            tostring(card_key)
        ] == true
end


local function provide_card_asset(
    player_id,
    card_def
)
    if
        not card_def or
        not card_def.asset_path
    then
        return
    end

    local hint = {
        asset_type =
            AssetType.DATA,

        package_type =
            PackageType.CARD,
    }

    local ok, err =
        pcall(
            Net.provide_asset_for_player,
            player_id,
            card_def.asset_path,
            hint
        )

    if not ok then
        print(
            "[crawler_whitelist] warning: could not provide card asset: " ..
            tostring(err)
        )
    end
end


function crawler_whitelist.unlock_card(
    player_id,
    card_key
)
    card_key =
        tostring(
            card_key or ""
        )

    local card_def =
        crawler_whitelist.CARDS[
            card_key
        ]

    if not card_def then
        return false,
            "unknown_card"
    end

    local unlocks,
          safe_secret,
          active_run =
        get_current_run_unlocks(
            player_id
        )

    if not active_run then
        return false,
            "not_in_active_run"
    end

    if unlocks[card_key] then
        crawler_whitelist.apply_for_player(
            player_id
        )

        return false,
            "already_unlocked"
    end

    unlocks[
        card_key
    ] = true

    ezmemory.save_player_memory(
        safe_secret
    )

    provide_card_asset(
        player_id,
        card_def
    )

    crawler_whitelist.apply_for_player(
        player_id
    )

    print(
        "[crawler_whitelist] unlocked " ..
        card_key ..
        " for player " ..
        tostring(player_id)
    )

    return true,
        "unlocked"
end


-- ============================================================
-- EZLIBS PLUGIN HANDLERS
-- ============================================================

function crawler_whitelist.handle_player_join(
    player_id
)
    crawler_whitelist.apply_for_player(
        player_id
    )
end


function crawler_whitelist.handle_player_transfer(
    player_id
)
    -- Always apply first.
    --
    -- This means default.tmx and the dungeon root get the
    -- properly restricted whitelist before the debug unlock.
    crawler_whitelist.apply_for_player(
        player_id
    )

    -- ========================================================
    -- TEMPORARY TEST
    -- ========================================================

    if not DEBUG_UNLOCK_CARD then
        return
    end

    local area_id =
        Net.get_player_area(
            player_id
        )

    local run_id =
        Net.get_area_custom_property(
            area_id,
            "dungeon_run_id"
        )

    local depth =
        tonumber(
            Net.get_area_custom_property(
                area_id,
                "dungeon_depth"
            )
        )

    if
        run_id and
        tostring(run_id) ~= "" and
        depth and
        depth >= DEBUG_UNLOCK_DEPTH and
        not crawler_whitelist.player_has_card_unlocked(
            player_id,
            DEBUG_UNLOCK_CARD
        )
    then
        print(
            "[crawler_whitelist] DEBUG depth " ..
            tostring(depth) ..
            " reached; unlocking " ..
            DEBUG_UNLOCK_CARD
        )

        crawler_whitelist.unlock_card(
            player_id,
            DEBUG_UNLOCK_CARD
        )
    end
end


return crawler_whitelist