AddEventHandler("Damage:Shared:DependencyUpdate", PrisonHospitalComponents)
function PrisonHospitalComponents()
	Labor = exports["sandbox-base"]:FetchComponent("Labor")
	Pwnzor = exports["sandbox-base"]:FetchComponent("Pwnzor")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("PrisonHospital", {
		"Labor",
		"Pwnzor",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		PrisonHospitalComponents()
		PrisonHospitalCallbacks()
	end)
end)
