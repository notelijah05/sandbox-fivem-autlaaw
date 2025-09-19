AddEventHandler("Jobs:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Logger = exports["sandbox-base"]:FetchComponent("Logger")
	Utils = exports["sandbox-base"]:FetchComponent("Utils")
	Notification = exports["sandbox-base"]:FetchComponent("Notification")
	Jobs = exports["sandbox-base"]:FetchComponent("Jobs")
	Polyzone = exports["sandbox-base"]:FetchComponent("Polyzone")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Jobs", {
		"Logger",
		"Utils",
		"Notification",
		"Jobs",
		"Polyzone",
		"Inventory",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()
		RegisterMetalDetectors()
	end)
end)
