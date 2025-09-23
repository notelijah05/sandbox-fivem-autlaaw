exports("GetEnvironment", function()
	return GetConvar("sv_environment", "DEV")
end)

exports("GetAccessRole", function()
	return GetConvar("sv_access_role", 0)
end)

exports("GetApiAddress", function()
	return GetConvar('api_address', 'CONVAR_DEFAULT')
end)

exports("GetApiId", function()
	return GetConvar('api_id', 'CONVAR_DEFAULT')
end)

exports("GetApiSecret", function()
	return GetConvar('api_secret', 'CONVAR_DEFAULT')
end)

exports("GetAuthUrl", function()
	return GetConvar("mongodb_auth_url", "CONVAR_DEFAULT")
end)

exports("GetAuthDb", function()
	return GetConvar("mongodb_auth_database", "CONVAR_DEFAULT")
end)

exports("GetGameUrl", function()
	return GetConvar("mongodb_game_url", "CONVAR_DEFAULT")
end)

exports("GetGameDb", function()
	return GetConvar("mongodb_game_database", "CONVAR_DEFAULT")
end)

exports("GetLogging", function()
	return tonumber(GetConvar("log_level", 0))
end)

exports("GetSbfwVersion", function()
	return GetConvar("sbfw_version", "UNKNOWN")
end)

-- exports("GetDiscordBotToken", function()
-- 	return GetConvar('discord_bot_token', 'CONVAR_DEFAULT')
-- end)

CreateThread(function()
	ENVIRONMENT = GetConvar("sv_environment", "DEV")
	ACCESS_ROLE = GetConvar("sv_access_role", 0)

	API_ADDRESS = GetConvar('api_address', 'CONVAR_DEFAULT')
	API_ID = GetConvar('api_id', 'CONVAR_DEFAULT')
	API_SECRET = GetConvar('api_secret', 'CONVAR_DEFAULT')

	--BOT_TOKEN = GetConvar('discord_bot_token', 'CONVAR_DEFAULT')
	AUTH_URL = GetConvar("mongodb_auth_url", "CONVAR_DEFAULT")
	AUTH_DB = GetConvar("mongodb_auth_database", "CONVAR_DEFAULT")
	GAME_URL = GetConvar("mongodb_game_url", "CONVAR_DEFAULT")
	GAME_DB = GetConvar("mongodb_game_database", "CONVAR_DEFAULT")
	LOGGING = tonumber(GetConvar("log_level", 0))
	SBFW_VERSION = GetConvar("sbfw_version", "UNKNOWN")
end)

AddEventHandler("Core:Shared:Watermark", function()
	GlobalState.IsProduction = (exports["sandbox-base"]:GetEnvironment():upper()) ~= "DEV"

	local convarChecks = {
		{ key = "sv_environment",        value = exports["sandbox-base"]:GetEnvironment(),       stop = true },
		{ key = "sv_access_role",        value = exports["sandbox-base"]:GetAccessRole(),        stop = false },
		{ key = "api_address",           value = exports["sandbox-base"]:GetApiAddress(),        stop = true },
		{ key = "api_id",                value = exports["sandbox-base"]:GetApiId(),             stop = true },
		{ key = "api_secret",            value = exports["sandbox-base"]:GetApiSecret(),         stop = true },
		--{ key = "discord_bot_token",     value = exports["sandbox-base"]:GetDiscordBotToken(),   stop = true },
		{ key = "mongodb_auth_url",      value = exports["sandbox-base"]:GetAuthUrl(),           stop = true },
		{ key = "mongodb_auth_database", value = exports["sandbox-base"]:GetAuthDb(),            stop = true },
		{ key = "mongodb_game_url",      value = exports["sandbox-base"]:GetGameUrl(),           stop = true },
		{ key = "mongodb_game_database", value = exports["sandbox-base"]:GetGameDb(),            stop = true },
		{ key = "log_level",             value = tostring(exports["sandbox-base"]:GetLogging()), stop = false },
		{ key = "SBFW_VERSION",          value = exports["sandbox-base"]:GetSbfwVersion(),       stop = false },
	}

	for k, v in pairs(convarChecks) do
		if v.value == "CONVAR_DEFAULT" then
			exports['sandbox-base']:LoggerError("Convar", "Missing Convar " .. v.key, {
				console = true,
				file = true,
			})

			if v.stop then
				exports["sandbox-base"]:Shutdown("Missing Convar " .. v.key)
				return
			end
		end
	end

	TriggerEvent("Core:Server:StartupReady")
end)
