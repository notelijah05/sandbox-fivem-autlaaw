DOORS_CACHE = {}
DOORS_IDS = {}
ELEVATOR_CACHE = {}

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Wait(1000)
		RegisterCallbacks()
		RegisterChatCommands()
		--RegisterItems()

		RunStartup()
	end
end)

local _startup = false
function RunStartup()
	if _startup then
		return
	end
	_startup = true

	for k, v in ipairs(_doorConfig) do
		if v.model and v.coords then
			if v.id and not DOORS_IDS[v.id] then
				DOORS_IDS[v.id] = k
			end

			DOORS_CACHE[k] = {
				locked = v.locked,
			}
		else
			exports['sandbox-base']:LoggerWarn("Doors", "Door: " .. (v.id and v.id or k), " Missing Required Data")
		end
	end

	for k, v in ipairs(_elevatorConfig) do
		ELEVATOR_CACHE[k] = {
			floors = {},
		}

		for k2, v2 in pairs(v.floors) do
			ELEVATOR_CACHE[k].floors[k2] = {
				locked = v2.defaultLocked or false,
			}
		end
	end

	exports['sandbox-base']:LoggerTrace("Doors",
		"Loaded ^2" .. #_doorConfig .. "^7 Doors & ^2" .. #_elevatorConfig .. "^7 Elevators")
end

function RegisterChatCommands()
	exports["sandbox-chat"]:RegisterAdminCommand("doorhelp", function(source, args, rawCommand)
		TriggerClientEvent("Doors:Client:DoorHelper", source)
	end, {
		help = "[Developer] Toggle Door Creation Helper",
	})
end

-- function RegisterItems()
--     exports['sandbox-inventory']:RegisterUse('lockpick', 'Doors', function(source, item)
--         TriggerClientEvent('Doors:Client:AttemptLockpick', source, item)
--     end)
-- end

function RegisterCallbacks()
	exports["sandbox-base"]:RegisterServerCallback("Doors:Fetch", function(source, data, cb)
		cb(DOORS_CACHE, ELEVATOR_CACHE)
	end)

	exports["sandbox-base"]:RegisterServerCallback("Doors:ToggleLocks", function(source, doorId, cb)
		if type(doorId) == "string" then
			doorId = DOORS_IDS[doorId]
		end

		local targetDoor = _doorConfig[doorId]
		if targetDoor and not IsDoorDisabled(doorId) and CheckPlayerAuth(source, targetDoor.restricted) then
			local newState = exports['sandbox-doors']:SetLock(doorId)
			if newState == nil then
				cb(false, false)
			else
				cb(true, newState)
			end
		else
			cb(false)
		end
	end)

	exports["sandbox-base"]:RegisterServerCallback("Doors:Lockpick", function(source, doorId, cb)
		if type(doorId) == "string" then
			doorId = DOORS_IDS[doorId]
		end

		local targetDoor = _doorConfig[doorId]
		if targetDoor and targetDoor.canLockpick then
			local newState = exports['sandbox-doors']:SetLock(doorId, false)
			if newState == nil then
				cb(false, false)
			else
				cb(true, newState)
			end
		else
			cb(false)
		end
	end)

	exports["sandbox-base"]:RegisterServerCallback("Doors:Elevators:ToggleLocks", function(source, data, cb)
		local targetElevator = _elevatorConfig[data.elevator]
		if targetElevator and targetElevator.canLock and CheckPlayerAuth(source, targetElevator.canLock) then
			local newState = exports['sandbox-doors']:SetElevatorLock(data.elevator, data.floor)
			if newState == nil then
				cb(false, false)
			else
				cb(true, newState)
			end
		else
			cb(false)
		end
	end)

	exports["sandbox-base"]:RegisterServerCallback("Doors:Elevator:Validate", function(source, data, cb)
		exports['sandbox-pwnzor']:TempPosIgnore(source)
		cb()
	end)
end

exports('SetLock', function(doorId, newState, doneDouble)
	if type(doorId) == "string" then
		doorId = DOORS_IDS[doorId]
	end

	local doorData = _doorConfig[doorId]

	if doorData then
		local isLocked = DOORS_CACHE[doorId].locked
		if newState == nil then
			newState = not isLocked
		end

		if newState ~= isLocked then
			DOORS_CACHE[doorId].locked = newState

			if DOORS_CACHE[doorId].forcedOpen then
				DOORS_CACHE[doorId].forcedOpen = false
			end

			TriggerClientEvent("Doors:Client:UpdateState", -1, doorId, newState)
			if doorData.double and not doneDouble then
				exports['sandbox-doors']:SetLock(doorData.double, newState, true)
			end
		end
		return newState
	end
	return nil
end)

exports('IsLocked', function(doorId)
	if type(doorId) == "string" then
		doorId = DOORS_IDS[doorId]
	end

	local doorData = _doorConfig[doorId]
	if doorData then
		return DOORS_CACHE[doorId].locked
	end
	return false
end)

exports('SetForcedOpen', function(doorId)
	if type(doorId) == "string" then
		doorId = DOORS_IDS[doorId]
	end

	if DOORS_CACHE[doorId] then
		DOORS_CACHE[doorId].forcedOpen = true

		TriggerClientEvent("Doors:Client:SetForcedOpen", -1, doorId)
	end
end)

exports('SetElevatorLock', function(elevatorId, floorId, newState)
	local data = _elevatorConfig[elevatorId]

	if
		data
		and ELEVATOR_CACHE[elevatorId]
		and ELEVATOR_CACHE[elevatorId].floors
		and ELEVATOR_CACHE[elevatorId].floors[floorId]
	then
		local isLocked = ELEVATOR_CACHE[elevatorId].floors[floorId].locked
		if newState == nil then
			newState = not isLocked
		end

		if data and newState ~= isLocked then
			ELEVATOR_CACHE[elevatorId].floors[floorId].locked = newState
			TriggerClientEvent("Doors:Client:UpdateElevatorState", -1, elevatorId, floorId, newState)
		end
		return newState
	end
	return nil
end)

exports('DisableDoor', function(doorId, seconds, doneDouble)
	if type(doorId) == "string" then
		doorId = DOORS_IDS[doorId]
	end

	local doorData = _doorConfig[doorId]

	if doorData then
		local endTime = os.time() + seconds
		DOORS_CACHE[doorId].disabledUntil = endTime

		TriggerClientEvent("Doors:Client:DisableDoor", -1, doorId, endTime)
		if doorData.double and not doneDouble then
			exports['sandbox-doors']:DisableDoor(doorData.double, seconds, true)
		end
	end
	return nil
end)

function IsDoorDisabled(doorId)
	if DOORS_CACHE[doorId] and DOORS_CACHE[doorId].disabledUntil then
		return DOORS_CACHE[doorId].disabledUntil >= os.time()
	end
	return false
end

function CheckPlayerAuth(source, doorPermissionData)
	if type(doorPermissionData) ~= "table" then
		return true
	end

	local char = exports['sandbox-characters']:FetchCharacterSource(source)
	if char then
		local stateId = char:GetData("SID")

		if exports['sandbox-jobs']:HasJob(source, "dgang", false, false, 99, true) then
			return true
		end

		for k, v in ipairs(doorPermissionData) do
			if v.type == "character" then
				if stateId == v.SID then
					return true
				end
			elseif v.type == "job" then
				if v.job then
					if
						exports['sandbox-jobs']:HasJob(
							source,
							v.job,
							v.workplace,
							v.grade,
							v.gradeLevel,
							v.reqDuty,
							v.jobPermission
						)
					then
						return true
					end
				elseif v.jobPermission then
					if exports['sandbox-jobs']:HasPermission(source, v.jobPermission) then
						return true
					end
				end
			elseif v.type == "propertyData" then
				if exports['sandbox-properties']:HasAccessWithData(source, v.key, v.value) then
					return true
				end
			end
		end
	end
	return false
end

RegisterNetEvent("Doors:Server:PrintDoor", function(data)
	local src = source
	local player = exports['sandbox-base']:FetchSource(src)
	if not player.Permissions:IsAdmin() then
		return
	end

	file = io.open("created_doors_data.txt", "a")
	io.output(file)
	local output = GetDoorOutput(data)
	io.write(output)
	io.close(file)
end)

function GetDoorOutput(data)
	local printout = '{\n\tid = "' .. data.name .. '",\n\tmodel = ' .. data.model .. ","

	printout = printout
		.. "\n\tcoords = vector3("
		.. tostring(exports['sandbox-base']:UtilsRound(data.coords.x, 2))
		.. ", "
		.. tostring(exports['sandbox-base']:UtilsRound(data.coords.y, 2))
		.. ", "
		.. tostring(exports['sandbox-base']:UtilsRound(data.coords.z, 2))
		.. "),"
	printout = printout .. "\n}\n\n"
	return printout
end
