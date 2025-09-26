AddEventHandler('Vehicles:Client:StartUp', function()
    exports["sandbox-base"]:RegisterClientCallback('Vehicles:GetFakePlateAddingVehicle', function(data, cb)
        local target = exports['sandbox-targeting']:GetEntityPlayerIsLookingAt()
        if target and target.entity and DoesEntityExist(target.entity) and IsEntityAVehicle(target.entity) and CanModelHaveFakePlate(GetEntityModel(target.entity)) then
            if exports['sandbox-vehicles']:HasAccess(target.entity, false, true) and (exports['sandbox-vehicles']:UtilsIsCloseToRearOfVehicle(target.entity) or exports['sandbox-vehicles']:UtilsIsCloseToFrontOfVehicle(target.entity)) then
                exports['sandbox-hud']:Progress({
                    name = "vehicle_adding_plate",
                    duration = 5000,
                    label = "Installing Plate",
                    useWhileDead = false,
                    canCancel = true,
                    ignoreModifier = true,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = false,
                    },
                    animation = {
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        anim = "machinic_loop_mechandplayer",
                        --flags = 15,
                    },
                }, function(cancelled)
                    if not cancelled and exports['sandbox-vehicles']:HasAccess(target.entity, true, true) and (exports['sandbox-vehicles']:UtilsIsCloseToRearOfVehicle(target.entity) or exports['sandbox-vehicles']:UtilsIsCloseToFrontOfVehicle(target.entity)) then
                        cb(VehToNet(target.entity))
                    else
                        cb(false)
                    end
                end)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)
end)

AddEventHandler('Vehicles:Client:RemoveFakePlate', function(entityData)
    if entityData and DoesEntityExist(entityData.entity) and CanModelHaveFakePlate(GetEntityModel(entityData.entity)) then
        exports['sandbox-hud']:Progress({
            name = "vehicle_removing_plate",
            duration = 5000,
            label = "Removing Plate",
            useWhileDead = false,
            canCancel = true,
            ignoreModifier = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = false,
            },
            animation = {
                animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                anim = "machinic_loop_mechandplayer",
                --flags = 15,
            },
        }, function(cancelled)
            if not cancelled and exports['sandbox-vehicles']:HasAccess(entityData.entity) and (exports['sandbox-vehicles']:UtilsIsCloseToRearOfVehicle(entityData.entity) or exports['sandbox-vehicles']:UtilsIsCloseToFrontOfVehicle(entityData.entity)) then
                exports["sandbox-base"]:ServerCallback('Vehicles:RemoveFakePlate', VehToNet(entityData.entity),
                    function(success, plate)
                        if success then
                            exports["sandbox-hud"]:NotifSuccess('Removed Plate Successfully')
                            SetVehicleNumberPlateText(entityData.entity, plate)
                        else
                            exports["sandbox-hud"]:NotifError('Could not Remove Plate')
                        end
                    end)
            else
                exports["sandbox-hud"]:NotifError('Could not Remove Plate')
            end
        end)
    end
end)

AddEventHandler('Vehicles:Client:RemoveHarness', function(entityData)
    if entityData and DoesEntityExist(entityData.entity) then
        exports['sandbox-hud']:Progress({
            name = "vehicle_removing_harness",
            duration = 5000,
            label = "Removing Harness",
            useWhileDead = false,
            canCancel = true,
            ignoreModifier = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = false,
            },
            animation = {
                animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                anim = "machinic_loop_mechandplayer",
                --flags = 15,
            },
        }, function(cancelled)
            if not cancelled and exports['sandbox-vehicles']:HasAccess(entityData.entity, true) then
                exports["sandbox-base"]:ServerCallback('Vehicles:RemoveHarness', VehToNet(entityData.entity),
                    function(success)
                        if success then
                            exports["sandbox-hud"]:NotifSuccess('Removed Harness Successfully')
                        else
                            exports["sandbox-hud"]:NotifError('Could not Remove Harness')
                        end
                    end)
            else
                exports["sandbox-hud"]:NotifError('Could not Remove Harness')
            end
        end)
    end
end)
