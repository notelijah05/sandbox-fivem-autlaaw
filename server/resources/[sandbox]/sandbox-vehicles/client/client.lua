_characterLoaded, GLOBAL_PED = false, nil

VEHICLE_INSIDE = nil
VEHICLE_SEAT = nil
VEHICLE_CLASS = nil

VEHICLE_TOP_SPEED = nil

VEHICLE_SEATBELT = false
VEHICLE_HARNESS = false

local vehicleDoorNames = {
	[0] = "Driver",
	[1] = "Passenger",
	[2] = "Rear Driver",
	[3] = "Rear Passenger",
	[4] = "Hood",
	[5] = "Trunk",
}

AddEventHandler("Core:Shared:Ready", function()
	RegisterCallbacks()

	TriggerEvent("Vehicles:Client:StartUp")

	exports["sandbox-keybinds"]:Add("toggle_engine", "IOM_WHEEL_UP", "MOUSE_WHEEL", "Vehicle - Toggle Engine",
		function()
			if VEHICLE_INSIDE and VEHICLE_SEAT == -1 then
				if IsPauseMenuActive() ~= 1 then
					exports['sandbox-vehicles']:EngineToggle(VEHICLE_INSIDE)
				end
			end
		end)

	exports['sandbox-hud']:InteractionRegisterMenu("veh_quick_actions", false, "car", function()
		if VEHICLE_INSIDE then
			local vehEnt = Entity(VEHICLE_INSIDE)
			local subMenu = {}
			local seatAmount = GetVehicleModelNumberOfSeats(GetEntityModel(VEHICLE_INSIDE))
			exports['sandbox-hud']:InteractionShowMenu({
				{
					icon = "key",
					label = "Give Keys",
					shouldShow = function()
						return VEHICLE_INSIDE and
							exports['sandbox-vehicles']:KeysHas(vehEnt.state.VIN, vehEnt.state.GroupKeys)
					end,
					action = function()
						if exports['sandbox-vehicles']:KeysHas(vehEnt.state.VIN, vehEnt.state.GroupKeys) then
							if IsPedInAnyVehicle(LocalPlayer.state.ped, true) then
								local sids = {}
								for i = -1, GetVehicleModelNumberOfSeats(VEHICLE_INSIDE), 1 do
									local ped = GetPedInVehicleSeat(VEHICLE_INSIDE, i)
									if ped ~= 0 and ped ~= LocalPlayer.state.ped then
										table.insert(sids, GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped)))
									end
								end
								exports["sandbox-base"]:ServerCallback("Vehicles:GiveKeys", {
									netId = VehToNet(VEHICLE_INSIDE),
									sids = sids,
								})
							end
						end

						exports['sandbox-hud']:InteractionHide()
					end,
				},
				{
					icon = "person-seat",
					label = "Seats",
					shouldShow = function()
						if VEHICLE_INSIDE then
							if GetVehicleModelNumberOfSeats(GetEntityModel(VEHICLE_INSIDE)) > 1 then
								return true
							end
						end
						return false
					end,
					action = function()
						local fuckingSeats = {}
						local seatAmount = GetVehicleModelNumberOfSeats(GetEntityModel(VEHICLE_INSIDE))
						for i = 1, seatAmount do
							local actualFuckingSeatNumber = i - 2
							if GetPedInVehicleSeat(VEHICLE_INSIDE, actualFuckingSeatNumber) == 0 then
								table.insert(fuckingSeats, {
									icon = "person-seat",
									label = actualFuckingSeatNumber == -1 and "Driver's Seat" or "Seat #" .. i,
									action = function()
										TriggerEvent("Vehicles:Client:Actions:SwitchSeat", actualFuckingSeatNumber)
										exports['sandbox-hud']:InteractionHide()
									end,
								})
							end
						end

						if #fuckingSeats > 0 then
							exports['sandbox-hud']:InteractionShowMenu(fuckingSeats)
						else
							exports["sandbox-hud"]:NotifError("No Seats Free")
						end
					end,
				},
				{
					icon = "car-side",
					label = "Doors",
					shouldShow = function()
						if VEHICLE_INSIDE then
							if GetNumberOfVehicleDoors(VEHICLE_INSIDE) >= 1 then
								return true
							end
						end
						return false
					end,
					action = function()
						local fuckingDoors = {}
						for doorId, doorName in pairs(vehicleDoorNames) do
							if GetIsDoorValid(VEHICLE_INSIDE, doorId) then
								table.insert(fuckingDoors, {
									icon = "car-side",
									label = doorName,
									action = function()
										TriggerEvent("Vehicles:Client:Actions:ToggleDoor", doorId)
									end,
								})
							end
						end

						exports['sandbox-hud']:InteractionShowMenu(fuckingDoors)
					end,
				},
				{
					icon = "car-side",
					label = "Close All Doors",
					shouldShow = function()
						if VEHICLE_INSIDE then
							if GetNumberOfVehicleDoors(VEHICLE_INSIDE) >= 1 then
								return true
							end
						end
						return false
					end,
					action = function()
						if VEHICLE_INSIDE then
							TriggerEvent("Vehicles:Client:Actions:ToggleDoor", "shut")
						end
					end,
				},
				{
					icon = "car-side",
					label = "Open All Doors",
					shouldShow = function()
						if VEHICLE_INSIDE then
							if GetNumberOfVehicleDoors(VEHICLE_INSIDE) >= 1 then
								return true
							end
						end
						return false
					end,
					action = function()
						if VEHICLE_INSIDE then
							TriggerEvent("Vehicles:Client:Actions:ToggleDoor", "open")
						end
					end,
				},
				{
					icon = "window-frame",
					label = "Windows",
					shouldShow = function()
						if VEHICLE_INSIDE then
							if GetNumberOfVehicleDoors(VEHICLE_INSIDE) >= 1 then
								return true
							end
						end
						return false
					end,
					action = function()
						local fuckingDoors = {}
						table.insert(fuckingDoors, {
							icon = "window-frame",
							label = "Driver Window",
							action = function()
								TriggerEvent("Vehicles:Client:Actions:ToggleWindow", 0)
							end,
						})

						table.insert(fuckingDoors, {
							icon = "window-frame",
							label = "Passenger Window",
							action = function()
								TriggerEvent("Vehicles:Client:Actions:ToggleWindow", 1)
							end,
						})

						table.insert(fuckingDoors, {
							icon = "window-frame",
							label = "Close All",
							action = function()
								TriggerEvent("Vehicles:Client:Actions:ToggleWindow", "shut")
							end,
						})

						table.insert(fuckingDoors, {
							icon = "window-frame",
							label = "Open All",
							action = function()
								TriggerEvent("Vehicles:Client:Actions:ToggleWindow", "open")
							end,
						})

						exports['sandbox-hud']:InteractionShowMenu(fuckingDoors)
					end,
				},
				{
					icon = "gauge-min",
					label = "Check Mileage",
					action = function()
						if VEHICLE_INSIDE then
							local vehEnt = Entity(VEHICLE_INSIDE)
							if vehEnt and vehEnt.state and vehEnt.state.Mileage then
								exports["sandbox-hud"]:NotifInfo(
									"This Vehicle Has " .. vehEnt.state.Mileage .. " Miles on the Odometer",
									10000
								)
							end

							exports['sandbox-hud']:InteractionHide()
						end
					end,
				},
				{
					icon = "gauge-circle-plus",
					label = "Check Nitrous Levels",
					shouldShow = function()
						if VEHICLE_INSIDE then
							local vehEnt = Entity(VEHICLE_INSIDE)
							if vehEnt and vehEnt.state and vehEnt.state.Nitrous then
								return true
							end
						end
						return false
					end,
					action = function()
						if VEHICLE_INSIDE then
							local vehEnt = Entity(VEHICLE_INSIDE)
							if vehEnt and vehEnt.state and vehEnt.state.Nitrous then
								exports["sandbox-hud"]:NotifStandard(
									"Nitrous Remaining: " ..
									exports['sandbox-base']:UtilsRound(vehEnt.state.Nitrous, 2) .. "%",
									10000
								)
							end

							exports['sandbox-hud']:InteractionHide()
						end
					end,
				},
				{
					icon = "gauge-circle-minus",
					label = "Remove Nitrous",
					shouldShow = function()
						if VEHICLE_INSIDE and GetPedInVehicleSeat(VEHICLE_INSIDE, -1) == LocalPlayer.state.ped then
							local vehEnt = Entity(VEHICLE_INSIDE)
							if vehEnt and vehEnt.state and vehEnt.state.Nitrous then
								return true
							end
						end
						return false
					end,
					action = function()
						if VEHICLE_INSIDE then
							local vehEnt = Entity(VEHICLE_INSIDE)
							if vehEnt and vehEnt.state and vehEnt.state.Nitrous then
								TriggerEvent("Vehicles:Client:RemoveNitrous")
							end
						end
					end,
				},
				-- {
				-- 	icon = "print-magnifying-glass",
				-- 	label = "Inspect VIN",
				-- 	shouldShow = function()
				-- 		return (LocalPlayer.state.onDuty ~= "police" and exports['sandbox-vehicles']:HasAccess(VEHICLE_INSIDE))
				-- 			or (LocalPlayer.state.onDuty == "police" and LocalPlayer.state.inPdStation)
				-- 	end,
				-- 	action = function()
				-- 		if
				-- 			VEHICLE_INSIDE
				-- 			and (
				-- 				(LocalPlayer.state.onDuty ~= "police" and exports['sandbox-vehicles']:HasAccess(VEHICLE_INSIDE))
				-- 				or (LocalPlayer.state.onDuty == "police" and LocalPlayer.state.inPdStation)
				-- 			)
				-- 		then
				--             exports['sandbox-hud']:ListMenuClose()
				-- 			TriggerServerEvent("Vehicle:Server:InspectVIN", VehToNet(VEHICLE_INSIDE))
				-- 		end
				-- 	end,
				-- },
				{
					icon = "lightbulb-on",
					label = "Neons",
					shouldShow = function()
						if VEHICLE_INSIDE and exports['sandbox-vehicles']:SyncNeonsHas() and not exports['sandbox-police']:IsPdCar(VEHICLE_INSIDE) then
							return true
						end
					end,
					action = function()
						if VEHICLE_INSIDE then
							exports['sandbox-vehicles']:SyncNeonsToggle()
						end
					end,
				},
			})
		end
	end, function()
		if VEHICLE_INSIDE then
			return true
		end
		return false
	end)
