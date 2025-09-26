exports("Shutdown", function(reason)
	exports['sandbox-base']:LoggerCritical("Core", "Shutting Down Core, Reason: " .. reason, {
		console = true,
		file = true,
	})
	Wait(1000) -- Need wait period so logging can finish
	os.exit()
end)

exports("DropAll", function()
	for k, v in pairs(exports["sandbox-base"]:GetAllPlayers()) do
		if v ~= nil then
			DropPlayer(
				v:GetData("Source"),
				"⛔ Server Restarting ⛔ Due to a pending restart, you've been dropped from the server. Please ❗❗❗RESTART FIVEM❗❗❗ and reconnect in a few minutes."
			)
		end
	end
end)

AddEventHandler("Core:Server:ForceAllSave", function()
	exports['sandbox-queue']:CloseAndDrop()
	exports["sandbox-base"]:DropAll()
	TriggerEvent("Core:Server:ForceSave")
end)

AddEventHandler("txAdmin:events:scheduledRestart", function(eventData)
	if eventData.secondsRemaining <= 60 then
		exports['sandbox-queue']:CloseAndDrop()
		exports["sandbox-base"]:DropAll()
		TriggerEvent("Core:Server:ForceSave")
	elseif not GlobalState["RestartLockdown"] and eventData.secondsRemaining <= (60 * 30) then
		GlobalState["RestartLockdown"] = true
	end

	-- exports["sandbox-chat"]:SendSystemBroadcast( -- TX Admin Sends them
	-- 	string.format("Server Restart In %s Minutes", math.floor(eventData.secondsRemaining / 60))
	-- )
end)

AddEventHandler("Core:Server:StartupReady", function()
	CreateThread(function()
		while not exports or exports[GetCurrentResourceName()] == nil do
			Wait(1)
		end

		TriggerEvent(
			"Database:Server:Initialize",
			exports["sandbox-base"]:GetAuthUrl(),
			exports["sandbox-base"]:GetAuthDb(),
			exports["sandbox-base"]:GetGameUrl(),
			exports["sandbox-base"]:GetGameDb()
		)
		while not COMPONENTS.Proxy.DatabaseReady do
			Wait(1)
		end

		TriggerEvent("Proxy:Shared:RegisterReady")
		for k, v in pairs(COMPONENTS) do
			TriggerEvent("Proxy:Shared:ExtendReady", k)
		end

		Wait(1000)

		COMPONENTS.Proxy.ExportsReady = true
		TriggerEvent("Proxy:Shared:ExportsReady")

		SetupAPIHandler()
		return
	end)
end)

-- CreateThread(function()
-- 	while true do
-- 		GlobalState["OS:Time"] = os.time()
-- 		Wait(1000)
-- 	end
-- end)

AddEventHandler("Database:Server:Ready", function(db)
	if COMPONENTS.Database == nil and db ~= nil then
		COMPONENTS.Database = db
	end
	COMPONENTS.Proxy.DatabaseReady = true
	TriggerEvent("Core:Shared:Ready")
end)

RegisterNetEvent("Core:Server:ResourceStopped", function(resource)
	local src = source
	if resource == "sandbox-pwnzor" then
		exports['sandbox-base']:PunishmentBanSource(src, -1, "Pwnzor Resource Stopped", "Pwnzor")
	end
end)

RegisterCommand("rcondisablelockdown", function()
	GlobalState["RestartLockdown"] = false
end, true)
