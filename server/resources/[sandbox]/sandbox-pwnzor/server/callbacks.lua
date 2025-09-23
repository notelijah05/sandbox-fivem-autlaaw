local _blacklistedClientEvents = {
	"esx:getSharedObject",
	"ambulancier:selfRespawn",
	"bank:transfer",
	"esx_ambulancejob:revive",
	"esx-qalle-jail:openJailMenu",
	"esx_jailer:wysylandoo",
	"esx_society:openBossMenu",
	"esx:spawnVehicle",
	"esx_status:set",
	"HCheat:TempDisableDetection",
	"UnJP",
}

local afkCodes = {}

local _blacklistedCommands = {
	"brutan",
	"chocolate",
	"haha",
	"killmenu",
	"KP",
	"lol",
	"lynx",
	"opk",
	--"panic",
	"panickey",
	"panik",
	-- "pk",
	"FunCtionOk",
	"porcodiooo",
	"demmerda",
	"puzzi",
	"jolmany",
}

local _retrieved = {}

function RegisterCallbacks()
	exports["sandbox-chat"]:RegisterStaffCommand("toggleafk", function(source, args, rawCommand)
		local disabled = GlobalState["DisableAFK"] or false
		GlobalState["DisableAFK"] = not disabled

		exports["sandbox-chat"]:SendSystemSingle(
			source,
			string.format("AFK Kicking %s", GlobalState["DisableAFK"] and "Disabled" or "Enabled")
		)
	end, {
		help = "Enabled/Disable AFK Kicks",
	}, 0)

	-- exports["sandbox-chat"]:RegisterAdminCommand("pwnzorban", function(source, args, rawCommand)
	-- 	local player = exports['sandbox-characters']:FetchBySID(tonumber(args[1]))
	-- 	if player ~= nil then
	-- 		exports['sandbox-base']:PunishmentBanSource(player:GetData("Source"), -1, args[2], "Pwnzor")
	-- 	end
	-- end, {
	-- 	help = "Fake Pwnzor Ban",
	-- 	params = {
	-- 		{
	-- 			name = "Target",
	-- 			help = "State ID of Who You Want To Ban",
	-- 		},
	-- 		{
	-- 			name = "Reason",
	-- 			help = "Reason For The Ban",
	-- 		},
	-- 	},
	-- }, 2)

	-- exports["sandbox-chat"]:RegisterAdminCommand("pwnzorsource", function(source, args, rawCommand)
	-- 	local player = exports['sandbox-base']:FetchSource(tonumber(args[1]))
	-- 	if player ~= nil then
	-- 		exports['sandbox-base']:PunishmentBanSource(tonumber(args[1]), -1, args[2], "Pwnzor")
	-- 	end
	-- end, {
	-- 	help = "Ban Player From Server",
	-- 	params = {
	-- 		{
	-- 			name = "Target",
	-- 			help = "Source of Who You Want To Ban",
	-- 		},
	-- 		{
	-- 			name = "Reason",
	-- 			help = "Reason For The Ban",
	-- 		},
	-- 	},
	-- }, 2)

	exports["sandbox-base"]:RegisterServerCallback("Pwnzor:GetEvents", function(source, data, cb)
		if not Pwnzor.Players:Get(source, "GetEvents") then
			Pwnzor.Players:Set(source, "GetEvents")
			cb(_blacklistedClientEvents)
		else
			if not exports['sandbox-base']:FetchSource(source).Permissions:IsAdmin() then
				exports['sandbox-base']:PunishmentBanSource(source, -1, "Attempt To Recall GetEvents", "Pwnzor")
			end
		end
	end)

	exports["sandbox-base"]:RegisterServerCallback("Pwnzor:GetCommands", function(source, data, cb)
		if not Pwnzor.Players:Get(source, "GetCommands") then
			Pwnzor.Players:Set(source, "GetCommands")
			cb(_blacklistedCommands)
		else
			if not exports['sandbox-base']:FetchSource(source).Permissions:IsAdmin() then
				exports['sandbox-base']:PunishmentBanSource(source, -1, "Attempt To Recall GetCommands", "Pwnzor")
			end
		end
	end)

	exports["sandbox-base"]:RegisterServerCallback("Pwnzor:AFK", function(source, data, cb)
		if Config.Components.AFK.Enabled then
			exports['sandbox-base']:PunishmentKick(source, "You Were Kicked For Being AFK", "Pwnzor", true)
		end
	end)

	local _fovScreenshotLast = {}

	exports["sandbox-base"]:RegisterServerCallback("Pwnzor:FOV", function(source, data, cb)
		if Config.Components.FOV.Enabled then
			local char = exports['sandbox-characters']:FetchCharacterSource(source)
			local fov = data.fov
			if char then
				if not _fovScreenshotLast[source] or (GetGameTimer() - _fovScreenshotLast[source]) > 30000 then
					_fovScreenshotLast[source] = GetGameTimer()
					Pwnzor:Screenshot(char:GetData("SID"), string.format("Detected Modified FOV: %s", fov))
				end

				exports['sandbox-base']:LoggerWarn(
					"Pwnzor",
					string.format(
						"%s %s (%s) Detected Modified FOV: %s",
						char:GetData("First"),
						char:GetData("Last"),
						char:GetData("SID"),
						fov
					),
					{
						console = true,
						file = false,
						database = true,
						discord = {
							embed = true,
							type = "error",
							webhook = GetConvar("discord_pwnzor_webhook", ""),
						},
					}
				)

				if Config.Components.FOV.Options.KickPlayer then
					Wait(5000) -- need time to process screenshot

					exports['sandbox-base']:PunishmentKick(src, string.format("Detected Modified FOV: %s", fov), "Pwnzor",
						true)
				end
			end
		end
	end)

	exports["sandbox-base"]:RegisterServerCallback("Pwnzor:AspectRatio", function(source, data, cb)
		if Config.Components.AspectRatio.Enabled then
			local src = source
			local char = exports['sandbox-characters']:FetchCharacterSource(src)
			if char then
				Pwnzor:Screenshot(char:GetData("SID"), "Detected Unusual Resolution")

				exports['sandbox-base']:LoggerWarn(
					"Pwnzor",
					string.format(
						"%s %s (%s) Detected Unusual Resolution",
						char:GetData("First"),
						char:GetData("Last"),
						char:GetData("SID")
					),
					{
						console = true,
						file = false,
						database = true,
						discord = {
							embed = true,
							type = "error",
							webhook = GetConvar("discord_pwnzor_webhook", ""),
						},
					}
				)

				if Config.Components.AspectRatio.Options.KickPlayer then
					Wait(5000) -- need time to process screenshot

					exports['sandbox-base']:PunishmentKick(src, "Detected Unusual Resolution", "Pwnzor", true)
				end
			end
		end
	end)

	exports["sandbox-base"]:RegisterServerCallback("Pwnzor:Trigger", function(source, data, cb)
		cb("💙 From Pwnzor 🙂")
		if not exports['sandbox-base']:FetchSource(source).Permissions:IsAdmin() then
			exports['sandbox-base']:LoggerInfo(
				"Pwnzor",
				string.format("Pwnzor Trigger For %s: %s (check) %s (match)", source, data.check, data.match),
				{
					console = true,
					file = true,
					database = true,
					discord = {
						embed = true,
						type = "error",
						webhook = GetConvar("discord_pwnzor_webhook", ""),
					},
				}
			)
			exports['sandbox-base']:PunishmentBanSource(
				source,
				-1,
				string.format("Pwnzor Trigger: %s (check) %s (match)", data.check, data.match),
				"Pwnzor"
			)
		end
	end)

	exports["sandbox-base"]:RegisterServerCallback("Pwnzor:GetCode", function(source, data, cb)
		afkCodes[source] = Generator.Hacker.ingVerb()
		cb(afkCodes[source])
	end)

	exports["sandbox-base"]:RegisterServerCallback("Pwnzor:EnterCode", function(source, data, cb)
		if afkCodes[source] ~= nil then
			if afkCodes[source] == data then
				afkCodes[source] = nil
				cb(true)
			else
				exports['sandbox-base']:ExecuteClient(source, "Notification", "Error", "Incorrect AFK Code")
				cb(false)
			end
		else
			cb(false)
		end
	end)
end
