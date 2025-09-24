AddEventHandler("Drugs:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	Targeting = exports["sandbox-base"]:FetchComponent("Targeting")
	Progress = exports["sandbox-base"]:FetchComponent("Progress")
	Hud = exports["sandbox-base"]:FetchComponent("Hud")
	ObjectPlacer = exports["sandbox-base"]:FetchComponent("ObjectPlacer")
	Minigame = exports["sandbox-base"]:FetchComponent("Minigame")
	ListMenu = exports["sandbox-base"]:FetchComponent("ListMenu")
	PedInteraction = exports["sandbox-base"]:FetchComponent("PedInteraction")
	Polyzone = exports["sandbox-base"]:FetchComponent("Polyzone")
	Minigame = exports["sandbox-base"]:FetchComponent("Minigame")
	Status = exports["sandbox-base"]:FetchComponent("Status")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Drugs", {
		"Inventory",
		"Targeting",
		"Progress",
		"Hud",
		"ObjectPlacer",
		"Minigame",
		"ListMenu",
		"PedInteraction",
		"Polyzone",
		"Minigame",
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
