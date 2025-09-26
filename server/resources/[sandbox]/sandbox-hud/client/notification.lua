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

RegisterNetEvent("HUD:Client:NotifClear", function()
	exports['sandbox-hud']:NotifClear()
end)

RegisterNetEvent("HUD:Client:NotifSuccess", function(message, duration, icon)
	exports['sandbox-hud']:NotifSuccess(message, duration, icon)
end)

RegisterNetEvent("HUD:Client:NotifWarn", function(message, duration, icon)
	exports['sandbox-hud']:NotifWarn(message, duration, icon)
end)

RegisterNetEvent("HUD:Client:NotifError", function(message, duration, icon)
	exports['sandbox-hud']:NotifError(message, duration, icon)
end)

RegisterNetEvent("HUD:Client:NotifInfo", function(message, duration, icon)
	exports['sandbox-hud']:NotifInfo(message, duration, icon)
end)

RegisterNetEvent("HUD:Client:NotifStandard", function(message, duration, icon)
	exports['sandbox-hud']:NotifStandard(message, duration, icon)
end)

RegisterNetEvent("HUD:Client:NotifCustom", function(message, duration, icon, style)
	exports['sandbox-hud']:NotifCustom(message, duration, icon, style)
end)

RegisterNetEvent("HUD:Client:NotifPersistentSuccess", function(id, message, icon)
	exports['sandbox-hud']:NotifPersistentSuccess(id, message, icon)
end)

RegisterNetEvent("HUD:Client:NotifPersistentWarn", function(id, message, icon)
	exports['sandbox-hud']:NotifPersistentWarn(id, message, icon)
end)

RegisterNetEvent("HUD:Client:NotifPersistentError", function(id, message, icon)
	exports['sandbox-hud']:NotifPersistentError(id, message, icon)
end)

RegisterNetEvent("HUD:Client:NotifPersistentInfo", function(id, message, icon)
	exports['sandbox-hud']:NotifPersistentInfo(id, message, icon)
end)

RegisterNetEvent("HUD:Client:NotifPersistentStandard", function(id, message, icon)
	exports['sandbox-hud']:NotifPersistentStandard(id, message, icon)
end)

RegisterNetEvent("HUD:Client:NotifPersistentCustom", function(id, message, icon, style)
	exports['sandbox-hud']:NotifPersistentCustom(id, message, icon, style)
end)

RegisterNetEvent("HUD:Client:NotifPersistentRemove", function(id)
	exports['sandbox-hud']:NotifPersistentRemove(id)
end)
