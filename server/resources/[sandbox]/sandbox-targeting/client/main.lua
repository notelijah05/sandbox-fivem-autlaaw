local IS_SPAWNED = false
GLOBAL_PED = false

targetableObjectModels = {}
targetableEntities = {}
interactionZones = {}

AddEventHandler('onClientResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Wait(1000)
		exports["sandbox-keybinds"]:Add("targeting_starts", "LMENU", "keyboard", "Targeting (Third Eye) (Hold)",
			function()
				if IS_SPAWNED and not LocalPlayer.state.isCuffed and not LocalPlayer.state.isHardCuffed then
					StartTargeting()
				end
			end, function()
				if not inTargetingMenu then
					StopTargeting()
				end
			end)

		if LocalPlayer.state.loggedIn then
			DeInitPolyzoneTargets()
			Wait(100)
			InitPolyzoneTargets()
		end
	end
end)

RegisterNetEvent("Characters:Client:Spawn")
AddEventHandler("Characters:Client:Spawn", function()
	CreateThread(function()
		while LocalPlayer.state.loggedIn do
			GLOBAL_PED = PlayerPedId()
			Wait(5000)
		end
	end)

	local lastEntity = nil
	CreateThread(function()
		while LocalPlayer.state.loggedIn do
			Wait(500)
			local hitting, endCoords, entity = GetEntityPlayerIsLookingAt(25.0, GLOBAL_PED, 286)
			if hitting and GetEntityType(entity) > 0 and entity ~= lastEntity then
				lastEntity = entity
				TriggerEvent("Targeting:Client:TargetChanged", entity, endCoords)
			elseif not hitting and lastEntity then
				lastEntity = nil
				TriggerEvent("Targeting:Client:TargetChanged", false)
			end
		end
	end)

	Wait(2000)
	IS_SPAWNED = true
	InitPolyzoneTargets()
end)

RegisterNetEvent("Characters:Client:Logout")
AddEventHandler("Characters:Client:Logout", function()
	DeInitPolyzoneTargets()
	IS_SPAWNED = false
end)

exports("GetEntityPlayerIsLookingAt", function()
	local hitting, endCoords, entity = GetEntityPlayerIsLookingAt(25.0, GLOBAL_PED, 286)
	if hitting then
		return {
			entity = entity,
			endCoords = endCoords,
		}
	end
	return false
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	-- ? Clear targets since they should be being reregistered on component update anyways
	targetableObjectModels = {}
	targetableEntities = {}
	interactablePeds = {}
	interactableModels = {}
	interactionZones = {}
end)
