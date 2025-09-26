_effectCds = {
	meth = {},
	coke = {},
	adrenaline = {},
}

function RegisterItemUse()
	exports['sandbox-inventory']:RegisterUse("meth_table", "DrugShit", function(source, slot, itemData)
		exports["sandbox-base"]:ClientCallback(source, "Drugs:Meth:PlaceTable", slot.id, function() end)
	end)

	exports['sandbox-inventory']:RegisterUse("moonshine_still", "DrugShit", function(source, slot, itemData)
		exports["sandbox-base"]:ClientCallback(source, "Drugs:Moonshine:PlaceStill", slot.id, function() end)
	end)

	exports['sandbox-inventory']:RegisterUse("moonshine_barrel", "DrugShit", function(source, slot, itemData)
		exports["sandbox-base"]:ClientCallback(source, "Drugs:Moonshine:PlaceBarrel", slot.id, function() end)
	end)

	exports['sandbox-inventory']:RegisterUse("adrenaline", "DrugShit", function(source, slot, itemData)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if char ~= nil then
			if _effectCds.adrenaline[char:GetData("SID")] == nil or os.time() > _effectCds.adrenaline[char:GetData("SID")] then
				_effectCds.adrenaline[char:GetData("SID")] = os.time() + (60 * 1)
				if exports['sandbox-inventory']:RemoveSlot(slot.Owner, slot.Name, 1, slot.Slot, 1) then
					exports["sandbox-base"]:ClientCallback(source, "Drugs:Adrenaline:Use", 100, function(s)
						if s then
							TriggerClientEvent("Drugs:Effects:Armor", source, 100)
						end
					end)
				end
			else
				exports['sandbox-hud']:NotifError(source, "Cannot Use That Yet")
			end
		end
	end)

	exports['sandbox-inventory']:RegisterUse("meth_pipe", "DrugShit", function(source, slot, itemData)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if char ~= nil then
			if _effectCds.meth[char:GetData("SID")] == nil or os.time() > _effectCds.meth[char:GetData("SID")] then
				local methItem = exports['sandbox-inventory']:ItemsGetFirst(char:GetData("SID"), "meth_bag", 1)
				if methItem?.id ~= nil then
					_effectCds.meth[char:GetData("SID")] = os.time() + (60 * 1)
					if exports['sandbox-inventory']:RemoveId(char:GetData("SID"), 1, methItem) then
						exports["sandbox-base"]:ClientCallback(source, "Drugs:Meth:Use", methItem.Quality, function(s)
							if s then
								exports['sandbox-drugs']:AddictionAdd(source, "Meth", 0.25)
								local drugStates = char:GetData("DrugStates") or {}
								drugStates["meth"] = {
									item = "meth_bag",
									expires = os.time() + (60 * 60),
								}
								char:SetData("DrugStates", drugStates)
								TriggerClientEvent("Drugs:Effects:Armor", source, methItem.Quality)
							end
						end)
					end
				else
					exports['sandbox-hud']:NotifError(source, "You Need Meth To Smoke")
				end
			else
				exports['sandbox-hud']:NotifError(source, "Cannot Use That Yet")
			end
		end
	end)

	exports['sandbox-inventory']:RegisterUse("meth_brick", "DrugShit", function(source, slot, itemData)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if os.time() >= slot.MetaData.Finished then
			if exports['sandbox-inventory']:RemoveSlot(slot.Owner, slot.Name, 1, slot.Slot, slot.invType) then
				exports['sandbox-inventory']:AddItem(
					char:GetData("SID"),
					"meth_bag",
					10,
					{},
					1,
					false,
					false,
					false,
					false,
					false,
					false,
					slot.Quality
				)
			end
		else
			exports['sandbox-hud']:NotifError(source, "Not Ready Yet", 6000)
		end
	end)

	-- exports['sandbox-inventory']:RegisterUse("meth_bag", "DrugShit", function(source, slot, itemData)
	-- 	local plyr = exports['sandbox-base']:FetchSource(source)
	-- 	if plyr ~= nil then
	-- 		local char = plyr:GetData("Character")
	-- 		if char ~= nil then
	-- 			if _effectCds.meth[char:GetData("SID")] == nil or os.time() > _effectCds.meth[char:GetData("SID")] then
	-- 				_effectCds.meth[char:GetData("SID")] = os.time() + (60 * 1)
	-- 				if exports['sandbox-inventory']:RemoveSlot(slot.Owner, slot.Name, 1, slot.Slot, slot.invType) then
	-- 					exports["sandbox-base"]:ClientCallback(source, "Drugs:Meth:Use", slot.Quality, function(s)
	-- 						if s then
	-- 							exports['sandbox-drugs']:AddictionAdd(source, "Meth", 0.25)
	-- 							TriggerClientEvent("Drugs:Effects:Armor", source, slot.Quality)
	-- 						end
	-- 					end)
	-- 				end
	-- 			else
	-- 				exports['sandbox-hud']:NotifError(source, "Cannot Use That Yet")
	-- 			end
	-- 		end
	-- 	end
	-- end)

	exports['sandbox-inventory']:RegisterUse("coke_brick", "DrugShit", function(source, slot, itemData)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if exports['sandbox-inventory']:RemoveSlot(slot.Owner, slot.Name, 1, slot.Slot, slot.invType) then
			exports['sandbox-inventory']:AddItem(
				char:GetData("SID"),
				"coke_bag",
				10,
				{},
				1,
				false,
				false,
				false,
				false,
				false,
				false,
				slot.Quality
			)
		end
	end)

	exports['sandbox-inventory']:RegisterUse("coke_bag", "DrugShit", function(source, slot, itemData)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if char ~= nil then
			if _effectCds.coke[char:GetData("SID")] == nil or os.time() > _effectCds.coke[char:GetData("SID")] then
				_effectCds.coke[char:GetData("SID")] = os.time() + (60 * 3)
				if exports['sandbox-inventory']:RemoveSlot(slot.Owner, slot.Name, 1, slot.Slot, slot.invType) then
					exports["sandbox-base"]:ClientCallback(source, "Drugs:Coke:Use", slot.Quality, function(s)
						if s then
							exports['sandbox-drugs']:AddictionAdd(source, "Coke", 0.25)
							TriggerClientEvent("Drugs:Effects:RunSpeed", source, slot.Quality)
						end
					end)
				end
			else
				exports['sandbox-hud']:NotifError(source, "Cannot Use That Yet")
			end
		end
	end)

	exports['sandbox-inventory']:RegisterUse("moonshine", "DrugShit", function(source, slot, itemData)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if char ~= nil then
			if _effectCds.coke[char:GetData("SID")] == nil or os.time() > _effectCds.coke[char:GetData("SID")] then
				_effectCds.coke[char:GetData("SID")] = os.time() + (60 * 3)
				if exports['sandbox-inventory']:RemoveSlot(slot.Owner, slot.Name, 1, slot.Slot, slot.invType) then
					exports["sandbox-base"]:ClientCallback(source, "Drugs:Moonshine:Use", slot.Quality, function(s)
						if s then
							exports['sandbox-drugs']:AddictionAdd(source, "Moonshine", 0.25)
							local drugStates = char:GetData("DrugStates") or {}
							drugStates["moonshine"] = {
								item = "moonshine",
								expires = os.time() + (60 * 30),
							}
							char:SetData("DrugStates", drugStates)
							TriggerClientEvent("Drugs:Effects:Heal", source, slot.Quality)
						end
					end)
				end
			else
				exports['sandbox-hud']:NotifError(source, "Cannot Use That Yet")
			end
		end
	end)
end
