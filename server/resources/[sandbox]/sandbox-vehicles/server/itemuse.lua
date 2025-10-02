exports('lockpick', function(event, item, inventory, slot, data)
	if event == 'usingItem' then
		Citizen.SetTimeout(500, function()
			exports["sandbox-base"]:ClientCallback(inventory.id, "Vehicles:Lockpick", true, function(using, success)
				if using then
					local currentDurability = slot.metadata and slot.metadata.durability or 100
					local newDurability

					if success then
						newDurability = currentDurability - 20
						exports.ox_inventory:SetDurability(inventory.id, slot.slot, newDurability)
					else
						newDurability = currentDurability - 50
						exports.ox_inventory:SetDurability(inventory.id, slot.slot, newDurability)
					end

					if newDurability <= 0 then
						exports.ox_inventory:RemoveItem(inventory.id, item.name, 1, slot.metadata, slot.slot)
					else
						exports.ox_inventory:SetDurability(inventory.id, slot.slot, newDurability)
					end
				end
			end)
		end)
		return
	end
end)

exports('adv_lockpick', function(event, item, inventory, slot, data)
	if event == 'usingItem' then
		Citizen.SetTimeout(500, function()
			exports["sandbox-base"]:ClientCallback(inventory.id, "Vehicles:AdvLockpick", true, function(using, success)
				if using then
					local currentDurability = slot.metadata and slot.metadata.durability or 100
					local newDurability

					if success then
						newDurability = currentDurability - 15
					else
						newDurability = currentDurability - 40
					end

					if newDurability <= 0 then
						exports.ox_inventory:RemoveItem(inventory.id, item.name, 1, slot.metadata, slot.slot)
					else
						exports.ox_inventory:SetDurability(inventory.id, slot.slot, newDurability)
					end
				end
			end)
		end)
		return
	end
end)

exports('electronics_kit', function(event, item, inventory, slot, data)
	if event == 'usingItem' then
		Citizen.SetTimeout(500, function()
			exports["sandbox-base"]:ClientCallback(inventory.id, "Vehicles:Hack", true, function(using, success)
				if using then
					local currentDurability = slot.metadata and slot.metadata.durability or 100
					local newDurability

					if success then
						newDurability = currentDurability - 25
					else
						newDurability = currentDurability - 60
					end

					if newDurability <= 0 then
						exports.ox_inventory:RemoveItem(inventory.id, item.name, 1, slot.metadata, slot.slot)
					else
						exports.ox_inventory:SetDurability(inventory.id, slot.slot, newDurability)
					end
				end
			end)
		end)
		return
	end
end)

exports('adv_electronics_kit', function(event, item, inventory, slot, data)
	if event == 'usingItem' then
		Citizen.SetTimeout(500, function()
			exports["sandbox-base"]:ClientCallback(inventory.id, "Vehicles:AdvHack", true, function(using, success)
				if using then
					local currentDurability = slot.metadata and slot.metadata.durability or 100
					local newDurability

					if success then
						newDurability = currentDurability - 20
					else
						newDurability = currentDurability - 50
					end

					if newDurability <= 0 then
						exports.ox_inventory:RemoveItem(inventory.id, item.name, 1, slot.metadata, slot.slot)
					else
						exports.ox_inventory:SetDurability(inventory.id, slot.slot, newDurability)
					end
				end
			end)
		end)
		return
	end
end)

exports('screwdriver', function(event, item, inventory, slot, data)
	if event == 'usingItem' then
		Citizen.SetTimeout(1500, function()
			exports["sandbox-base"]:ClientCallback(inventory.id, "Vehicles:Lockpick", {
				{
					base = 4000,
					mod = 900,
				},
				{
					base = 3500,
					mod = 900,
				},
				false
			}, function(using, success)
				if using then
					local currentDurability = slot.metadata and slot.metadata.durability or 100
					local newDurability

					if success then
						newDurability = currentDurability - 30
					else
						newDurability = currentDurability - 70
					end

					if newDurability <= 0 then
						exports.ox_inventory:RemoveItem(inventory.id, item.name, 1, slot.metadata, slot.slot)
					else
						exports.ox_inventory:SetDurability(inventory.id, slot.slot, newDurability)
					end
				end
			end)
		end)
		return
	end
end)

exports('repairkit', function(event, item, inventory, slot, data)
	if event == 'usingItem' then
		exports["sandbox-base"]:ClientCallback(inventory.id, "Vehicles:RepairKit", false, function(success)
			if success then
				exports.ox_inventory:RemoveItem(inventory.id, item.name, 1, slot.metadata, slot.slot)
			end
		end)
		return
	end
end)

exports('repairkitadv', function(event, item, inventory, slot, data)
	if event == 'usingItem' then
		exports["sandbox-base"]:ClientCallback(inventory.id, "Vehicles:RepairKit", true, function(success)
			if success then
				exports.ox_inventory:RemoveItem(inventory.id, item.name, 1, slot.metadata, slot.slot)
			end
		end)
		return
	end
end)

