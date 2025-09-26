local Config = require('shared.Config')

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Wait(1000)
		RegisterCallbacks()
		RegisterChatCommands()
		TriggerEvent("Locations:Server:Startup")
	end
end)

function RegisterCallbacks()
	exports["sandbox-base"]:RegisterServerCallback("Locations:GetAll", {}, function(source, data, cb)
		exports['sandbox-locations']:GetAll(data.type, cb)
	end)
end

function RegisterChatCommands()
	exports["sandbox-chat"]:RegisterAdminCommand("location", function(source, args, rawCommand)
		local playerPed = GetPlayerPed(source)
		local coords = GetEntityCoords(playerPed)
		local heading = GetEntityHeading(playerPed)
		if args[1]:lower() == "add" and args[2] then
			exports['sandbox-locations']:Add(coords, heading, args[2], args[3])
		end
	end, {
		help = "Add Location",
		params = {
			{
				name = "Action",
				help = "Available: add",
			},
			{
				name = "Type",
				help = "Type of Location",
			},
			{
				name = "Name",
				help = "Name of Location",
			},
		},
	}, 3)
end

exports("Add", function(coords, heading, type, name, cb)
	local doc = {
		Coords = {
			x = coords.x,
			y = coords.y,
			z = coords.z,
		},
		Heading = heading,
		Type = type,
		Name = name,
	}

	table.insert(Config.Spawns, doc)

	exports['sandbox-base']:LoggerInfo("Locations", string.format("Added location: %s (%s)", name, type))

	TriggerEvent("Locations:Server:Added", type, doc)
	if cb ~= nil then
		cb(true)
	end
end)

exports("GetAll", function(type, cb)
	local filtered = {}

	for _, location in ipairs(Config.Spawns) do
		if not type or location.Type == type then
			local locationCopy = {
				Coords = vector3(location.Coords.x, location.Coords.y, location.Coords.z),
				Heading = location.Heading,
				Type = location.Type,
				Name = location.Name
			}
			table.insert(filtered, locationCopy)
		end
	end

	cb(filtered)
end)
