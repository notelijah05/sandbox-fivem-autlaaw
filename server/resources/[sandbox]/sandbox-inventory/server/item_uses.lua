local _partsTable = {
	{ 15, { name = "repair_part_electronics", min = 3, max = 5 } },
	{ 15, { name = "repair_part_axle", min = 3, max = 5 } },
	{ 15, { name = "repair_part_injectors", min = 3, max = 5 } },
	{ 15, { name = "repair_part_clutch", min = 3, max = 5 } },
	{ 15, { name = "repair_part_brakes", min = 3, max = 5 } },
	{ 15, { name = "repair_part_transmission", min = 3, max = 5 } },
	{ 10, { name = "repair_part_rad", min = 3, max = 5 } },
}

local _partsTableHG = {
	{ 20, { name = "repair_part_injectors_hg" } },
	{ 20, { name = "repair_part_clutch_hg" } },
	{ 20, { name = "repair_part_brakes_hg" } },
	{ 20, { name = "repair_part_transmission_hg" } },
	{ 20, { name = "repair_part_rad_hg" } },
}

local _materialsTable = {
	{ 19, { name = "electronic_parts", min = 20, max = 120 } },
	{ 19, { name = "plastic", min = 20, max = 120 } },
	{ 19, { name = "rubber", min = 20, max = 120 } },
	{ 19, { name = "copperwire", min = 50, max = 250 } },
	{ 19, { name = "glue", min = 10, max = 55 } },
	{ 5,  { name = "ironbar", min = 10, max = 50 } },
}

