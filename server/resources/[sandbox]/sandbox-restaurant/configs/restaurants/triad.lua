table.insert(Config.Restaurants, {
    Name = "Triad Records Bar",
    Job = "triad",
    Pickups = {
        {
            id = "triad-pickup-1",
            coords = vector3(-828.37, -727.79, 28.06),
            width = 1.0,
            length = 1.0,
            options = {
                heading = 0,
                --debugPoly=true,
                minZ = 27.66,
                maxZ = 29.06
            },
            data = {
                business = "triad",
                inventory = {
                    invType = 25,
                    owner = "triad-pickup-1",
                },
            },
        },
    },
    Warmers = {
        {
            fridge = true,
            id = "triad-1",
            coords = vector3(-826.09, -729.23, 28.06),
            width = 1.6,
            length = 1.0,
            options = {
                heading = 0,
                --debugPoly=true,
                minZ = 27.06,
                maxZ = 28.46
            },
            restrict = {
                jobs = { "triad" },
            },
            data = {
                business = "triad",
                inventory = {
                    invType = 96,
                    owner = "triad-1",
                },
            },
        },
        {
            fridge = true,
            id = "triad-2",
            coords = vector3(-831.43, -730.5, 28.06),
            width = 0.8,
            length = 1.0,
            options = {
                heading = 0,
                --debugPoly=true,
                minZ = 26.86,
                maxZ = 29.06
            },
            restrict = {
                jobs = { "triad" },
            },
            data = {
                business = "triad",
                inventory = {
                    invType = 96,
                    owner = "triad-2",
                },
            },
        },
    },
})
