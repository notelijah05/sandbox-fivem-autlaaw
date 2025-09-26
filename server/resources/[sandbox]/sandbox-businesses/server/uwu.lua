local _uwuPrizes = {
	{ 100,  "uwu_prize_b8" }, -- blue bear
	{ 1400, "uwu_prize_b2" }, -- orange bear
	{ 1,    "uwu_prize_b10" }, -- snow bear
	{ 1300, "uwu_prize_b3" }, -- red bear
	{ 800,  "uwu_prize_b5" }, -- pink bear
	{ 700,  "uwu_prize_b6" }, -- yellow bear
	{ 10,   "uwu_prize_b9" }, -- grey bear
	{ 1000, "uwu_prize_b4" }, -- green bear
	{ 1600, "uwu_prize_b1" }, -- brown bear
	{ 200,  "uwu_prize_b7" }, -- moon pink bear
}

AddEventHandler("Businesses:Server:Startup", function()
	exports['sandbox-inventory']:RegisterUse("uwu_prize_box", "Businesses", function(source, item)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if exports['sandbox-inventory']:ItemsHas(char:GetData("SID"), 1, "uwu_prize_box", 1) then
			if exports['sandbox-inventory']:RemoveSlot(item.Owner, "uwu_prize_box", 1, item.Slot, 1) then
				local prize = exports['sandbox-base']:UtilsWeightedRandom(_uwuPrizes)
				exports['sandbox-inventory']:AddItem(char:GetData("SID"), prize, 1, {}, 1)
			end
		end
	end)

	exports['sandbox-inventory']:RegisterUse("uwu_prize_b1", "Businesses", function(source, item)
		TriggerClientEvent("Inventory:Client:Collectables:UseItem", source, item.Name)
	end)

	exports['sandbox-inventory']:RegisterUse("uwu_prize_b2", "Businesses", function(source, item)
		TriggerClientEvent("Inventory:Client:Collectables:UseItem", source, item.Name)
	end)

	exports['sandbox-inventory']:RegisterUse("uwu_prize_b3", "Businesses", function(source, item)
		TriggerClientEvent("Inventory:Client:Collectables:UseItem", source, item.Name)
	end)

	exports['sandbox-inventory']:RegisterUse("uwu_prize_b4", "Businesses", function(source, item)
		TriggerClientEvent("Inventory:Client:Collectables:UseItem", source, item.Name)
	end)

	exports['sandbox-inventory']:RegisterUse("uwu_prize_b5", "Businesses", function(source, item)
		TriggerClientEvent("Inventory:Client:Collectables:UseItem", source, item.Name)
	end)

	exports['sandbox-inventory']:RegisterUse("uwu_prize_b6", "Businesses", function(source, item)
		TriggerClientEvent("Inventory:Client:Collectables:UseItem", source, item.Name)
	end)

	exports['sandbox-inventory']:RegisterUse("uwu_prize_b7", "Businesses", function(source, item)
		TriggerClientEvent("Inventory:Client:Collectables:UseItem", source, item.Name)
	end)

	exports['sandbox-inventory']:RegisterUse("uwu_prize_b8", "Businesses", function(source, item)
		TriggerClientEvent("Inventory:Client:Collectables:UseItem", source, item.Name)
	end)

	exports['sandbox-inventory']:RegisterUse("uwu_prize_b9", "Businesses", function(source, item)
		TriggerClientEvent("Inventory:Client:Collectables:UseItem", source, item.Name)
	end)

	exports['sandbox-inventory']:RegisterUse("uwu_prize_b10", "Businesses", function(source, item)
		TriggerClientEvent("Inventory:Client:Collectables:UseItem", source, item.Name)
	end)

	exports["sandbox-base"]:RegisterServerCallback("Businesses:Server:PetCat", function(source, data, cb)
		if source == nil then
			return
		end
		local _source = source
		if data.entity ~= 0 and data.entity ~= nil then
			exports['sandbox-status']:Remove(_source, "PLAYER_STRESS", math.random(3))
			cb(true)
		else
			cb(false)
		end
	end)
end)
