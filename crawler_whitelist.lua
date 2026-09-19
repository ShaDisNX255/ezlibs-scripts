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

        display_name = "Bubbler",

        sources = {
            blue_mystery = true,
        },
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

local POST_UNLOCK_REWARD_DELAY_TICKS = 20
local REJOIN_REWARD_DELAY_TICKS = 20

local pending_reward_packets = {}

-- Tracks whether this client session has already been
-- rehydrated for a particular dungeon run.
local hydrated_run_for_player = {}


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

local function build_card_reward_entry(
    card_def,
    code
)
    if
        not card_def or
        not card_def.package_id or
        card_def.package_id == ""
    then
        return nil
    end

    return {
        type = 1,
        card_id = card_def.package_id,
        code = code or card_def.code or "*",
    }
end


local function queue_reward_packet(
    player_id,
    rewards,
    ticks
)
    if
        not rewards or
        #rewards == 0
    then
        return false
    end

    local delay =
        math.max(
            1,
            math.floor(
                tonumber(ticks) or
                POST_UNLOCK_REWARD_DELAY_TICKS
            )
        )

    local pending =
        pending_reward_packets[
            player_id
        ]

    if pending then
        -- Don't overwrite an already queued packet.
        -- Add the new rewards to it.
        for _, reward in
            ipairs(rewards)
        do
            pending.rewards[
                #pending.rewards + 1
            ] = reward
        end

        if delay < pending.ticks then
            pending.ticks = delay
        end
    else
        pending_reward_packets[
            player_id
        ] = {
            ticks = delay,
            rewards = rewards,
        }
    end

    return true
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

local function queue_unlocked_cards_for_current_run(
    player_id
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

    local area_id =
        Net.get_player_area(
            player_id
        )

    if not area_id then
        return false
    end

    local run_id =
        Net.get_area_custom_property(
            area_id,
            "dungeon_run_id"
        )

    if
        not run_id or
        tostring(run_id) == "" or
        tostring(run_id) == "pool"
    then
        return false
    end

    run_id =
        tostring(run_id)

    -- Already restored this run during this connection.
    -- Normal room-to-room transfers must NOT duplicate cards.
    if
        hydrated_run_for_player[
            player_id
        ] == run_id
    then
        return false
    end

    local rewards = {}

    for card_key, is_unlocked in
        pairs(unlocks)
    do
        if is_unlocked == true then
            local card_def =
                crawler_whitelist.CARDS[
                    card_key
                ]

            if card_def then
                -- Re-send the package itself because the
                -- connecting client may not have it locally.
                provide_card_asset(
                    player_id,
                    card_def
                )

                local reward =
                    build_card_reward_entry(
                        card_def,
                        card_def.code
                    )

                if reward then
                    rewards[
                        #rewards + 1
                    ] = reward
                end
            end
        end
    end

    -- Mark this even if the player currently owns no unlocked
    -- chips. Otherwise every room transfer would repeat this scan.
    hydrated_run_for_player[
        player_id
    ] = run_id

    if #rewards > 0 then
        print(
            "[crawler_whitelist] restoring " ..
            tostring(#rewards) ..
            " unlocked chip(s) for run " ..
            run_id ..
            " player " ..
            tostring(player_id)
        )

        queue_reward_packet(
            player_id,
            rewards,
            REJOIN_REWARD_DELAY_TICKS
        )
    end

    return true
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
            "unknown_card",
            nil
    end

    local unlocks,
          safe_secret,
          active_run =
        get_current_run_unlocks(
            player_id
        )

    if not active_run then
        return false,
            "not_in_active_run",
            card_def
    end

    if unlocks[card_key] then
        crawler_whitelist.apply_for_player(
            player_id
        )

        return false,
            "already_unlocked",
            card_def
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

    local reward =
        build_card_reward_entry(
            card_def,
            card_def.code
        )

    if reward then
        queue_reward_packet(
            player_id,
            { reward },
            POST_UNLOCK_REWARD_DELAY_TICKS
        )
    end

    print(
        "[crawler_whitelist] unlocked " ..
        card_key ..
        " for player " ..
        tostring(player_id)
    )

    return true,
        "unlocked",
        card_def
end

function crawler_whitelist.unlock_card_from_source(
    player_id,
    card_key,
    source
)
    if not crawler_whitelist.card_allows_source(
        card_key,
        source
    ) then
        return false,
            "source_not_allowed",
            crawler_whitelist.get_card_def(
                card_key
            )
    end

    return crawler_whitelist.unlock_card(
        player_id,
        card_key
    )
end


function crawler_whitelist.get_available_cards_for_source(
    player_id,
    source
)
    local unlocks,
          _,
          active_run =
        get_current_run_unlocks(
            player_id
        )

    if not active_run then
        return {}
    end

    local candidates = {}

    for card_key, card_def in
        pairs(crawler_whitelist.CARDS)
    do
        if
            card_def.sources and
            card_def.sources[source] == true and
            unlocks[card_key] ~= true
        then
            candidates[
                #candidates + 1
            ] = card_key
        end
    end

    -- Keeps the candidate list deterministic before
    -- selecting a random entry.
    table.sort(candidates)

    return candidates
end


function crawler_whitelist.unlock_random_card_from_source(
    player_id,
    source
)
    local candidates =
        crawler_whitelist.get_available_cards_for_source(
            player_id,
            source
        )

    if #candidates == 0 then
        return false,
            "pool_exhausted",
            nil
    end

    local card_key =
        candidates[
            math.random(
                1,
                #candidates
            )
        ]

    local ok,
          reason,
          card_def =
        crawler_whitelist.unlock_card_from_source(
            player_id,
            card_key,
            source
        )

    return
        ok,
        reason,
        card_def,
        card_key
end

-- ============================================================
-- EZLIBS PLUGIN HANDLERS
-- ============================================================

function crawler_whitelist.handle_player_join(
    player_id
)
    pending_reward_packets[
        player_id
    ] = nil

    hydrated_run_for_player[
        player_id
    ] = nil

    crawler_whitelist.apply_for_player(
        player_id
    )

    -- Usually player_join occurs in default.tmx and this does
    -- nothing. If a player ever joins directly into a valid
    -- dungeon run, it also handles that case correctly.
    queue_unlocked_cards_for_current_run(
        player_id
    )
end


function crawler_whitelist.handle_player_transfer(
    player_id
)
    crawler_whitelist.apply_for_player(
        player_id
    )

    -- Restore chips already earned during this run after
    -- reconnecting to the server.
    queue_unlocked_cards_for_current_run(
        player_id
    )
end

function crawler_whitelist.on_tick(
    delta_time
)
    for player_id, packet in
        pairs(pending_reward_packets)
    do
        packet.ticks =
            packet.ticks - 1

        if packet.ticks <= 0 then
            local ok, err =
                pcall(
                    Net.send_player_battle_rewards,
                    player_id,
                    packet.rewards
                )

            if not ok then
                print(
                    "[crawler_whitelist] failed sending chip rewards: " ..
                    tostring(err)
                )
            end

            pending_reward_packets[
                player_id
            ] = nil
        end
    end
end


function crawler_whitelist.handle_player_disconnect(
    player_id
)
    pending_reward_packets[
        player_id
    ] = nil

    hydrated_run_for_player[
        player_id
    ] = nil
end

return crawler_whitelist