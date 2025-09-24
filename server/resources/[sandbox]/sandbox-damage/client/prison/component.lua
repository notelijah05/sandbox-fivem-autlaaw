AddEventHandler("Hospital:Shared:DependencyUpdate", PrisonHospitalComponents)
function PrisonHospitalComponents()
	Polyzone = exports["sandbox-base"]:FetchComponent("Polyzone")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Hospital", {
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
