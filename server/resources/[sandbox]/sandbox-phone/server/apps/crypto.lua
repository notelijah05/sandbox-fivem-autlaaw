AddEventHandler("Crypto:Server:Startup", function()
	while Crypto == nil do
		Wait(10)
	end

	exports['sandbox-finance']:CryptoCoinCreate("Vroom", "VRM", 100, false, false)
	exports['sandbox-finance']:CryptoCoinCreate("Mald", "MALD", 250, true, 190)

	-- Compatability since we're renaming MALD
	exports['sandbox-base']:MiddlewareAdd("Characters:Spawning", function(source)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		local myCrypto = char:GetData("Crypto")

		if myCrypto.PLEB ~= nil then
			myCrypto.MALD = myCrypto.PLEB
			myCrypto.PLEB = nil
			char:SetData("Crypto", myCrypto)
		end
	end, 1)
end)

AddEventHandler("Phone:Server:RegisterCallbacks", function()
	exports["sandbox-base"]:RegisterServerCallback("Phone:Crypto:Buy", function(source, data, cb)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if char then
			return cb(exports['sandbox-finance']:CryptoExchangeBuy(data.Short, char:GetData("SID"), data.Quantity))
		end
		cb(false)
	end)

	exports["sandbox-base"]:RegisterServerCallback("Phone:Crypto:Sell", function(source, data, cb)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if char then
			return cb(exports['sandbox-finance']:CryptoExchangeSell(data.Short, char:GetData("SID"), data.Quantity))
		end
		cb(false)
	end)

	exports["sandbox-base"]:RegisterServerCallback("Phone:Crypto:Transfer", function(source, data, cb)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if char and char:GetData("SID") ~= data.Target then
			return cb(exports['sandbox-finance']:CryptoExchangeTransfer(data.Short, char:GetData("SID"), data.Target,
				data.Quantity))
		end
		cb(false)
	end)
end)
