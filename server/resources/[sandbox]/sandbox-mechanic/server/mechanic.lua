AddEventHandler("Apartments:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Mechanic = exports["sandbox-base"]:FetchComponent("Mechanic")
	Jobs = exports["sandbox-base"]:FetchComponent("Jobs")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Mechanic", {
		"Mechanic",
		"Jobs",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()
		RegisterCallbacks()

		RegisterMechanicItems()

		for k, v in ipairs(_mechanicShopStorageCrafting) do
			if v.partCrafting then
				for benchId, bench in ipairs(v.partCrafting) do
					exports['sandbox-inventory']:CraftingRegisterBench(string.format("mech-%s-%s", v.job, benchId),
						bench.label, bench.targeting, {
							x = bench.targeting.poly.coords.x,
							y = bench.targeting.poly.coords.y,
							z = bench.targeting.poly.coords.z,
							h = bench.targeting.poly.options.heading,
						}, {
							job = {
								id = v.job,
								onDuty = true,
							},
						}, bench.recipes, bench.canUseSchematics)
				end
			end

			if v.partStorage then
				for storageId, storage in ipairs(v.partStorage) do
					exports['sandbox-inventory']:PolyCreate(storage)
				end
			end
		end
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Mechanic", MECHANIC)
end)

MECHANIC = {}
