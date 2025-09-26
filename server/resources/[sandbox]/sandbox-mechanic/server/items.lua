function RegisterMechanicItems()
    for k, v in pairs(_mechanicItemsToParts) do
        exports['sandbox-inventory']:RegisterUse(k, 'Mechanic', function(source, itemData)
            exports["sandbox-base"]:ClientCallback(source, 'Mechanic:StartInstall', {
                part = itemData.Name,
                quantity = 1,
            }, function(success)
                if success then
                    exports['sandbox-inventory']:RemoveSlot(itemData.Owner, itemData.Name, 1, itemData.Slot,
                        itemData.invType)
                end
            end)
        end)
    end

    for k, v in pairs(_mechanicItemsToUpgrades) do
        exports['sandbox-inventory']:RegisterUse(k, 'Mechanic', function(source, itemData)
            local partData = _mechanicItemsToUpgrades[itemData.Name]

            if partData then
                exports["sandbox-base"]:ClientCallback(source, 'Mechanic:StartUpgradeInstall', partData,
                    function(success, veh)
                        if success and veh then
                            exports['sandbox-inventory']:RemoveSlot(itemData.Owner, itemData.Name, 1, itemData.Slot,
                                itemData.invType)

                            local veh = NetworkGetEntityFromNetworkId(veh)
                            local vehState = Entity(veh)
                            if DoesEntityExist(veh) and vehState and vehState.state.VIN then
                                local vehicleData = exports['sandbox-vehicles']:OwnedGetActive(vehState.state.VIN)
                                if vehicleData and vehicleData:GetData('Properties') then
                                    local currentProperties = vehicleData:GetData('Properties')

                                    if currentProperties.mods then
                                        if partData.toggleMod then
                                            currentProperties.mods[partData.mod] = true
                                        else
                                            currentProperties.mods[partData.mod] = partData.modIndex
                                        end
                                    end

                                    vehicleData:SetData('Properties', currentProperties)
                                    exports['sandbox-vehicles']:OwnedForceSave(vehicleData:GetData('VIN'))
                                end
                            end

                            TriggerClientEvent('Mechanic:Client:ForcePerformanceProperty', -1,
                                NetworkGetNetworkIdFromEntity(veh), partData.modType,
                                partData.toggleMod or partData.modIndex)
                        end
                    end)
            end
        end)
    end
end
