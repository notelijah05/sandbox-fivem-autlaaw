AddEventHandler("Core:Shared:Ready", function()
	SetupCameras()
	RegisterChatCommands()

	exports["sandbox-base"]:RegisterServerCallback("CCTV:PreviousInGroup", function(source, data, cb)
		local pState = Player(source).state
		if pState.inCCTVCam then
			for i = pState.inCCTVCam.camId - 1, 0, -1 do
				if i ~= pState.inCCTVCam.camId and GlobalState[pState.inCCTVCam.camKey]?.group == Config.Cameras[i]?.group then
					return exports['sandbox-cctv']:View(source, i)
				end
			end

			for i = #Config.Cameras, 0, -1 do
				if i ~= pState.inCCTVCam.camId and GlobalState[pState.inCCTVCam.camKey]?.group == Config.Cameras[i]?.group then
					return exports['sandbox-cctv']:View(source, i)
				end
			end
		end
	end)

	exports["sandbox-base"]:RegisterServerCallback("CCTV:NextInGroup", function(source, data, cb)
		local pState = Player(source).state
		if pState.inCCTVCam then
			for i = pState.inCCTVCam.camId + 1, #Config.Cameras do
				if i ~= pState.inCCTVCam.camId and GlobalState[pState.inCCTVCam.camKey]?.group == Config.Cameras[i]?.group then
					return exports['sandbox-cctv']:View(source, i)
				end
			end

			for i = 1, #Config.Cameras do
				if i ~= pState.inCCTVCam.camId and GlobalState[pState.inCCTVCam.camKey]?.group == Config.Cameras[i]?.group then
					return exports['sandbox-cctv']:View(source, i)
				end
			end
		end
	end)

	exports["sandbox-base"]:RegisterServerCallback("CCTV:ViewGroup", function(source, data, cb)
		exports['sandbox-cctv']:ViewGroup(source, data)
	end)
end)

exports('View', function(source, camId)
	local pState = Player(source).state
	if Config.AllowedJobs[pState.onDuty] or exports['sandbox-base']:FetchSource(source).Permissions:IsAdmin() then
		TriggerClientEvent("CCTV:Client:View", source, camId)
	end
end)

exports('ViewGroup', function(source, camGroup)
	for k, v in ipairs(Config.Cameras) do
		if v?.group == camGroup then
			return exports['sandbox-cctv']:View(source, k)
		end
	end

	return nil
end)

exports('StateOnline', function(camId)
	local camKey = string.format("CCTV:Camera:%s", camId)
	if GlobalState[camKey] ~= nil then
		GlobalState[camKey].isOnline = true
	end
end)

exports('StateOffline', function(camId)
	local camKey = string.format("CCTV:Camera:%s", camId)
	if GlobalState[camKey] ~= nil then
		GlobalState[camKey].isOnline = false
	end
end)

exports('StateGroupOnline', function(groupId)
	for k, v in pairs(Config.Cameras) do
		if v.group == groupId then
			exports['sandbox-cctv']:StateOnline(k)
		end
	end
end)

exports('StateGroupOffline', function(groupId)
	for k, v in pairs(Config.Cameras) do
		if v.group == groupId then
			exports['sandbox-cctv']:StateOffline(k)
		end
	end
end)
