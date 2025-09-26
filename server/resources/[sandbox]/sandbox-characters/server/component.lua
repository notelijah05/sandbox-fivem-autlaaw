ONLINE_CHARACTERS = {}

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Wait(1000)
		RegisterCallbacks()
		RegisterLocationCallbacks()
		RegisterMiddleware()
		Startup()
		RegisterCommands()
	end
end)

exports("GetLastLocation", function(source)
	return _tempLastLocation[source] or false
end)
