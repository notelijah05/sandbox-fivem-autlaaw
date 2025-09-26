local Config = require('shared.config')

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Wait(1000)
		RegisterLocationCallbacks()
	end
end)

function RegisterLocationCallbacks()
	exports["sandbox-base"]:RegisterServerCallback("Locations:GetAll", {}, function(source, data, cb)
		exports['sandbox-characters']:GetAllLocations(data.type, cb)
	end)
end

exports("GetAllLocations", function(type, cb)
	local filtered = {}

	for _, location in ipairs(Config.DefaultSpawns) do
		if not type or location.Type == type then
			local locationCopy = {
				id = location.id,
				label = location.label,
				location = { x = location.location.x, y = location.location.y, z = location.location.z, h = location.location.h },
			}
			table.insert(filtered, locationCopy)
		end
	end

	cb(filtered)
end)