function RegisterRandomItems()
	exports.ox_inventory:RegisterUse("vanityitem", "VanityItems", function(source, item, itemData)
		if item?.MetaData?.CustomItemAction == "overlay" then
			TriggerClientEvent("Inventory:Client:UseVanityItem", source, source, item.MetaData.CustomItemAction, item)
		elseif item?.MetaData?.CustomItemAction == "overlayall" then
			TriggerClientEvent("Inventory:Client:UseVanityItem", -1, source, item.MetaData.CustomItemAction, item)
		end
	end)

	exports.ox_inventory:RegisterUse("cigarette", "RandomItems", function(source, item)
		exports.ox_inventory:RemoveSlot(item.Owner, item.Name, 1, item.Slot, item.invType)
		Player(source).state.stressTicks = { "3", "3", "3", "3", "3", "3", "3", "3" }
		TriggerClientEvent("Status:Client:Ticks:Stress", source)
	end)

	exports.ox_inventory:RegisterUse("buttplug_black", "ERP", function(source, item)
		TriggerClientEvent('Inventory:Client:ERP:ButtPlug', source, "black")
	end)

	exports.ox_inventory:RegisterUse("carvedpumpkin", "Misc", function(source, item)
		TriggerClientEvent('Inventory:Client:Halloween:Pumpkin', source, "pumpkin1")
	end)

	exports.ox_inventory:RegisterUse("sign_dontblock", "Signs", function(source, item)
		TriggerClientEvent('Inventory:Client:Signs:UseSign', source, item)
	end)

	exports.ox_inventory:RegisterUse("sign_leftturn", "Signs", function(source, item)
		TriggerClientEvent('Inventory:Client:Signs:UseSign', source, item)
	end)

	exports.ox_inventory:RegisterUse("sign_nopark", "Signs", function(source, item)
		TriggerClientEvent('Inventory:Client:Signs:UseSign', source, item)
	end)

	exports.ox_inventory:RegisterUse("sign_notresspass", "Signs", function(source, item)
		TriggerClientEvent('Inventory:Client:Signs:UseSign', source, item)
	end)

	exports.ox_inventory:RegisterUse("sign_rightturn", "Signs", function(source, item)
		TriggerClientEvent('Inventory:Client:Signs:UseSign', source, item)
	end)

	exports.ox_inventory:RegisterUse("sign_stop", "Signs", function(source, item)
		TriggerClientEvent('Inventory:Client:Signs:UseSign', source, item)
	end)

	exports.ox_inventory:RegisterUse("sign_uturn", "Signs", function(source, item)
		TriggerClientEvent('Inventory:Client:Signs:UseSign', source, item)
	end)

	exports.ox_inventory:RegisterUse("sign_walkingman", "Signs", function(source, item)
		TriggerClientEvent('Inventory:Client:Signs:UseSign', source, item)
	end)

	exports.ox_inventory:RegisterUse("sign_yield", "Signs", function(source, item)
		TriggerClientEvent('Inventory:Client:Signs:UseSign', source, item)
	end)

	exports.ox_inventory:RegisterUse("redlight", "RandomItems", function(source, item)
		TriggerClientEvent('Inventory:Client:RandomItems:Redlight', source)
	end)

	exports.ox_inventory:RegisterUse("buttplug_pink", "ERP", function(source, item)
		TriggerClientEvent('Inventory:Client:ERP:ButtPlug', source, "pink")
	end)

	exports.ox_inventory:RegisterUse("vibrator_pink", "ERP", function(source, item)
		TriggerClientEvent('Inventory:Client:ERP:Vibrator', source, "pink")
	end)

	exports.ox_inventory:RegisterUse("briefcase_cash", "RandomItems", function(source, item)
		exports['sandbox-hud']:NotifError(source, "No money to be found.")

		-- local Winnings = 25000
		-- local char = exports['sandbox-characters']:FetchCharacterSource(source)
		-- exports.ox_inventory:RemoveSlot(item.Owner, item.Name, 1, item.Slot, item.invType)
		-- TriggerClientEvent('Inventory:Client:RandomItems:BriefcaseCash', source)
		-- exports['sandbox-finance']:BalanceDeposit(exports['sandbox-finance']:AccountsGetPersonal(char:GetData("SID")).Account, Winnings, {
		-- 	type = "deposit",
		-- 	title = "Sandbox Lotto Event",
		-- 	description = string.format("Lotto Earnings - $%s", Winnings),
		-- 	data = Winnings
		-- })
		-- exports['sandbox-hud']:NotifSuccess(source, "You found a briefcase with $25,000!")
	end)

	exports.ox_inventory:RegisterUse("cigarette_pack", "RandomItems", function(source, item)
		if (item.MetaData.Count and tonumber(item.MetaData.Count) or 0) > 0 then
			exports.ox_inventory:AddItem(item.Owner, "cigarette", 1, {}, 1)
			if tonumber(item.MetaData.Count) - 1 <= 0 then
				exports.ox_inventory:RemoveSlot(item.Owner, item.Name, 1, item.Slot, item.invType)
			else
				exports.ox_inventory:SetMetaDataKey(item.id, "Count", tonumber(item.MetaData.Count) - 1, source)
			end
		else
			exports.ox_inventory:RemoveSlot(item.Owner, item.Name, 1, item.Slot, item.invType)
			exports['sandbox-hud']:NotifError(source, "Pack Has No More Cigarettes In It")
		end
	end)

	exports.ox_inventory:RegisterUse("rusty_strawsprinkbox", "RustyBrowns", function(source, item)
		if (item.MetaData.Count and tonumber(item.MetaData.Count) or 0) > 0 then
			exports.ox_inventory:AddItem(item.Owner, "rusty_strawsprinkle", 1, {}, 1)
			if tonumber(item.MetaData.Count) - 1 <= 0 then
				exports.ox_inventory:RemoveSlot(item.Owner, item.Name, 1, item.Slot, item.invType)
			else
				exports.ox_inventory:SetMetaDataKey(item.id, "Count", tonumber(item.MetaData.Count) - 1, source)
			end
		else
			exports.ox_inventory:RemoveSlot(item.Owner, item.Name, 1, item.Slot, item.invType)
			exports['sandbox-hud']:NotifError(source, "Box Has No More Donuts In It")
		end
	end)

	exports.ox_inventory:RegisterUse("rusty_ringmixbox", "RustyBrowns", function(source, item)
		local _mixedDonuts = {
			[1] = {
				name = 'rusty_blueice'
			},
			[2] = {
				name = 'rusty_lemon'
			},
			[3] = {
				name = 'rusty_cookiecream'
			},
			[4] = {
				name = 'rusty_strawsprinkle'
			},
			[5] = {
				name = 'rusty_chocsprinkle'
			},
			[6] = {
				name = 'rusty_ring'
			},
		}
		if (item.MetaData.Count and tonumber(item.MetaData.Count) or 0) > 0 then
			exports.ox_inventory:AddItem(item.Owner, _mixedDonuts[math.random(#_mixedDonuts)].name, 1, {}, 1)
			if tonumber(item.MetaData.Count) - 1 <= 0 then
				exports.ox_inventory:RemoveSlot(item.Owner, item.Name, 1, item.Slot, item.invType)
			else
				exports.ox_inventory:SetMetaDataKey(item.id, "Count", tonumber(item.MetaData.Count) - 1, source)
			end
		else
			exports.ox_inventory:RemoveSlot(item.Owner, item.Name, 1, item.Slot, item.invType)
			exports['sandbox-hud']:NotifError(source, "Box Has No More Donuts In It")
		end
	end)

	exports.ox_inventory:RegisterUse("rusty_ringbox", "RustyBrowns", function(source, item)
		local _mixedDonuts = {
			[1] = {
				name = 'rusty_blueice'
			},
			[2] = {
				name = 'rusty_lemon'
			},
			[3] = {
				name = 'rusty_cookiecream'
			},
			[4] = {
				name = 'rusty_strawsprinkle'
			},
			[5] = {
				name = 'rusty_chocsprinkle'
			},
			[6] = {
				name = 'rusty_ring'
			},
			[7] = {
				name = 'rusty_chocstuff'
			},
			[8] = {
				name = 'rusty_custard'
			},
		}
		if (item.MetaData.Count and tonumber(item.MetaData.Count) or 0) > 0 then
			exports.ox_inventory:AddItem(item.Owner, _mixedDonuts[math.random(#_mixedDonuts)].name, 1, {}, 1)
			if tonumber(item.MetaData.Count) - 1 <= 0 then
				exports.ox_inventory:RemoveSlot(item.Owner, item.Name, 1, item.Slot, item.invType)
			else
				exports.ox_inventory:SetMetaDataKey(item.id, "Count", tonumber(item.MetaData.Count) - 1, source)
			end
		else
			exports.ox_inventory:RemoveSlot(item.Owner, item.Name, 1, item.Slot, item.invType)
			exports['sandbox-hud']:NotifError(source, "Box Has No More Donuts In It")
		end
	end)

	exports.ox_inventory:RegisterUse("rusty_pd", "RustyBrowns", function(source, item)
		local _mixedDonuts = {
			[1] = {
				name = 'rusty_strawsprinkle'
			},
			[2] = {
				name = 'rusty_chocsprinkle'
			},
			[3] = {
				name = 'rusty_ring'
			},
		}
		if (item.MetaData.Count and tonumber(item.MetaData.Count) or 0) > 0 then
			exports.ox_inventory:AddItem(item.Owner, _mixedDonuts[math.random(#_mixedDonuts)].name, 1, {}, 1)
			if tonumber(item.MetaData.Count) - 1 <= 0 then
				exports.ox_inventory:RemoveSlot(item.Owner, item.Name, 1, item.Slot, item.invType)
			else
				exports.ox_inventory:SetMetaDataKey(item.id, "Count", tonumber(item.MetaData.Count) - 1, source)
			end
		else
			exports.ox_inventory:RemoveSlot(item.Owner, item.Name, 1, item.Slot, item.invType)
			exports['sandbox-hud']:NotifError(source, "Box Has No More Donuts In It")
		end
	end)

	exports.ox_inventory:RegisterUse("armor", "RandomItems", function(source, item)
		exports.ox_inventory:RemoveSlot(item.Owner, item.Name, 1, item.Slot, item.invType)
		SetPedArmour(GetPlayerPed(source), 50)
	end)

	exports.ox_inventory:RegisterUse("heavyarmor", "RandomItems", function(source, item)
		exports.ox_inventory:RemoveSlot(item.Owner, item.Name, 1, item.Slot, item.invType)
		SetPedArmour(GetPlayerPed(source), 100)
	end)

	exports.ox_inventory:RegisterUse("pdarmor", "RandomItems", function(source, item)
		exports.ox_inventory:RemoveSlot(item.Owner, item.Name, 1, item.Slot, item.invType)
		SetPedArmour(GetPlayerPed(source), 100)
	end)

	exports.ox_inventory:RegisterUse("parts_box", "RandomItems", function(source, item)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if char ~= nil then
			exports.ox_inventory:RemoveSlot(item.Owner, item.Name, 1, item.Slot, item.invType)
			if item.MetaData.Items then
				for k, v in ipairs(item.MetaData.Items) do
					exports.ox_inventory:AddItem(item.Owner, v.name, v.count, {}, 1)
				end
			end
		end
	end)

	exports.ox_inventory:RegisterUse("birthday_cake", "RandomItems", function(source, item)
		exports.ox_inventory:RemoveSlot(item.Owner, item.Name, 1, item.Slot, item.invType)
		TriggerClientEvent('Inventory:Client:RandomItems:BirthdayCake', source)
	end)

	exports.ox_inventory:RegisterUse("parachute", "RandomItems", function(source, item)
		exports["sandbox-base"]:ClientCallback(source, "Weapons:CanEquipParachute", {}, function(canEquip)
			if canEquip then
				local char = exports['sandbox-characters']:FetchCharacterSource(source)
				if char then
					local states = char:GetData("States") or {}
					if not hasValue(states, "SCRIPT_PARACHUTE") then
						exports.ox_inventory:RemoveSlot(item.Owner, item.Name, 1, item.Slot, item.invType)

						table.insert(states, "SCRIPT_PARACHUTE")
						char:SetData("States", states)
					else
						exports['sandbox-hud']:NotifError(source,
							"Already Have Parachute Equipped")
					end
				end
			else
				exports['sandbox-hud']:NotifError(source, "Cannot Equip Parachute")
			end
		end)
	end)

	exports.ox_inventory:RegisterUse("shark_card", "RandomShit", function(source, item)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if char ~= nil then
			local sid = char:GetData("SID")
			local f = exports['sandbox-finance']:AccountsGetPersonal(sid)
			if f ~= nil then
				if exports.ox_inventory:RemoveId(sid, 1, item) then
					local amt = item.MetaData.Amount
					if item.MetaData.CustomAmt ~= nil then
						amt = (item.MetaData.CustomAmt.Min or 0) + math.random(item.MetaData.CustomAmt.Random)
					end

					exports['sandbox-finance']:BalanceDeposit(f.Account, amt, {
						type = "deposit",
						title = "Shark Card",
						description = "balance Redemption From A Shark Card",
						data = {},
					}, false)
				end
			end
		end
	end)

	exports["sandbox-base"]:RegisterServerCallback("Inventory:UsedParachute", function(source, data, cb)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if char then
			local states = char:GetData("States") or {}
			if hasValue(states, "SCRIPT_PARACHUTE") then
				for k, v in ipairs(states) do
					if v == "SCRIPT_PARACHUTE" then
						table.remove(states, k)
						char:SetData("States", states)
						break
					end
				end
			end
		end
	end)
end
