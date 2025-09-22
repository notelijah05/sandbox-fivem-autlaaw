AddEventHandler("Jobs:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Jobs = exports["sandbox-base"]:FetchComponent("Jobs")
	Polyzone = exports["sandbox-base"]:FetchComponent("Polyzone")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Jobs", {
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
