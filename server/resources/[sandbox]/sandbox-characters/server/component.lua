ONLINE_CHARACTERS = {}

AddEventHandler("Characters:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	GlobalConfig = exports["sandbox-base"]:FetchComponent("Config")
	Reputation = exports["sandbox-base"]:FetchComponent("Reputation")
	RegisterCommands()
	_spawnFuncs = {}
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Characters", {
		"Config",
		"Reputation",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()
		RegisterCallbacks()
		RegisterMiddleware()
		Startup()
	end)
end)

exports("GetLastLocation", function(source)
	return _tempLastLocation[source] or false
end)
