local config = {}

-- ============================================================
-- GENERAL ENCOUNTER CONFIG
-- ============================================================

config.package_paths = {
    easy = "/server/assets/ezlibs-assets/ezencounters/optimized/easy.zip",
    medium = "/server/assets/ezlibs-assets/ezencounters/optimized/medium.zip",
    hard = "/server/assets/ezlibs-assets/ezencounters/optimized/hard.zip",
    boss = "/server/assets/ezlibs-assets/ezencounters/optimized/hard.zip",
}

config.minimum_steps_before_encounter = 50
config.encounter_chance_per_step = 0.03

config.area_pool_size = {
    easy = 7,
    medium = 7,
    hard = 7,
    boss = 8,
}

config.enemy_count = {
    easy = { min = 1, max = 2, },
    medium = { min = 2, max = 3, },
    hard = { min = 3, max = 4, },
    boss = { min = 3, max = 4, },
}

config.boss_chance = 0.30

-- ============================================================
-- EASY — AREAS 0-3
-- ============================================================

config.easy_pool = {
    { name = "Paraball", rank = 1 },
    { name = "Kiorushin", rank = 1 },
    { name = "Kiorushin", rank = 2 },
    { name = "Cannodumb", rank = 1 },
    { name = "Cannodumb", rank = 2 },
    { name = "Rabiree", rank = 1 },
    { name = "Weathers", rank = 1 },
    { name = "Shellky", rank = 1 },
    { name = "Metall", rank = 1 },
    { name = "Metall", rank = 2 },
    { name = "Kakajee", rank = 1 },
    { name = "Gunner", rank = 1 },
    { name = "Gunner", rank = 2 },
    { name = "Fancar", rank = 1 },
    { name = "Piranha", rank = 1 },
    { name = "Yura", rank = 1 },
    { name = "OldStove", rank = 1 },
    { name = "OldHeater", rank = 1 },
    { name = "Chuuton", rank = 1 },
    { name = "Dharma", rank = 1 },
    { name = "KillPlant", rank = 1 },
    { name = "Garue", rank = 1 },
    { name = "Garuebar", rank = 1 },
    { name = "Ebiron", rank = 1 },
    { name = "HardBolz", rank = 1 },
    { name = "Kabutank", rank = 1 },
    { name = "Kabutank", rank = 2 },
    { name = "Swordin", rank = 1 },
    { name = "Lark", rank = 1 },
    { name = "BombCorn", rank = 1 },
    { name = "Quaker", rank = 1 },
    { name = "HeelNavi", rank = 1 },
    { name = "MetFire", rank = 1 },
    { name = "Volgear", rank = 1 },
    { name = "Puffy", rank = 1 },
    { name = "Rounda", rank = 1 },
    { name = "Yort", rank = 1 },
}

-- ============================================================
-- MEDIUM — AREAS 4-6
-- ============================================================

config.medium_pool = {
    { name = "Paraball", rank = 2 },
    { name = "Kiorushin", rank = 3 },
    { name = "HeavyArei", rank = 1 },
    { name = "Cannodumb", rank = 3 },
    { name = "Rabiree", rank = 2 },
    { name = "Weathers", rank = 2 },
    { name = "Zaemon", rank = 1 },
    { name = "AppleSam", rank = 1 },
    { name = "Genin", rank = 1 },
    { name = "Shellky", rank = 2 },
    { name = "CirKiller", rank = 1 },
    { name = "Kuumoss", rank = 1 },
    { name = "Metall", rank = 3 },
    { name = "Kakajee", rank = 2 },
    { name = "Gunner", rank = 3 },
    { name = "Fancar", rank = 2 },
    { name = "Piranha", rank = 2 },
    { name = "Piranha", rank = 3 },
    { name = "Yurayura", rank = 1 },
    { name = "OldBurner", rank = 1 },
    { name = "Chuuton", rank = 2 },
    { name = "Curze", rank = 1 },
    { name = "Dharga", rank = 1 },
    { name = "KillWeed", rank = 1 },
    { name = "Garuedan", rank = 1 },
    { name = "Ebidel", rank = 1 },
    { name = "ColdBolz", rank = 1 },
    { name = "Kabutank", rank = 3 },
    { name = "Swordra", rank = 1 },
    { name = "Bark", rank = 1 },
    { name = "MegaCorn", rank = 1 },
    { name = "Quaker", rank = 2 },
    { name = "HeelNavi", rank = 2 },
    { name = "HauntedCandle", rank = 1 },
    { name = "HauntedCandle", rank = 2 },
    { name = "FulFire", rank = 1 },
    { name = "Volgear", rank = 2 },
    { name = "KillerEye", rank = 1 },
    { name = "Puffy", rank = 2 },
    { name = "Volcano", rank = 1 },
    { name = "Roundarau", rank = 1 },
    { name = "Yort", rank = 2 },
}

