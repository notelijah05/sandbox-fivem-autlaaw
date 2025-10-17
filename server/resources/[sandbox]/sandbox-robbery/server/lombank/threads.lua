local _threading = false
function StartLombankThreads()
    if _threading then return end
    _threading = true

    CreateThread(function()
        while _threading do
            if _lbGlobalReset ~= nil then
                if os.time() > _lbGlobalReset then
                    exports['sandbox-base']:LoggerInfo("Robbery", "Lombank Heist Has Been Reset")
                    ResetLombank()
                end
            end
            Wait(30000)
        end
    end)

    CreateThread(function()
        while _threading do
            local powerDisabled = IsLBPowerDisabled()
            if not powerDisabled and not exports['sandbox-doors']:IsLocked("lombank_hidden_entrance") then
                exports['sandbox-doors']:SetLock("lombank_hidden_entrance", true)
                exports['sandbox-doors']:SetLock("lombank_lasers", true)
            elseif powerDisabled and exports['sandbox-doors']:IsLocked("lombank_hidden_entrance") then
                exports['sandbox-doors']:SetLock("lombank_hidden_entrance", false)
            end
            Wait((1000 * 60) * 1)
        end
    end)

    CreateThread(function()
        while _threading do
            for i = #_unlockingDoors, 1, -1 do
                local v = _unlockingDoors[i]
                if os.time() > v.expires then
                    exports['sandbox-doors']:SetLock(v.door, false)
                    if v.forceOpen then
                        exports['sandbox-doors']:SetForcedOpen(v.door)
                    end
                    exports['sandbox-hud']:Notification("info", v.source, "Door Unlocked")
                    table.remove(_unlockingDoors, i)
                end
            end
            Wait(30000)
        end
    end)

    CreateThread(function()
        while _threading do
            if _lbGlobalReset ~= nil and os.time() > _lbGlobalReset then
                ResetLombank()
                _lbGlobalReset = nil
            end
            Wait(60000)
        end
    end)

    -- CreateThread(function()
    --     while _threading do
    --         local powerDisabled = IsLBPowerDisabled()
    --         if not powerDisabled and not exports['sandbox-doors']:IsLocked("lombank_hidden_entrance") then
    --             exports['sandbox-doors']:SetLock("lombank_hidden_entrance", true)
    --         end
    --         Wait((1000 * 60) * 1)
    --     end
    -- end)
end
