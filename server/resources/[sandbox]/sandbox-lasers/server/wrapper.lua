AddEventHandler('onResourceStart', function(resource)
   	if resource == GetCurrentResourceName() then
		Wait(1000)
    exports["sandbox-chat"]:RegisterAdminCommand("lasers", function(source, args, rawCommand)
        if args[1] == "start" then
            exports["sandbox-base"]:ClientCallback(source, "Lasers:Create:Start")
        elseif args[1] == "end" then
            exports["sandbox-base"]:ClientCallback(source, "Lasers:Create:End")
        elseif args[1] == "save" then
            exports["sandbox-base"]:ClientCallback(source, "Lasers:Create:Save")
        else

    end, {
        help = "Create Lasers",
        params = {
            {
                name = "Action",
                help = "Action to perform (start, end, save)",
            },
        },
    }, 1)
   end
end)