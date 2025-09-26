ONLINE_CHARACTERS = {}

AddEventHandler("Core:Shared:Ready", function()
	RegisterCallbacks()
	RegisterMiddleware()
	Startup()
	RegisterCommands()
	_spawnFuncs = {}
end)

exports("GetLastLocation", function(source)
	return _tempLastLocation[source] or false
end)