exports('fakeplates', function(event, item, inventory, slot, data)
	if event == 'usingItem' then
		local currentMeta = item.metadata or {}
		if not currentMeta.Plate then -- Data needs generating
			local updatingMetaData = {}

			updatingMetaData.Plate = Vehicles.Identification.Plate:Generate(true)
			updatingMetaData.VIN = Vehicles.Identification.VIN:GenerateLocal()
			updatingMetaData.OwnerName = exports['sandbox-base']:GeneratorNameFirst() ..
				" " .. exports['sandbox-base']:GeneratorNameLast()
			updatingMetaData.SID = exports['sandbox-base']:SequenceGet("Character")
			updatingMetaData.Vehicle = exports['sandbox-vehicles']:RandomName()

			currentMeta = exports.ox_inventory:SetMetadata(inventory.id, slot.slot, updatingMetaData)
		end

		if not currentMeta.Vehicle then
			currentMeta.Vehicle = exports['sandbox-vehicles']:RandomName()

			exports.ox_inventory:SetMetadata(inventory.id, slot.slot, {
				Vehicle = currentMeta.Vehicle
			})
		end

		if currentMeta then
			exports["sandbox-base"]:ClientCallback(inventory.id, "Vehicles:GetFakePlateAddingVehicle", {}, function(veh)
				if not veh then
					return
				end
				veh = NetworkGetEntityFromNetworkId(veh)
				if veh and DoesEntityExist(veh) then
					local vehState = Entity(veh).state
					if not vehState.VIN then
						return
					end

					local vehicle = exports['sandbox-vehicles']:OwnedGetActive(vehState.VIN)
					if not vehicle then
						return
					end
					if not vehicle:GetData("FakePlate") then
						vehicle:SetData("FakePlate", currentMeta.Plate)
						vehicle:SetData("FakePlateData", currentMeta)

						SetVehicleNumberPlateText(veh, currentMeta.Plate)
						vehState.FakePlate = currentMeta.Plate

						exports['sandbox-vehicles']:OwnedForceSave(vehState.VIN)

						exports.ox_inventory:RemoveItem(inventory.id, item.name, 1, slot.metadata, slot.slot)

						exports['sandbox-hud']:NotifSuccess(inventory.id, "Fake Plate Installed")
					else
						exports['sandbox-hud']:NotifError(inventory.id,
							"A Fake Plate is Already Installed")
					end
				end
			end)
		end
		return
	end
end)

exports('carpolish', function(event, item, inventory, slot, data)
	if event == 'usingItem' then
		UseCarPolish(inventory.id, item, inventory, slot, 1)
		return
	end
end)

exports('carpolish_high', function(event, item, inventory, slot, data)
	if event == 'usingItem' then
		UseCarPolish(inventory.id, item, inventory, slot, 2)
		return
	end
end)

exports('carclean', function(event, item, inventory, slot, data)
	if event == 'usingItem' then
		TriggerClientEvent("Vehicles:Client:CleaningKit", inventory.id)
		return
	end
end)

exports('purgecontroller', function(event, item, inventory, slot, data)
	if event == 'usingItem' then
		UsePurgeColorController(inventory.id, item, inventory, slot)
		return
	end
end)

exports('car_bomb', function(event, item, inventory, slot, data)
	if event == 'usingItem' then
		exports["sandbox-base"]:ClientCallback(inventory.id, "Vehicles:UseCarBomb", {}, function(veh, reason, config)
			if not veh then
				if reason then
					exports['sandbox-hud']:NotifError(inventory.id, reason)
				end
				return
			end
			veh = NetworkGetEntityFromNetworkId(veh)
			if veh and DoesEntityExist(veh) then
				local char = exports['sandbox-characters']:FetchCharacterSource(inventory.id)
				if char then
					local vehState = Entity(veh).state
					if not vehState.VIN then
						return
					end

					if not vehState.CarBomb then
						vehState.CarBomb = {
							Speed = config.minSpeed,
							Removal = config.removalTime,
							ExplosionTicks = config.preExplosionTicks,
							InstalledBy = char:GetData("SID"),
						}

						exports.ox_inventory:RemoveItem(inventory.id, item.name, 1, slot.metadata, slot.slot)

						exports['sandbox-hud']:NotifSuccess(inventory.id, "Car Bomb Installed")
					else
						exports['sandbox-hud']:NotifError(inventory.id,
							"Vehicle Already Has Car Bomb")
					end
				else
					exports['sandbox-hud']:NotifError(inventory.id, "Error Installing Car Bomb")
				end
			end
		end)
		return
	end
end)

exports('harness', function(event, item, inventory, slot, data)
	if event == 'usingItem' then
		exports["sandbox-base"]:ClientCallback(inventory.id, "Vehicles:InstallHarness", {}, function(veh)
			if not veh then
				return
			end
			veh = NetworkGetEntityFromNetworkId(veh)
			if veh and DoesEntityExist(veh) then
				local vehState = Entity(veh).state
				if not vehState.VIN then
					return
				end

				local slotData = inventory.items[slot]
				if slotData then
					if exports.ox_inventory:RemoveItem(inventory.id, item.name, 1, slotData.metadata, slot) then
						vehState.Harness = 10
						exports['sandbox-hud']:NotifSuccess(inventory.id, "Harness Installed")
					end
				end
			end
		end)
		return
	end
end)

