AddEventHandler("Phone:Server:RegisterMiddleware", function()
	exports['sandbox-base']:MiddlewareAdd("Phone:Spawning", function(source, char)
		return {
			{
				type = "garages",
				data = exports['sandbox-vehicles']:GaragesGetAll(),
			},
		}
	end)
end)

AddEventHandler("Phone:Server:RegisterCallbacks", function()
	exports["sandbox-base"]:RegisterServerCallback("Phone:Garage:GetCars", function(source, data, cb)
		local src = source
		local char = exports['sandbox-characters']:FetchCharacterSource(src)
		exports['sandbox-vehicles']:OwnedGetAll(nil, 0, char:GetData("SID"), cb)
	end)

	exports["sandbox-base"]:RegisterServerCallback("Phone:Garage:TrackVehicle", function(source, data, cb)
		cb(exports['sandbox-vehicles']:OwnedTrack(data))
	end)
end)
