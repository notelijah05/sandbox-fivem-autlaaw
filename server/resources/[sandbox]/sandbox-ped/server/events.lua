RegisterServerEvent("Ped:EnterCreator", function()
	local routeId = exports["sandbox-base"]:RequestRouteId("ped:" .. source)
	exports["sandbox-base"]:AddPlayerToRoute(source, routeId)
end)

RegisterServerEvent("Ped:LeaveCreator", function()
	exports["sandbox-base"]:RoutePlayerToGlobalRoute(source)
end)
