local Config = require('shared.Config')

AddEventHandler('onClientResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Wait(1000)
        for k, v in ipairs(Config.LogoutLocations) do
            exports['sandbox-targeting']:ZonesAddBox("logout-location-" .. k, "person-from-portal", v.center, v.length,
                v.width, v.options,
                {
                    {
                        icon = "person-from-portal",
                        text = "Logout",
                        event = "Locations:Client:LogoutLocation",
                    },
                }, 2.0, true)
        end
    end
end)

exports("GetAll", function(type, cb)
    exports["sandbox-base"]:ServerCallback('Locations:GetAll', {
        type = type
    }, cb)
end)

AddEventHandler('Locations:Client:LogoutLocation', function()
    exports['sandbox-characters']:Logout()
end)

AddEventHandler("Characters:Client:Spawn", function()
    CreateThread(function()
        while LocalPlayer.state.loggedIn do
            Wait(60000)

            if not LocalPlayer.state.tpLocation then
                local coords = GetEntityCoords(PlayerPedId())
                if LocalPlayer.state.loggedIn and coords and #(coords - vector3(0.0, 0.0, 0.0)) >= 10.0 then
                    TriggerServerEvent('Characters:Server:LastLocation', coords)
                end
            end
        end
    end)
end)
