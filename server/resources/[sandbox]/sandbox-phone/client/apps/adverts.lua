RegisterNUICallback("CreateAdvert", function(data, cb)
	cb("OK")
	exports["sandbox-base"]:ServerCallback("Phone:Adverts:Create", data)
end)

RegisterNUICallback("UpdateAdvert", function(data, cb)
	cb("OK")
	exports["sandbox-base"]:ServerCallback("Phone:Adverts:Update", data)
end)

RegisterNUICallback("DeleteAdvert", function(data, cb)
	cb("OK")
	exports["sandbox-base"]:ServerCallback("Phone:Adverts:Delete")
end)
