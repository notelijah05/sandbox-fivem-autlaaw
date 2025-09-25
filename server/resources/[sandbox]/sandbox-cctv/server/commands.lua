function RegisterChatCommands()
	exports["sandbox-chat"]:RegisterAdminCommand("acam", function(source, args, rawCommand)
		if (tonumber(args[1])) then
			exports['sandbox-cctv']:View(source, tonumber(args[1]))
		else
			exports['sandbox-cctv']:ViewGroup(source, args[1])
		end
	end, {
		help = "View CCTV Cam",
		params = {
			{
				name = "Cam ID",
				help = string.format("ID Of Camera (1 - %s)", #Config.Cameras),
			},
		},
	}, 1)
end
