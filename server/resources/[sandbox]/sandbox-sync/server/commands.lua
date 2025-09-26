function RegisterChatCommands()
    exports["sandbox-chat"]:RegisterAdminCommand('freezetime', function(source, args, rawCommand)
        exports["sandbox-sync"]:FreezeTime()
        exports["sandbox-chat"]:SendServerSingle(source,
            'Time Has Been ' .. (exports["sandbox-sync"]:GetTimeFrozen() and 'Frozen' or 'Unfrozen'))
    end, {
        help = 'Freeze Time',
        params = {}
    })

    exports["sandbox-chat"]:RegisterAdminCommand('freezeweather', function(source, args, rawCommand)
        exports["sandbox-sync"]:FreezeWeather()
        exports["sandbox-chat"]:SendServerSingle(source,
            'Weather Has Been ' .. (exports["sandbox-sync"]:GetWeatherFrozen() and 'Frozen' or 'Unfrozen'))
    end, {
        help = 'Freeze the Weather',
        params = {}
    })

    exports["sandbox-chat"]:RegisterAdminCommand('weather', function(source, args, rawCommand)
        for _, v in pairs(AvailableWeatherTypes) do
            if args[1]:upper() == v then
                exports["sandbox-sync"]:SetWeather(args[1])
                return
            end
        end
        exports["sandbox-chat"]:SendServerSingle(source, 'Invalid Weather Type')
    end, {
        help = 'Set Weather',
        params = { {
            name = 'Type',
            help =
            'EXTRASUNNY, CLEAR, NEUTRAL, SMOG, FOGGY, OVERCAST, CLOUDS, CLEARING, RAIN, THUNDER, SNOW, BLIZZARD, SNOWLIGHT, XMAS, HALLOWEEN'
        }
        }
    }, 1)

    exports["sandbox-chat"]:RegisterAdminCommand('time', function(src, args, raw)
        exports["sandbox-sync"]:SetTimeType(args[1])
    end, {
        help = 'Set Time',
        params = {
            { name = 'Type', help = 'MORNING, NOON, EVENING, NIGHT' }
        }
    }, 1)

    exports["sandbox-chat"]:RegisterAdminCommand('clock', function(src, args, raw)
        exports["sandbox-sync"]:SetTime(tonumber(args[1]), tonumber(args[2]))
    end, {
        help = 'Set Specific Hour',
        params = {
            { name = 'Hour', help = '0 - 23' },
        }
    }, -1)

    exports["sandbox-chat"]:RegisterAdminCommand('blackout', function(source, args, rawCommand)
        exports["sandbox-sync"]:SetBlackout()
        exports["sandbox-chat"]:SendServerSingle(source,
            'Blackout Has Been ' .. (exports["sandbox-sync"]:GetBlackout() and 'Enabled' or 'Disabled'))
    end, {
        help = 'Toggle Blackout'
    }, 0)

    exports["sandbox-chat"]:RegisterAdminCommand('winter', function(source, args, rawCommand)
        exports["sandbox-sync"]:SetWinter()
        exports["sandbox-chat"]:SendServerSingle(source, 'Winter Only Weather Has Been ' ..
            (exports["sandbox-sync"]:GetWinter() and 'Enabled' or 'Disabled'))
    end, {
        help = 'Toggle Winter Only Weather'
    }, 0)
end
