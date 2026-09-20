local ezwarps = require('scripts/ezlibs-scripts/ezwarps/main')
local ezmemory = require('scripts/ezlibs-scripts/ezmemory')
local helpers = require('scripts/ezlibs-scripts/helpers')
local eztriggers = require('scripts/ezlibs-scripts/eztriggers')
local object_registry = require('scripts/ezlibs-scripts/object_registry')
local ezbus = require('scripts/ezlibs-scripts/ezbus')
local ezconfig = require('scripts/ezlibs-scripts/ezconfig')
local crawler_whitelist =
    require(
        'scripts/ezlibs-scripts/crawler_whitelist'
    )

local crawler_encounter_config =
    require(
        'scripts/ezlibs-scripts/crawler_encounter_config'
    )

local ezencounters = {}
local players_in_encounters = {}
local player_last_position = {}
local player_steps_since_encounter = {}
local named_encounters = {}
local provided_encounter_assets = {}
local encounter_finished_callbacks = {}

-- Ensure encounters directory exists
helpers.ensure_directory(ezconfig.ENCOUNTERS_PATH)

local load_battle_rewards = function ()
    local rewards_path = ezconfig.ENCOUNTERS_PATH .. 'rewards'
    local status, rewards = pcall(function () return require(rewards_path) end)
    if status and type(rewards) == 'table' then
        print('[ezencounters] loaded battle rewards')
        return rewards
    end
    return nil
end

local battle_rewards = load_battle_rewards()

local battle_reward_types = {
    money = 0,
    hp = 2,
    bugfrags = 3,
}

local get_reward_tier = function(
    score
)
    score =
        tonumber(score) or 0

    if score >= 9 then
        return "high"
    end

    if score >= 5 then
        return "mid"
    end

    return "low"
end


local get_enemy_reward_table = function(
    enemy
)
    if
        not battle_rewards or
        not enemy
    then
        return nil
    end


    local drops =
        battle_rewards.drops or
        battle_rewards


    local enemy_rewards =
        drops[
            enemy.name
        ]


    if type(enemy_rewards) ~= "table" then
        return nil
    end


    return
        enemy_rewards[
            enemy.rank
        ] or
        enemy_rewards[
            tostring(
                enemy.rank
            )
        ]
end


local pick_reward_enemy = function(
    encounter_info
)
    local candidates = {}


    for _, enemy in ipairs(
        (
            encounter_info and
            encounter_info.enemies
        ) or {}
    )
    do
        if
            type(enemy) == "table" and
            tonumber(
                enemy.team or 1
            ) ~= 2
        then
            candidates[
                #candidates + 1
            ] =
                enemy
        end
    end


    if #candidates == 0 then
        return nil
    end


    return candidates[
        math.random(
            #candidates
        )
    ]
end


local get_money_value = function(
    reward_table,
    difficulty,
    tier
)
    if
        reward_table and
        type(
            reward_table.money
        ) == "table"
    then
        local value =
            tonumber(
                reward_table.money[
                    tier
                ]
            )

        if value then
            return math.floor(
                value
            )
        end
    end


    local money_cfg =
        battle_rewards and
        battle_rewards.money


    local difficulty_cfg =
        money_cfg and
        money_cfg[
            difficulty
        ]


    return math.floor(
        tonumber(
            difficulty_cfg and
            difficulty_cfg[
                tier
            ]
        ) or 0
    )
end


local get_chip_chance = function(
    reward_table,
    difficulty,
    tier
)
    if
        reward_table and
        type(
            reward_table.chip_chances
        ) == "table"
    then
        local override =
            tonumber(
                reward_table.chip_chances[
                    tier
                ]
            )

        if override then
            return override
        end
    end


    local chances =
        battle_rewards and
        battle_rewards.chip_chances


    local difficulty_chances =
        chances and
        chances[
            difficulty
        ]


    return tonumber(
        difficulty_chances and
        difficulty_chances[
            tier
        ]
    ) or 0
end