end)

AddEventHandler("Vehicles:Client:GiveKeys", function(entityData, data)
	local vehEnt = Entity(entityData.entity)

	if exports['sandbox-vehicles']:KeysHas(vehEnt.state.VIN, vehEnt.state.GroupKeys) then
		local myCoords = GetEntityCoords(LocalPlayer.state.ped)
		local peds = GetGamePool("CPed")
		local sids = {}
		for _, ped in ipairs(peds) do
			if ped ~= LocalPlayer.state.ped and IsPedAPlayer(ped) then
				local entCoords = GetEntityCoords(ped)
				if #(entCoords - myCoords) <= 4.0 then
					table.insert(sids, GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped)))
				end
			end
		end
		exports["sandbox-base"]:ServerCallback("Vehicles:GiveKeys", {
			netId = VehToNet(entityData.entity),
			sids = sids,
		})
	end
end)

RegisterNetEvent("Characters:Client:Spawn")
AddEventHandler("Characters:Client:Spawn", function()
	_characterLoaded = true
	TriggerEvent("Vehicles:Client:CharacterLogin")
end)

RegisterNetEvent("Characters:Client:Logout")
AddEventHandler("Characters:Client:Logout", function()
	_characterLoaded = false

	TriggerEvent("Vehicles:Client:CharacterLogout")
end)

