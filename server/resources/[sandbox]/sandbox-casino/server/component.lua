_casinoConfig = {}

_casinoConfigLoaded = false

AddEventHandler("Casino:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Casino = exports["sandbox-base"]:FetchComponent("Casino")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Casino", {
		"Casino",
	}, function(error)
		if #error > 0 then
			exports['sandbox-base']:LoggerCritical("Casino", "Failed To Load All Dependencies")
			return
		end
		RetrieveComponents()

		TriggerEvent("Casino:Server:Startup")

		if GetConvar("casino_open", "false") == "true" then
			GlobalState["CasinoOpen"] = true
		else
			GlobalState["CasinoOpen"] = false
		end

		exports["sandbox-base"]:RegisterServerCallback("Casino:OpenClose", function(source, data, cb)
			if Player(source).state.onDuty == "casino" and data.state ~= GlobalState["CasinoOpen"] then
				GlobalState["CasinoOpen"] = data.state

				if GlobalState["CasinoOpen"] then
					exports['sandbox-base']:ExecuteClient(source, "Notification", "Success", "Casino Opened")
				else
					exports['sandbox-base']:ExecuteClient(source, "Notification", "Error", "Casino Closed")
				end
			else
				exports['sandbox-base']:ExecuteClient(source, "Notification", "Error", "Error Opening/Closing Casino")
			end
		end)

		exports["sandbox-base"]:RegisterServerCallback("Casino:BuyChips", function(source, amount, cb)
			local char = exports['sandbox-characters']:FetchCharacterSource(source)
			if char and amount and amount > 0 then
				local amount = math.floor(amount)
				if exports['sandbox-finance']:WalletModify(source, -amount) then
					local total = Casino.Chips:Modify(source, amount)
					if total then
						SendCasinoPhoneNotification(
							source,
							string.format("Purchased $%s in Chips", formatNumberToCurrency(amount)),
							string.format("You now have a chip balance of $%s", formatNumberToCurrency(total))
						)

						return cb(true)
					end
				end
			end

			cb(false)
		end)

		exports["sandbox-base"]:RegisterServerCallback("Casino:SellChips", function(source, amount, cb)
			local char = exports['sandbox-characters']:FetchCharacterSource(source)
			if char and amount and amount > 0 then
				local amount = math.floor(amount)
				local chipTotal = Casino.Chips:Modify(source, -amount)
				if chipTotal then
					if exports['sandbox-finance']:WalletModify(source, amount) then
						SendCasinoPhoneNotification(
							source,
							string.format("Cashed Out $%s of Chips", formatNumberToCurrency(amount)),
							string.format("You now have a chip balance of $%s", formatNumberToCurrency(chipTotal))
						)

						return cb(true)
					end
				end
			end

			cb(false)
		end)

		exports["sandbox-base"]:RegisterServerCallback("Casino:PurchaseVIP", function(source, amount, cb)
			local char = exports['sandbox-characters']:FetchCharacterSource(source)
			if char then
				if exports['sandbox-finance']:WalletModify(source, -10000) then
					exports['sandbox-inventory']:AddItem(char:GetData("SID"), "diamond_vip", 1, {}, 1)
					GiveCasinoFuckingMoney(source, "VIP Card", 10000)
				else
					exports['sandbox-base']:ExecuteClient(source, "Notification", "Error", "Not Enough Cash")
				end
			end

			cb(true)
		end)

		exports["sandbox-base"]:RegisterServerCallback("Casino:GetBigWins", function(source, data, cb)
			if Player(source).state.onDuty == "casino" then
				exports['sandbox-base']:DatabaseGameFind({
					collection = "casino_bigwins",
					query = {},
				}, function(success, results)
					if success and #results > 0 then
						cb(results)
					else
						cb(false)
					end
				end)
			else
				cb(false)
			end
		end)

		exports["sandbox-chat"]:RegisterCommand("chips", function(source, args, rawCommand)
			local chipTotal = Casino.Chips:Get(source)

			SendCasinoPhoneNotification(
				source,
				"Current Chip Balance",
				string.format("Your current balance is $%s", formatNumberToCurrency(chipTotal))
			)
		end, {
			help = "Show Casino Chip Balance",
		})

		RunConfigStartup()
	end)
