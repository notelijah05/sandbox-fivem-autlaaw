table.insert(Config.Restaurants, {
	Name = "Tequi-La-La",
	Job = "tequila",
	Pickups = {
		{
			id = "tequila-pickup-1",
			coords = vector3(-560.79, 285.41, 82.18),
			width = 1.6,
			length = 1.6,
			options = {
				heading = 355,
				--debugPoly=true,
				minZ = 81.78,
				maxZ = 83.18,
			},
			data = {
				business = "tequila",
				inventory = {
					invType = 25,
					owner = "tequila-pickup-1",
				},
			},
		},
		{
			id = "tequila-pickup-2",
			coords = vector3(-560.56, 288.01, 82.18),
			width = 1.6,
			length = 1.6,
			options = {
				heading = 355,
				--debugPoly=true,
				minZ = 81.78,
				maxZ = 83.18,
			},
			data = {
				business = "tequila",
				inventory = {
					invType = 25,
					owner = "tequila-pickup-2",
				},
			},
		},
	},
	Warmers = {
		{
			fridge = true,
			id = "tequila-1",
			coords = vector3(-562.03, 290.0, 82.18),
			width = 2.0,
			length = 1.0,
			options = {
				heading = 355,
				--debugPoly=true,
				minZ = 81.18,
				maxZ = 83.38,
			},
			restrict = {
				jobs = { "tequila" },
			},
			data = {
				business = "tequila",
				inventory = {
					invType = 82,
					owner = "tequila-1",
				},
			},
		},
		{
			fridge = true,
			id = "tequila-2",
			coords = vector3(-563.03, 284.55, 82.18),
			width = 0.8,
			length = 1.0,
			options = {
				heading = 355,
				--debugPoly=true,
				minZ = 81.38,
				maxZ = 82.78,
			},
			restrict = {
				jobs = { "tequila" },
			},
			data = {
				business = "tequila",
				inventory = {
					invType = 82,
					owner = "tequila-2",
				},
			},
		},
	},
})
