AddEventHandler("Damage:Shared:DependencyUpdate", PrisonHospitalComponents)
function PrisonHospitalComponents()
	Crypto = exports["sandbox-base"]:FetchComponent("Crypto")
	Billing = exports["sandbox-base"]:FetchComponent("Billing")
	Labor = exports["sandbox-base"]:FetchComponent("Labor")
	Jobs = exports["sandbox-base"]:FetchComponent("Jobs")
	Handcuffs = exports["sandbox-base"]:FetchComponent("Handcuffs")
	Pwnzor = exports["sandbox-base"]:FetchComponent("Pwnzor")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("PrisonHospital", {
		"Crypto",
		"Billing",
		"Labor",
		"Jobs",
		"Handcuffs",
		"Pwnzor",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		PrisonHospitalComponents()
		PrisonHospitalCallbacks()
	end)
end)