end)

local _configStartup = false
function RunConfigStartup()
	if not _configStartup then
		_configStartup = true

		exports['sandbox-base']:DatabaseGameFind({
			collection = "casino_config",
			query = {},
		}, function(success, results)
			if success and #results > 0 then
				for k, v in ipairs(results) do
					_casinoConfig[v.key] = v.data
				end
			end

			_casinoConfigLoaded = true
		end)
	end
end

_CASINO = {
	Chips = {
		Get = function(self, source)
			local char = exports['sandbox-characters']:FetchCharacterSource(source)
			if char then
				return char:GetData("CasinoChips") or 0
			end
			return 0
		end,
		Has = function(self, source, amount)
			local char = exports['sandbox-characters']:FetchCharacterSource(source)
			if char and amount > 0 then
				local currentChips = char:GetData("CasinoChips") or 0
				if currentChips >= amount then
					return true
				end
			end
			return false
		end,
		Modify = function(self, source, amount)
			local char = exports['sandbox-characters']:FetchCharacterSource(source)
			if char then
				local currentChips = char:GetData("CasinoChips") or 0
				local newChipBalance = math.floor(currentChips + amount)
				if newChipBalance >= 0 then
					char:SetData("CasinoChips", newChipBalance)
					return newChipBalance
				end
			end
			return false
		end,
	},
	Config = {
		Set = function(self, key, data)
			local p = promise.new()

			exports['sandbox-base']:DatabaseGameFindOneAndUpdate({
				collection = "casino_config",
				query = {
					key = key,
				},
				update = {
					["$set"] = {
						data = data,
					},
				},
				options = {
					returnDocument = "after",
					upsert = true,
				},
			}, function(success, results)
				if success and results then
					_casinoConfig[key] = data
					p:resolve(true)
				else
					p:resolve(false)
				end

				_casinoConfigLoaded = true
			end)

			local res = Citizen.Await(p)
			return res
		end,
		Get = function(self, key)
			return _casinoConfig[key]
		end,
	},
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Casino", _CASINO)
end)

function SendCasinoWonChipsPhoneNotification(source, amount)
	local chipTotal = Casino.Chips:Get(source)
	SendCasinoPhoneNotification(
		source,
		string.format("You Won $%s in Chips!", formatNumberToCurrency(amount)),
		string.format("Your balance is now $%s", formatNumberToCurrency(chipTotal))
	)
end

function SendCasinoSpentChipsPhoneNotification(source, amount)
	local chipTotal = Casino.Chips:Get(source)
	SendCasinoPhoneNotification(
		source,
		string.format("You Paid $%s in Chips!", formatNumberToCurrency(amount)),
		string.format("Your balance is now $%s", formatNumberToCurrency(chipTotal))
	)
end

function SendCasinoPhoneNotification(source, title, description, time)
	exports['sandbox-phone']:NotificationAdd(source, title, description, os.time(), time or 7500, {
		color = "#18191e",
		label = "Casino",
		icon = "cards",
	}, {}, nil)
end

function GiveCasinoFuckingMoney(source, game, amount)
	local charInfo = "Unknown"
	local char = exports['sandbox-characters']:FetchCharacterSource(source)
	if char then
		charInfo = string.format("%s %s [%s]", char:GetData("First"), char:GetData("Last"), char:GetData("SID"))
	end

	local f = exports['sandbox-finance']:AccountsGetOrganization("dgang")
	exports['sandbox-finance']:BalanceDeposit(f.Account, amount, {
		type = "deposit",
		title = game,
		description = string.format("%s Profit From %s", game, charInfo),
		data = {},
	}, true)

	if game == "Lucky Wheel" then
		amount = 100
		local f = exports['sandbox-finance']:AccountsGetOrganization("casino")
		exports['sandbox-finance']:BalanceDeposit(f.Account, amount, {
			type = "deposit",
			title = game,
			description = string.format("%s Profit From %s", game, charInfo),
			data = {},
		}, true)
	end
end
