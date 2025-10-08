exports('NotifClear', function()
    SendNUIMessage({
        type = "CLEAR_ALERTS",
    })
end)

exports('Notification', function(notifType, message, duration, icon, style, id)
    if duration == nil then
        duration = 2500
    end

    local notification = {
        type = notifType,
        message = message,
        duration = duration,
        icon = icon,
    }

    if style then
        notification.style = style
    end

    if duration == -1 then
        if id == nil then
            return
        end
        notification._id = id
    end

    SendNUIMessage({
        type = "ADD_ALERT",
        data = {
            notification = notification,
        },
    })
end)

exports('NotifSuccess', function(message, duration, icon)
    exports['sandbox-hud']:Notification("success", message, duration, icon)
end)

exports('NotifWarn', function(message, duration, icon)
    exports['sandbox-hud']:Notification("warning", message, duration, icon)
end)

exports('NotifError', function(message, duration, icon)
    exports['sandbox-hud']:Notification("error", message, duration, icon)
end)

exports('NotifInfo', function(message, duration, icon)
    exports['sandbox-hud']:Notification("info", message, duration, icon)
end)

exports('NotifStandard', function(message, duration, icon)
    exports['sandbox-hud']:Notification("standard", message, duration, icon)
end)

exports('NotifCustom', function(message, duration, icon, style)
    exports['sandbox-hud']:Notification("custom", message, duration, icon, style)
end)

exports('NotifPersistentSuccess', function(id, message, icon)
    exports['sandbox-hud']:Notification("success", message, -1, icon, nil, id)
end)

exports('NotifPersistentWarn', function(id, message, icon)
    exports['sandbox-hud']:Notification("warning", message, -1, icon, nil, id)
end)

exports('NotifPersistentError', function(id, message, icon)
    exports['sandbox-hud']:Notification("error", message, -1, icon, nil, id)
end)

exports('NotifPersistentInfo', function(id, message, icon)
    exports['sandbox-hud']:Notification("info", message, -1, icon, nil, id)
end)

exports('NotifPersistentStandard', function(id, message, icon)
    exports['sandbox-hud']:Notification("standard", message, -1, icon, nil, id)
end)

exports('NotifPersistentCustom', function(id, message, icon, style)
    exports['sandbox-hud']:Notification("custom", message, -1, icon, style, id)
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

RegisterNetEvent("HUD:Client:Notification", function(notifType, message, duration, icon, style, id)
    exports['sandbox-hud']:Notification(notifType, message, duration, icon, style, id)
end)
