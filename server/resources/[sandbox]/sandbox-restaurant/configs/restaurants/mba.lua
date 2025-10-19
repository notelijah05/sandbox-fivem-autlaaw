table.insert(Config.Restaurants, {
	Name = "Maze Bank Arena",
	Job = "mba",
	Pickups = {
		{
			id = "mba-pickup-1",
			coords = vector3(-293.921, -1936.200, 42.088),
			width = 1.0,
			length = 1.0,
			options = {
				heading = 147.256,
				--debugPoly=true,
				minZ = 40.78,
				maxZ = 43.18,
			},
			data = {
				business = "mba",
				inventory = {
					invType = 146,
					owner = "mba-pickup-1",
				},
			},
		},
		{
			id = "mba-pickup-2",
			coords = vector3(-292.164, -1932.132, 30.157),
			width = 1.0,
			length = 1.0,
			options = {
				heading = 321,
				--debugPoly=true,
				minZ = 28.78,
				maxZ = 32.18,
			},
			data = {
				business = "mba",
				inventory = {
					invType = 147,
					owner = "mba-pickup-2",
				},
			},
		},
	},
})
