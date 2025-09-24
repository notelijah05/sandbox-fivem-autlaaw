AddEventHandler("Damage:Shared:DependencyUpdate", PrisonHospitalComponents)
function PrisonHospitalComponents()
	Damage = exports["sandbox-base"]:FetchComponent("Damage")
	Hospital = exports["sandbox-base"]:FetchComponent("Hospital")
	Crypto = exports["sandbox-base"]:FetchComponent("Crypto")
	Billing = exports["sandbox-base"]:FetchComponent("Billing")
	Labor = exports["sandbox-base"]:FetchComponent("Labor")
	Jobs = exports["sandbox-base"]:FetchComponent("Jobs")
	Handcuffs = exports["sandbox-base"]:FetchComponent("Handcuffs")
	Ped = exports["sandbox-base"]:FetchComponent("Ped")
	Pwnzor = exports["sandbox-base"]:FetchComponent("Pwnzor")
	Banking = exports["sandbox-base"]:FetchComponent("Banking")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("PrisonHospital", {
		"Damage",
		"Hospital",
		"Crypto",
		"Billing",
		"Labor",
		"Jobs",
		"Handcuffs",
		"Ped",
		"Pwnzor",
		"Banking",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		PrisonHospitalComponents()
		PrisonHospitalCallbacks()
	end)
end)