local get_battle_reward = function(
    player_id,
    encounter_info,
    stats,
    persistent_health
)
    if
        not battle_rewards or
        not stats or
        stats.reason ~= 1
    then
        return nil,
            0,
            nil
    end


    local source_enemy =
        pick_reward_enemy(
            encounter_info
        )


    if not source_enemy then
        return nil,
            0,
            nil
    end


    local reward_table =
        get_enemy_reward_table(
            source_enemy
        )


    local difficulty =
        (
            reward_table and
            reward_table.difficulty
        ) or
        (
            encounter_info and
            encounter_info._crawler_reward_tier
        ) or
        "easy"


    if difficulty == "boss" then
        difficulty =
            "hard"
    end


    local health =
        tonumber(
            stats.health
        ) or 0


    local max_health =
        tonumber(
            Net.get_player_max_health(
                player_id
            )
        ) or 0


    local recovery =
        reward_table and
        reward_table.low_hp_recovery


    if not recovery then
        recovery =
            battle_rewards.low_hp_recovery
    end


    local recovery_reward =
        nil


    -- Low-HP recovery is an ADDITIONAL reward.
    --
    -- It does NOT replace the normal chip-or-money reward.
    if
        persistent_health and
        type(recovery) == "table" and
        max_health > 0
    then
        local threshold =
            tonumber(
                recovery.threshold
            ) or 0.375


        local value =
            math.floor(
                tonumber(
                    recovery.value
                ) or 0
            )


        if
            value > 0 and
            health <
                max_health *
                threshold
        then
            recovery_reward = {
                type = "hp",
                value = value,
            }
        end
    end


    local function finish_reward(
        primary_reward,
        delay_ticks,
        post_send_chip_key
    )
        return
            primary_reward,
            delay_ticks or 0,
            recovery_reward,
            post_send_chip_key
    end


    local tier =
        get_reward_tier(
            stats.score
        )


    local money =
        get_money_value(
            reward_table,
            difficulty,
            tier
        )


    local chip_key =
        reward_table and
        (
            reward_table.chip or
            reward_table.card
        )


    -- No chip configured for this virus/rank.
    --
    -- This is intentional for viruses that do not have
    -- an assigned battle chip. They simply award money.
    if not chip_key then
        if money > 0 then
            return finish_reward(
                {
                    type = "money",
                    value = money,
                },
                0
            )
        end


        return finish_reward(
            nil,
            0
        )
    end


    local chip_chance =
        get_chip_chance(
            reward_table,
            difficulty,
            tier
        )


    -- Failed chip roll -> money.
    if math.random() > chip_chance then
        if money > 0 then
            return finish_reward(
                {
                    type = "money",
                    value = money,
                },
                0
            )
        end


        return finish_reward(
            nil,
            0
        )
    end


    -- Successful chip roll, but duplicate chips are not
    -- currently supported by ONB.
    --
    -- Give the appropriate money reward instead.
    if crawler_whitelist.player_has_card_unlocked(
        player_id,
        chip_key
    ) then
        if money > 0 then
            return finish_reward(
                {
                    type = "money",
                    value = money,
                },
                0
            )
        end


        return finish_reward(
            nil,
            0
        )
    end


    local ready,
          reason,
          _,
          card_reward =
        crawler_whitelist.prepare_card_for_battle_reward(
            player_id,
            chip_key
        )


    if
        ready and
        card_reward
    then
        print(
            "[ezencounters] battle chip drop " ..
            tostring(chip_key) ..
            " from " ..
            tostring(source_enemy.name) ..
            " rank=" ..
            tostring(source_enemy.rank) ..
            " tier=" ..
            tostring(tier)
        )

        return finish_reward(
            card_reward,
            0,
            chip_key
        )
    end


    print(
        "[ezencounters] chip reward fallback to money: " ..
        tostring(chip_key) ..
        " reason=" ..
        tostring(reason)
    )


    if money > 0 then
        return finish_reward(
            {
                type = "money",
                value = money,
            },
            0
        )
    end


    return finish_reward(
        nil,
        0
    )
end

