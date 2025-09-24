AddEventHandler("Robbery:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	PedInteraction = exports["sandbox-base"]:FetchComponent("PedInteraction")
	Progress = exports["sandbox-base"]:FetchComponent("Progress")
	Polyzone = exports["sandbox-base"]:FetchComponent("Polyzone")
	Targeting = exports["sandbox-base"]:FetchComponent("Targeting")
	Progress = exports["sandbox-base"]:FetchComponent("Progress")
	Minigame = exports["sandbox-base"]:FetchComponent("Minigame")
	Properties = exports["sandbox-base"]:FetchComponent("Properties")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	EmergencyAlerts = exports["sandbox-base"]:FetchComponent("EmergencyAlerts")
	Doors = exports["sandbox-base"]:FetchComponent("Doors")
	Damage = exports["sandbox-base"]:FetchComponent("Damage")
	Lasers = exports["sandbox-base"]:FetchComponent("Lasers")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Robbery", {
		"PedInteraction",
		"Progress",
		"Polyzone",
		"Targeting",
		"Progress",
		"Minigame",
		"Properties",
		"Inventory",
		"EmergencyAlerts",
		"Doors",
		"Damage",
		"Lasers",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()
		RegisterGamesCallbacks()
		TriggerEvent("Robbery:Client:Setup")

		CreateThread(function()
			PedInteraction:Add(
				"RobToolsPickup",
				GetHashKey("csb_anton"),
				vector3(1129.422, -476.236, 65.485),
				300.00,
				25.0,
				{
					{
						icon = "hand",
						text = "Pickup Items",
						event = "Robbery:Client:PickupItems",
					},
				},
				"box-dollar"
			)
		end)
	end)
end)

AddEventHandler("Robbery:Client:PickupItems", function()
	exports["sandbox-base"]:ServerCallback("Robbery:Pickup", {})
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Robbery", _ROBBERY)
end)

RegisterNetEvent("Robbery:Client:State:Init", function(states)
	_bankStates = states

	for k, v in pairs(states) do
		TriggerEvent(string.format("Robbery:Client:Update:%s", k))
	end
end)

RegisterNetEvent("Robbery:Client:State:Set", function(bank, state)
	_bankStates[bank] = state
	TriggerEvent(string.format("Robbery:Client:Update:%s", bank))
end)

RegisterNetEvent("Robbery:Client:State:Update", function(bank, key, value, tableId)
	print("Heist State Debug: ", bank, key, value, tableId)
	if tableId then
		_bankStates[bank][tableId] = _bankStates[bank][tableId] or {}
		_bankStates[bank][tableId][key] = value
	else
		_bankStates[bank][key] = value
	end
	TriggerEvent(string.format("Robbery:Client:Update:%s", bank))
end)

RegisterNetEvent("Robbery:Client:PrintState", function(heistId)
	if heistId ~= nil and _bankStates[heistId] ~= nil then
		print(json.encode(_bankStates[heistId], { indent = true }))
	else
		print(json.encode(_bankStates, { indent = true }))
	end
end)

AddEventHandler("Robbery:Client:Holdup:Do", function(entity, data)
	Progress:ProgressWithTickEvent({
		name = "holdup",
		duration = 5000,
		label = "Robbing",
		useWhileDead = false,
		canCancel = true,
		ignoreModifier = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "random@shop_robbery",
			anim = "robbery_action_b",
			flags = 49,
		},
	}, function()
		if
			#(
				GetEntityCoords(LocalPlayer.state.ped)
				- GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(entity.serverId)))
			) <= 3.0
		then
			return
		end
		Progress:Cancel()
	end, function(cancelled)
		if not cancelled then
			exports["sandbox-base"]:ServerCallback("Robbery:Holdup:Do", entity.serverId, function(s)
				Inventory.Dumbfuck:Open(s)

				while not LocalPlayer.state.inventoryOpen do
					Wait(1)
				end

				CreateThread(function()
					while LocalPlayer.state.inventoryOpen do
						if
							#(
								GetEntityCoords(LocalPlayer.state.ped)
								- GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(entity.serverId)))
							) > 3.0
						then
							Inventory.Close:All()
						end
						Wait(2)
					end
				end)
			end)
		end
	end)
end)

_ROBBERY = {}
