AddEventHandler("Drugs:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	ObjectPlacer = exports["sandbox-base"]:FetchComponent("ObjectPlacer")
	Status = exports["sandbox-base"]:FetchComponent("Status")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Drugs", {
		"ObjectPlacer",
		"Status",
	}, function(error)
		if #error > 0 then
			exports['sandbox-base']:LoggerCritical("Drugs", "Failed To Load All Dependencies")
			return
		end
		RetrieveComponents()

		TriggerEvent("Drugs:Client:Startup")
	end)
end)
