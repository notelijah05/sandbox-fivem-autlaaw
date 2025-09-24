_cryptoCoins = {}

AddEventHandler("Crypto:Shared:DependencyUpdate", RetrieveCryptoComponents)
function RetrieveCryptoComponents()
	Generator = exports["sandbox-base"]:FetchComponent("Generator")
	Jobs = exports["sandbox-base"]:FetchComponent("Jobs")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Crypto", {
		"Generator",
		"Jobs",
	}, function(error)
		if #error > 0 then
			exports['sandbox-base']:LoggerCritical("Crypto", "Failed To Load All Dependencies")
			return
		end
		RetrieveCryptoComponents()
	end)
end)

exports("CryptoCoinCreate", function(name, acronym, price, buyable, sellable)
	while Crypto == nil do
		Wait(1)
	end

	if not exports['sandbox-finance']:CryptoCoinGet(acronym) then
		table.insert(_cryptoCoins, {
			Name = name,
			Short = acronym,
			Price = price,
			Buyable = buyable,
			Sellable = sellable,
		})
	else
		for k, v in ipairs(_cryptoCoins) do
			if v.Short == acronym then
				_cryptoCoins[k] = {
					Name = name,
					Short = acronym,
					Price = price,
					Buyable = buyable,
					Sellable = sellable,
				}
				return
			end
		end
	end
end)

exports("CryptoCoinGet", function(acronym)
	for k, v in ipairs(_cryptoCoins) do
		if v.Short == acronym then
			return v
		end
	end

	return nil
end)

exports("CryptoCoinGetAll", function()
	return _cryptoCoins
end)

exports("CryptoHas", function(source, coin, amt)
	local char = exports['sandbox-characters']:FetchCharacterSource(source)
	if char ~= nil then
		local crypto = char:GetData("Crypto") or {}
		return crypto[coin] ~= nil and crypto[coin] >= amt
	else
		return false
	end
end)

exports("CryptoExchangeIsListed", function(coin)
	for k, v in ipairs(_cryptoCoins) do
		if v.Short == coin then
			return true
		end
	end
	return false
end)

exports("CryptoExchangeBuy", function(coin, target, amount)
	if exports['sandbox-finance']:CryptoExchangeIsListed(coin) then
		local char = exports['sandbox-characters']:FetchBySID(target)
		if char ~= nil then
			local acc = exports['sandbox-finance']:AccountsGetPersonal(char:GetData("SID"))
			local coinData = exports['sandbox-finance']:CryptoCoinGet(coin)
			if acc.Balance >= (coinData.Price * amount) then
				if
					exports['sandbox-finance']:BalanceWithdraw(acc.Account, (coinData.Price * amount), {
						type = "withdraw",
						title = "Crypto Purchase",
						description = string.format("Bought %s $%s", amount, coin),
						transactionAccount = false,
						data = {
							character = char:GetData("SID"),
						},
					})
				then
					exports['sandbox-phone']:NotificationAdd(
						char:GetData("Source"),
						"Crypto Purchase",
						string.format("You Bought %s $%s", amount, coin),
						os.time(),
						6000,
						"crypto",
						{}
					)
					return exports['sandbox-finance']:CryptoExchangeAdd(coin, char:GetData("CryptoWallet"), amount)
				else
					return false
				end
			else
				exports['sandbox-phone']:NotificationAdd(
					char:GetData("Source"),
					"Crypto Purchase",
					"Insufficient Funds",
					os.time(),
					6000,
					"crypto",
					{}
				)
				return false
			end
		else
			return false
		end
	else
		return false
	end
end)

exports("CryptoExchangeSell", function(coin, target, amount)
	if exports['sandbox-finance']:CryptoExchangeIsListed(coin) then
		local char = exports['sandbox-characters']:FetchBySID(target)
		if char ~= nil then
			local acc = exports['sandbox-finance']:AccountsGetPersonal(char:GetData("SID"))
			local coinData = exports['sandbox-finance']:CryptoCoinGet(coin)

			if coinData.Sellable then
				if exports['sandbox-finance']:CryptoExchangeRemove(coin, char:GetData("CryptoWallet"), amount, true) then
					return exports['sandbox-finance']:BalanceDeposit(acc.Account, (coinData.Sellable * amount), {
						type = "deposit",
						title = "Crypto Sale",
						description = string.format("Sold %s $%s", amount, coin),
						transactionAccount = false,
						data = {
							character = char:GetData("SID"),
						},
					})
				else
					return false
				end
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
end)

