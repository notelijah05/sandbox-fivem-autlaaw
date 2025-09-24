AddEventHandler("Hospital:Shared:DependencyUpdate", SAFDComponents)
function SAFDComponents()
	Damage = exports["sandbox-base"]:FetchComponent("Damage")
	Targeting = exports["sandbox-base"]:FetchComponent("Targeting")
	Hospital = exports["sandbox-base"]:FetchComponent("Hospital")
	PedInteraction = exports["sandbox-base"]:FetchComponent("PedInteraction")
	Escort = exports["sandbox-base"]:FetchComponent("Escort")
	Polyzone = exports["sandbox-base"]:FetchComponent("Polyzone")
	Animations = exports["sandbox-base"]:FetchComponent("Animations")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Hospital", {
		"Damage",
		"Targeting",
		"Hospital",
		"PedInteraction",
		"Escort",
		"Polyzone",
		"Animations",
	}, function(error)
		if #error > 0 then
			return
		end
		SAFDComponents()
		SAFDInit()
	end)
end)
