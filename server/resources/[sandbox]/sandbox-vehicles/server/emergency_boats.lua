local boatModels = {
	police = `predator`,
	ems = `dinghy3`,
}

local boatCooldowns = {}

RegisterNetEvent("Vehicles:Server:RequestEmergencyBoat", function(parkingSpace)
	local src = source
	local char = exports['sandbox-characters']:FetchCharacterSource(src)
	local onDuty = Player(src).state.onDuty
	if
		char
		and (onDuty == "police" or onDuty == "ems")
		and (not boatCooldowns[onDuty] or boatCooldowns[onDuty] <= os.time())
	then
		exports['sandbox-vehicles']:SpawnTemp(
			source,
			boatModels[onDuty] or `predator`,
			"boat",
			parkingSpace.xyz,
			parkingSpace.w,
			function(veh, VIN)
				exports['sandbox-vehicles']:KeysAdd(src, VIN)

				Entity(veh).state.GroupKeys = onDuty
				Entity(veh).state.EmergencyBoat = true

				boatCooldowns[onDuty] = os.time() + (60 * 0.25) -- Will do for now
			end
		)
	else
		exports['sandbox-hud']:NotifError(source, "On Cooldown")
	end
end)

RegisterNetEvent("Vehicles:Server:DeleteEmergencyBoat", function(vNet)
	local src = source
	local char = exports['sandbox-characters']:FetchCharacterSource(src)
	local onDuty = Player(src).state.onDuty
	if char and (onDuty == "police" or onDuty == "ems") then
		local veh = NetworkGetEntityFromNetworkId(vNet)
		if veh and DoesEntityExist(veh) and Entity(veh).state.EmergencyBoat then
			exports['sandbox-vehicles']:Delete(veh, function() end)

			boatCooldowns[onDuty] = false
		end
	end
end)