exports("CryptoExchangeAdd", function(coin, target, amount, skipAlert)
	local char = exports['sandbox-characters']:FetchCharacterData("CryptoWallet", target)
	if char ~= nil then
		local crypto = char:GetData("Crypto") or {}
		if crypto[coin] == nil then
			crypto[coin] = 0
		end

		crypto[coin] = crypto[coin] + amount
		char:SetData("Crypto", crypto)

		if not skipAlert then
			exports['sandbox-phone']:NotificationAdd(
				char:GetData("Source"),
				"Received Crypto",
				string.format("You Received %s $%s", amount, coin),
				os.time(),
				6000,
				"crypto",
				{}
			)
		end

		return true
	else
		local p = promise.new()
		exports['sandbox-base']:DatabaseGameUpdateOne({
			collection = "characters",
			query = {
				CryptoWallet = target,
			},
			update = {
				["$inc"] = {
					[string.format("Crypto.%s", coin)] = amount,
				},
			},
		}, function(success, res)
			p:resolve(success)
		end)

		return Citizen.Await(p)
	end
end)

exports("CryptoExchangeRemove", function(coin, target, amount, skipAlert)
	local p = promise.new()
	local char = exports['sandbox-characters']:FetchCharacterData("CryptoWallet", target)
	if char ~= nil then
		local crypto = char:GetData("Crypto") or {}

		if crypto[coin] == nil then
			crypto[coin] = 0
		end

		if crypto[coin] >= amount then
			crypto[coin] = crypto[coin] - amount
			char:SetData("Crypto", crypto)

			if not skipAlert then
				exports['sandbox-phone']:NotificationAdd(
					char:GetData("Source"),
					"Crypto Purchase",
					string.format("You Paid %s $%s", amount, coin),
					os.time(),
					6000,
					"crypto",
					{}
				)
			end

			p:resolve(true)
		else
			p:resolve(false)
		end
	else
		exports['sandbox-base']:DatabaseGameFindOne({
			collection = "characters",
			query = {
				CryptoWallet = target,
			},
		}, function(success, res)
			if #res == 0 then
				p:resolve(false)
				return
			else
				if res[1].Crypto[coin] >= amount then
					exports['sandbox-base']:DatabaseGameUpdateOne({
						collection = "characters",
						query = {
							CryptoWallet = target,
						},
						update = {
							["$inc"] = {
								[string.format("Crypto.%s", coin)] = amount,
							},
						},
					}, function(success, res)
						p:resolve(success)
					end)
				else
					p:resolve(false)
					return
				end
			end
		end)
	end

	return Citizen.Await(p)
end)

exports("CryptoExchangeTransfer", function(coin, sender, target, amount)
	local char = exports['sandbox-characters']:FetchBySID(sender)
	if char then
		if char:GetData("CryptoWallet") ~= target then
			local tChar = exports['sandbox-characters']:FetchCharacterData("CryptoWallet", target)

			if tChar or DoesCryptoWalletExist(target) then
				if exports['sandbox-finance']:CryptoExchangeRemove(coin, char:GetData("CryptoWallet"), math.abs(amount), true) then
					exports['sandbox-phone']:NotificationAdd(
						char:GetData("Source"),
						"Crypto Transfer",
						string.format("You Sent %s $%s", amount, coin),
						os.time(),
						6000,
						"crypto",
						{}
					)

					if exports['sandbox-finance']:CryptoExchangeAdd(coin, target, math.abs(amount), true) then
						if tChar then
							exports['sandbox-phone']:NotificationAdd(
								tChar:GetData("Source"),
								"Crypto Transfer",
								string.format("You Received %s $%s", amount, coin),
								os.time(),
								6000,
								"crypto",
								{}
							)
						end

						return true
					end
				end
			end
		end
	end
	return false
end)
