local loot_tiers = {}


loot_tiers.blue_mystery = {
    -- EASY
    airwheel1 = "easy",
    boomerang = "easy",
    invisible = "easy",
    kunai = "easy",
    pawn = "easy",
    snowcannon = "easy",
    strawdoll = "easy",
    twinfang1 = "easy",
    deathmatch1 = "easy",
    cmonsnake = "easy",
    barrier = "easy",
    wideblade = "easy",
    longblade = "easy",

    -- MEDIUM
    airwheel2 = "medium",
    invisible = "easy",
    antidmg = "medium",
    colorpoint = "medium",
    flameline3 = "medium",
    hiboomerang = "medium",
    lifesynchro = "medium",
    quickgauge = "medium",
    twinfang2 = "medium",
    deathmatch2 = "medium",
    barrier100 = "medium",
    stelpnsh = "medium",
    attackplus20 = "medium",

    -- HARD
    airwheel3 = "hard",
    attackplus30 = "hard",
    doublepoint = "hard",
    megaboomerang = "hard",
    meteorshower = "hard",
    neovariable = "hard",
    poltergeist = "hard",
    twinfang3 = "hard",
    deathmatch3 = "hard",
    barrier200 = "hard",
    stelrvng = "hard",
    bamboolance = "hard",
    paladinsword = "hard",
}


loot_tiers.chip_seller = {
    -- EASY
    energybomb = "easy",
    gundelsol1 = "easy",
    longsword = "easy",
    markvulcan1 = "easy",
    pulsebeam1 = "easy",
    recov30 = "easy",
    recov50 = "easy",
    spreadgun1 = "easy",
    stonecube = "easy",
    thunderball = "easy",
    timebomb1 = "easy",

    -- MEDIUM
    aquasword = "medium",
    bigbomb = "medium",
    flamesword = "medium",
    gundelsol2 = "medium",
    markvulcan2 = "medium",
    megaenergybomb = "medium",
    pulsebeam2 = "medium",
    recov80 = "medium",
    recov120 = "medium",
    spreadgun2 = "medium",
    timebomb2 = "medium",
    tornado = "medium",
    vulcan2 = "medium",
    barrier100 = "medium",

    -- HARD
    fullcustom = "hard",
    gundelsol3 = "hard",
    markvulcan3 = "hard",
    pulsebeam3 = "hard",
    recov150 = "hard",
    recov200 = "hard",
    recov300 = "hard",
    spreadgun3 = "hard",
    supernorthwind = "hard",
    supervulcan = "hard",
    timebomb3 = "hard",
    variablesword = "hard",
    vulcan3 = "hard",
    barrier200 = "hard",
    stelrvng = "hard",
}


function loot_tiers.get(
    source,
    chip_key
)
    local source_tiers =
        loot_tiers[source]

    if not source_tiers then
        return nil
    end

    return source_tiers[
        chip_key
    ]
end


function loot_tiers.matches(
    source,
    chip_key,
    tier
)
    return loot_tiers.get(
        source,
        chip_key
    ) == tier
end


return loot_tiers