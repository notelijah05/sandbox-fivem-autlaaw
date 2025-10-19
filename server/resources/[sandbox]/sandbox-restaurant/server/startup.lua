_pickups = {}
_warmers = {}

function Startup()
	for k, v in ipairs(Config.Restaurants) do
		exports['sandbox-base']:LoggerTrace("Restaurant", string.format("Registering Restaurant ^3%s^7", v.Name))
		if v.Pickups then
			for num, pickup in pairs(v.Pickups) do
				table.insert(_pickups, pickup.id)
				pickup.num = num
				pickup.job = v.Job
				pickup.jobName = v.Name
				GlobalState[string.format("Restaurant:Pickup:%s", pickup.id)] = pickup
			end
		end

		if v.Warmers then
			for _, warmer in pairs(v.Warmers) do
				for _, jobId in ipairs(warmer.restrict.jobs) do
					if _warmers[jobId] == nil then
						_warmers[jobId] = {}
					end

					table.insert(_warmers[jobId], warmer.id)
				end
				GlobalState[string.format("Restaurant:Warmers:%s", warmer.id)] = warmer
			end
		end
	end
end
