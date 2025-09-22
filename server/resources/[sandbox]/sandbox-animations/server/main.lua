AddEventHandler("Animations:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Chat = exports["sandbox-base"]:FetchComponent("Chat")
	Animations = exports["sandbox-base"]:FetchComponent("Animations")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	Photos = exports["sandbox-base"]:FetchComponent("Photos")
	RegisterChatCommands()
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Animations", {
		"Chat",
		"Animations",
		"Inventory",
		"Photos",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()
		RegisterCallbacks()
		RegisterMiddleware()

		RegisterItems()
	end)
end)

function RegisterMiddleware()
	exports['sandbox-base']:Add("Characters:Spawning", function(source)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if char:GetData("Animations") == nil then
			char:SetData("Animations", { walk = "default", expression = "default", emoteBinds = {} })
		end
	end, 10)
end

function RegisterChatCommands()
	Chat:RegisterCommand("e", function(source, args, rawCommand)
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
	Chat:RegisterCommand("emotes", function(source, args, rawCommand)
		TriggerClientEvent("Execute:Client:Component", source, "Animations", "OpenMainEmoteMenu")
	end, {
		help = "Open Emote Menu",
	})
	Chat:RegisterCommand("emotebinds", function(source, args, rawCommand)
		TriggerClientEvent("Animations:Client:OpenEmoteBinds", source)
	end, {
		help = "Edit Emote Binds",
	})
	Chat:RegisterCommand("walks", function(source, args, rawCommand)
		TriggerClientEvent("Execute:Client:Component", source, "Animations", "OpenWalksMenu")
	end, {
		help = "Change Walk Style",
	})
	Chat:RegisterCommand("face", function(source, args, rawCommand)
		TriggerClientEvent("Execute:Client:Component", source, "Animations", "OpenExpressionsMenu")
	end, {
		help = "Change Facial Expression",
	})
	Chat:RegisterCommand("selfie", function(source, args, rawCommand)
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
			cb(Animations.PedFeatures:UpdateFeatureInfo(char, data.type, data.data))
		else
			cb(false)
		end
	end)

	exports["sandbox-base"]:RegisterServerCallback("Animations:UpdateEmoteBinds", function(source, data, cb)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if char then
			cb(Animations.EmoteBinds:Update(char, data), data)
		else
			cb(false)
		end
	end)
end

ANIMATIONS = {
	PedFeatures = {
		UpdateFeatureInfo = function(self, char, type, data, cb)
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
		end,
	},
	EmoteBinds = {
		Update = function(self, char, data, cb)
			local currentData = char:GetData("Animations")
			char:SetData(
				"Animations",
				{ walk = currentData.walk, expression = currentData.expression, emoteBinds = data }
			)
			return true
		end,
	},
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Animations", ANIMATIONS)
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
				local retval = Photos:Create(src, _data)
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
