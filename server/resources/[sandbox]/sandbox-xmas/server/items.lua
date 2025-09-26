function RegisterItems()
	exports['sandbox-inventory']:RegisterUse("present", "Xmas", function(source, item)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if char ~= nil then
			local sid = char:GetData("SID")
			exports['sandbox-inventory']:RemoveId(sid, 1, item)
			exports['sandbox-inventory']:LootCustomWeightedSetWithCountAndModifier(_xmasConfig.Loot.present, sid, 1, 1,
				false)
		end
	end)

	exports['sandbox-inventory']:RegisterUse("present_daily", "Xmas", function(source, item)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if char ~= nil then
			local sid = char:GetData("SID")
			exports['sandbox-inventory']:RemoveId(sid, 1, item)
			exports['sandbox-inventory']:LootCustomWeightedSetWithCountAndModifier(_xmasConfig.Loot.daily, sid, 1, 1,
				false)
		end
	end)
end
