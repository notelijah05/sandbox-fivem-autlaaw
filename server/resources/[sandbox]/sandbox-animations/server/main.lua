AddEventHandler("Core:Shared:Ready", function()
	RegisterCallbacks()
	RegisterMiddleware()
	RegisterChatCommands()
	RegisterItems()
end)

function RegisterMiddleware()
	exports['sandbox-base']:MiddlewareAdd("Characters:Spawning", function(source)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if char:GetData("Animations") == nil then
			char:SetData("Animations", { walk = "default", expression = "default", emoteBinds = {} })
		end
	end, 10)
end

function RegisterChatCommands()
	exports["sandbox-chat"]:RegisterCommand("e", function(source, args, rawCommand)
		local emote = args[1]
		if emote == "c" or emote == "cancel" then
			TriggerClientEvent("Animations:Client:CharacterCancelEmote", source)
		else
			TriggerClientEvent("Animations:Client:CharacterDoAnEmote", source, emote)
		end
	end, {
		help = "Do An Emote or Dance",
		params = { {
			name = "Emote",
			help = "Name of The Emote",
		} },
	})
	exports["sandbox-chat"]:RegisterCommand("emotes", function(source, args, rawCommand)
		TriggerClientEvent("Animations:Client:OpenMainEmoteMenu", source)
	end, {
		help = "Open Emote Menu",
	})
	exports["sandbox-chat"]:RegisterCommand("emotebinds", function(source, args, rawCommand)
		TriggerClientEvent("Animations:Client:OpenEmoteBinds", source)
	end, {
		help = "Edit Emote Binds",
	})
	exports["sandbox-chat"]:RegisterCommand("walks", function(source, args, rawCommand)
		TriggerClientEvent("Animations:Client:OpenWalksMenu", source)
	end, {
		help = "Change Walk Style",
	})
	exports["sandbox-chat"]:RegisterCommand("face", function(source, args, rawCommand)
		TriggerClientEvent("Animations:Client:OpenExpressionsMenu", source)
	end, {
		help = "Change Facial Expression",
	})
	exports["sandbox-chat"]:RegisterCommand("selfie", function(source, args, rawCommand)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if
			not Player(source).state.isCuffed
			and not Player(source).state.isDead
			and hasValue(char:GetData("States"), "PHONE")
		then
			TriggerClientEvent("Animations:Client:Selfie", source)
		else
			exports['sandbox-base']:ExecuteClient(source, "Notification", "Error", "You do not have a phone.")
		end
	end, {
		help = "Open Selfie Mode",
	})
end

function RegisterCallbacks()
	exports["sandbox-base"]:RegisterServerCallback("Animations:UpdatePedFeatures", function(source, data, cb)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if char then
			cb(exports['sandbox-animations']:PedFeaturesUpdateFeatureInfo(char, data.type, data.data))
		else
			cb(false)
		end
	end)

	exports["sandbox-base"]:RegisterServerCallback("Animations:UpdateEmoteBinds", function(source, data, cb)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if char then
			cb(exports['sandbox-animations']:EmoteBindsUpdate(char, data), data)
		else
			cb(false)
		end
	end)
end

exports("PedFeaturesUpdateFeatureInfo", function(char, type, data, cb)
	if type == "walk" then
		local currentData = char:GetData("Animations")
		char:SetData(
			"Animations",
			{ walk = data, expression = currentData.expression, emoteBinds = currentData.emoteBinds }
		)
		return true
	elseif type == "expression" then
		local currentData = char:GetData("Animations")
		char:SetData(
			"Animations",
			{ walk = currentData.walk, expression = data, emoteBinds = currentData.emoteBinds }
		)
		return true
	end
	return false
end)

exports("EmoteBindsUpdate", function(char, data, cb)
	local currentData = char:GetData("Animations")
	char:SetData(
		"Animations",
		{ walk = currentData.walk, expression = currentData.expression, emoteBinds = data }
	)
	return true
end)

RegisterServerEvent("Animations:Server:ClearAttached", function(propsToDelete)
	local src = source
	local ped = GetPlayerPed(src)

	if ped then
		for k, v in ipairs(GetAllObjects()) do
			if DoesEntityExist(v) and GetEntityAttachedTo(v) == ped and propsToDelete[GetEntityModel(v)] then
				DeleteEntity(v)
			end
		end
	end
end)

local pendingSend = false

RegisterServerEvent("Selfie:CaptureSelfie", function()
	local src = source
	local char = exports['sandbox-characters']:FetchCharacterSource(src)
	if char then
		if pendingSend then
			exports['sandbox-base']:ExecuteClient(src, "Notification", "Warn",
				"Please wait while current photo is uploading", 2000)
			return
		end
		pendingSend = true
		exports['sandbox-base']:ExecuteClient(src, "Notification", "Info", "Prepping Photo Upload", 2000)

		exports["sandbox-base"]:ClientCallback(src, "Selfie:Client:UploadPhoto", {
			api = tostring(GetConvar("phone_selfie_webhook", "")),
			token = tostring(GetConvar("phone_selfie_token", "")),
		}, function(ret)
			if ret then
				local _data = {
					image_url = json.decode(ret).url,
				}
				local retval = exports['sandbox-phone']:PhotosCreate(src, _data)
				if retval then
					pendingSend = false
					TriggerClientEvent("Selfie:DoCloseSelfie", src)
					exports['sandbox-base']:ExecuteClient(src, "Notification", "Success", "Photo uploaded successfully!",
						2000)
				else
					pendingSend = false
					TriggerClientEvent("Selfie:DoCloseSelfie", src)
					exports['sandbox-base']:ExecuteClient(src, "Notification", "Error", "Error uploading photo!", 2000)
				end
			else
				pendingSend = false
				TriggerClientEvent("Selfie:DoCloseSelfie", src)
				exports['sandbox-base']:ExecuteClient(src, "Notification", "Error", "Error uploading photo!", 2000)
				print("^1ERROR: " .. data)
			end
		end)
	end
end)
