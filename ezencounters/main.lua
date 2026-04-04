local ezwarps = require('scripts/ezlibs-scripts/ezwarps/main')
local ezmemory = require('scripts/ezlibs-scripts/ezmemory')
local helpers = require('scripts/ezlibs-scripts/helpers')
local eztriggers = require('scripts/ezlibs-scripts/eztriggers')
local CONFIG = require('scripts/ezlibs-scripts/ezconfig')

local ezencounters = {}
local players_in_encounters = {}
local player_last_position = {}
local player_steps_since_encounter = {}
local named_encounters = {}
local provided_encounter_assets = {}
local encounter_finished_callbacks = {}
local preloaded_encounter_assets_for_player = {}

-- ===================== WWWServer random encounter config =====================
local WWW_RANDOM_ENABLED = true
local WWW_RANDOM_PACKAGE_PATH = "/server/assets/ezlibs-assets/ezencounters/ezencounters.zip"
local TAG_TRAP_PACKAGE_PATH = WWW_RANDOM_PACKAGE_PATH
local WWW_RANDOM_MIN_STEPS = 80
local WWW_RANDOM_CHANCE = 0.40

local enums = require("scripts/libs/enums")
local PackageType = enums.PackageType
local AssetType = enums.AssetType

local ENCOUNTER_PRELOAD_BASE_PATH = "/server/assets/mobs/"
local ENCOUNTER_PRELOAD_HINT = { AssetType.DATA, PackageType.ENCOUNTER }

local WWW_FORMATION_WEIGHTS = {
    boss  = 5,
    two   = 35,
    three = 40,
    four  = 20,
}

local WWW_OBSTACLE_ONE_CHANCE = 0.20
local WWW_OBSTACLE_TWO_CHANCE = 0.08

local WWW_PANEL_VARIATION_CHANCE = 0.15
local WWW_PANEL_VARIATION_COUNT_MIN = 1
local WWW_PANEL_VARIATION_COUNT_MAX = 2

local WWW_RANDOM_OBSTACLE_POOL = {
    "Rock",
    "RockCube",
    "Coffin",
    "BlastCube",
    "IceCube",
}

-- These are indices into entry.lua's tile_states array (1-based):
-- 2=cracked, 9=grass, 11=holy, 12=ice, 13=lava, 14=poison
local WWW_TILE_STATE_POOL = { 2, 9, 11, 12, 13, 14 }

local DEFAULT_ENEMY_RANKS = { "1", "2", "3" }
local DEFAULT_BOSS_RANKS = { "1", "2", "3" }

local function enemy(alias, preload_files, supported_ranks)
    return {
        alias = alias,
        pool = "enemy",
        preload_files = preload_files or {},
        supported_ranks = supported_ranks or DEFAULT_ENEMY_RANKS,
    }
end

local function boss(alias, preload_files, supported_ranks)
    return {
        alias = alias,
        pool = "boss",
        preload_files = preload_files or {},
        supported_ranks = supported_ranks or DEFAULT_BOSS_RANKS,
    }
end

