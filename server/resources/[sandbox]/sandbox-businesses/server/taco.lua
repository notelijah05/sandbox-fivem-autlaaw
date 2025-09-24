local _currentCookItem = nil
local _deliveryCounter = 0
local _itemCount = 1
local _dropOffItem = "taco_bag"
local _maxRolls = 10
local _maxBands = 3

AddEventHandler("Businesses:Server:Startup", function()
	-- Init cook stuff
	_currentCookItem = math.random(#_tacoFoodItems)
	GlobalState["TacoShop:Counter"] = _deliveryCounter
	GlobalState["TacoShop:CurrentItem"] = _currentCookItem
	TriggerClientEvent("Taco:SetQueue", -1, { counter = _deliveryCounter, item = _currentCookItem })

	-- Create storage
	if _tacoConfig.storage then
		for _, storage in pairs(_tacoConfig.storage) do
			exports['sandbox-inventory']:PolyCreate(storage)
		end
	end

	Reputation:Create("TacoDelivery", "Taco Delivery", {
		{ label = "Rank 1",   value = 500 },
		{ label = "Rank 2",   value = 1000 },
		{ label = "Rank 3",   value = 2500 },
		{ label = "Rank 4",   value = 4000 },
		{ label = "Rank 5",   value = 5000 },
		{ label = "Pls Stop", value = 7500 },
	}, false) -- hidden rep

	Reputation:Create("TacoCrafter", "Taco Artist", {
		{ label = "Rank 1",   value = 500 },
		{ label = "Rank 2",   value = 1000 },
		{ label = "Rank 3",   value = 2500 },
		{ label = "Rank 4",   value = 4000 },
		{ label = "Rank 5",   value = 5000 },
		{ label = "Pls Stop", value = 7500 },
	}, false) -- hidden rep

	exports['sandbox-inventory']:CraftingRegisterBench("TacoShopFood", "Taco Farmer Prep Table", {
		actionString = "Packaging",
		icon = "taco",
		poly = {
			coords = vector3(9.81, -1600.51, 29.38),
			w = 1.8,
			l = 0.8,
			options = {
				name = "TacoShopFood",
				heading = 320,
				--debugPoly=true,
				minZ = 26.18,
				maxZ = 30.18,
			},
		},
	}, {}, {
		shared = true,
	}, {
		{
			result = { name = "beef_taco", count = 4 },
			items = {
				{ name = "taco_cheese",   count = 2 },
				{ name = "taco_beef",     count = 2 },
				{ name = "taco_tortilla", count = 4 },
			},
			time = 3000,
			animation = "mechanic",
		},
		{
			result = { name = "tostada", count = 4 },
			items = {
				{ name = "taco_cheese",   count = 2 },
				{ name = "taco_beef",     count = 2 },
				{ name = "taco_tortilla", count = 4 },
			},
			time = 3000,
			animation = "mechanic",
		},
		{
			result = { name = "quesadilla", count = 4 },
			items = {
				{ name = "taco_cheese",   count = 2 },
				{ name = "taco_chicken",  count = 2 },
				{ name = "taco_tortilla", count = 4 },
			},
			time = 3000,
			animation = "mechanic",
		},
		{
			result = { name = "burrito", count = 4 },
			items = {
				{ name = "taco_cheese",   count = 2 },
				{ name = "taco_chicken",  count = 2 },
				{ name = "taco_tortilla", count = 4 },
			},
			time = 3000,
			animation = "mechanic",
		},
		{
			result = { name = "enchilada", count = 4 },
			items = {
				{ name = "taco_cheese",   count = 2 },
				{ name = "taco_beef",     count = 2 },
				{ name = "taco_tortilla", count = 4 },
			},
			time = 3000,
			animation = "mechanic",
		},
		{
			result = { name = "carne_asada", count = 4 },
			items = {
				{ name = "taco_cheese", count = 2 },
				{ name = "taco_steak",  count = 4 },
			},
			time = 3000,
			animation = "mechanic",
		},
		{
			result = { name = "torta", count = 4 },
			items = {
				{ name = "taco_cheese",  count = 2 },
				{ name = "taco_chicken", count = 2 },
				{ name = "torta_roll",   count = 4 },
			},
			time = 3000,
			animation = "mechanic",
		},
	})

	exports['sandbox-inventory']:CraftingRegisterBench("TacoShopDrinks", "Taco Farmer Fountain Drinks", {
		actionString = "Pouring",
		icon = "glass",
		poly = {
			coords = vector3(7.5, -1606.48, 29.38),
			w = 0.8,
			l = 1.8,
			options = {
				name = "TacoShopDrinks",
				heading = 320,
				--debugPoly=true,
				minZ = 29.18,
				maxZ = 30.58,
			},
		},
	}, {}, {
		shared = true,
	}, {
		{
			result = { name = "jugo", count = 4 },
			items = {
				{ name = "taco_plastic_cups", count = 4 },
			},
			time = 2000,
			animation = "mechanic",
		},
		{
			result = { name = "taco_soda", count = 4 },
			items = {
				{ name = "taco_plastic_cups", count = 4 },
			},
			time = 2000,
			animation = "mechanic",
		},
	})

	exports["sandbox-base"]:RegisterServerCallback("Taco:GetNewQueueItem", function(source, data, cb)
		_currentCookItem = math.random(#_tacoFoodItems)
		GlobalState["TacoShop:Counter"] = _deliveryCounter
		GlobalState["TacoShop:CurrentItem"] = _currentCookItem
		TriggerClientEvent("Taco:SetQueue", -1, { counter = _deliveryCounter, item = _currentCookItem })
		cb(true)
	end)

	exports["sandbox-base"]:RegisterServerCallback("Taco:SetState", function(source, data, cb)
		TriggerClientEvent("Taco:PickupState", -1, data)
		cb(true)
	end)

	exports["sandbox-base"]:RegisterServerCallback("Tacos:AddToQueue", function(source, data, cb)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if char then
			local count = exports['sandbox-inventory']:ItemsGetCount(char:GetData("SID"), 1, data.item) or 0
			if count > 0 then
				local itemData = exports['sandbox-inventory']:ItemsGetData(data.item)

				if itemData and exports['sandbox-inventory']:Remove(char:GetData("SID"), 1, data.item, _itemCount) then
					_deliveryCounter = _deliveryCounter + 1
					if _deliveryCounter > _tacoQueue.maxQueue then
						_deliveryCounter = _tacoQueue.maxQueue
					end

					local _tacoArtistCash = math.random(15, 30)
					local repLevel = Reputation:GetLevel(source, "TacoCrafter") or 0
					if repLevel > 0 then
						_tacoArtistCash = math.floor(_tacoArtistCash * repLevel)
					end
					exports['sandbox-finance']:WalletModify(source, _tacoArtistCash)
					Reputation.Modify:Add(source, "TacoCrafter", 1)

					cb(true)
				end
			else
				cb(false)
			end
		end
	end)

	exports["sandbox-base"]:RegisterServerCallback("Tacos:Pickup", function(source, data, cb)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if char then
			_deliveryCounter = _deliveryCounter - 1
			if _deliveryCounter < 0 then
				_deliveryCounter = 0
			end
			exports['sandbox-inventory']:AddItem(char:GetData("SID"), _dropOffItem, 1, {}, 1)
			GlobalState["TacoShop:Counter"] = _deliveryCounter
			GlobalState["TacoShop:CurrentItem"] = _currentCookItem
			TriggerClientEvent("Taco:SetQueue", -1, { counter = _deliveryCounter, item = _currentCookItem })
			cb(true)
		end
	end)

	exports["sandbox-base"]:RegisterServerCallback("Tacos:Dropoff", function(source, data, cb)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if char then
			local count = exports['sandbox-inventory']:ItemsGetCount(char:GetData("SID"), 1, _dropOffItem) or 0
			if count > 0 then
				local itemData = exports['sandbox-inventory']:ItemsGetData(_dropOffItem)

				if itemData and exports['sandbox-inventory']:Remove(char:GetData("SID"), 1, _dropOffItem, _itemCount) then
					local repLevel = Reputation:GetLevel(source, "TacoDelivery") or 0
					local repGained = 1
					local _tacoDeliveryCash = math.random(15, 30)
					if repLevel > 0 then
						_tacoDeliveryCash = math.floor(_tacoDeliveryCash * repLevel)
					end

					if exports['sandbox-inventory']:ItemsHas(char:GetData("SID"), 1, "moneyroll", 1) then
						local _moneyRollCount = exports['sandbox-inventory']:ItemsGetCount(char:GetData("SID"), 1,
							"moneyroll")
						local itemDataMoneyRoll = exports['sandbox-inventory']:ItemsGetData("moneyroll")
						if _moneyRollCount >= _maxRolls then
							if
								itemDataMoneyRoll
								and exports['sandbox-inventory']:Remove(char:GetData("SID"), 1, "moneyroll", _maxRolls)
							then
								local _moneyRollOutput = math.floor(
									((_tacoConfig.tacoPricing[repLevel] / 100) * itemDataMoneyRoll.price) * _maxRolls
								)
								_tacoDeliveryCash = _tacoDeliveryCash + _moneyRollOutput
								repGained = repGained + math.random(3)
							end
						end
					elseif exports['sandbox-inventory']:ItemsHas(char:GetData("SID"), 1, "moneyband", 1) then
						local _moneyBandCount = exports['sandbox-inventory']:ItemsGetCount(char:GetData("SID"), 1,
							"moneyband")
						local itemDataMoneyBand = exports['sandbox-inventory']:ItemsGetData("moneyband")
						if _moneyBandCount >= _maxBands then
							if
								itemDataMoneyBand
								and exports['sandbox-inventory']:Remove(char:GetData("SID"), 1, "moneyband", _maxBands)
							then
								local _moneyBandOutput = math.floor(
									((_tacoConfig.tacoPricing[repLevel] / 100) * itemDataMoneyBand.price) * _maxBands
								)
								_tacoDeliveryCash = _tacoDeliveryCash + _moneyBandOutput
								repGained = repGained + math.random(3)
							end
						end
					end

					exports['sandbox-finance']:WalletModify(source, _tacoDeliveryCash)
					Reputation.Modify:Add(source, "TacoDelivery", repGained)

					cb(true)
				end
			else
				cb(false)
			end
		end
	end)
end)
