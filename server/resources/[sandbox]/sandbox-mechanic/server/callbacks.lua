function RegisterCallbacks()
	exports["sandbox-base"]:RegisterServerCallback("Mechanic:InstallMultipleRepairParts", function(source, data, cb)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if char and data?.part and data?.quantity and _mechanicItemsToParts[data.part] then
			if exports['sandbox-inventory']:ItemsHas(char:GetData("SID"), 1, data.part, data.quantity) then
				exports["sandbox-base"]:ClientCallback(source, "Mechanic:StartInstall", data, function(success)
					if success then
						exports['sandbox-inventory']:Remove(char:GetData("SID"), 1, data.part, data.quantity)
					end
				end)

				cb(true)
				return
			end
		end

		cb(false)
	end)
	exports["sandbox-base"]:RegisterServerCallback("Mechanic:RemovePerformanceUpgrade", function(source, data, cb)
		local partData = data
		exports["sandbox-base"]:ClientCallback(source, 'Mechanic:StartUpgradeRemoval', partData, function(success, veh)
			if success and veh then
				local veh = NetworkGetEntityFromNetworkId(veh)
				local vehState = Entity(veh)
				if DoesEntityExist(veh) and vehState and vehState.state.VIN then
					local vehicleData = exports['sandbox-vehicles']:OwnedGetActive(vehState.state.VIN)
					if vehicleData and vehicleData:GetData('Properties') then
						local currentProperties = vehicleData:GetData('Properties')

						if currentProperties.mods then
							currentProperties.mods[partData.partName:lower()] = -1
						end

						vehicleData:SetData('Properties', currentProperties)
						exports['sandbox-vehicles']:OwnedForceSave(vehicleData:GetData('VIN'))
					end
				end

				TriggerClientEvent('Mechanic:Client:ForcePerformanceProperty', -1, NetworkGetNetworkIdFromEntity(veh),
					partData.modTpe, partData.toggleMod or partData.modIndex)
			end
		end)
		cb(true)
	end)
end