local normalize_battle_rewards = function (player_id, rewards, stats, persistent_health)
    local native_rewards = {}
    local money = 0
    local bugfrags = 0
    local recovery = 0
    local health = math.floor(tonumber(stats and stats.health) or 0)
    local max_health = tonumber(Net.get_player_max_health(player_id)) or health
    local missing_health = math.max(0, max_health - health)

    for _, reward in ipairs(rewards or {}) do
        if type(reward) == 'table' then
            local reward_type = reward.type
            local native_type = battle_reward_types[reward_type]

            if reward_type == 'chip' then
                native_type = 1
            elseif type(reward_type) == 'number' then
                native_type = reward_type
            end

            if native_type == 1 and reward.card_id then
                native_rewards[#native_rewards + 1] = {
                    type = 1,
                    card_id = reward.card_id,
                    code = reward.code or '*',
                }
            elseif native_type == battle_reward_types.money then
                local value = math.floor(tonumber(reward.value) or 0)
                if value > 0 then
                    native_rewards[#native_rewards + 1] = {type=native_type,value=value}
                    money = money + value
                end
            elseif native_type == battle_reward_types.bugfrags then
                local value = math.floor(tonumber(reward.value) or 0)
                if value > 0 then
                    native_rewards[#native_rewards + 1] = {type=native_type,value=value}
                    bugfrags = bugfrags + value
                end
            elseif native_type == battle_reward_types.hp and persistent_health then
                local value = math.floor(tonumber(reward.value) or 0)
                value = math.min(value, missing_health)
                if value > 0 then
                    native_rewards[#native_rewards + 1] = {type=native_type,value=value}
                    recovery = recovery + value
                    missing_health = missing_health - value
                end
            end
        end
    end

    return native_rewards, money, bugfrags, recovery
end

local send_battle_rewards = function (player_id, rewards, stats, persistent_health)
    local native_rewards, money, bugfrags, recovery = normalize_battle_rewards(
        player_id,
        rewards,
        stats,
        persistent_health
    )

    local current_money = nil
    if money > 0 then
        current_money = ezmemory.get_player_money(player_id)
    end

    local current_fragments = nil
    if bugfrags > 0 then
        current_fragments = ezmemory.get_player_fragments(player_id)
    end

if #native_rewards > 0 then
    for index, reward in
        ipairs(native_rewards)
    do
        print(
            "[ezencounters][REWARD DEBUG]" ..
            " index=" ..
            tostring(index) ..
            " type=" ..
            tostring(reward.type) ..
            " card_id=" ..
            tostring(reward.card_id) ..
            " code=" ..
            tostring(reward.code) ..
            " value=" ..
            tostring(reward.value)
        )
    end


    Net.send_player_battle_rewards(
        player_id,
        native_rewards
    )
end

    if current_money ~= nil then
        ezmemory.set_player_money(player_id, current_money + money)
    end

    if current_fragments ~= nil then
        ezmemory.set_player_fragments(player_id, current_fragments + bugfrags)
    end

    return recovery
end

local pending_battle_reward_packets =
    {}

local pending_post_reward_unlocks =
    {}

local queue_post_reward_unlock =
    function(
        player_id,
        card_key
    )
        pending_post_reward_unlocks[
            player_id
        ] = {
            ticks = 1,
            card_key = card_key,
        }
    end

local queue_battle_reward_packet =
    function(
        player_id,
        rewards,
        stats,
        persistent_health,
        ticks
    )
        pending_battle_reward_packets[
            player_id
        ] = {
            ticks =
                math.max(
                    1,
                    math.floor(
                        tonumber(
                            ticks
                        ) or 1
                    )
                ),

            rewards =
                rewards,

            stats = {
                health =
                    stats and
                    stats.health or 0,
            },

            persistent_health =
                persistent_health,
        }
    end


Net:on("tick", function()
    for player_id, packet in pairs(pending_battle_reward_packets) do
        packet.ticks = packet.ticks - 1

        if packet.ticks <= 0 then
            if Net.is_player(player_id) then
                send_battle_rewards(
                    player_id,
                    packet.rewards,
                    packet.stats,
                    packet.persistent_health
                )
            end

            pending_battle_reward_packets[player_id] = nil
        end
    end

    for player_id, packet in pairs(pending_post_reward_unlocks) do
        packet.ticks = packet.ticks - 1

        if packet.ticks <= 0 then
            if Net.is_player(player_id) then
                print(
                    "[ezencounters][POST REWARD UNLOCK] " ..
                    tostring(packet.card_key)
                )

                crawler_whitelist.commit_card_after_battle_reward(
                    player_id,
                    packet.card_key
                )
            end

            pending_post_reward_unlocks[player_id] = nil
        end
    end
end)

local persist_battle_health = function (player_id, stats, recovery)
    local health = math.floor(tonumber(stats and stats.health) or 0)
    local max_health = tonumber(Net.get_player_max_health(player_id)) or health

    health = health + math.max(0, math.floor(tonumber(recovery) or 0))

    health = math.min(health, max_health)
    ezmemory.set_player_health(player_id, health)
end

local load_encounters_for_areas = function ()
    local areas = Net.list_areas()
    local area_encounter_tables = {}
    for i, area_id in ipairs(areas) do
        local encounter_table_path = ezconfig.ENCOUNTERS_PATH .. area_id
        local status, err = pcall(function () require(encounter_table_path) end)
        if status == true then
            area_encounter_tables[area_id] = require(encounter_table_path)
            for index, encounter_info in ipairs(area_encounter_tables[area_id].encounters) do
                if not provided_encounter_assets[encounter_info.path] then
                    print('[ezencounters] providing mob package '..encounter_info.path)
                    Net.provide_asset(area_id, encounter_info.path)
                    provided_encounter_assets[encounter_info.path] = true
                end
                if encounter_info.name then
                    print('[ezencounters] loaded named encounter '..encounter_info.name)
                    named_encounters[encounter_info.name] = encounter_info
                end
            end
            print('[ezencounters] loaded encounter table for '..area_id)
        end
    end
    return area_encounter_tables
end

local area_encounter_tables = load_encounters_for_areas()

-- ============================================================
-- CRAWLER RANDOM ENCOUNTERS
-- ============================================================

local CRAWLER_ENEMY_CELLS = {
    {x=4,y=1},
    {x=5,y=1},
    {x=6,y=1},

    {x=4,y=2},
    {x=5,y=2},
    {x=6,y=2},

    {x=4,y=3},
    {x=5,y=3},
    {x=6,y=3},
}


local function crawler_shuffle(
    list
)
    for i = #list, 2, -1 do
        local j =
            math.random(i)

        list[i],
        list[j] =
            list[j],
            list[i]
    end

    return list
end


local function crawler_pick_distinct(
    source,
    count
)
    local copy = {}


    for index,
        value
        in ipairs(source or {})
    do
        copy[index] =
            value
    end


    crawler_shuffle(
        copy
    )


    local out = {}


    for i = 1,
        math.min(
            count,
            #copy
        )
    do
        out[
            #out + 1
        ] =
            copy[i]
    end


    return out
end


local function crawler_blank_positions()
    return {
        {0,0,0,0,0,0},
        {0,0,0,0,0,0},
        {0,0,0,0,0,0},
    }
end


local function crawler_get_master_pool(
    difficulty
)
    if difficulty == "easy" then
        return crawler_encounter_config.easy_pool
    end


    if difficulty == "medium" then
        return crawler_encounter_config.medium_pool
    end


    -- Boss territory uses the Hard normal-virus universe.
    if
        difficulty == "hard" or
        difficulty == "boss"
    then
        return crawler_encounter_config.hard_pool
    end


    return nil
end


local function crawler_create_area_pool(
    difficulty
)
    local master_pool =
        crawler_get_master_pool(
            difficulty
        )


    if
        not master_pool or
        #master_pool == 0
    then
        return {}
    end


    local pool_size =
        crawler_encounter_config.area_pool_size[
            difficulty
        ] or 7


    return crawler_pick_distinct(
        master_pool,
        pool_size
    )
end


local function crawler_build_positions(
    enemy_count
)
    local positions =
        crawler_blank_positions()


    local cells =
        crawler_pick_distinct(
            CRAWLER_ENEMY_CELLS,
            enemy_count
        )


    for index,
        cell
        in ipairs(cells)
    do
        positions[
            cell.y
        ][
            cell.x
        ] =
            index
    end


    return positions
end


local function crawler_pool_to_string(
    pool
)
    local parts = {}


    for _, enemy in
        ipairs(pool or {})
    do
        parts[
            #parts + 1
        ] =
            tostring(
                enemy.name
            ) ..
            "[" ..
            tostring(
                enemy.rank
            ) ..
            "]"
    end


    return table.concat(
        parts,
        ", "
    )
end


local function get_or_create_crawler_area_table(
    area_id
)
    if not area_id then
        return nil
    end


    if area_encounter_tables[
        area_id
    ] then
        return area_encounter_tables[
            area_id
        ]
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
        return nil
    end


    local room_type =
        Net.get_area_custom_property(
            area_id,
            "dungeon_room_type"
        )


    -- Rest areas remain safe.
    if room_type == "lobby" then
        return nil
    end


    local difficulty =
        Net.get_area_custom_property(
            area_id,
            "dungeon_difficulty"
        )


    if
        difficulty ~= "easy" and
        difficulty ~= "medium" and
        difficulty ~= "hard" and
        difficulty ~= "boss"
    then
        return nil
    end


    local reward_tier =
        Net.get_area_custom_property(
            area_id,
            "dungeon_reward_tier"
        )


    if
        reward_tier ~= "easy" and
        reward_tier ~= "medium" and
        reward_tier ~= "hard"
    then
        reward_tier =
            difficulty == "boss"
                and "hard"
                or difficulty
    end


    local area_pool =
        crawler_create_area_pool(
            difficulty
        )


    if #area_pool == 0 then
        return nil
    end


    local encounter_table = {
        persistent_health =
            true,

        minimum_steps_before_encounter =
            crawler_encounter_config.minimum_steps_before_encounter,

        encounter_chance_per_step =
            crawler_encounter_config.encounter_chance_per_step,

        crawler_random =
            true,

        crawler_difficulty =
            difficulty,

        crawler_reward_tier =
            reward_tier,

        crawler_pool =
            area_pool,

        encounters =
            {},
    }


    area_encounter_tables[
        area_id
    ] =
        encounter_table


    Net.provide_asset(
        area_id,
        crawler_encounter_config.package_path
    )


    print(
        "[ezencounters][crawler] created " ..
        tostring(difficulty) ..
        " encounter pool for " ..
        tostring(area_id) ..
        ": " ..
        crawler_pool_to_string(
            area_pool
        )
    )


    return encounter_table
end


local function build_crawler_random_encounter(
    area_id,
    encounter_table
)
    local difficulty =
        encounter_table.crawler_difficulty


    -- --------------------------------------------------------
    -- BOSS ROLL
    -- --------------------------------------------------------

    if
        difficulty == "boss" and
        math.random() <
            crawler_encounter_config.boss_chance
    then
        local boss_pool =
            crawler_encounter_config.boss_pool


        if
            boss_pool and
            #boss_pool > 0
        then
            local boss =
                boss_pool[
                    math.random(
                        #boss_pool
                    )
                ]


            return {
                name =
                    "CrawlerBoss_" ..
                    tostring(area_id) ..
                    "_" ..
                    tostring(
                        math.random(
                            1000000
                        )
                    ),

                path =
                    crawler_encounter_config.package_path,

                enemies = {
                    {
                        name =
                            boss.name,

                        rank =
                            boss.rank,
                    },
                },

                positions =
                    crawler_build_positions(
                        1
                    ),

                _crawler_reward_tier =
                    "hard",

                _crawler_boss =
                    true,
            }
        end
    end


    -- --------------------------------------------------------
    -- NORMAL VIRUS ENCOUNTER
    -- --------------------------------------------------------

    local count_cfg =
        crawler_encounter_config.enemy_count[
            difficulty
        ]


    if not count_cfg then
        return nil
    end


    local enemy_count =
        math.random(
            count_cfg.min,
            count_cfg.max
        )


    enemy_count =
        math.min(
            enemy_count,
            #encounter_table.crawler_pool,
            #CRAWLER_ENEMY_CELLS
        )


    local chosen =
        crawler_pick_distinct(
            encounter_table.crawler_pool,
            enemy_count
        )


    local enemies = {}


    for _, enemy in
        ipairs(chosen)
    do
        enemies[
            #enemies + 1
        ] = {
            name =
                enemy.name,

            rank =
                enemy.rank,
        }
    end


    return {
        name =
            "CrawlerRandom_" ..
            tostring(area_id) ..
            "_" ..
            tostring(
                math.random(
                    1000000
                )
            ),

        path =
            crawler_encounter_config.package_path,

        enemies =
            enemies,

        positions =
            crawler_build_positions(
                #enemies
            ),

        _crawler_reward_tier =
            encounter_table.crawler_reward_tier,

        _crawler_boss =
            false,
    }
end

local function should_record_step(player_id)
    local player_area = Net.get_player_area(player_id)
    if not player_last_position[player_id] then
        return false
    end
    if Net.is_player_battling(player_id) then
        return false
    end
    if ezwarps.player_is_in_animation(player_id) then
        return false
    end
    local last_pos = player_last_position[player_id]
    local last_tile = Net.get_tile(player_area, last_pos.x, last_pos.y, last_pos.z) -- { gid, flipped_horizontally, flipped_vertically, rotated }
    local tile_tileset_info =  Net.get_tileset_for_tile(player_area, last_tile.gid) -- { path, first_gid }?
    if not tile_tileset_info then
        return false
    end
    if string.find(tile_tileset_info.path,'conveyer') then
        return false
    end
    return true
end

ezencounters.increment_steps_since_encounter = function (player_id)
    if not should_record_step(player_id) then
        return
    end
    local player_area = Net.get_player_area(player_id)
    local encounter_table =
        area_encounter_tables[
            player_area
        ] or
        get_or_create_crawler_area_table(
            player_area
        )
    if not player_steps_since_encounter[player_id] then
        player_steps_since_encounter[player_id] = 1
    else
        player_steps_since_encounter[player_id] = player_steps_since_encounter[player_id] + 1
    end
    if encounter_table then
        if player_steps_since_encounter[player_id] >= encounter_table.minimum_steps_before_encounter then
            ezencounters.try_random_encounter(player_id,encounter_table)
        end
    end
end

ezencounters.handle_player_move = function(player_id, x, y, z)
    local floor = math.floor
    local rounded_pos_x = floor(x)
    local rounded_pos_y = floor(y)
    local rounded_pos_z = floor(z)
    local last_tile = player_last_position[player_id]
    if last_tile then
        if last_tile.x ~= rounded_pos_x or last_tile.y ~= rounded_pos_y or last_tile.z ~= rounded_pos_z then
            --player has moved to a different tile
            player_last_position[player_id] = {x=rounded_pos_x,y=rounded_pos_y,z=rounded_pos_z}
        end
    else
        player_last_position[player_id] = {x=rounded_pos_x,y=rounded_pos_y,z=rounded_pos_z}
    end
    ezencounters.increment_steps_since_encounter(player_id)
end

ezencounters.pick_encounter_from_table = function (encounter_table)
    local total_weight = 0
    for _, option in ipairs(encounter_table.encounters) do
        total_weight = total_weight + option.weight
    end
    local crawler = math.random() * total_weight
    for i, option in ipairs(encounter_table.encounters) do
        crawler = crawler - option.weight
        if crawler <= 0 then
            return encounter_table.encounters[i]
        end
    end
    return encounter_table.encounters[1]
end

ezencounters.try_random_encounter =
    function(
        player_id,
        encounter_table
    )
        if
            math.random() >
            encounter_table.encounter_chance_per_step
        then
            return
        end


        local encounter_info


        if encounter_table.crawler_random then
            local player_area =
                Net.get_player_area(
                    player_id
                )


            encounter_info =
                build_crawler_random_encounter(
                    player_area,
                    encounter_table
                )
        else
            encounter_info =
                ezencounters.pick_encounter_from_table(
                    encounter_table
                )
        end


        if not encounter_info then
            return
        end


        ezencounters.begin_encounter(
            player_id,
            encounter_info
        )
    end

-- FIXED: Now returns the stats
ezencounters.begin_encounter_by_name = function(player_id,encounter_name,trigger_object)
    return async(function ()
        local encounter_info = named_encounters[encounter_name]
        if encounter_info then
            local stats = await(ezencounters.begin_encounter(player_id,encounter_info,trigger_object))
            return stats
        else
            print('[ezencounters] no encounter with name ',encounter_name,' has been added to any encounter tables!')
            return nil
        end
    end)
end

ezencounters.begin_encounter = function (player_id,encounter_info,trigger_object)
    return async(function ()
        --print('[ezencounters] beginning encounter for',player_id)
        local player_area = Net.get_player_area(player_id)
        local encounter_table = area_encounter_tables[player_area]
        players_in_encounters[player_id] = {
            encounter_info=encounter_info,
            persistent_health=encounter_table and encounter_table.persistent_health == true
        }
        ezencounters.clear_tiles_since_encounter(player_id)
        ezbus:emit("encounter_started", {
            player_id = player_id,
            encounter_info = encounter_info,
            trigger_object = trigger_object
        })
        local stats = await(Async.initiate_encounter(player_id,encounter_info.path,encounter_info))
        return stats
    end)
end

ezencounters.clear_tiles_since_encounter = function (player_id)
    player_steps_since_encounter[player_id] = nil
end

ezencounters.clear_last_position = function (player_id)
    print('[ezencounters] clearing last position')
    player_last_position[player_id] = nil
    ezencounters.clear_tiles_since_encounter(player_id)
    players_in_encounters[player_id] = nil
end

Net:on("battle_results", function(event)
    local player_id = event.player_id

    if players_in_encounters[player_id] then
        local player_encounter = players_in_encounters[player_id]

        if encounter_finished_callbacks[player_id] then
            encounter_finished_callbacks[player_id](event)
            encounter_finished_callbacks[player_id] = nil
        end

        local rewards = {}

        local reward,
              reward_delay_ticks,
              recovery_reward,
              post_send_chip_key =
            get_battle_reward(
                player_id,
                player_encounter.encounter_info,
                event,
                player_encounter.persistent_health
            )

        if recovery_reward then
            rewards[#rewards + 1] = recovery_reward
        end

        if reward then
            rewards[#rewards + 1] = reward
        end

        if player_encounter.encounter_info.results_callback then
            player_encounter.encounter_info.results_callback(
                player_id,
                player_encounter.encounter_info,
                event,
                rewards
            )
        end

        local recovery = 0

        if #rewards > 0 then
            if reward_delay_ticks and reward_delay_ticks > 0 then
                queue_battle_reward_packet(
                    player_id,
                    rewards,
                    event,
                    player_encounter.persistent_health,
                    reward_delay_ticks
                )

                if recovery_reward then
                    recovery = math.max(
                        0,
                        math.floor(
                            tonumber(recovery_reward.value) or 0
                        )
                    )
                end
            else
                recovery = send_battle_rewards(
                    player_id,
                    rewards,
                    event,
                    player_encounter.persistent_health
                )
            end
        end

        -- The battle reward has now been sent/queued.
        -- For chip rewards using the new ordering test, unlock and
        -- provide the package on the following server tick.
        if post_send_chip_key then
            queue_post_reward_unlock(
                player_id,
                post_send_chip_key
            )
        end

        if player_encounter.persistent_health then
            persist_battle_health(
                player_id,
                event,
                recovery
            )
        end

        players_in_encounters[player_id] = nil
    end

    ezbus:emit("encounter_finished", {
        player_id = player_id,
        stats = {
            health = event.health,
            time = event.time,
            reason = event.reason,
            emotion = event.emotion,
            turns = event.turns,
            enemies = event.enemies,
            score = event.score
        }
    })
end)

ezencounters.handle_player_transfer = ezencounters.clear_last_position

ezencounters.handle_player_disconnect = function (player_id)
    encounter_finished_callbacks[player_id] = nil
	pending_battle_reward_packets[player_id] = nil
    pending_post_reward_unlocks[player_id] = nil
    ezencounters.clear_last_position(player_id)
end

local function on_radius_encounter_triggered(event)
    return async(function ()
        print('[ezencounters] radius encounter triggered ',event.object.custom_properties)
        local player_area = Net.get_player_area(event.player_id)
        local is_hidden_already = ezmemory.object_is_hidden_from_player(event.player_id,player_area,event.object.id)
        if is_hidden_already then
            return
        end
        local encounter_name = event.object.custom_properties["Name"]
        local stats = false
        if encounter_name then
            stats = await(ezencounters.begin_encounter_by_name(event.player_id,encounter_name,event.object))
        else
            local encounter_info = {path=event.object.custom_properties["Path"]}
            stats = await(ezencounters.begin_encounter(event.player_id,encounter_info,event.object))
        end
        if stats then
            if stats.reason ~= 1 then
                return stats -- dont hide the encounter if the player ran, lost, or used dev escape
            end
            local player_area = Net.get_player_area(event.player_id)
            if event.object.custom_properties["Once"] == "true" then
                ezmemory.hide_object_from_player(event.player_id,player_area,event.object.id)
            end
        end
        ezmemory.hide_object_from_player_till_disconnect(event.player_id,player_area,event.object.id)
    end)
end

-- Register handler for Radius Encounter objects
object_registry.register_handler("Radius Encounter", function(area_id, object)
    local radius = tonumber(object.custom_properties["Radius"] or 1)
    local emitter = eztriggers.add_radius_trigger(area_id, object, radius, radius, 0, 0)
    emitter:on('entered', function(event)
        return on_radius_encounter_triggered(event)
    end)
end)

return ezencounters
