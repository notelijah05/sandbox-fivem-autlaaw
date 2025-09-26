exports('NotifClear', function(source)
    TriggerClientEvent("HUD:Client:NotifClear", source)
end)

exports('NotifSuccess', function(source, message, duration, icon)
    if duration == nil then
        duration = 2500
    end

    TriggerClientEvent("HUD:Client:NotifSuccess", source, message, duration, icon)
end)

exports('NotifWarn', function(source, message, duration, icon)
    if duration == nil then
        duration = 2500
    end

    TriggerClientEvent("HUD:Client:NotifWarn", source, message, duration, icon)
end)

exports('NotifError', function(source, message, duration, icon)
    if duration == nil then
        duration = 2500
    end

    TriggerClientEvent("HUD:Client:NotifError", source, message, duration, icon)
end)

exports('NotifInfo', function(source, message, duration, icon)
    if duration == nil then
        duration = 2500
    end

    TriggerClientEvent("HUD:Client:NotifInfo", source, message, duration, icon)
end)

exports('NotifStandard', function(source, message, duration, icon)
    if duration == nil then
        duration = 2500
    end

    TriggerClientEvent("HUD:Client:NotifStandard", source, message, duration, icon)
end)

exports('NotifCustom', function(source, message, duration, icon, style)
    if duration == nil then
        duration = 2500
    end

    TriggerClientEvent("HUD:Client:NotifCustom", source, message, duration, icon, style)
end)

exports('NotifPersistentSuccess', function(source, id, message, icon)
    TriggerClientEvent("HUD:Client:NotifPersistentSuccess", source, id, message, icon)
end)

exports('NotifPersistentWarn', function(source, id, message, icon)
    TriggerClientEvent("HUD:Client:NotifPersistentWarn", source, id, message, icon)
end)

exports('NotifPersistentError', function(source, id, message, icon)
    TriggerClientEvent("HUD:Client:NotifPersistentError", source, id, message, icon)
end)

exports('NotifPersistentInfo', function(source, id, message, icon)
    TriggerClientEvent("HUD:Client:NotifPersistentInfo", source, id, message, icon)
end)

exports('NotifPersistentStandard', function(source, id, message, icon)
    TriggerClientEvent("HUD:Client:NotifPersistentStandard", source, id, message, icon)
end)

exports('NotifPersistentCustom', function(source, id, message, icon, style)
    TriggerClientEvent("HUD:Client:NotifPersistentCustom", source, id, message, icon, style)
end)

exports('NotifPersistentRemove', function(source, id)
    TriggerClientEvent("HUD:Client:NotifPersistentRemove", source, id)
end)
