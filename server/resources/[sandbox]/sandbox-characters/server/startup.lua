Spawns = {}

function Startup()
	exports['sandbox-locations']:GetAll("spawn", function(results)
		if not results then
			exports['sandbox-base']:LoggerError("Characters", "Failed to load spawn locations")
			return
		end

		exports['sandbox-base']:LoggerTrace("Characters", "Loaded ^2" .. #results .. "^7 Spawn Locations",
			{ console = true })

		Spawns = { table.unpack(Config.DefaultSpawns) }
		for k, v in ipairs(results) do
			local spawn = {
				id = v.Name, -- Use Name as id since we don't have _id from database anymore
				label = v.Name,
				location = { x = v.Coords.x, y = v.Coords.y, z = v.Coords.z, h = v.Heading },
			}
			table.insert(Spawns, spawn)
		end
	end)
end

AddEventHandler("Locations:Server:Added", function(type, location)
	if type == "spawn" then
		table.insert(Spawns, {
			label = location.Name,
			location = { x = location.Coords.x, y = location.Coords.y, z = location.Coords.z, h = location.Coords.h },
		})
		exports['sandbox-base']:LoggerInfo("Characters", "New Spawn Point Created: ^5" .. location.Name,
			{ console = true })
	end
end)
