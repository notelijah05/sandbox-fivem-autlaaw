table.insert(Config.Restaurants, {
    Name = "Bobs Balls",
    Job = "bowling",
    Pickups = {
        {
            id = "bobs_balls-pickup-1",
            coords = vector3(755.73, -768.12, 26.34),
            width = 0.8,
            length = 0.6,
            options = {
                heading = 0,
                --debugPoly=true,
                minZ = 26.14,
                maxZ = 26.94
            },
            data = {
                business = "bowling",
                inventory = {
                    invType = 25,
                    owner = "bobs_balls-pickup-1",
                },
            },
        },
    },
    -- Warmers = {
    -- 	{
    -- 		id = "pizza_this-warmer-1",
    -- 		coords = vector3(811.69, -755.44, 26.78),
    -- 		width = 0.8,
    -- 		length = 2.0,
    -- 		options = {
    -- 			heading = 0,
    -- 			--debugPoly=true,
    -- 			minZ = 26.58,
    -- 			maxZ = 27.38
    -- 		},
    -- 		restrict = {
    -- 			jobs = { "pizza_this" },
    -- 		},
    -- 		inventory = {
    -- 			invType = 60,
    -- 			owner = "pizza_this-warmer-1",
    -- 		},
    -- 	},
    -- },
})
