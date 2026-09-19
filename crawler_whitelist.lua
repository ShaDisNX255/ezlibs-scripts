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

    -- Default reward code is the first code declared by each package.
    -- Encounter and boss rewards are unlocked explicitly by their future
    -- battle reward logic, so both generic source flags remain false.

    -- ========================================================
    -- ENCOUNTER REWARDS
    -- ========================================================

    airhockey1 = {
        package_id = "com.OFC.card.EXEPoN-063-AirHockey1",
        asset_path = "/server/assets/chips/EXEPon-AirHockey1.zip",
        code = "M",
        display_name = "AirHockey1",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    airhockey2 = {
        package_id = "com.OFC.card.EXEPoN-064-AirHockey2",
        asset_path = "/server/assets/chips/EXEPon-AirHockey2.zip",
        code = "E",
        display_name = "AirHockey2",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    airhockey3 = {
        package_id = "com.OFC.card.EXEPoN-065-AirHockey3",
        asset_path = "/server/assets/chips/EXEPon-AirHockey3.zip",
        code = "S",
        display_name = "AirHockey3",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    blizzard = {
        package_id = "com.k1rbyat1na.card.EXE4-027-Blizzard",
        asset_path = "/server/assets/chips/EXE4-Blizzard.zip",
        code = "H",
        display_name = "Blizzard",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    boomerang1 = {
        package_id = "com.OFC.card.EXEPoN-066-Boomerang1",
        asset_path = "/server/assets/chips/EXEPon-Boomerang1.zip",
        code = "L",
        display_name = "Boomerang1",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    boomerang2 = {
        package_id = "com.OFC.card.EXEPoN-067-Boomerang2",
        asset_path = "/server/assets/chips/EXEPon-Boomerang2.zip",
        code = "L",
        display_name = "Boomerang2",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    boomerang3 = {
        package_id = "com.OFC.card.EXEPoN-068-Boomerang3",
        asset_path = "/server/assets/chips/EXEPon-Boomerang3.zip",
        code = "S",
        display_name = "Boomerang3",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    burnsquare1 = {
        package_id = "com.OFC.card.EXE6-108-BurnSquare1",
        asset_path = "/server/assets/chips/EXE6-BurnSquare1.zip",
        code = "H",
        display_name = "BurnSquare1",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    burnsquare2 = {
        package_id = "com.OFC.card.EXE6-109-BurnSquare2",
        asset_path = "/server/assets/chips/EXE6-BurnSquare2.zip",
        code = "D",
        display_name = "BurnSquare2",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    burnsquare3 = {
        package_id = "com.OFC.card.EXE6-110-BurnSquare3",
        asset_path = "/server/assets/chips/EXE6-BurnSquare3.zip",
        code = "E",
        display_name = "BurnSquare3",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    cannonball = {
        package_id = "com.OFC.card.EXEPoN-027-Hougan",
        asset_path = "/server/assets/chips/EXEPon-CannonBall.zip",
        code = "B",
        display_name = "CannonBall",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    circgun1 = {
        package_id = "com.EXE4.Card082-CircGun1",
        asset_path = "/server/assets/chips/EXE4-CircGun1.zip",
        code = "H",
        display_name = "CircGun1",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    circgun2 = {
        package_id = "com.EXE4.Card083-CircGun2",
        asset_path = "/server/assets/chips/EXE4-CircGun2.zip",
        code = "D",
        display_name = "CircGun2",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    circgun3 = {
        package_id = "com.EXE4.Card084-CircGun3",
        asset_path = "/server/assets/chips/EXE4-CircGun3.zip",
        code = "J",
        display_name = "CircGun3",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    condor = {
        package_id = "com.louise.card.condor",
        asset_path = "/server/assets/chips/Custom-Condor.zip",
        code = "B",
        display_name = "Condor",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    cornshot1 = {
        package_id = "com.ipc.card.corn1",
        asset_path = "/server/assets/chips/Custom-CornShot1.zip",
        code = "J",
        display_name = "CornShot1",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    cornshot2 = {
        package_id = "com.ipc.card.corn2",
        asset_path = "/server/assets/chips/Custom-CornShot2.zip",
        code = "C",
        display_name = "CornShot2",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    cornshot3 = {
        package_id = "com.ipc.card.corn3",
        asset_path = "/server/assets/chips/Custom-CornShot3.zip",
        code = "P",
        display_name = "CornShot3",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    cyclone = {
        package_id = "rune.legacy.cyclone",
        asset_path = "/server/assets/chips/Legacy-Cyclone.zip",
        code = "E",
        display_name = "Cyclone",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    dashatk = {
        package_id = "com.louise.card.dashattck",
        asset_path = "/server/assets/chips/Custom-DashAtk.zip",
        code = "C",
        display_name = "DashAtk",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    dollthunder1 = {
        package_id = "Dolthdr1rune.legacy.PVP",
        asset_path = "/server/assets/chips/Legacy-DollThunder1.zip",
        code = "A",
        display_name = "DollThunder1",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    dollthunder2 = {
        package_id = "Dolthdr2rune.legacy.PVP",
        asset_path = "/server/assets/chips/Legacy-DollThunder2.zip",
        code = "C",
        display_name = "DollThunder2",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    dollthunder3 = {
        package_id = "Dolthdr3.rune.legacy.PVP",
        asset_path = "/server/assets/chips/Legacy-DollThunder3.zip",
        code = "B",
        display_name = "DollThunder3",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    doublekunai1 = {
        package_id = "com.k1rbyat1na.card.EXE2-033-RyuoteKunai1",
        asset_path = "/server/assets/chips/EXE2-DoubleKunai1.zip",
        code = "E",
        display_name = "DoubleKunai1",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    doublekunai2 = {
        package_id = "com.k1rbyat1na.card.EXE2-034-RyuoteKunai2",
        asset_path = "/server/assets/chips/EXE2-DoubleKunai2.zip",
        code = "D",
        display_name = "DoubleKunai2",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    doublekunai3 = {
        package_id = "com.k1rbyat1na.card.EXE2-035-RyuoteKunai3",
        asset_path = "/server/assets/chips/EXE2-DoubleKunai3.zip",
        code = "C",
        display_name = "DoubleKunai3",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    dynawave = {
        package_id = "com.OFC.card.EXEPoN-053-DynaWave",
        asset_path = "/server/assets/chips/EXEPon-DynaWave.zip",
        code = "E",
        display_name = "DynaWave",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    elecshock = {
        package_id = "com.k1rbyat1na.card.EXE4-029-ElecShock",
        asset_path = "/server/assets/chips/EXE4-ElecShock.zip",
        code = "J",
        display_name = "ElecShock",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    flameline1 = {
        package_id = "com.OFC.card.EXEPoN-054-FlameLine1",
        asset_path = "/server/assets/chips/EXEPon-FlameLine1.zip",
        code = "F",
        display_name = "FlameLine1",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    flameline2 = {
        package_id = "com.OFC.card.EXEPoN-055-FlameLine2",
        asset_path = "/server/assets/chips/EXEPon-FlameLine2.zip",
        code = "D",
        display_name = "FlameLine2",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    heatbreath = {
        package_id = "com.k1rbyat1na.card.EXE4-028-HeatBreath",
        asset_path = "/server/assets/chips/EXE4-HeatBreath.zip",
        code = "D",
        display_name = "HeatBreath",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    heavyshake1 = {
        package_id = "com.OFC.card.EXE3-081-HeavyShake1",
        asset_path = "/server/assets/chips/EXE3-HeavyShake1.zip",
        code = "E",
        display_name = "HeavyShake1",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    heavyshake2 = {
        package_id = "com.OFC.card.EXE3-082-HeavyShake2",
        asset_path = "/server/assets/chips/EXE3-HeavyShake2.zip",
        code = "B",
        display_name = "HeavyShake2",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    heavyshake3 = {
        package_id = "com.OFC.card.EXE3-083-HeavyShake3",
        asset_path = "/server/assets/chips/EXE3-HeavyShake3.zip",
        code = "D",
        display_name = "HeavyShake3",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    hellsburner1 = {
        package_id = "com.OFC.card.EXE6-019-HellsBurner1",
        asset_path = "/server/assets/chips/EXE6-HellsBurner1.zip",
        code = "F",
        display_name = "HellsBurner1",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    hellsburner2 = {
        package_id = "com.OFC.card.EXE6-020-HellsBurner2",
        asset_path = "/server/assets/chips/EXE6-HellsBurner2.zip",
        code = "S",
        display_name = "HellsBurner2",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    hellsburner3 = {
        package_id = "com.OFC.card.EXE6-021-HellsBurner3",
        asset_path = "/server/assets/chips/EXE6-HellsBurner3.zip",
        code = "C",
        display_name = "HellsBurner3",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    hicannon = {
        package_id = "com.OFC.card.EXE6-002-HighCannon",
        asset_path = "/server/assets/chips/EXE6-HiCannon.zip",
        code = "L",
        display_name = "HiCannon",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    hurricane = {
        package_id = "rune.legacy.huricane",
        asset_path = "/server/assets/chips/Legacy-Hurricane.zip",
        code = "G",
        display_name = "Hurricane",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    iceball = {
        package_id = "com.OFC.card.EXEPoN-028-KooriHougan",
        asset_path = "/server/assets/chips/EXEPon-IceBall.zip",
        code = "D",
        display_name = "IceBall",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    katana1 = {
        package_id = "rune.legacy.katana1",
        asset_path = "/server/assets/chips/Legacy-Katana1.zip",
        code = "D",
        display_name = "Katana1",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    katana2 = {
        package_id = "rune.legacy.katana2",
        asset_path = "/server/assets/chips/Legacy-Katana2.zip",
        code = "B",
        display_name = "Katana2",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    katana3 = {
        package_id = "rune.legacy.katana3",
        asset_path = "/server/assets/chips/Legacy-Katana3.zip",
        code = "A",
        display_name = "Katana3",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    killersensor1 = {
        package_id = "com.OFC.card.EXE6-116-KillerSensor1",
        asset_path = "/server/assets/chips/EXE6-KillerSensor1.zip",
        code = "J",
        display_name = "KillerSensor1",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    killersensor2 = {
        package_id = "com.OFC.card.EXE6-117-KillerSensor2",
        asset_path = "/server/assets/chips/EXE6-KillerSensor2.zip",
        code = "N",
        display_name = "KillerSensor2",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    killersensor3 = {
        package_id = "com.OFC.card.EXE6-118-KillerSensor3",
        asset_path = "/server/assets/chips/EXE6-KillerSensor3.zip",
        code = "I",
        display_name = "KillerSensor3",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    lavaball = {
        package_id = "com.OFC.card.EXEPoN-029-YouganHougan",
        asset_path = "/server/assets/chips/EXEPon-LavaBall.zip",
        code = "E",
        display_name = "LavaBall",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    machinegun1 = {
        package_id = "com.OFC.card.EXE6-055-MachineGun1",
        asset_path = "/server/assets/chips/EXE6-MachineGun1.zip",
        code = "A",
        display_name = "MachineGun1",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    machinegun2 = {
        package_id = "com.OFC.card.EXE6-056-MachineGun2",
        asset_path = "/server/assets/chips/EXE6-MachineGun2.zip",
        code = "E",
        display_name = "MachineGun2",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    machinegun3 = {
        package_id = "com.OFC.card.EXE6-057-MachineGun3",
        asset_path = "/server/assets/chips/EXE6-MachineGun3.zip",
        code = "B",
        display_name = "MachineGun3",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    megacannon = {
        package_id = "com.OFC.card.EXE6-003-MegaCannon",
        asset_path = "/server/assets/chips/EXE6-MegaCannon.zip",
        code = "R",
        display_name = "MegaCannon",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    meteorearth1 = {
        package_id = "com.OFC.card.EXE5-093-MeteorEarth1",
        asset_path = "/server/assets/chips/EXE5-MeteorEarth1.zip",
        code = "A",
        display_name = "MeteorEarth1",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    meteorearth2 = {
        package_id = "com.OFC.card.EXE5-094-MeteorEarth2",
        asset_path = "/server/assets/chips/EXE5-MeteorEarth2.zip",
        code = "E",
        display_name = "MeteorEarth2",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    meteorearth3 = {
        package_id = "com.OFC.card.EXE5-095-MeteorEarth3",
        asset_path = "/server/assets/chips/EXE5-MeteorEarth3.zip",
        code = "C",
        display_name = "MeteorEarth3",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    plasmaball1 = {
        package_id = "com.OFC.card.EXE3-106-PlasmaBall1",
        asset_path = "/server/assets/chips/EXE3-PlasmaBall1.zip",
        code = "B",
        display_name = "PlasmaBall1",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    plasmaball2 = {
        package_id = "com.OFC.card.EXE3-107-PlasmaBall2",
        asset_path = "/server/assets/chips/EXE3-PlasmaBall2.zip",
        code = "A",
        display_name = "PlasmaBall2",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    plasmaball3 = {
        package_id = "com.OFC.card.EXE3-108-PlasmaBall3",
        asset_path = "/server/assets/chips/EXE3-PlasmaBall3.zip",
        code = "F",
        display_name = "PlasmaBall3",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    rabiring1 = {
        package_id = "com.OFC.card.EXEPoN-017-RabiRing1",
        asset_path = "/server/assets/chips/EXEPon-RabiRing1.zip",
        code = "A",
        display_name = "RabiRing1",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    rabiring2 = {
        package_id = "com.OFC.card.EXEPoN-018-RabiRing2",
        asset_path = "/server/assets/chips/EXEPon-RabiRing2.zip",
        code = "B",
        display_name = "RabiRing2",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    rabiring3 = {
        package_id = "com.OFC.card.EXEPoN-019-RabiRing3",
        asset_path = "/server/assets/chips/EXEPon-RabiRing3.zip",
        code = "C",
        display_name = "RabiRing3",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    ratton1 = {
        package_id = "com.OFC.card.EXEPoN-031-Ratton1",
        asset_path = "/server/assets/chips/EXEPon-Ratton1.zip",
        code = "A",
        display_name = "Ratton1",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    ratton2 = {
        package_id = "com.OFC.card.EXEPoN-032-Ratton2",
        asset_path = "/server/assets/chips/EXEPon-Ratton2.zip",
        code = "A",
        display_name = "Ratton2",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    ratton3 = {
        package_id = "com.OFC.card.EXEPoN-033-Ratton3",
        asset_path = "/server/assets/chips/EXEPon-Ratton3.zip",
        code = "A",
        display_name = "Ratton3",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    redfruit1 = {
        package_id = "P0W3RK1D.card.RedFruit1",
        asset_path = "/server/assets/chips/Custom-RedFruit1.zip",
        code = "K",
        display_name = "RedFruit1",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    reflector1 = {
        package_id = "com.OFC.card.EXE6-091-ReflecMet1",
        asset_path = "/server/assets/chips/EXE6-Reflector1.zip",
        code = "A",
        display_name = "Reflector1",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    reflector2 = {
        package_id = "com.OFC.card.EXE6-092-ReflecMet2",
        asset_path = "/server/assets/chips/EXE6-Reflector2.zip",
        code = "B",
        display_name = "Reflector2",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    reflector3 = {
        package_id = "com.OFC.card.EXE6-093-ReflecMet3",
        asset_path = "/server/assets/chips/EXE6-Reflector3.zip",
        code = "E",
        display_name = "Reflector3",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    satellite1 = {
        package_id = "com.OFC.card.EXEPoN-072-Satellite1",
        asset_path = "/server/assets/chips/EXEPon-Satellite1.zip",
        code = "D",
        display_name = "Satellite1",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    satellite2 = {
        package_id = "com.OFC.card.EXEPoN-073-Satellite2",
        asset_path = "/server/assets/chips/EXEPon-Satellite2.zip",
        code = "I",
        display_name = "Satellite2",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    satellite3 = {
        package_id = "com.OFC.card.EXEPoN-074-Satellite3",
        asset_path = "/server/assets/chips/EXEPon-Satellite3.zip",
        code = "H",
        display_name = "Satellite3",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    shockwave = {
        package_id = "com.OFC.card.EXEPoN-051-ShockWave",
        asset_path = "/server/assets/chips/EXEPon-ShockWave.zip",
        code = "D",
        display_name = "ShockWave",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    sonicwave = {
        package_id = "com.OFC.card.EXEPoN-052-SonicWave",
        asset_path = "/server/assets/chips/EXEPon-SonicWave.zip",
        code = "G",
        display_name = "SonicWave",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    triarrow = {
        package_id = "com.k1rbyat1na.card.EXE1-036-TripleArrow",
        asset_path = "/server/assets/chips/EXE1-TriArrow.zip",
        code = "A",
        display_name = "TriArrow",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    trilance = {
        package_id = "com.k1rbyat1na.card.EXE1-038-TripleLance",
        asset_path = "/server/assets/chips/EXE1-TriLance.zip",
        code = "K",
        display_name = "TriLance",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    trispear = {
        package_id = "com.k1rbyat1na.card.EXE1-037-TripleSpear",
        asset_path = "/server/assets/chips/EXE1-TriSpear.zip",
        code = "F",
        display_name = "TriSpear",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    typhoon = {
        package_id = "rune.legacy.typhoon",
        asset_path = "/server/assets/chips/Legacy-Typhoon.zip",
        code = "A",
        display_name = "Typhoon",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    wavearm1 = {
        package_id = "hoov.cards.wavearm1",
        asset_path = "/server/assets/chips/Custom-WaveArm1.zip",
        code = "E",
        display_name = "WaveArm1",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    wavearm2 = {
        package_id = "hoov.cards.wavearm2",
        asset_path = "/server/assets/chips/Custom-WaveArm2.zip",
        code = "L",
        display_name = "WaveArm2",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    wavearm3 = {
        package_id = "hoov.cards.wavearm3",
        asset_path = "/server/assets/chips/Custom-WaveArm3.zip",
        code = "R",
        display_name = "WaveArm3",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    wideshot1 = {
        package_id = "com.ijuinpersonalterminalcompany.card.wideshot1bn5",
        asset_path = "/server/assets/chips/Custom-WideShot1.zip",
        code = "L",
        display_name = "WideShot1",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    wideshot2 = {
        package_id = "com.ijuinpersonalterminalcompany.card.wideshot2bn5",
        asset_path = "/server/assets/chips/Custom-WideShot2.zip",
        code = "E",
        display_name = "WideShot2",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    wideshot3 = {
        package_id = "com.ijuinpersonalterminalcompany.card.wideshot3bn5",
        asset_path = "/server/assets/chips/Custom-WideShot3.zip",
        code = "S",
        display_name = "WideShot3",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    woodpowder = {
        package_id = "com.k1rbyat1na.card.EXE4-030-WoodPowder",
        asset_path = "/server/assets/chips/EXE4-WoodPowder.zip",
        code = "F",
        display_name = "WoodPowder",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    yoyo1 = {
        package_id = "com.loui.card.",
        asset_path = "/server/assets/chips/Custom-YoYo1.zip",
        code = "C",
        display_name = "YoYo1",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    yoyo2 = {
        package_id = "com.loui.card.",
        asset_path = "/server/assets/chips/Custom-YoYo2.zip",
        code = "H",
        display_name = "YoYo2",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    yoyo3 = {
        package_id = "com.loui.card.",
        asset_path = "/server/assets/chips/Custom-YoYo3.zip",
        code = "M",
        display_name = "YoYo3",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    -- ========================================================
    -- BLUE MYSTERY DATA
    -- ========================================================

    airwheel1 = {
        package_id = "com.OFC.card.EXE6-13",
        asset_path = "/server/assets/chips/EXE6-AirWheel1.zip",
        code = "F",
        display_name = "AirWheel1",
        sources = {
            blue_mystery = true,
            chip_seller = false,
        },
    },

    airwheel2 = {
        package_id = "com.OFC.card.EXE6-13",
        asset_path = "/server/assets/chips/EXE6-AirWheel2.zip",
        code = "A",
        display_name = "AirWheel2",
        sources = {
            blue_mystery = true,
            chip_seller = false,
        },
    },

    airwheel3 = {
        package_id = "com.OFC.card.EXE6-13",
        asset_path = "/server/assets/chips/EXE6-AirWheel3.zip",
        code = "N",
        display_name = "AirWheel3",
        sources = {
            blue_mystery = true,
            chip_seller = false,
        },
    },

    antidmg = {
        package_id = "com.ShaDis.CardBN6.189",
        asset_path = "/server/assets/chips/EXE6-AntiDmg.zip",
        code = "G",
        display_name = "AntiDmg",
        sources = {
            blue_mystery = true,
            chip_seller = false,
        },
    },

    attackplus30 = {
        package_id = "com.OFC.card.EXE6-197-Attack+30",
        asset_path = "/server/assets/chips/EXE6-AttackPlus30.zip",
        code = "*",
        display_name = "AttackPlus30",
        sources = {
            blue_mystery = true,
            chip_seller = false,
        },
    },

    boomerang = {
        package_id = "com.OFC.card.EXE6-119-Boomerang",
        asset_path = "/server/assets/chips/EXE6-Boomerang.zip",
        code = "T",
        display_name = "Boomerang",
        sources = {
            blue_mystery = true,
            chip_seller = false,
        },
    },

    colorpoint = {
        package_id = "com.OFC.card.EXE6-199-ColorPoint",
        asset_path = "/server/assets/chips/EXE6-ColorPoint.zip",
        code = "*",
        display_name = "ColorPoint",
        sources = {
            blue_mystery = true,
            chip_seller = false,
        },
    },

    doublepoint = {
        package_id = "com.OFC.card.EXE6-200-DoublePoint",
        asset_path = "/server/assets/chips/EXE6-DoublePoint.zip",
        code = "*",
        display_name = "DoublePoint",
        sources = {
            blue_mystery = true,
            chip_seller = false,
        },
    },

    flameline3 = {
        package_id = "com.OFC.card.EXEPoN-056-FlameLine3",
        asset_path = "/server/assets/chips/EXEPon-FlameLine3.zip",
        code = "J",
        display_name = "FlameLine3",
        sources = {
            blue_mystery = true,
            chip_seller = false,
        },
    },

    hiboomerang = {
        package_id = "com.OFC.card.EXE6-120-HighBoomerang",
        asset_path = "/server/assets/chips/EXE6-HiBoomerang.zip",
        code = "B",
        display_name = "HiBoomerang",
        sources = {
            blue_mystery = true,
            chip_seller = false,
        },
    },

    invisible = {
        package_id = "com.OFC.card.EXE6-179-Invisible",
        asset_path = "/server/assets/chips/EXE6-Invisible.zip",
        code = "*",
        display_name = "Invisible",
        sources = {
            blue_mystery = true,
            chip_seller = false,
        },
    },

    kunai = {
        package_id = "com.alrysc.card.BetterKunai",
        asset_path = "/server/assets/chips/Custom-Kunai.zip",
        code = "K",
        display_name = "Kunai",
        sources = {
            blue_mystery = true,
            chip_seller = false,
        },
    },

    lifesynchro = {
        package_id = "com.OFC.card.EXE6-195-LifeSynchro",
        asset_path = "/server/assets/chips/EXE6-LifeSynchro.zip",
        code = "*",
        display_name = "LifeSynchro",
        sources = {
            blue_mystery = true,
            chip_seller = false,
        },
    },

    megaboomerang = {
        package_id = "com.OFC.card.EXE6-121-MegaBoomerang",
        asset_path = "/server/assets/chips/EXE6-MegaBoomerang.zip",
        code = "I",
        display_name = "MegaBoomerang",
        sources = {
            blue_mystery = true,
            chip_seller = false,
        },
    },

    meteorshower = {
        package_id = "com.OFC.card.EXE6-111-Ryuuseigun",
        asset_path = "/server/assets/chips/EXE6-MeteorShower.zip",
        code = "R",
        display_name = "MeteorShower",
        sources = {
            blue_mystery = true,
            chip_seller = false,
        },
    },

    neovariable = {
        package_id = "com.OFC.card.EXE6-082-NeoVariable",
        asset_path = "/server/assets/chips/EXE6-NeoVariable.zip",
        code = "N",
        display_name = "NeoVariable",
        sources = {
            blue_mystery = true,
            chip_seller = false,
        },
    },

    pawn = {
        package_id = "com.alrysc.card.Pawn",
        asset_path = "/server/assets/chips/Custom-Pawn.zip",
        code = "B",
        display_name = "Pawn",
        sources = {
            blue_mystery = true,
            chip_seller = false,
        },
    },

    poltergeist = {
        package_id = "com.darkware.card.EXE5-Poltergeist",
        asset_path = "/server/assets/chips/EXE5-Poltergeist.zip",
        code = "P",
        display_name = "Poltergeist",
        sources = {
            blue_mystery = true,
            chip_seller = false,
        },
    },

    quickgauge = {
        package_id = "com.OFC.card.EXE6-175-QuickGauge",
        asset_path = "/server/assets/chips/EXE6-QuickGauge.zip",
        code = "E",
        display_name = "QuickGauge",
        sources = {
            blue_mystery = true,
            chip_seller = false,
        },
    },

    snowcannon = {
        package_id = "snowcan.eclipsedzenith",
        asset_path = "/server/assets/chips/Custom-SnowCannon.zip",
        code = "I",
        display_name = "SnowCannon",
        sources = {
            blue_mystery = true,
            chip_seller = false,
        },
    },

    strawdoll = {
        package_id = "com.OFC.card.EXE6-153-WaraNingyou",
        asset_path = "/server/assets/chips/EXE6-StrawDoll.zip",
        code = "F",
        display_name = "StrawDoll",
        sources = {
            blue_mystery = true,
            chip_seller = false,
        },
    },

    twinfang1 = {
        package_id = "hoov.card.twinfang1",
        asset_path = "/server/assets/chips/Custom-TwinFang1.zip",
        code = "A",
        display_name = "TwinFang1",
        sources = {
            blue_mystery = true,
            chip_seller = false,
        },
    },

    twinfang2 = {
        package_id = "hoov.card.twinfang2",
        asset_path = "/server/assets/chips/Custom-TwinFang2.zip",
        code = "O",
        display_name = "TwinFang2",
        sources = {
            blue_mystery = true,
            chip_seller = false,
        },
    },

    twinfang3 = {
        package_id = "hoov.card.twinfang3",
        asset_path = "/server/assets/chips/Custom-TwinFang3.zip",
        code = "F",
        display_name = "TwinFang3",
        sources = {
            blue_mystery = true,
            chip_seller = false,
        },
    },

    -- ========================================================
    -- CHIP SELLER
    -- ========================================================

    aquasword = {
        package_id = "com.OFC.card.EXE6-076-AquaSword",
        asset_path = "/server/assets/chips/EXE6-AquaSword.zip",
        code = "A",
        display_name = "AquaSword",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    bigbomb = {
        package_id = "com.ipc.k1rbyat1na.card.EXE6-059-BigBomb",
        asset_path = "/server/assets/chips/EXE6-BigBomb.zip",
        code = "O",
        display_name = "BigBomb",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    energybomb = {
        package_id = "com.rune.k1rbyat1na.card.EXE6-060-EnergyBomb",
        asset_path = "/server/assets/chips/EXE6-EnergyBomb.zip",
        code = "C",
        display_name = "EnergyBomb",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    flamesword = {
        package_id = "com.OFC.card.EXE6-075-FlameSword",
        asset_path = "/server/assets/chips/EXE6-FlameSword.zip",
        code = "F",
        display_name = "FlameSword",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    fullcustom = {
        package_id = "com.OFC.card.EXE6-176-FullCustom",
        asset_path = "/server/assets/chips/EXE6-FullCustom.zip",
        code = "*",
        display_name = "FullCustom",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    gundelsol1 = {
        package_id = "com.OFC.card.EXE6-015-GunDelSol1",
        asset_path = "/server/assets/chips/EXE6-GunDelSol1.zip",
        code = "C",
        display_name = "GunDelSol1",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    gundelsol2 = {
        package_id = "com.OFC.card.EXE6-016-GunDelSol2",
        asset_path = "/server/assets/chips/EXE6-GunDelSol2.zip",
        code = "B",
        display_name = "GunDelSol2",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    gundelsol3 = {
        package_id = "com.OFC.card.EXE6-017-GunDelSol3",
        asset_path = "/server/assets/chips/EXE6-GunDelSol3.zip",
        code = "N",
        display_name = "GunDelSol3",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    longsword = {
        package_id = "com.OFC.card.EXE6-072-LongSword",
        asset_path = "/server/assets/chips/EXE6-LongSword.zip",
        code = "H",
        display_name = "LongSword",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    markvulcan1 = {
        package_id = "com.alrysc.card.markvulcan1",
        asset_path = "/server/assets/chips/Custom-MarkVulcan1.zip",
        code = "M",
        display_name = "MarkVulcan1",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    markvulcan2 = {
        package_id = "com.alrysc.card.markvulcan2",
        asset_path = "/server/assets/chips/Custom-MarkVulcan2.zip",
        code = "E",
        display_name = "MarkVulcan2",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    markvulcan3 = {
        package_id = "com.alrysc.card.markvulcan3",
        asset_path = "/server/assets/chips/Custom-MarkVulcan3.zip",
        code = "H",
        display_name = "MarkVulcan3",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    megaenergybomb = {
        package_id = "com.rune.k1rbyat1na.card.EXE6-061-MegaEnergyBomb",
        asset_path = "/server/assets/chips/EXE6-MegaEnergyBomb.zip",
        code = "G",
        display_name = "MegaEnergyBomb",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    pulsebeam1 = {
        package_id = "com.OFC.card.EXE5-012-PulseBeam1",
        asset_path = "/server/assets/chips/EXE5-PulseBeam1.zip",
        code = "F",
        display_name = "PulseBeam1",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    pulsebeam2 = {
        package_id = "com.OFC.card.EXE5-013-PulseBeam2",
        asset_path = "/server/assets/chips/EXE5-PulseBeam2.zip",
        code = "E",
        display_name = "PulseBeam2",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    pulsebeam3 = {
        package_id = "com.OFC.card.EXE5-014-PulseBeam3",
        asset_path = "/server/assets/chips/EXE5-PulseBeam3.zip",
        code = "C",
        display_name = "PulseBeam3",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    recov10 = {
        package_id = "com.OFC.card.EXE6-156-Recovery",
        asset_path = "/server/assets/chips/EXE6-Recov10.zip",
        code = "A",
        display_name = "Recov10",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    recov120 = {
        package_id = "com.OFC.card.EXE6-160-Recovery",
        asset_path = "/server/assets/chips/EXE6-Recov120.zip",
        code = "F",
        display_name = "Recov120",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    recov150 = {
        package_id = "com.OFC.card.EXE6-161-Recovery",
        asset_path = "/server/assets/chips/EXE6-Recov150.zip",
        code = "J",
        display_name = "Recov150",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    recov200 = {
        package_id = "com.OFC.card.EXE6-162-Recovery",
        asset_path = "/server/assets/chips/EXE6-Recov200.zip",
        code = "I",
        display_name = "Recov200",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    recov30 = {
        package_id = "com.OFC.card.EXE6-157-Recovery",
        asset_path = "/server/assets/chips/EXE6-Recov30.zip",
        code = "E",
        display_name = "Recov30",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    recov300 = {
        package_id = "com.OFC.card.EXE6-163-Recovery",
        asset_path = "/server/assets/chips/EXE6-Recov300.zip",
        code = "J",
        display_name = "Recov300",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    recov50 = {
        package_id = "com.OFC.card.EXE6-158-Recovery",
        asset_path = "/server/assets/chips/EXE6-Recov50.zip",
        code = "C",
        display_name = "Recov50",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    recov80 = {
        package_id = "com.OFC.card.EXE6-159-Recovery",
        asset_path = "/server/assets/chips/EXE6-Recov80.zip",
        code = "H",
        display_name = "Recov80",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    spreadgun1 = {
        package_id = "com.OFC.card.EXE6-009-SpreadGun1",
        asset_path = "/server/assets/chips/EXE6-SpreadGun1.zip",
        code = "L",
        display_name = "SpreadGun1",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    spreadgun2 = {
        package_id = "com.OFC.card.EXE6-010-SpreadGun2",
        asset_path = "/server/assets/chips/EXE6-SpreadGun2.zip",
        code = "A",
        display_name = "SpreadGun2",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    spreadgun3 = {
        package_id = "com.OFC.card.EXE6-011-SpreadGun3",
        asset_path = "/server/assets/chips/EXE6-SpreadGun3.zip",
        code = "Q",
        display_name = "SpreadGun3",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    stonecube = {
        package_id = "com.OFC.card.EXE6-138-StoneCube",
        asset_path = "/server/assets/chips/EXE6-StoneCube.zip",
        code = "*",
        display_name = "StoneCube",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    supernorthwind = {
        package_id = "com.OFC.card.EXE4-130-SuperKitakaze",
        asset_path = "/server/assets/chips/EXE4-SuperNorthWind.zip",
        code = "E",
        display_name = "SuperNorthWind",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    supervulcan = {
        package_id = "com.OFC.card.EXEPoN-124-SuperVulcan",
        asset_path = "/server/assets/chips/EXEPon-SuperVulcan.zip",
        code = "V",
        display_name = "SuperVulcan",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    thunderball = {
        package_id = "com.OFC.card.EXE6-029-ThunderBall",
        asset_path = "/server/assets/chips/EXE6-ThunderBall.zip",
        code = "B",
        display_name = "ThunderBall",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    timebomb1 = {
        package_id = "hoov.cards.timebomb1",
        asset_path = "/server/assets/chips/Custom-TimeBomb1.zip",
        code = "H",
        display_name = "TimeBomb1",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    timebomb2 = {
        package_id = "hoov.cards.timebomb2",
        asset_path = "/server/assets/chips/Custom-TimeBomb2.zip",
        code = "D",
        display_name = "TimeBomb2",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    timebomb3 = {
        package_id = "hoov.cards.timebomb3",
        asset_path = "/server/assets/chips/Custom-TimeBomb3.zip",
        code = "F",
        display_name = "TimeBomb3",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    tornado = {
        package_id = "com.OFC.card.EXE6-053-Tornado",
        asset_path = "/server/assets/chips/EXE6-Tornado.zip",
        code = "L",
        display_name = "Tornado",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    variablesword = {
        package_id = "com.OFC.card.EXE6-081-VariableSword",
        asset_path = "/server/assets/chips/EXE6-VariableSword.zip",
        code = "K",
        display_name = "VariableSword",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    vulcan1 = {
        package_id = "com.OFC.card.EXEPoN-004-Vulcan1",
        asset_path = "/server/assets/chips/EXEPon-Vulcan1.zip",
        code = "E",
        display_name = "Vulcan1",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    vulcan2 = {
        package_id = "com.OFC.card.EXEPoN-005-Vulcan2",
        asset_path = "/server/assets/chips/EXEPon-Vulcan2.zip",
        code = "B",
        display_name = "Vulcan2",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    vulcan3 = {
        package_id = "com.OFC.card.EXEPoN-006-Vulcan3",
        asset_path = "/server/assets/chips/EXEPon-Vulcan3.zip",
        code = "O",
        display_name = "Vulcan3",
        sources = {
            blue_mystery = false,
            chip_seller = true,
        },
    },

    -- ========================================================
    -- BOSS REWARDS
    -- ========================================================

    bassdg = {
        package_id = "com.alrysc.card.BassDG",
        asset_path = "/server/assets/chips/Custom-BassDG.zip",
        code = "F",
        display_name = "BassDG",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    burnerman = {
        package_id = "com.OFC.card.EXE4-248-BurnerMan",
        asset_path = "/server/assets/chips/EXE4-BurnerMan.zip",
        code = "B",
        display_name = "BurnerMan",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    burnermands = {
        package_id = "com.OFC.card.EXE4-250-BurnerManDS",
        asset_path = "/server/assets/chips/EXE4-BurnerManDS.zip",
        code = "B",
        display_name = "BurnerManDS",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    burnermansp = {
        package_id = "com.OFC.card.EXE4-249-BurnerManSP",
        asset_path = "/server/assets/chips/EXE4-BurnerManSP.zip",
        code = "B",
        display_name = "BurnerManSP",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    elementman = {
        package_id = "com.OFC.card.EXE6-270-ElementMan",
        asset_path = "/server/assets/chips/EXE6-ElementMan.zip",
        code = "E",
        display_name = "ElementMan",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    elementmanex = {
        package_id = "com.OFC.card.EXE6-271-ElementManEX",
        asset_path = "/server/assets/chips/EXE6-ElementManEX.zip",
        code = "E",
        display_name = "ElementManEX",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    elementmansp = {
        package_id = "com.OFC.card.EXE6-272-ElementManSP",
        asset_path = "/server/assets/chips/EXE6-ElementManSP.zip",
        code = "E",
        display_name = "ElementManSP",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    hatman = {
        package_id = "com.OFC.card.EXEPoN-172-HatMan",
        asset_path = "/server/assets/chips/EXEPon-HatMan.zip",
        code = "H",
        display_name = "HatMan",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    hatmansp = {
        package_id = "com.OFC.card.EXEPoN-175-HatManSP",
        asset_path = "/server/assets/chips/EXEPon-HatManSP.zip",
        code = "H",
        display_name = "HatManSP",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    hatmanv2 = {
        package_id = "com.OFC.card.EXEPoN-173-HatManV2",
        asset_path = "/server/assets/chips/EXEPon-HatManV2.zip",
        code = "H",
        display_name = "HatManV2",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    hatmanv3 = {
        package_id = "com.OFC.card.EXEPoN-174-HatManV3",
        asset_path = "/server/assets/chips/EXEPon-HatManV3.zip",
        code = "H",
        display_name = "HatManV3",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    shademan = {
        package_id = "com.OFC.card.EXE5-262-ShadeMan",
        asset_path = "/server/assets/chips/EXE5-ShadeMan.zip",
        code = "S",
        display_name = "ShadeMan",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    shademands = {
        package_id = "com.OFC.card.EXE5-264-ShadeManDS",
        asset_path = "/server/assets/chips/EXE5-ShadeManDS.zip",
        code = "S",
        display_name = "ShadeManDS",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    shademansp = {
        package_id = "com.OFC.card.EXE5-263-ShadeManSP",
        asset_path = "/server/assets/chips/EXE5-ShadeManSP.zip",
        code = "S",
        display_name = "ShadeManSP",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    shadowman = {
        package_id = "com.OFC.card.EXE5-244-ShadowMan",
        asset_path = "/server/assets/chips/EXE5-ShadowMan.zip",
        code = "S",
        display_name = "ShadowMan",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    shadowmands = {
        package_id = "com.OFC.card.EXE5-246-ShadowManDS",
        asset_path = "/server/assets/chips/EXE5-ShadowManDS.zip",
        code = "S",
        display_name = "ShadowManDS",
        sources = {
            blue_mystery = false,
            chip_seller = false,
        },
    },

    shadowmansp = {
        package_id = "com.OFC.card.EXE5-245-ShadowManSP",
        asset_path = "/server/assets/chips/EXE5-ShadowManSP.zip",
        code = "S",
        display_name = "ShadowManSP",
        sources = {
            blue_mystery = false,
            chip_seller = false,
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

function crawler_whitelist.begin_run_for_player(
    player_id,
    run_id
)
    run_id =
        tostring(
            run_id or ""
        )

    if run_id == ""
        or run_id == "pool"
    then
        return false,
            "invalid_run_id"
    end


    local player_memory,
        safe_secret =
        get_player_memory(
            player_id
        )

    if not player_memory
        or not safe_secret
    then
        return false,
            "missing_player_memory"
    end


    if type(
        player_memory.meta
    ) ~= "table"
    then
        player_memory.meta = {}
    end


    local previous_run_id =
        tostring(
            player_memory.meta.crawler_run_id
                or ""
        )


    -- A genuinely new run starts with no earned crawler chips.
    --
    -- Re-entering the SAME active run keeps everything already
    -- earned during that run.
    if previous_run_id ~= run_id then
        player_memory.crawler_chip_unlocks = {}

        pending_reward_packets[
            player_id
        ] = nil

        hydrated_run_for_player[
            player_id
        ] = nil
    end


    if type(
        player_memory.crawler_chip_unlocks
    ) ~= "table"
    then
        player_memory.crawler_chip_unlocks = {}
    end


    player_memory.meta.crawler_run_id =
        run_id


    ezmemory.save_player_memory(
        safe_secret
    )


    print(
        "[crawler_whitelist] player " ..
        tostring(player_id) ..
        " entered crawler run " ..
        run_id
    )


    return true,
        "ready"
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

function crawler_whitelist.restore_unlocked_cards_for_current_run(
    player_id
)
    crawler_whitelist.apply_for_player(
        player_id
    )

    return queue_unlocked_cards_for_current_run(
        player_id
    )
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