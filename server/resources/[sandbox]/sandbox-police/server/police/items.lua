function PoliceItems()
    exports['sandbox-inventory']:RegisterUse("det_cord", "PDItems", function(source, slot, itemData)
        local pState = Player(source).state
        if pState.onDuty == "police" then
            exports["sandbox-base"]:ClientCallback(source, "Police:DoDetCord", {}, function(s, doorId)
                if s and exports['sandbox-inventory']:RemoveSlot(slot.Owner, slot.Name, 1, slot.Slot, 1) then
                    exports['sandbox-doors']:SetLock(doorId, false)
                    exports['sandbox-doors']:DisableDoor(doorId, 60 * 60)
                end
            end)
        end
    end)
end
