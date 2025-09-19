AddEventHandler("Finance:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Utils = exports["sandbox-base"]:FetchComponent("Utils")
	Execute = exports["sandbox-base"]:FetchComponent("Execute")
	Middleware = exports["sandbox-base"]:FetchComponent("Middleware")
	Chat = exports["sandbox-base"]:FetchComponent("Chat")
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Generator = exports["sandbox-base"]:FetchComponent("Generator")
	Phone = exports["sandbox-base"]:FetchComponent("Phone")
	Crypto = exports["sandbox-base"]:FetchComponent("Crypto")
	Banking = exports["sandbox-base"]:FetchComponent("Banking")
	Billing = exports["sandbox-base"]:FetchComponent("Billing")
	Loans = exports["sandbox-base"]:FetchComponent("Loans")
	Wallet = exports["sandbox-base"]:FetchComponent("Wallet")
	Tasks = exports["sandbox-base"]:FetchComponent("Tasks")
	Jobs = exports["sandbox-base"]:FetchComponent("Jobs")
	Vehicles = exports["sandbox-base"]:FetchComponent("Vehicles")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	Properties = exports["sandbox-base"]:FetchComponent("Properties")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Finance", {
		"Utils",
		"Execute",
		"Chat",
		"Middleware",
		"Logger",
		"Generator",
		"Phone",
		"Wallet",
		"Banking",
		"Billing",
		"Loans",
		"Crypto",
		"Jobs",
		"Tasks",
		"Vehicles",
		"Inventory",
		"Properties",
	}, function(error)
		if #error > 0 then
			exports["sandbox-base"]:FetchComponent("Logger"):Critical("Finance", "Failed To Load All Dependencies")
			return
		end
		RetrieveComponents()

		TriggerEvent("Finance:Server:Startup")
	end)
end)
