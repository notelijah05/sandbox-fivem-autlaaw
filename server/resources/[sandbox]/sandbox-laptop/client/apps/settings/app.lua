RegisterNUICallback("UpdateSetting", function(data, cb)
	cb("OK")
	_settings[data.type] = data.val
	exports["sandbox-base"]:ServerCallback("Laptop:Settings:Update", data)
end)
