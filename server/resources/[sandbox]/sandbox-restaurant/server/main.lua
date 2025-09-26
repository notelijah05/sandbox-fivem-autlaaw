AddEventHandler("Core:Shared:Ready", function()
	Startup()

	exports['sandbox-base']:MiddlewareAdd("Characters:Spawning", function(source)
		RunRestaurantJobUpdate(source, true)
	end, 2)
end)

function RunRestaurantJobUpdate(source, onSpawn)
	local charJobs = exports['sandbox-jobs']:GetJobs(source)
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
