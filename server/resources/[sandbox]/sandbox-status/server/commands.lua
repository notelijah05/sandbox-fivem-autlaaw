function RegisterChatCommands()
    exports["sandbox-chat"]:RegisterAdminCommand('reset', function(source, args, rawCommand)
        TriggerClientEvent('Status:Client:Reset', source)
    end, {
        help = 'Reset Statuses',
    }, 0)
end
