exports('NotifClear', function()
	SendNUIMessage({
		type = "CLEAR_ALERTS",
	})
end)

exports('NotifSuccess', function(message, duration, icon)
	if duration == nil then
		duration = 2500
	end

	SendNUIMessage({
		type = "ADD_ALERT",
		data = {
			notification = {
				type = "success",
				message = message,
				duration = duration,
				icon = icon,
			},
		},
	})
end)

exports('NotifWarn', function(message, duration, icon)
	if duration == nil then
		duration = 2500
	end

	SendNUIMessage({
		type = "ADD_ALERT",
		data = {
			notification = {
				type = "warning",
				message = message,
				duration = duration,
				icon = icon,
			},
		},
	})
end)

exports('NotifError', function(message, duration, icon)
	if duration == nil then
		duration = 2500
	end

	SendNUIMessage({
		type = "ADD_ALERT",
		data = {
			notification = {
				type = "error",
				message = message,
				duration = duration,
				icon = icon,
			},
		},
	})
end)

exports('NotifInfo', function(message, duration, icon)
	if duration == nil then
		duration = 2500
	end

	SendNUIMessage({
		type = "ADD_ALERT",
		data = {
			notification = {
				type = "info",
				message = message,
				duration = duration,
				icon = icon,
			},
		},
	})
end)

exports('NotifStandard', function(message, duration, icon)
	if duration == nil then
		duration = 2500
	end

	SendNUIMessage({
		type = "ADD_ALERT",
		data = {
			notification = {
				type = "standard",
				message = message,
				duration = duration,
				icon = icon,
			},
		},
	})
end)

exports('NotifCustom', function(message, duration, icon, style)
	if duration == nil then
		duration = 2500
	end

	SendNUIMessage({
		type = "ADD_ALERT",
		data = {
			notification = {
				type = "custom",
				message = message,
				duration = duration,
				icon = icon,
				style = style,
			},
		},
	})
end)

exports('NotifPersistentSuccess', function(id, message, icon)
	SendNUIMessage({
		type = "ADD_ALERT",
		data = {
			notification = {
				_id = id,
				type = "success",
				message = message,
				duration = -1,
				icon = icon,
			},
		},
	})
end)

exports('NotifPersistentWarn', function(id, message, icon)
	SendNUIMessage({
		type = "ADD_ALERT",
		data = {
			notification = {
				_id = id,
				type = "warning",
				message = message,
				duration = -1,
				icon = icon,
			},
		},
	})
end)

exports('NotifPersistentError', function(id, message, icon)
	SendNUIMessage({
		type = "ADD_ALERT",
		data = {
			notification = {
				_id = id,
				type = "error",
				message = message,
				duration = -1,
				icon = icon,
			},
		},
	})
end)

exports('NotifPersistentInfo', function(id, message, icon)
	SendNUIMessage({
		type = "ADD_ALERT",
		data = {
			notification = {
				_id = id,
				type = "info",
				message = message,
				duration = -1,
				icon = icon,
			},
		},
	})
end)

exports('NotifPersistentStandard', function(id, message, icon)
	SendNUIMessage({
		type = "ADD_ALERT",
		data = {
			notification = {
				_id = id,
				type = "standard",
				message = message,
				duration = -1,
				icon = icon,
			},
		},
	})
end)

exports('NotifPersistentCustom', function(id, message, icon, style)
	SendNUIMessage({
		type = "ADD_ALERT",
		data = {
			notification = {
				_id = id,
				type = "custom",
				message = message,
				duration = -1,
				icon = icon,
				style = style,
			},
		},
	})
end)

exports('NotifPersistentRemove', function(id)
	SendNUIMessage({
		type = "HIDE_ALERT",
		data = {
			id = id,
		},
	})
end)
