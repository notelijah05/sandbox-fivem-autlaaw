AddEventHandler("Hospital:Shared:DependencyUpdate", PrisonHospitalComponents)
function PrisonHospitalComponents()
	Damage = exports["sandbox-base"]:FetchComponent("Damage")
	Targeting = exports["sandbox-base"]:FetchComponent("Targeting")
	Hospital = exports["sandbox-base"]:FetchComponent("Hospital")
	PedInteraction = exports["sandbox-base"]:FetchComponent("PedInteraction")
	Polyzone = exports["sandbox-base"]:FetchComponent("Polyzone")
	Animations = exports["sandbox-base"]:FetchComponent("Animations")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Hospital", {
		"Damage",
		"Targeting",
		"Hospital",
		"PedInteraction",
		"Polyzone",
		"Animations",
		"Inventory",
	}, function(error)
		if #error > 0 then
			return
		end
		PrisonHospitalComponents()
		PrisonHospitalInit()
		PrisonVisitation()
	end)
end)