-- ============================================================
-- Declare your WWW random units here.
--
-- For each alias, keep everything together:
--   * which pool it belongs to (enemy/boss)
--   * which zip files should preload on login
--   * which rank tokens it supports
--
-- Rank tokens should match what your ezencounters entry expects, e.g.
--   "1", "2", "3", "sp", "rare1", "rare2", "nm"
-- ============================================================
local WWW_RANDOM_UNIT_DEFINITIONS = {
    enemy("Boomer", { "Boomer.zip" }, { "1", "Rare1", "Rare2", "SP", "NM" }),
    enemy("Gloomer", {}, { "1" }),
	enemy("Doomer", {}, { "1" }),
    boss("BurnerMan", {
        "BurnerMan0.zip",
        "BurnerMan1.zip",
        "BurnerMan2.zip",
        "BurnerMan3.zip",
        "BurnerMan4.zip",
    }, { "1", "2", "3", "sp" }),
    enemy("Cannodumb", { "Cannodumb.zip" }, { "1", "2", "3", "SP" }),
    enemy("Chuuton", { "Chuuton.zip" }, { "1", "2", "3", "SP" }),
    enemy("CirKiller", { "CirKiller.zip" }, { "1", "2", "3", "SP", "Rare1", "Rare2" }),
    enemy("BombCorn", { "Corn.zip" }, { "1", "SP", "Rare1", "Rare2" }),
    enemy("GigaCorn", {}, { "1" }),
    enemy("MegaCorn", {}, { "1" }),
    enemy("Curze", { "Curze.zip" }, { "1", "SP" }),
    enemy("Curzed", {}, { "1" }),
    enemy("Curzena", {}, { "1" }),
    enemy("Dharma", { "Dharma.zip" }, { "1", "SP" }),
    enemy("Dharga", {}, { "1" }),
    enemy("Dhardara", {}, { "1" }),
    enemy("Ebiron", { "Ebiron.zip" }, { "1", "SP" }),
    enemy("Ebidel", {}, { "1" }),
    enemy("EbiSide", {}, { "1" }),
    enemy("Fancar", { "Fancar.zip" }, { "1", "2", "3" }),
    enemy("Fishy", { "Fishy.zip" }, { "1", "2", "3", "SP", "Rare1", "Rare2", "NM" }),
    enemy("Garue", { "Garue.zip" }, { "1", "SP" }),
    enemy("Garuebar", {}, { "1" }),
    enemy("Garuedan", {}, { "1" }),
    enemy("Gunner", { "Gunner.zip" }, { "1", "2", "3", "SP", "Rare1", "Rare2" }),
    enemy("HardBolz", { "HardBolz.zip" }, { "1", "SP" }),
    enemy("ColdBolz", {}, { "1" }),
    enemy("MagraBolz", {}, { "1" }),
    enemy("HauntedCandle", { "HCandle.zip" }, { "1", "2", "3", "SP", "Rare1", "Rare2" }),
    boss("HeelNavi", { "HeelNavi.zip" }, { "1", "2", "3", "SP" }),
    enemy("Kabutank", { "Kabutank.zip" }, { "1", "2", "3", "SP" }),
    enemy("Kakajee", { "Kakajee.zip" }, { "1", "2", "3", "SP", "Rare1", "Rare2" }),
    enemy("KillerEye", { "KillerEye.zip" }, { "1", "SP", "Rare1", "Rare2" }),
    enemy("DemonEye", {}, { "1" }),
    enemy("JokerEye", {}, { "1" }),
    enemy("KillPlant", { "KillPlant.zip" }, { "1", "SP" }),
    enemy("KillWeed", {}, { "1" }),
    enemy("KillFlower", {}, { "1" }),
    enemy("Kuumoss", { "Kuumoss.zip" }, { "1", "2", "3", "SP", "Rare1", "Rare2" }),
    enemy("Lark", { "Lark.zip" }, { "1", "SP", "Rare1", "Rare2", "NM" }),
    enemy("Bark", {}, { "1" }),
    enemy("Tark", {}, { "1" }),
    enemy("Metall", { "Metall.zip" }, { "1", "2", "3", "SP", "Rare1", "Rare2", "NM" }),
    enemy("MetFire", { "MetFire.zip" }, { "1", "SP", "Rare1", "Rare2", "NM" }),
    enemy("FulFire", {}, { "1" }),
    enemy("DthFire", {}, { "1" }),
    enemy("Metrid", { "Metrid.zip" }, { "1", "2", "3", "SP", "NM" }),
    enemy("Piranha", { "Piranha.zip" }, { "1", "2", "3", "SP", "Rare1", "Rare2", "NM" }),
    enemy("Puffy", { "Puffy.zip" }, { "1", "2", "3", "SP", "Rare1", "Rare2" }),
    enemy("Quaker", { "Quaker.zip" }, { "1", "2", "3", "SP", "NM" }),
    enemy("Shaker", {}, { "1" }),
    enemy("Breaker", {}, { "1" }),
    enemy("Rabiri", { "Rabiri.zip" }, { "1", "SP" }),
    enemy("HighRabiri", {}, { "1" }),
    enemy("MegaRabiri", {}, { "1" }),
    boss("StarMan", {
        "StarMan1.zip",
        "StarMan2.zip",
        "StarMan3.zip",
        "StarMan4.zip",
    }, { "1", "2", "3", "SP" }),
    enemy("Swordy", { "Swordy.zip" }, { "1", "2", "3", "4", "5", "6", "7", "8" }),
    enemy("Volgear", { "Volgear.zip" }, { "1", "2", "3", "SP" }),
    enemy("WindBox", { "WindBox.zip" }, { "1", "2", "3", "SP", "NM" }),
    enemy("VacuumFan", {}, { "1", "2", "3", "SP", "NM" }),
    enemy("Yort", { "Yort.zip" }, { "1", "2", "3", "4", "5", "6" }),
    enemy("Yura", { "Yura.zip" }, { "1", "SP" }),
    enemy("Yurayura", {}, { "1" }),
    enemy("Yurarion", {}, { "1" }),
    boss("GutsMan", {
        "Gutsman_V1.zip",
        "Gutsman_V2.zip",
        "Gutsman_V3.zip",
        "Gutsman_V4.zip",
    }, { "1", "2", "3", "SP" }),
}

