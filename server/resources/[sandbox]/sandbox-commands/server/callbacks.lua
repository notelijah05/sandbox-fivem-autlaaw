function RegisterCallbacks()
	exports["sandbox-base"]:RegisterServerCallback("Commands:ValidateAdmin", function(source, data, cb)
		local player = exports['sandbox-base']:FetchSource(source)
		if player.Permissions:IsAdmin() then
			cb(true)
		else
			exports['sandbox-base']:LoggerError("Commands",
				string.format("%s attempted to use an admin command but failed Admin Validation.", {
					console = true,
					file = true,
					database = true,
					discord = {
						embed = true,
						type = "error",
					},
				}, player:GetData("Identifier"))
			)
		end
	end)
end