RegisterNetEvent("Vehicles:Client:Actions:SwitchSeat")
AddEventHandler("Vehicles:Client:Actions:SwitchSeat", function(seatNum)
	if not VEHICLE_INSIDE then
		return
	end
	if GetPedInVehicleSeat(VEHICLE_INSIDE, seatNum) == 0 then
		SetPedIntoVehicle(GLOBAL_PED, VEHICLE_INSIDE, seatNum)
	else
		exports["sandbox-hud"]:NotifError("Seat Occupied")
	end
end)

RegisterNetEvent("Vehicles:Client:Actions:ToggleDoor")
AddEventHandler("Vehicles:Client:Actions:ToggleDoor", function(doorNum)
	local vehicle = VEHICLE_INSIDE

	if not vehicle then
		local targetVehicle = exports['sandbox-targeting']:GetEntityPlayerIsLookingAt()
		if
			targetVehicle
			and targetVehicle.entity
			and DoesEntityExist(targetVehicle.entity)
			and GetEntitySpeed(targetVehicle.entity) <= 2.0
			and GetPedInVehicleSeat(targetVehicle.entity, -1) == 0
			and GetVehicleDoorLockStatus(targetVehicle.entity) == 1
		then
			vehicle = targetVehicle.entity
		else
			return
		end
	end

	if doorNum == "shut" or doorNum == "close" then
		exports['sandbox-vehicles']:SyncDoorsShut(vehicle, "all", false)
	elseif doorNum == "open" then
		exports['sandbox-vehicles']:SyncDoorsOpen(vehicle, "all", false, false)
	else
		if GetVehicleDoorAngleRatio(vehicle, doorNum) > 0.0 then
			exports['sandbox-vehicles']:SyncDoorsShut(vehicle, doorNum, false)
		else
			exports['sandbox-vehicles']:SyncDoorsOpen(vehicle, doorNum, false, false)
		end
	end
end)

RegisterNetEvent("Vehicles:Client:Actions:ToggleWindow")
AddEventHandler("Vehicles:Client:Actions:ToggleWindow", function(winNum)
	local vehicle = VEHICLE_INSIDE

	if not vehicle then
		local targetVehicle = exports['sandbox-targeting']:GetEntityPlayerIsLookingAt()
		if
			targetVehicle
			and targetVehicle.entity
			and DoesEntityExist(targetVehicle.entity)
			and GetEntitySpeed(targetVehicle.entity) <= 2.0
			and GetPedInVehicleSeat(targetVehicle.entity, -1) == 0
		then
			vehicle = targetVehicle.entity
		else
			return
		end
	end

	if winNum == "shut" or winNum == "close" then
		for i = 0, 4 do
			RollUpWindow(vehicle, i)
		end
	elseif winNum == "open" then
		for i = 0, 4 do
			RollDownWindows(vehicle, i)
		end
	else
		if IsVehicleWindowIntact(vehicle, winNum) then
			RollDownWindows(vehicle, winNum)
		else
			RollUpWindow(vehicle, winNum)
		end
	end
end)
