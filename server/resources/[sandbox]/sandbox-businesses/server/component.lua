_pickups = {}

AddEventHandler("Core:Shared:Ready", function()
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
end)

function Startup()
	for k, v in ipairs(Config.Businesses) do
		exports['sandbox-base']:LoggerTrace("Businesses", string.format("Registering Business ^3%s^7", v.Name))
		if v.Benches then
			for benchId, bench in pairs(v.Benches) do
				-- exports['sandbox-base']:LoggerTrace(
				-- 	"Businesses",
				-- 	string.format("Registering Crafting Bench ^2%s^7 For ^3%s^7", bench.label, v.Name)
				-- )

				if bench.targeting.manual then
					exports['sandbox-inventory']:CraftingRegisterBench(string.format("%s-%s", v.Job, benchId),
						bench.label, bench.targeting, {}, {
							job = {
								id = v.Job,
								onDuty = true,
							},
						}, bench.recipes)
				else
					exports['sandbox-inventory']:CraftingRegisterBench(string.format("%s-%s", k, benchId), bench.label,
						bench.targeting, {
							x = 0,
							y = 0,
							z = bench.targeting.poly.coords.z,
							h = bench.targeting.poly.options.heading,
						}, {
							job = {
								id = v.Job,
								onDuty = true,
							},
						}, bench.recipes)
				end
			end
		end

		if v.Storage then
			for _, storage in pairs(v.Storage) do
				-- exports['sandbox-base']:LoggerTrace(
				-- 	"Businesses",
				-- 	string.format("Registering Poly Inventory ^2%s^7 For ^3%s^7", storage.id, v.Name)
				-- )
				exports['sandbox-inventory']:PolyCreate(storage)
			end
		end

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
