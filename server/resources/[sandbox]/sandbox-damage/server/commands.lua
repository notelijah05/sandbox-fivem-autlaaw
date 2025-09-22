function RegisterChatCommands()
    Chat:RegisterStaffCommand("heal", function(source, args, rawCommand)
        if args[1] ~= nil then
            local admin = exports['sandbox-base']:FetchSource(source)
            local char = exports['sandbox-characters']:FetchBySID(tonumber(args[1]))
            if char ~= nil and ((char:GetData("Source") ~= admin:GetData("Source")) or admin.Permissions:IsAdmin()) then
                exports["sandbox-base"]:ClientCallback(char:GetData("Source"), "Damage:Heal", true)
                Status:Set(source, "PLAYER_STRESS", 0)
            else
                Chat.Send.System:Single(source, "Invalid State ID")
            end
        else
            local char = exports['sandbox-characters']:FetchCharacterSource(source)
            if char ~= nil then
                exports["sandbox-base"]:ClientCallback(source, "Damage:Heal", true)
                Status:Set(source, "PLAYER_STRESS", 0)
            end
        end
    end, {
        help = "Heals Player",
        params = {
            {
                name = "Target (Optional)",
                help = "State ID of Who You Want To Heal",
            },
        },
    }, -1)

    Chat:RegisterStaffCommand("healrange", function(source, args, rawCommand)
        local radius = args[1] and tonumber(args[1]) or 25.0

        local myPed = GetPlayerPed(source)
        for k, v in pairs(exports['sandbox-characters']:FetchAllCharacters()) do
            if v ~= nil then
                local src = v:GetData("Source")
                if Player(src).state.isDead then
                    local ped = GetPlayerPed(src)
                    if #(GetEntityCoords(ped) - GetEntityCoords(myPed)) <= radius then
                        exports["sandbox-base"]:ClientCallback(src, "Damage:Heal", true)
                    end
                end
            end
        end

        exports["sandbox-base"]:ClientCallback(source, "Damage:Heal", true)
        Status:Set(source, "PLAYER_STRESS", 0)
    end, {
        help = "Heals Player",
        params = {
            {
                name = "Radius (Optional)",
                help = "Radius To Heal Players (If Empty, Default Is 25 Meters)",
            },
        },
    }, -1)

    Chat:RegisterAdminCommand("god", function(source, args, rawCommand)
        if Player(source).state.isGodmode then
            SetPlayerInvincible(source, false)
            Player(source).state.isGodmode = false
            exports['sandbox-base']:ExecuteClient(source, "Notification", "Info", "God Mode Disabled")
            exports["sandbox-base"]:ClientCallback(source, "Damage:Admin:Godmode", false)
        else
            SetPlayerInvincible(source, true)
            Player(source).state.isGodmode = true
            exports['sandbox-base']:ExecuteClient(source, "Notification", "Info", "God Mode Enabled")
            exports["sandbox-base"]:ClientCallback(source, "Damage:Admin:Godmode", true)
        end
    end, {
        help = "Toggle God Mode",
    }, -1)

    Chat:RegisterAdminCommand("die", function(source, args, rawCommand)
        if not Player(source).state.isDead then
            exports["sandbox-base"]:ClientCallback(source, "Damage:Kill")
        end
    end, {
        help = "Kill Yourself",
    })
end
