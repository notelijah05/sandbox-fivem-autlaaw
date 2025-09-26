local _uircd = {}

AddEventHandler("Core:Shared:Ready", function()
	RegisterChatCommands()
	exports['sandbox-base']:MiddlewareAdd("Characters:Creating", function(source, cData)
		return {
			{
				HUDConfig = {
					layout = "default",
					statusType = "numbers",
					buffsAnchor = "compass",
					vehicle = "default",
					buffsAnchor2 = true,
					showRPM = true,
					hideCrossStreet = false,
					hideCompassBg = false,
					minimapAnchor = true,
					transparentBg = true,
				},
			},
		}
	end)
	exports['sandbox-base']:MiddlewareAdd("Characters:Spawning", function(source)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		local config = char:GetData("HUDConfig")
		if not config then
			char:SetData("HUDConfig", {
				layout = "default",
				statusType = "numbers",
				buffsAnchor = "compass",
				vehicle = "default",
				buffsAnchor2 = true,
				showRPM = true,
				hideCrossStreet = false,
				hideCompassBg = false,
				minimapAnchor = true,
				transparentBg = true,
			})
		end
	end, 1)

	exports["sandbox-base"]:RegisterServerCallback("HUD:SaveConfig", function(source, data, cb)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if char ~= nil then
			char:SetData("HUDConfig", data)
			cb(true)
		else
			cb(false)
		end
	end)

	exports["sandbox-base"]:RegisterServerCallback("HUD:RemoveBlindfold", function(source, data, cb)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if char ~= nil then
			local tarState = Player(data).state
			if tarState.isBlindfolded then
				exports["sandbox-base"]:ClientCallback(source, "HUD:PutOnBlindfold", "Removing Blindfold",
					function(isSuccess)
						if isSuccess then
							if exports['sandbox-inventory']:AddItem(char:GetData("SID"), "blindfold", 1, {}, 1) then
								tarState.isBlindfolded = false
								TriggerClientEvent("VOIP:Client:Gag:Use", data)
							else
								exports['sandbox-hud']:NotifError(source,
									"Failed Adding Item")
								cb(false)
							end
						end
					end)
			else
				exports['sandbox-hud']:NotifError(source, "Target Not Blindfolded")
				cb(false)
			end
		else
			cb(false)
		end
	end)

	exports['sandbox-inventory']:RegisterUse("blindfold", "HUD", function(source, item, itemData)
		exports["sandbox-base"]:ClientCallback(source, "HUD:GetTargetInfront", {}, function(target)
			if target ~= nil then
				local tarState = Player(target).state
				if not tarState.isBlindfolded then
					exports["sandbox-base"]:ClientCallback(source, "HUD:PutOnBlindfold", "Blindfolding",
						function(isSuccess)
							if isSuccess then
								if tarState.isCuffed then
									if exports['sandbox-inventory']:RemoveSlot(item.Owner, item.Name, 1, item.Slot, 1) then
										tarState.isBlindfolded = true
										TriggerClientEvent("VOIP:Client:Gag:Use", target)
									else
										exports['sandbox-hud']:NotifError(source,
											"Failed Removing Item")
									end
								else
									exports['sandbox-hud']:NotifError(source,
										"Target Not Cuffed")
								end
							end
						end)
				else
					exports['sandbox-hud']:NotifError(source,
						"Target Already Blindfolded")
				end
			else
				exports['sandbox-hud']:NotifError(source, "Nobody Near To Blindfold")
			end
		end)
	end)
end)

function RegisterChatCommands()
	exports["sandbox-chat"]:RegisterCommand("uir", function(source, args, rawCommand)
		if not _uircd[source] or os.time() > _uircd[source] then
			TriggerClientEvent("UI:Client:Reset", source, true)
			_uircd[source] = os.time() + (60 * 5)
		else
			exports["sandbox-chat"]:SendSystemSingle(source, "You're Trying To Do This Too Much, Stop.")
		end
	end, {
		help = "Resets UI",
	})

	exports["sandbox-chat"]:RegisterCommand("hud", function(source, args, rawCommand)
		TriggerClientEvent("UI:Client:Configure", source, true)
	end, {
		help = "Open HUD Config Menu",
	})

	exports["sandbox-chat"]:RegisterAdminCommand("testblindfold", function(source, args, rawCommand)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if char ~= nil then
			Player(source).state.isBlindfolded = not Player(source).state.isBlindfolded
		end
	end, {
		help = "Test Blindfold",
	})

	-- exports["sandbox-chat"]:RegisterAdminCommand("notif", function(source, args, rawCommand)
	-- 	exports['sandbox-hud']:NotifSuccess(source, "This is a test, lul")
	-- end, {
	-- 	help = "Test Notification",
	-- })

	-- exports["sandbox-chat"]:RegisterAdminCommand("list", function(source, args, rawCommand)
	-- 	TriggerClientEvent("ListMenu:Client:Test", source)
	-- end, {
	-- 	help = "Test List Menu",
	-- })

	-- exports["sandbox-chat"]:RegisterAdminCommand("input", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Input:Client:Test", source)
	-- end, {
	-- 	help = "Test Input",
	-- })

	-- exports["sandbox-chat"]:RegisterAdminCommand("confirm", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Confirm:Client:Test", source)
	-- end, {
	-- 	help = "Test Confirm Dialog",
	-- })

	-- exports["sandbox-chat"]:RegisterAdminCommand("skill", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Minigame:Client:Skillbar", source)
	-- end, {
	-- 	help = "Test Skill Bar",
	-- })

	-- exports["sandbox-chat"]:RegisterAdminCommand("scan", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Minigame:Client:Scanner", source)
	-- end, {
	-- 	help = "Test Scanner",
	-- })

	-- exports["sandbox-chat"]:RegisterAdminCommand("sequencer", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Minigame:Client:Sequencer", source)
	-- end, {
	-- 	help = "Test Sequencer",
	-- })

	-- exports["sandbox-chat"]:RegisterAdminCommand("keypad", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Minigame:Client:Keypad", source)
	-- end, {
	-- 	help = "Test Keypad",
	-- })

	-- exports["sandbox-chat"]:RegisterAdminCommand("scrambler", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Minigame:Client:Scrambler", source)
	-- end, {
	-- 	help = "Test Scrambler",
	-- })

	-- exports["sandbox-chat"]:RegisterAdminCommand("memory", function(source, args, rawCommand)
	-- 	TriggerClientEvent("Minigame:Client:Memory", source)
	-- end, {
	-- 	help = "Test Memory",
	-- })
end
