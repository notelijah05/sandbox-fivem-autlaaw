local _devMode = false

RegisterNetEvent("HUD:Client:DevMode", function()
    if LocalPlayer.state.isStaff or LocalPlayer.state.isAdmin then
        _devMode = not _devMode
        exports['sandbox-hud']:Notification("info", "Dev Mode " .. (_devMode and "Enabled" or "Disabled"), 2500,
            "fas fa-cube")

        if _devMode then
            -- Vehicle targets
            exports.ox_target:addGlobalVehicle({
                {
                    label = "Dev Actions",
                    name = "dev_actions",
                    icon = "fas fa-cube",
                    openMenu = "dev_actions",
                    canInteract = function()
                        return _devMode
                    end
                },
                {
                    label = "Delete Vehicle",
                    name = "dev_delete_vehicle",
                    icon = "fas fa-trash",
                    menuName = "dev_actions",
                    canInteract = function()
                        return _devMode
                    end,
                    onSelect = function(data)
                        TriggerServerEvent('dev:deleteVehicle', NetworkGetNetworkIdFromEntity(data.entity))
                    end
                },
                {
                    label = "Get Keys",
                    name = "dev_get_keys",
                    icon = "fas fa-key",
                    menuName = "dev_actions",
                    canInteract = function()
                        return _devMode
                    end,
                    onSelect = function(data)
                        TriggerServerEvent('dev:getKeys', NetworkGetNetworkIdFromEntity(data.entity))
                    end
                },
                {
                    label = 'Debug Vehicle',
                    name = 'debug_vehicle',
                    event = 'ox_target:debug',
                    icon = 'fas fa-car',
                    menuName = 'dev_actions',
                    canInteract = function()
                        return _devMode
                    end,
                }
            })

            -- Ped targets
            exports.ox_target:addGlobalPed({
                {
                    name = 'dev_actions_ped',
                    icon = 'fas fa-cube',
                    label = 'Dev Actions',
                    openMenu = 'dev_actions',
                    canInteract = function()
                        return _devMode
                    end
                },
                {
                    name = 'debug_ped',
                    event = 'ox_target:debug',
                    icon = 'fas fa-male',
                    label = 'Debug Ped',
                    menuName = 'dev_actions',
                    canInteract = function()
                        return _devMode
                    end,
                }
            })

            -- Object targets
            exports.ox_target:addGlobalObject({
                {
                    name = 'dev_actions_object',
                    icon = 'fas fa-cube',
                    label = 'Dev Actions',
                    openMenu = 'dev_actions',
                    canInteract = function()
                        return _devMode
                    end
                },
                {
                    name = 'debug_object',
                    event = 'ox_target:debug',
                    icon = 'fas fa-bong',
                    label = 'Debug Object',
                    menuName = 'dev_actions',
                    canInteract = function()
                        return _devMode
                    end,
                }
            })
        else
            -- Vehicle targets removal
            exports.ox_target:removeGlobalVehicle('dev_actions')
            exports.ox_target:removeGlobalVehicle('dev_delete_vehicle')
            exports.ox_target:removeGlobalVehicle('debug_vehicle')

            -- Ped targets removal
            exports.ox_target:removeGlobalPed('dev_actions_ped')
            exports.ox_target:removeGlobalPed('debug_ped')

            -- Object targets removal
            exports.ox_target:removeGlobalObject('dev_actions_object')
            exports.ox_target:removeGlobalObject('debug_object')
        end
    else
        exports['sandbox-hud']:Notification("error", "How are you doing this?")
    end
end)

exports('IsDevModeActive', function()
    return _devMode
end)
