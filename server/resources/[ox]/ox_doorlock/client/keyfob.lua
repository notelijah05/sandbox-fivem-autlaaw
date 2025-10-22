local keyfobRange = 10.0

RegisterNetEvent('ox_doorlock:useKeyfobClient', function(itemName, success, doorId)
    if not success then return end
    
    PlaySoundFrontend(-1, "CLICK_SPECIAL", "WEB_NAVIGATION_SOUNDS_PHONE", true)
    
    local playerPed = PlayerPedId()
    if not IsEntityPlayingAnim(playerPed, 'anim@mp_player_intmenu@key_fob@', 'fob_click', 3) then
        RequestAnimDict('anim@mp_player_intmenu@key_fob@')
        while not HasAnimDictLoaded('anim@mp_player_intmenu@key_fob@') do
            Wait(0)
        end
        TaskPlayAnim(playerPed, 'anim@mp_player_intmenu@key_fob@', 'fob_click', 8.0, 8.0, 1000, 48, 0, false, false, false)
    end
end)

exports('useKeyfob', function(data, slot)
    TriggerServerEvent('ox_doorlock:useKeyfob', data)
end)

exports('getKeyfobRange', function()
    return keyfobRange
end)

