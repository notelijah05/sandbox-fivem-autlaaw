Spawns = {}

function Startup()
	exports['sandbox-characters']:GetAllLocations("spawn", function(results)
		if not results then
			exports['sandbox-base']:LoggerError("Characters", "Failed to load spawn locations")
			return
		end

		exports['sandbox-base']:LoggerTrace("Characters", "Loaded ^2" .. #results .. "^7 Spawn Locations",
			{ console = true })

		for k, v in ipairs(results) do
			local spawn = {
				id = v.id,
				label = v.label,
				location = { x = v.location.x, y = v.location.y, z = v.location.z, h = v.location.h },
			}
			table.insert(Spawns, spawn)
		end
	end)
end
