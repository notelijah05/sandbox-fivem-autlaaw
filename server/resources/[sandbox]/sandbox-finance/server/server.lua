AddEventHandler("Finance:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Generator = exports["sandbox-base"]:FetchComponent("Generator")
	Crypto = exports["sandbox-base"]:FetchComponent("Crypto")
	Banking = exports["sandbox-base"]:FetchComponent("Banking")
	Billing = exports["sandbox-base"]:FetchComponent("Billing")
	Loans = exports["sandbox-base"]:FetchComponent("Loans")
	Wallet = exports["sandbox-base"]:FetchComponent("Wallet")
	Jobs = exports["sandbox-base"]:FetchComponent("Jobs")
	Vehicles = exports["sandbox-base"]:FetchComponent("Vehicles")
	Properties = exports["sandbox-base"]:FetchComponent("Properties")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Finance", {
		"Generator",
		"Wallet",
		"Banking",
		"Billing",
		"Loans",
		"Crypto",
		"Jobs",
		"Vehicles",
		"Properties",
	}, function(error)
		if #error > 0 then
			exports['sandbox-base']:LoggerCritical("Finance", "Failed To Load All Dependencies")
			return
		end
		RetrieveComponents()

		TriggerEvent("Finance:Server:Startup")
	end)
end)
