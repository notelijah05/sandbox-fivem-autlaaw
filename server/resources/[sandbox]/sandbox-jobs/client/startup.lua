AddEventHandler("Jobs:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Jobs = exports["sandbox-base"]:FetchComponent("Jobs")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Jobs", {
		"Jobs",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()
		RegisterMetalDetectors()
	end)
end)
