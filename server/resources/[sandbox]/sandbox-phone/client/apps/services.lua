RegisterNUICallback("Services:GetServices", function(data, cb)
	exports["sandbox-base"]:ServerCallback("Phone:Services:GetServices", data, function(servicesData)
		cb(servicesData)
	end)
end)

RegisterNUICallback("Services:SetGPS", function(data, cb)
	if data.location then
		DeleteWaypoint()
		SetNewWaypoint(data.location.x, data.location.y)
		exports["sandbox-hud"]:NotifSuccess("GPS route set")
		cb("OK")
	else
		cb(false)
		exports["sandbox-hud"]:NotifError("Error setting waypoint.")
	end
end)