-- ============================================================
-- HARD — AREAS 7-9 + NORMAL AREA-10 VIRUS ENCOUNTERS
-- ============================================================

config.hard_pool = {
    { name = "Paraball", rank = 3 },
    { name = "HeavyArei", rank = 2 },
    { name = "HeavyArei", rank = 3 },
    { name = "Rabiree", rank = 3 },
    { name = "Weathers", rank = 3 },
    { name = "Zaemon", rank = 2 },
    { name = "Zaemon", rank = 3 },
    { name = "AppleSam", rank = 2 },
    { name = "AppleSam", rank = 3 },
    { name = "Genin", rank = 2 },
    { name = "Genin", rank = 3 },
    { name = "Shellky", rank = 3 },
    { name = "CirKiller", rank = 2 },
    { name = "CirKiller", rank = 3 },
    { name = "Kuumoss", rank = 2 },
    { name = "Kuumoss", rank = 3 },
    { name = "Kakajee", rank = 3 },
    { name = "Fancar", rank = 3 },
    { name = "Yurarion", rank = 1 },
    { name = "Chuuton", rank = 3 },
    { name = "Curzena", rank = 1 },
    { name = "Curzed", rank = 1 },
    { name = "Dhardara", rank = 1 },
    { name = "KillFlower", rank = 1 },
    { name = "EbiSide", rank = 1 },
    { name = "MagraBolz", rank = 1 },
    { name = "Swortar", rank = 1 },
    { name = "DreamMeraru", rank = 1 },
    { name = "DreamMeraru", rank = 2 },
    { name = "DreamMeraru", rank = 3 },
    { name = "DreamLapia", rank = 1 },
    { name = "DreamLapia", rank = 2 },
    { name = "DreamLapia", rank = 3 },
    { name = "DreamBolt", rank = 1 },
    { name = "DreamBolt", rank = 2 },
    { name = "DreamBolt", rank = 3 },
    { name = "DreamMoss", rank = 1 },
    { name = "DreamMoss", rank = 2 },
    { name = "DreamMoss", rank = 3 },
    { name = "Tark", rank = 1 },
    { name = "GigaCorn", rank = 1 },
    { name = "Quaker", rank = 3 },
    { name = "HeelNavi", rank = 3 },
    { name = "HauntedCandle", rank = 3 },
    { name = "DthFire", rank = 1 },
    { name = "Volgear", rank = 3 },
    { name = "DemonEye", rank = 1 },
    { name = "JokerEye", rank = 1 },
    { name = "Puffy", rank = 3 },
    { name = "Volcano", rank = 2 },
    { name = "Volcano", rank = 3 },
    { name = "Roundabar", rank = 1 },
    { name = "Yort", rank = 3 },
}

-- ============================================================
-- BOSS POOL
-- ============================================================

config.boss_pool = {
    { name = "Forte", rank = 1 },
    { name = "Gregar", rank = 1 },
    { name = "GregarBeast", rank = 1 },
    { name = "Duo", rank = 1 },
    { name = "BurnerMan", rank = 1 },
    { name = "Colonel", rank = 1 },
    { name = "ElementMan", rank = 1 },
    { name = "StarMan", rank = 1 },
    { name = "Proto", rank = 1 },
    { name = "ShadowMan", rank = 1 },
    { name = "HatMan", rank = 1 },
    { name = "QuickMan", rank = 1 },
    { name = "ShadeMan", rank = 1 },
    { name = "Noir", rank = 1 },
}

return config
