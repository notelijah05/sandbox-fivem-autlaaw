function RegisterItemUses()
	exports['sandbox-inventory']:RegisterUse("lockpick", "Vehicles", function(source, slot, itemData)
		Citizen.SetTimeout(500, function()
			exports["sandbox-base"]:ClientCallback(source, "Vehicles:Lockpick", true, function(using, success)
				if using then
					local newValue = slot.CreateDate - (60 * 60 * 24)
					if success then
						newValue = slot.CreateDate - (60 * 60 * 12)
					end
					if (os.time() - itemData.durability >= newValue) then
						exports['sandbox-inventory']:RemoveId(slot.Owner, slot.invType, slot)
					else
						exports['sandbox-inventory']:SetItemCreateDate(slot.id, newValue)
					end
				end
			end)
		end)
	end)

	exports['sandbox-inventory']:RegisterUse("adv_lockpick", "Vehicles", function(source, slot, itemData)
		Citizen.SetTimeout(500, function()
			exports["sandbox-base"]:ClientCallback(source, "Vehicles:AdvLockpick", true, function(using, success)
				if using then
					local newValue = slot.CreateDate - (60 * 60 * 24)
					if success then
						newValue = slot.CreateDate - (60 * 60 * 12)
					end
					if (os.time() - itemData.durability >= newValue) then
						exports['sandbox-inventory']:RemoveId(slot.Owner, slot.invType, slot)
					else
						exports['sandbox-inventory']:SetItemCreateDate(slot.id, newValue)
					end
				end
			end)
		end)
	end)

	exports['sandbox-inventory']:RegisterUse("electronics_kit", "Vehicles", function(source, slot, itemData)
		Citizen.SetTimeout(500, function()
			exports["sandbox-base"]:ClientCallback(source, "Vehicles:Hack", true, function(using, success)
				if using then
					local newValue = slot.CreateDate - (60 * 60 * 24)
					if success then
						newValue = slot.CreateDate - (60 * 60 * 12)
					end
					if (os.time() - itemData.durability >= newValue) then
						exports['sandbox-inventory']:RemoveId(slot.Owner, slot.invType, slot)
					else
						exports['sandbox-inventory']:SetItemCreateDate(slot.id, newValue)
					end
				end
			end)
		end)
	end)

	exports['sandbox-inventory']:RegisterUse("adv_electronics_kit", "Vehicles", function(source, slot, itemData)
		Citizen.SetTimeout(500, function()
			exports["sandbox-base"]:ClientCallback(source, "Vehicles:AdvHack", true, function(using, success)
				if using then
					local newValue = slot.CreateDate - (60 * 60 * 24)
					if success then
						newValue = slot.CreateDate - (60 * 60 * 12)
					end
					if (os.time() - itemData.durability >= newValue) then
						exports['sandbox-inventory']:RemoveId(slot.Owner, slot.invType, slot)
					else
						exports['sandbox-inventory']:SetItemCreateDate(slot.id, newValue)
					end
				end
			end)
		end)
	end)

	exports['sandbox-inventory']:RegisterUse("screwdriver", "Vehicles", function(source, slot, itemData)
		Citizen.SetTimeout(1500, function()
			exports["sandbox-base"]:ClientCallback(source, "Vehicles:Lockpick", {
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
					local newValue = slot.CreateDate - (60 * 60 * 24)
					if success then
						newValue = slot.CreateDate - (60 * 60 * 12)
					end
					if (os.time() - itemData.durability >= newValue) then
						exports['sandbox-inventory']:RemoveId(slot.Owner, slot.invType, slot)
					else
						exports['sandbox-inventory']:SetItemCreateDate(slot.id, newValue)
					end
				end
			end)
		end)
	end)

	exports['sandbox-inventory']:RegisterUse("repairkit", "Vehicles", function(source, itemData)
		exports["sandbox-base"]:ClientCallback(source, "Vehicles:RepairKit", false, function(success)
			if success then
				exports['sandbox-inventory']:RemoveSlot(itemData.Owner, itemData.Name, 1, itemData.Slot, itemData
					.invType)
			end
		end)
	end)

	exports['sandbox-inventory']:RegisterUse("repairkitadv", "Vehicles", function(source, itemData)
		exports["sandbox-base"]:ClientCallback(source, "Vehicles:RepairKit", true, function(success)
			if success then
				exports['sandbox-inventory']:RemoveSlot(itemData.Owner, itemData.Name, 1, itemData.Slot, itemData
					.invType)
			end
		end)
	end)

	exports['sandbox-inventory']:RegisterUse("fakeplates", "Vehicles", function(source, itemData)
		local currentMeta = itemData.MetaData or {}
		if not currentMeta.Plate then -- Data needs generating
			local updatingMetaData = {}

			updatingMetaData.Plate = Vehicles.Identification.Plate:Generate(true)
			updatingMetaData.VIN = Vehicles.Identification.VIN:GenerateLocal() -- Might not be completely unique but odds are low and idc
			updatingMetaData.OwnerName = Generator.Name:First() .. " " .. Generator.Name:Last()
			updatingMetaData.SID = exports['sandbox-base']:SequenceGet("Character")
			updatingMetaData.Vehicle = exports['sandbox-vehicles']:RandomName()

			currentMeta = exports['sandbox-inventory']:UpdateMetaData(itemData.id, updatingMetaData)
		end

		if not currentMeta.Vehicle then
			currentMeta.Vehicle = exports['sandbox-vehicles']:RandomName()

			exports['sandbox-inventory']:UpdateMetaData(iitemData.id, {
				Vehicle = currentMeta.Vehicle
			})
		end

		if currentMeta then
			exports["sandbox-base"]:ClientCallback(source, "Vehicles:GetFakePlateAddingVehicle", {}, function(veh)
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

						exports['sandbox-inventory']:RemoveSlot(itemData.Owner, itemData.Name, 1, itemData.Slot,
							itemData.invType)

						exports['sandbox-base']:ExecuteClient(source, "Notification", "Success", "Fake Plate Installed")
					else
						exports['sandbox-base']:ExecuteClient(source, "Notification", "Error",
							"A Fake Plate is Already Installed")
					end
				end
			end)
		end
	end)

	exports['sandbox-inventory']:RegisterUse("carpolish", "Vehicles", function(source, itemData)
		UseCarPolish(source, itemData, 1)
	end)

	exports['sandbox-inventory']:RegisterUse("carpolish_high", "Vehicles", function(source, itemData)
		UseCarPolish(source, itemData, 2)
	end)

	exports['sandbox-inventory']:RegisterUse("carclean", "Vehicles", function(source, itemData)
		TriggerClientEvent("Vehicles:Client:CleaningKit", source)
	end)

	exports['sandbox-inventory']:RegisterUse("purgecontroller", "Vehicles", function(source, itemData)
		UsePurgeColorController(source, itemData)
	end)

	exports['sandbox-inventory']:RegisterUse("car_bomb", "Vehicles", function(source, itemData)
		exports["sandbox-base"]:ClientCallback(source, "Vehicles:UseCarBomb", {}, function(veh, reason, config)
			if not veh then
				if reason then
					exports['sandbox-base']:ExecuteClient(source, "Notification", "Error", reason)
				end
				return
			end
			veh = NetworkGetEntityFromNetworkId(veh)
			if veh and DoesEntityExist(veh) then
				local char = exports['sandbox-characters']:FetchCharacterSource(source)
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

						exports['sandbox-inventory']:RemoveSlot(itemData.Owner, itemData.Name, 1, itemData.Slot,
							itemData.invType)

						exports['sandbox-base']:ExecuteClient(source, "Notification", "Success", "Car Bomb Installed")
					else
						exports['sandbox-base']:ExecuteClient(source, "Notification", "Error",
							"Vehicle Already Has Car Bomb")
					end
				else
					exports['sandbox-base']:ExecuteClient(source, "Notification", "Error", "Error Installing Car Bomb")
				end
			end
		end)
	end)

	exports['sandbox-inventory']:RegisterUse("harness", "Vehicles", function(source, itemData)
		exports["sandbox-base"]:ClientCallback(source, "Vehicles:InstallHarness", {}, function(veh)
			if not veh then
				return
			end
			veh = NetworkGetEntityFromNetworkId(veh)
			if veh and DoesEntityExist(veh) then
				local vehState = Entity(veh).state
				if not vehState.VIN then
					return
				end

				if exports['sandbox-inventory']:RemoveSlot(itemData.Owner, itemData.Name, 1, itemData.Slot, itemData.invType) then
					vehState.Harness = 10
					exports['sandbox-base']:ExecuteClient(source, "Notification", "Success", "Harness Installed")
				end
			end
		end)
	end)

	exports['sandbox-inventory']:RegisterUse("nitrous", "Vehicles", function(source, itemData)
		if itemData?.MetaData?.Nitrous and itemData?.MetaData?.Nitrous > 0 then
			exports["sandbox-base"]:ClientCallback(source, "Vehicles:InstallNitrous", {}, function(veh)
				if not veh then
					return
				end
				veh = NetworkGetEntityFromNetworkId(veh)
				if veh and DoesEntityExist(veh) then
					local vehState = Entity(veh).state
					if not vehState.VIN then
						return
					end

					if exports['sandbox-inventory']:RemoveId(itemData.Owner, itemData.invType, itemData) then
						vehState.Nitrous = itemData.MetaData.Nitrous + 0.0
						exports['sandbox-base']:ExecuteClient(source, "Notification", "Success",
							"Nitrous Oxide Installed")
					end
				end
			end)
		else
			exports['sandbox-base']:ExecuteClient(source, "Notification", "Error", "The Bottle is Empty!")
		end
	end)
end

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

function UseCarPolish(source, itemData, type)
	local typeData = polishTypes[type]
	if not type then return end

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
					Type = t,
					Expires = os.time() + typeData.length,
					Time = os.time(),
					Mult = typeData.multiplier,
				}

				exports['sandbox-inventory']:RemoveSlot(itemData.Owner, itemData.Name, 1, itemData.Slot, itemData
					.invType)

				exports['sandbox-base']:ExecuteClient(source, "Notification", "Success", "Polish Applied")
			else
				exports['sandbox-base']:ExecuteClient(source, "Notification", "Error",
					"Vehicle Already Has That Polish and It Was Recently Installed")
			end
		end
	end)
end

function UsePurgeColorController(source, itemData)
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
						exports['sandbox-base']:ExecuteClient(source, "Notification", "Success", "Purge Changes Applied")
					else
						exports['sandbox-base']:ExecuteClient(source, "Notification", "Error", "Changes were discarded")
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