exports('nitrous', function(event, item, inventory, slot, data)
	if event == 'usingItem' then
		if item?.metadata?.Nitrous and item?.metadata?.Nitrous > 0 then
			exports["sandbox-base"]:ClientCallback(inventory.id, "Vehicles:InstallNitrous", {}, function(veh)
				if not veh then
					return
				end
				veh = NetworkGetEntityFromNetworkId(veh)
				if veh and DoesEntityExist(veh) then
					local vehState = Entity(veh).state
					if not vehState.VIN then
						return
					end

					if exports.ox_inventory:RemoveItem(inventory.id, item.name, 1, slot.metadata, slot.slot) then
						vehState.Nitrous = item.metadata.Nitrous + 0.0
						exports['sandbox-hud']:NotifSuccess(inventory.id,
							"Nitrous Oxide Installed")
					end
				end
			end)
		else
			exports['sandbox-hud']:NotifError(inventory.id, "The Bottle is Empty!")
			return false
		end
		return
	end
end)

local polishTypes = {
	{                          -- Normal Polish
		length = (60 * 60 * 24 * 7), -- Lasts for a week
		multiplier = 10.0,
	},
	{                           -- High Polish
		length = (60 * 60 * 24 * 14), -- Lasts for 2 weeks
		multiplier = 15.0,
	}
}

function UseCarPolish(source, item, inventory, slot, type)
	local typeData = polishTypes[type]
	if not typeData then return end

	exports["sandbox-base"]:ClientCallback(source, "Vehicles:UseCarPolish", {}, function(veh)
		if not veh then
			return
		end
		veh = NetworkGetEntityFromNetworkId(veh)
		if veh and DoesEntityExist(veh) then
			local vehState = Entity(veh).state
			if not vehState.VIN then
				return
			end

			if (not vehState.Polish) or (vehState.Polish?.Type ~= type) or (vehState.Polish?.Time and (os.time() - vehState.Polish?.Time) >= (60 * 60 * 24)) then
				vehState.Polish = {
					Type = type,
					Expires = os.time() + typeData.length,
					Time = os.time(),
					Mult = typeData.multiplier,
				}

				exports.ox_inventory:RemoveItem(inventory.id, item.name, 1, slot.metadata, slot.slot)

				exports['sandbox-hud']:NotifSuccess(source, "Polish Applied")
			else
				exports['sandbox-hud']:NotifError(source,
					"Vehicle Already Has That Polish and It Was Recently Installed")
			end
		end
	end)
end

function UsePurgeColorController(source, item, inventory, slot)
	exports["sandbox-base"]:ClientCallback(source, "Vehicles:UsePurgeColorController", {}, function(veh)
		if not veh then
			return
		end
		veh = NetworkGetEntityFromNetworkId(veh)
		if veh and DoesEntityExist(veh) then
			local vehState = Entity(veh).state
			if not vehState.VIN then
				return
			end

			exports["sandbox-base"]:ClientCallback(source, "Vehicles:UsePurgeColorControllerMenu",
				{ purgeColor = vehState?.PurgeColor, purgeLocation = vehState?.PurgeLocation }, function(retval)
					if retval then
						if retval.purgeColor then
							vehState.PurgeColor = {
								r = retval.purgeColor.r,
								g = retval.purgeColor.g,
								b = retval.purgeColor.b,
							}
						end
						if retval.purgeLocation then
							vehState.PurgeLocation = retval.purgeLocation
						end
						exports['sandbox-hud']:NotifSuccess(source, "Purge Changes Applied")
					else
						exports['sandbox-hud']:NotifError(source, "Changes were discarded")
					end
				end)
		end
	end)
end

RegisterNetEvent('Vehicles:Server:HarnessDamage', function()
	local src = source
	local veh = GetVehiclePedIsIn(GetPlayerPed(src), false)
	if DoesEntityExist(veh) then
		local vehState = Entity(veh)
		if vehState and vehState.state.VIN and vehState.state.Harness and vehState.state.Harness > 0 then
			vehState.state.Harness = vehState.state.Harness - 1
		end
	end
end)

RegisterNetEvent('Vehicles:Server:RemoveBomb', function(vNet)
	local veh = NetworkGetEntityFromNetworkId(vNet)
	if veh and DoesEntityExist(veh) then
		local vehState = Entity(veh)
		if vehState and vehState.state.VIN and vehState.state.CarBomb then
			vehState.state.CarBomb = false
		end
	end
end)

RegisterServerEvent('Vehicles:Server:NitrousUsage', function(vNet, used)
	local src = source
	local veh = NetworkGetEntityFromNetworkId(vNet)

	local ent = Entity(veh)
	if ent and ent.state and ent.state.Nitrous then
		ent.state.Nitrous = ent.state.Nitrous - used
		if ent.state.Nitrous < 0 then
			ent.state.Nitrous = 0.0
		end
	end
end)