local WWW_RANDOM_ALIAS_CONFIG = {}
local WWW_RANDOM_ENEMY_POOL = {}
local WWW_RANDOM_BOSS_POOL = {}
local ENCOUNTER_PRELOAD_FILES = {}

local _seen_preload_files = {}
for _, unit in ipairs(WWW_RANDOM_UNIT_DEFINITIONS) do
    WWW_RANDOM_ALIAS_CONFIG[unit.alias] = unit

    if unit.pool == "boss" then
        WWW_RANDOM_BOSS_POOL[#WWW_RANDOM_BOSS_POOL + 1] = unit.alias
    else
        WWW_RANDOM_ENEMY_POOL[#WWW_RANDOM_ENEMY_POOL + 1] = unit.alias
    end

    for _, zip_name in ipairs(unit.preload_files or {}) do
        if not _seen_preload_files[zip_name] then
            _seen_preload_files[zip_name] = true
            ENCOUNTER_PRELOAD_FILES[#ENCOUNTER_PRELOAD_FILES + 1] = zip_name
        end
    end
end

local function build_encounter_preload_path(zip_name)
    return ENCOUNTER_PRELOAD_BASE_PATH .. zip_name
end

local function preload_www_encounter_asset_for_player(player_id)
    if not WWW_RANDOM_ENABLED then
        return
    end

    if preloaded_encounter_assets_for_player[player_id] then
        return
    end

    print(
        "[ezencounters] preloading encounter packages for player",
        tostring(player_id)
    )

    for _, zip_name in ipairs(ENCOUNTER_PRELOAD_FILES) do
        local package_path = build_encounter_preload_path(zip_name)

        print(
            "[ezencounters] provide_asset_for_player",
            "player=",
            tostring(player_id),
            "path=",
            tostring(package_path)
        )

        Net.provide_asset_for_player(
            player_id,
            package_path,
            ENCOUNTER_PRELOAD_HINT
        )
    end

    preloaded_encounter_assets_for_player[player_id] = true
end

local function _copy_rank_list(rank_list)
    local out = {}
    for i, rank_token in ipairs(rank_list or {}) do
        out[i] = tostring(rank_token)
    end
    return out
end

local function _get_supported_ranks_for_alias(alias, is_boss)
    local config = WWW_RANDOM_ALIAS_CONFIG[alias]
    if config and config.supported_ranks and #config.supported_ranks > 0 then
        return _copy_rank_list(config.supported_ranks)
    end

    if is_boss then
        return _copy_rank_list(DEFAULT_BOSS_RANKS)
    end

    return _copy_rank_list(DEFAULT_ENEMY_RANKS)
end

local function _pick_random_rank_token(alias, is_boss)
    local supported_ranks = _get_supported_ranks_for_alias(alias, is_boss)
    if #supported_ranks == 0 then
        return "1"
    end

    return supported_ranks[math.random(#supported_ranks)]
end

local WWW_DEFAULT_PLAYER_POSITIONS = {
    {0,0,0,0,0,0},
    {0,1,0,0,0,0},
    {0,0,0,0,0,0},
}

local WWW_DEFAULT_TILES = {
    {1,1,1,1,1,1},
    {1,1,1,1,1,1},
    {1,1,1,1,1,1},
}

local WWW_DEFAULT_TEAMS = {
    {2,2,2,1,1,1},
    {2,2,2,1,1,1},
    {2,2,2,1,1,1},
}

-- Only enemy-side cells (right 3x3)
local WWW_ENEMY_CELLS = {
    {x=4,y=1},{x=5,y=1},{x=6,y=1},
    {x=4,y=2},{x=5,y=2},{x=6,y=2},
    {x=4,y=3},{x=5,y=3},{x=6,y=3},
}

local function _copy_grid(grid)
    local out = {}
    for y, row in ipairs(grid) do
        out[y] = {}
        for x, v in ipairs(row) do
            out[y][x] = v
        end
    end
    return out
end

local function _blank_positions_grid()
    return {
        {0,0,0,0,0,0},
        {0,0,0,0,0,0},
        {0,0,0,0,0,0},
    }
end

local function _cell_key(x, y)
    return tostring(x) .. "," .. tostring(y)
end

local function _shuffle_in_place(arr)
    for i = #arr, 2, -1 do
        local j = math.random(i)
        arr[i], arr[j] = arr[j], arr[i]
    end
    return arr
end

local function _pick_distinct(pool, count)
    local temp = {}
    for i, v in ipairs(pool) do
        temp[i] = v
    end
    _shuffle_in_place(temp)

    local out = {}
    for i = 1, math.min(count, #temp) do
        out[#out+1] = temp[i]
    end
    return out
end

local function _pick_weighted_key(weight_table)
    local total = 0
    for _, weight in pairs(weight_table) do
        total = total + weight
    end

    local crawler = math.random() * total
    for key, weight in pairs(weight_table) do
        crawler = crawler - weight
        if crawler <= 0 then
            return key
        end
    end

    return "two"
end

local function _result_flags(stats)
    local reason = tonumber(stats and stats.reason or 0) or 0
    local hp     = tonumber(stats and (stats.health or stats.player_hp or stats.hp) or 0) or 0

    local ran, dev_escape, won, lost = false, false, false, false

    if reason == 1 then
        won = true
    elseif reason == 2 then
        lost = true
    elseif reason == 3 then
        ran = true
    elseif reason == 4 then
        ran = true
        dev_escape = true
    else
        ran = stats and (stats.ran or stats.fled or stats.escape) or false
        if not ran then
            if hp > 0 then
                won = true
            else
                lost = true
            end
        end
    end

    return {
        reason = reason,
        hp = hp,
        ran = ran,
        dev_escape = dev_escape,
        won = won,
        lost = lost,
    }
end

local function _send_rewards_and_fixup_wallet(player_id, rewards)
    if not rewards or #rewards == 0 then return end

    local expected_money = 0
    for _, r in ipairs(rewards) do
        if r and r.type == 0 then
            expected_money = expected_money + (tonumber(r.value) or 0)
        end
    end

    local money_before = nil
    if expected_money > 0 and Net.get_player_money then
        money_before = tonumber(Net.get_player_money(player_id) or 0) or 0
    end

    Net.send_player_battle_rewards(player_id, rewards)

    if expected_money > 0 and money_before ~= nil then
        local money_after = tonumber(Net.get_player_money(player_id) or 0) or 0
        if money_after < (money_before + expected_money) then
            -- negative spend adds money through ezmemory + sync
            pcall(ezmemory.spend_player_money, player_id, -expected_money)
        elseif ezmemory.get_player_money then
            pcall(ezmemory.get_player_money, player_id)
        end
    end
end

local function persist_health_and_emotion(player_id, stats)
    local emotion = tonumber(stats and stats.emotion or 0) or 0
    local health = tonumber(stats and stats.health or 0) or 0

    if emotion == 1 then
        Net.set_player_emotion(player_id, emotion)
    else
        Net.set_player_emotion(player_id, 0)
    end

    ezmemory.set_player_health(player_id, health)
end

local function give_result_awards(player_id, encounter_info, stats)
    local flags = _result_flags(stats)

    -- WWWServer rewards only on a real win
    if not flags.won then
        persist_health_and_emotion(player_id, stats)
        return
    end

    local score = tonumber(stats and stats.score or 0) or 0
    local hp = tonumber(stats and stats.health or 0) or 0
    local reward_multiplier = tonumber(encounter_info and encounter_info._www_reward_multiplier or 1) or 1

    local monies = score * 3 * reward_multiplier
    local hp_bonus = (hp < 201) and 500 or 0

    local rewards = {}
    if monies > 0 then
        table.insert(rewards, { type = 0, value = monies }) -- money
    end
    if hp_bonus > 0 then
        table.insert(rewards, { type = 2, value = hp_bonus }) -- health+
    end

    if #rewards > 0 then
        _send_rewards_and_fixup_wallet(player_id, rewards)
    end

    persist_health_and_emotion(player_id, {
        health = hp + hp_bonus,
        emotion = stats and stats.emotion or 0
    })
end

local function _build_enemy_positions(enemy_count, is_boss)
    local positions = _blank_positions_grid()
    local occupied = {}

    if is_boss then
        positions[2][5] = 1
        occupied[_cell_key(5, 2)] = true
        return positions, occupied
    end

    local chosen_cells = _pick_distinct(WWW_ENEMY_CELLS, enemy_count)
    for index, cell in ipairs(chosen_cells) do
        positions[cell.y][cell.x] = index
        occupied[_cell_key(cell.x, cell.y)] = true
    end

    return positions, occupied
end

local function _build_obstacles(occupied)
    local obstacles = {}
    local obstacle_positions = _blank_positions_grid()

    local obstacle_count = 0
    if math.random() < WWW_OBSTACLE_ONE_CHANCE then
        obstacle_count = 1
        if math.random() < WWW_OBSTACLE_TWO_CHANCE then
            obstacle_count = 2
        end
    end

    if obstacle_count == 0 then
        return obstacles, obstacle_positions
    end

    local free_cells = {}
    for _, cell in ipairs(WWW_ENEMY_CELLS) do
        if not occupied[_cell_key(cell.x, cell.y)] then
            free_cells[#free_cells+1] = cell
        end
    end

    local chosen_cells = _pick_distinct(free_cells, obstacle_count)
    for index, cell in ipairs(chosen_cells) do
        obstacles[index] = {
            name = WWW_RANDOM_OBSTACLE_POOL[math.random(#WWW_RANDOM_OBSTACLE_POOL)]
        }
        obstacle_positions[cell.y][cell.x] = index
        occupied[_cell_key(cell.x, cell.y)] = true
    end

    return obstacles, obstacle_positions
end

local function _build_tiles()
    local tiles = _copy_grid(WWW_DEFAULT_TILES)

    if math.random() >= WWW_PANEL_VARIATION_CHANCE then
        return tiles
    end

    local count = math.random(WWW_PANEL_VARIATION_COUNT_MIN, WWW_PANEL_VARIATION_COUNT_MAX)
    local chosen_cells = _pick_distinct(WWW_ENEMY_CELLS, count)

    for _, cell in ipairs(chosen_cells) do
        tiles[cell.y][cell.x] = WWW_TILE_STATE_POOL[math.random(#WWW_TILE_STATE_POOL)]
    end

    return tiles
end

local function _pick_enemy_aliases(pool, count)
    local chosen = _pick_distinct(pool, count)
    if #chosen >= count then
        return chosen
    end

    -- fallback: allow repeats if count > available pool size
    while #chosen < count do
        chosen[#chosen+1] = pool[math.random(#pool)]
    end

    return chosen
end

local function _build_random_www_encounter(area_id)
    local formation = _pick_weighted_key(WWW_FORMATION_WEIGHTS)

    if formation == "boss" and #WWW_RANDOM_BOSS_POOL == 0 then
        formation = "three"
    end

    local is_boss = (formation == "boss")
    local enemy_count = 2
    if formation == "three" then
        enemy_count = 3
    elseif formation == "four" then
        enemy_count = 4
    elseif formation == "boss" then
        enemy_count = 1
    end

    local alias_pool = is_boss and WWW_RANDOM_BOSS_POOL or WWW_RANDOM_ENEMY_POOL
    local aliases = _pick_enemy_aliases(alias_pool, enemy_count)

    local enemies = {}
    for i = 1, enemy_count do
        local alias = aliases[i]
        enemies[i] = {
            name = alias,
            rank = _pick_random_rank_token(alias, is_boss),
        }
    end

    local positions, occupied = _build_enemy_positions(enemy_count, is_boss)
    local obstacles, obstacle_positions = _build_obstacles(occupied)

    local reward_multiplier = is_boss and 5 or enemy_count

    return {
        name = string.format("WWWRandom_%s_%d", tostring(area_id), math.random(1000000)),
        path = WWW_RANDOM_PACKAGE_PATH,
        enemies = enemies,
        obstacles = obstacles,
        positions = positions,
        obstacle_positions = obstacle_positions,
        player_positions = _copy_grid(WWW_DEFAULT_PLAYER_POSITIONS),
        tiles = _build_tiles(),
        teams = _copy_grid(WWW_DEFAULT_TEAMS),
        results_callback = give_result_awards,
        _www_reward_multiplier = reward_multiplier,
        _www_is_boss = is_boss,
    }
end

local function _build_random_tag_trap_encounter(area_id, trap_type)
    local is_boss = (trap_type == "boss")

    if is_boss and #WWW_RANDOM_BOSS_POOL == 0 then
        return nil
    end

    if (not is_boss) and #WWW_RANDOM_ENEMY_POOL == 0 then
        return nil
    end

    local enemy_count = 1
    if not is_boss then
        local roll = math.random()
        if roll < 0.45 then
            enemy_count = 2
        elseif roll < 0.80 then
            enemy_count = 3
        else
            enemy_count = 4
        end
    end

    local alias_pool = is_boss and WWW_RANDOM_BOSS_POOL or WWW_RANDOM_ENEMY_POOL
    local aliases = _pick_enemy_aliases(alias_pool, enemy_count)

    local enemies = {}
    for i = 1, enemy_count do
        local alias = aliases[i]
        enemies[i] = {
            name = alias,
            rank = _pick_random_rank_token(alias, is_boss),
        }
    end

    local positions, occupied = _build_enemy_positions(enemy_count, is_boss)
    local obstacles, obstacle_positions = _build_obstacles(occupied)

    return {
        name = string.format("TagTrap_%s_%s_%d", tostring(trap_type), tostring(area_id), math.random(1000000)),
        path = TAG_TRAP_PACKAGE_PATH,
        enemies = enemies,
        obstacles = obstacles,
        obstacle_positions = obstacle_positions,
        positions = positions,
        player_positions = _copy_grid(WWW_DEFAULT_PLAYER_POSITIONS),
        tiles = _build_tiles(),
        teams = _copy_grid(WWW_DEFAULT_TEAMS),

        -- important: trap fights should NOT award normal WWW money/hp bonuses
        results_callback = nil,
        _tag_trap = true,
        _tag_trap_type = trap_type,
    }
end

ezencounters.begin_tag_trap = function(player_id, area_id, trap_type)
    return async(function()
        local encounter_info = _build_random_tag_trap_encounter(area_id, trap_type)
        if not encounter_info then
            print("[ezencounters] failed to build tag trap for", tostring(trap_type), tostring(area_id))
            return nil
        end

        local stats = await(ezencounters.begin_encounter(player_id, encounter_info))
        return stats
    end)
end

local function provide_encounter_asset_for_area(area_id, package_path)
    local key = tostring(area_id) .. "|" .. tostring(package_path)
    if provided_encounter_assets[key] then
        return
    end

    print('[ezencounters] providing mob package '..package_path..' for '..area_id)
    Net.provide_asset(area_id, package_path)
    provided_encounter_assets[key] = true
end
-- =================== /WWWServer random encounter config ======================

local load_encounters_for_areas = function ()
    local areas = Net.list_areas()
    local area_encounter_tables = {}
    for i, area_id in ipairs(areas) do
        local encounter_table_path = CONFIG.ENCOUNTERS_PATH..area_id
        local status, err = pcall(function () require(encounter_table_path) end)
        if status == true then
            area_encounter_tables[area_id] = require(encounter_table_path)
            for index, encounter_info in ipairs(area_encounter_tables[area_id].encounters) do
                provide_encounter_asset_for_area(area_id, encounter_info.path)
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
local function get_or_create_area_encounter_table(area_id)
    if area_encounter_tables[area_id] then
        return area_encounter_tables[area_id]
    end

    if not WWW_RANDOM_ENABLED then
        return nil
    end

    -- Keep the Net Square / default area safe
    if area_id == "default" then
        return nil
    end

    provide_encounter_asset_for_area(area_id, WWW_RANDOM_PACKAGE_PATH)

    local encounter_table = {
        minimum_steps_before_encounter = WWW_RANDOM_MIN_STEPS,
        encounter_chance_per_step = WWW_RANDOM_CHANCE,
        www_random = true,
    }

    area_encounter_tables[area_id] = encounter_table
    print('[ezencounters] created random WWW encounter table for '..area_id)
    return encounter_table
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
    local encounter_table = get_or_create_area_encounter_table(player_area)

    if not player_steps_since_encounter[player_id] then
        player_steps_since_encounter[player_id] = 1
    else
        player_steps_since_encounter[player_id] = player_steps_since_encounter[player_id] + 1
    end

    if encounter_table and player_steps_since_encounter[player_id] >= encounter_table.minimum_steps_before_encounter then
        ezencounters.try_random_encounter(player_id, encounter_table)
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

ezencounters.try_random_encounter = function (player_id, encounter_table)
    if math.random() > encounter_table.encounter_chance_per_step then
        return
    end

    local encounter_info
    if encounter_table.www_random then
        local player_area = Net.get_player_area(player_id)
        encounter_info = _build_random_www_encounter(player_area)
    else
        encounter_info = ezencounters.pick_encounter_from_table(encounter_table)
    end

    ezencounters.begin_encounter(player_id, encounter_info)
end

ezencounters.begin_encounter_by_name = function(player_id,encounter_name,trigger_object)
    return async(function ()
        local encounter_info = named_encounters[encounter_name]
        if encounter_info then
            await(ezencounters.begin_encounter(player_id,encounter_info,trigger_object))
        else
            print('[ezencounters] no encounter with name ',encounter_name,' has been added to any encounter tables!')
        end
    end)
end

ezencounters.begin_encounter = function (player_id,encounter_info,trigger_object)
    return async(function ()
        --print('[ezencounters] beginning encounter for',player_id)
        players_in_encounters[player_id] = {encounter_info=encounter_info}
        ezencounters.clear_tiles_since_encounter(player_id)
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
        if player_encounter.encounter_info.results_callback then
            player_encounter.encounter_info.results_callback(player_id,player_encounter.encounter_info,event)
        end
        players_in_encounters[player_id] = nil
    end
    -- stats = { health: number, score: number, time: number, ran: bool, emotion: number, turns: number, npcs: { id: String, health: number }[] }
end)

ezencounters.handle_player_transfer = ezencounters.clear_last_position

ezencounters.handle_player_disconnect = function (player_id)
    encounter_finished_callbacks[player_id] = nil
    preloaded_encounter_assets_for_player[player_id] = nil
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
            local flags = _result_flags(stats)
            if flags.ran or flags.lost then
                return stats -- dont hide the encounter if the player ran or lost
            end
            local player_area = Net.get_player_area(event.player_id)
            if event.object.custom_properties["Once"] == "true" then
                ezmemory.hide_object_from_player(event.player_id,player_area,event.object.id)
            end
        end
        ezmemory.hide_object_from_player_till_disconnect(event.player_id,player_area,event.object.id)
    end)
end

local areas = Net.list_areas()
for i, area_id in next, areas do
    --filter and store an array of all radius encounters
    local objects = Net.list_objects(area_id)
    for j, object_id in next, objects do
        local object = Net.get_object_by_id(area_id, object_id)
        if object.type == "Radius Encounter" then
            local radius = tonumber(object.custom_properties["Radius"] or 1)
            local emitter = eztriggers.add_radius_trigger(area_id,object,radius,radius,0,0)
            emitter:on('entered_radius',function(event)
                return on_radius_encounter_triggered(event)
            end)
        end
    end
end

Net:on("player_join", function(event)
    preload_www_encounter_asset_for_player(event.player_id)
end)

return ezencounters
