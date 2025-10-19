_pickups = {}

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Wait(1000)
		TriggerEvent("Businesses:Server:Startup")

		exports['sandbox-base']:MiddlewareAdd("Characters:Spawning", function(source)
			TriggerClientEvent(
				"Taco:SetQueue",
				source,
				{ counter = GlobalState["TacoShop:Counter"], item = GlobalState["TacoShop:CurrentItem"] }
			)
		end, 2)

		exports['sandbox-base']:MiddlewareAdd("Characters:Spawning", function(source)
			TriggerLatentClientEvent("Businesses:Client:CreatePoly", source, 50000, _pickups)
		end, 2)

		Startup()
	end
end)

function Startup()
	for k, v in ipairs(Config.Businesses) do
		exports['sandbox-base']:LoggerTrace("Businesses", string.format("Registering Business ^3%s^7", v.Name))
		if v.Pickups then
			for num, pickup in pairs(v.Pickups) do
				table.insert(_pickups, pickup.id)
				pickup.num = num
				pickup.job = v.Job
				pickup.jobName = v.Name
				GlobalState[string.format("Businesses:Pickup:%s", pickup.id)] = pickup
			end
		end
	end
end
