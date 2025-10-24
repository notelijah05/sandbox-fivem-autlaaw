-- If you are adding on to this, make sure you validate permission / distance / whatever you are using it for.

RegisterNetEvent('dev:deleteVehicle', function(netId)
    local player = exports['sandbox-base']:FetchSource(source)
    if player.Permissions:IsStaff() or player.Permissions:IsAdmin() then
        local entity = NetworkGetEntityFromNetworkId(netId)
        if not DoesEntityExist(entity) then return end

        exports['sandbox-vehicles']:Delete(entity, function() end)
    else
        exports['sandbox-base']:LoggerInfo(
            "Pwnzor",
            string.format(
                "%s (%s) Attempted To Use Debug Function: %s. Network ID: %s, potentially a cheater?",
                player:GetData("Name"),
                player:GetData("AccountID"),
                "dev:deleteVehicle",
                netId
            )
        )
        return exports['sandbox-hud']:Notification(source, "error", "How are you doing this?")
    end
end)
