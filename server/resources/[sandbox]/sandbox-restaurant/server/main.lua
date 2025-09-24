AddEventHandler("Restaurant:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	Jobs = exports["sandbox-base"]:FetchComponent("Jobs")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Restaurant", {
		"Inventory",
		"Jobs",
	}, function(error)
		if error then
		end

		RetrieveComponents()
		Startup()

		exports['sandbox-base']:MiddlewareAdd("Characters:Spawning", function(source)
			RunRestaurantJobUpdate(source, true)
		end, 2)
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Restaurant", _RESTAURANT)
end)

_RESTAURANT = {}

function RunRestaurantJobUpdate(source, onSpawn)
	local charJobs = Jobs.Permissions:GetJobs(source)
	local warmersList = {}
	for k, v in ipairs(charJobs) do
		local jobWarmers = _warmers[v.Id]
		if jobWarmers then
			table.insert(warmersList, jobWarmers)
		end
	end
	TriggerClientEvent("Restaurant:Client:CreatePoly", source, _pickups, warmersList, onSpawn)
end

AddEventHandler("Jobs:Server:JobUpdate", function(source)
	RunRestaurantJobUpdate(source)
end)
