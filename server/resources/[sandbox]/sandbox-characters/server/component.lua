ONLINE_CHARACTERS = {}

AddEventHandler("Characters:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	GlobalConfig = exports["sandbox-base"]:FetchComponent("Config")
	Routing = exports["sandbox-base"]:FetchComponent("Routing")
	Sequence = exports["sandbox-base"]:FetchComponent("Sequence")
	Reputation = exports["sandbox-base"]:FetchComponent("Reputation")
	Apartment = exports["sandbox-base"]:FetchComponent("Apartment")
	Phone = exports["sandbox-base"]:FetchComponent("Phone")
	Damage = exports["sandbox-base"]:FetchComponent("Damage")
	Punishment = exports["sandbox-base"]:FetchComponent("Punishment")
	RegisterCommands()
	_spawnFuncs = {}
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Characters", {
		"Config",
		"Routing",
		"Sequence",
		"Reputation",
		"Apartment",
		"Phone",
		"Damage",
		"Punishment",
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

CHARACTERS = {
	GetLastLocation = function(self, source)
		return _tempLastLocation[source] or false
	end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Characters", CHARACTERS)
end)
