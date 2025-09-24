AddEventHandler("Finance:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Generator = exports["sandbox-base"]:FetchComponent("Generator")
	Wallet = exports["sandbox-base"]:FetchComponent("Wallet")
	Jobs = exports["sandbox-base"]:FetchComponent("Jobs")
	Properties = exports["sandbox-base"]:FetchComponent("Properties")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Finance", {
		"Generator",
		"Wallet",
		"Jobs",
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
