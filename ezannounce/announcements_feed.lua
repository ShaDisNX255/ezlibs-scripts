local announcments = {
    {
        id = "WELCOME_2809",
        icon = 1,
        title = "Welcome",
        from = "Admin",
        body = "Welcome to ONB Mystery Dungeon. Be careful when you navigate through the dungeon, if you get deleted you lose your progress. The server restarts after 2 minutes of no online players and re-builds the maps, so you'll always have a different experience. Have fun!",
        mug_texture_path = "",
        mug_animation_path = "",
        starts_at = 0,        -- optional: timestamp when it becomes active
        ends_at = nil,        -- optional: expiry timestamp
        priority = 0,         -- higher = more likely to trigger the ring
        notify_message = "Looks like you got an e-mail!",
    }
}
return announcments
