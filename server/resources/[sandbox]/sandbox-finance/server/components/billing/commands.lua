AddEventHandler('Finance:Server:Startup', function()
    exports["sandbox-chat"]:RegisterCommand('fine', function(src, args, raw)
        local player = exports['sandbox-characters']:FetchBySID(tonumber(args[1]))
        if player ~= nil then
            local targetSource, fineAmount = table.unpack(args)
            local fine = tonumber(fineAmount)
            if fine and fine > 0 and fine <= 100000 then
                local success = exports['sandbox-finance']:BillingFine(src, player:GetData("Source"), fine)
                if success then
                    exports["sandbox-chat"]:SendSystemSingle(src,
                        string.format("You Successfully Fined State ID %s For $%s. You earned $%s.", args[1],
                            success.amount, success.cut))
                else
                    exports["sandbox-chat"]:SendSystemSingle(src, "Fine Failed")
                end
            else
                exports["sandbox-chat"]:SendSystemSingle(src, "Fine Amount Too High!")
            end
        else
            exports["sandbox-chat"]:SendSystemSingle(src, "Invalid Target")
        end
    end, {
        help = '[Government] Fine Someone',
        params = {
            { name = 'State ID', help = 'The State ID of the person you want to fine.' },
            { name = 'Amount',   help = 'The amount of money you are fining them.' },
        },
    }, 2, {
        { Id = 'police' },
    })

    exports["sandbox-chat"]:RegisterAdminCommand('testbilling', function(source, args, rawCommand)
        exports['sandbox-hud']:NotifInfo(source, 'Bill Created')
        exports['sandbox-finance']:BillingCreate(source, 'Some Random Fucking Business', 1500,
            'This is a shitty description of a test bill.',
            function(wasPayed)
                if wasPayed then
                    exports['sandbox-hud']:NotifSuccess(src, 'Bill Accepted')
                else
                    exports['sandbox-hud']:NotifError(src, 'Bill Declined')
                end
            end)
    end, {
        help = 'Test Billing'
    }, 0)
end)
