exports("LootItemClass", function(owner, invType, class, count)
	return exports.ox_inventory:AddItem(owner, itemClasses[class][math.random(#itemClasses[class])], count, {},
		invType)
end)

exports("LootCustomSet", function(set, owner, invType, count)
	return exports.ox_inventory:AddItem(owner, set[math.random(#set)], count, {}, invType)
end)

exports("LootCustomSetWithCount", function(set, owner, invType)
	local i = set[math.random(#set)]
	return exports.ox_inventory:AddItem(owner, i.name, math.random(i.min or 0, i.max), {}, invType)
end)

-- Export for adding weighted set item
-- Pass a set array with the following layout
-- set = {
-- 	{chance_num, item_name },
-- }
exports("LootCustomWeightedSet", function(set, owner, invType)
	local randomItem = exports['sandbox-base']:UtilsWeightedRandom(set)
	if randomItem then
		return exports.ox_inventory:AddItem(owner, randomItem, 1, {}, invType)
	end
end)

-- Export for adding weighted set item with count
-- Pass a set array with the following layout
-- set = {
-- 	{chance_num, { name = item, max = max } },
-- }
exports("LootCustomWeightedSetWithCount", function(set, owner, invType, dontAdd)
	local randomItem = exports['sandbox-base']:UtilsWeightedRandom(set)
	if randomItem and randomItem.name and randomItem.max then
		if dontAdd then
			return {
				name = randomItem.name,
				count = math.random(randomItem.min or 1, randomItem.max)
			}
		else
			return exports.ox_inventory:AddItem(owner, randomItem.name,
				math.random(randomItem.min or 1, randomItem.max),
				randomItem.metadata or {}, invType)
		end
	end
end)

-- Export for adding weighted set item with count and modifier
-- Pass a set array with the following layout
-- set = {
-- 	{chance_num, { name = item, max = max } },
-- }
exports("LootCustomWeightedSetWithCountAndModifier", function(set, owner, invType, modifier, dontAdd)
	local randomItem = exports['sandbox-base']:UtilsWeightedRandom(set)
	if randomItem and randomItem.name and randomItem.max then
		if dontAdd then
			return {
				name = randomItem.name,
				count = math.random(randomItem.min or 1, randomItem.max) * modifier
			}
		else
			return exports.ox_inventory:AddItem(owner, randomItem.name,
				math.random(randomItem.min or 1, randomItem.max) * modifier, randomItem.metadata or {}, invType)
		end
	end
end)

exports("LootSetsGem", function(owner, invType)
	local randomGem = exports['sandbox-base']:UtilsWeightedRandom({
		{ 5,  "diamond" },
		{ 5,  "emerald" },
		{ 5,  "sapphire" },
		{ 5,  "ruby" },
		{ 25, "amethyst" },
		{ 25, "citrine" },
		{ 75, "opal" },
	})
	return exports.ox_inventory:AddItem(owner, randomGem, 1, {}, invType)
end)

exports("LootSetsGemRandom", function(owner, invType, day)
	local randomGem = nil
	if day == 1 then
		randomGem = exports['sandbox-base']:UtilsWeightedRandom({
			{ 15, "diamond" },
			{ 15, "emerald" },
			{ 20, "sapphire" },
			{ 20, "ruby" },
			{ 25, "amethyst" },
			{ 25, "citrine" },
			{ 50, "opal" },
		})
	else
		randomGem = exports['sandbox-base']:UtilsWeightedRandom({
			{ 5,  "diamond" },
			{ 5,  "emerald" },
			{ 5,  "sapphire" },
			{ 5,  "ruby" },
			{ 25, "amethyst" },
			{ 25, "citrine" },
			{ 75, "opal" },
		})
	end

	return exports.ox_inventory:AddItem(owner, randomGem, 1, {}, invType)
end)

exports("LootSetsOre", function(owner, invType, count)
	local randomOre = exports['sandbox-base']:UtilsWeightedRandom({
		{ 12, "goldore" },
		{ 18, "silverore" },
		{ 50, "ironore" },
	})
	return exports.ox_inventory:AddItem(owner, randomOre, count, {}, invType)
end)
