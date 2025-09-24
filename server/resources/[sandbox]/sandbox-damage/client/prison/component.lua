AddEventHandler("Hospital:Shared:DependencyUpdate", PrisonHospitalComponents)
function PrisonHospitalComponents()
	Damage = exports["sandbox-base"]:FetchComponent("Damage")
	Hospital = exports["sandbox-base"]:FetchComponent("Hospital")
	Polyzone = exports["sandbox-base"]:FetchComponent("Polyzone")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Hospital", {
		"Damage",
		"Hospital",
		"Polyzone",
	}, function(error)
		if #error > 0 then
			return
		end
		PrisonHospitalComponents()
		PrisonHospitalInit()
		PrisonVisitation()
	end)
end)
