AddEventHandler("Finance:Server:Startup", function()
	exports["sandbox-base"]:RegisterServerCallback("Wallet:GetCash", function(source, data, cb)
		cb(exports['sandbox-finance']:WalletGet(source))
	end)

	exports["sandbox-base"]:RegisterServerCallback("Wallet:GiveCash", function(source, data, cb)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		local targetChar = exports['sandbox-characters']:FetchBySID(data.target)

		if char ~= nil and targetChar ~= nil then
			local playerCoords = GetEntityCoords(GetPlayerPed(source))
			local targetCoords = GetEntityCoords(GetPlayerPed(targetChar:GetData("Source")))

			if #(playerCoords - targetCoords) <= 5.0 then
				local amount = math.tointeger(data.amount)
				if amount and amount > 0 then
					if exports['sandbox-finance']:WalletModify(source, -amount, true) then
						if exports['sandbox-finance']:WalletModify(targetChar:GetData("Source"), amount, true) then
							TriggerClientEvent('Finance:Client:HandOffCash', source)
							exports['sandbox-base']:ExecuteClient(
								source,
								"Notification",
								"Success",
								"You Gave $" .. formatNumberToCurrency(amount) .. " in Cash"
							)
							exports['sandbox-base']:ExecuteClient(
								targetChar:GetData("Source"),
								"Notification",
								"Success",
								"You Just Received $" .. formatNumberToCurrency(amount) .. " in Cash"
							)
							return
						else
							return exports["sandbox-chat"]:SendSystemSingle(source, "Error")
						end
					else
						return exports["sandbox-chat"]:SendSystemSingle(source, "Not Enough Cash")
					end
				else
					return exports["sandbox-chat"]:SendSystemSingle(source, "Invalid Amount")
				end
			else
				return exports["sandbox-chat"]:SendSystemSingle(source, "Target Not Nearby")
			end
		else
			cb(false)
		end
	end)

	exports["sandbox-chat"]:RegisterCommand("cash", function(source, args, rawCommand)
		ShowCash(source)
	end, {
		help = "Show Current Cash",
	})

	exports["sandbox-chat"]:RegisterAdminCommand("addcash", function(source, args, rawCommand)
		local addingAmount = tonumber(args[1])
		if addingAmount and addingAmount > 0 then
			exports['sandbox-finance']:WalletModify(source, addingAmount)
		end
	end, {
		help = "Give Cash To Yourself",
		params = {
			{
				name = "Amount",
				help = "Amount of cash to give",
			},
		},
	}, 1)

	exports["sandbox-chat"]:RegisterCommand("givecash", function(source, args, rawCommand)
		local target = tonumber(args[1])
		if target and target > 0 then
			local char = exports['sandbox-characters']:FetchCharacterSource(source)
			local targetChar = exports['sandbox-characters']:FetchBySID(target)

			if char and targetChar and targetChar:GetData("Source") ~= char:GetData("Source") then
				local playerCoords = GetEntityCoords(GetPlayerPed(source))
				local targetCoords = GetEntityCoords(GetPlayerPed(targetChar:GetData("Source")))

				if #(playerCoords - targetCoords) <= 5.0 then
					local amount = math.tointeger(args[2])
					if amount and amount > 0 then
						if exports['sandbox-finance']:WalletModify(source, -amount, true) then
							if exports['sandbox-finance']:WalletModify(targetChar:GetData("Source"), amount, true) then
								TriggerClientEvent('Finance:Client:HandOffCash', source)
								exports['sandbox-base']:ExecuteClient(
									source,
									"Notification",
									"Success",
									"You Gave $" .. formatNumberToCurrency(amount) .. " in Cash"
								)
								exports['sandbox-base']:ExecuteClient(
									targetChar:GetData("Source"),
									"Notification",
									"Success",
									"You Just Received $" .. formatNumberToCurrency(amount) .. " in Cash"
								)
								return
							else
								return exports["sandbox-chat"]:SendSystemSingle(source, "Error")
							end
						else
							return exports["sandbox-chat"]:SendSystemSingle(source, "Not Enough Cash")
						end
					else
						return exports["sandbox-chat"]:SendSystemSingle(source, "Invalid Amount")
					end
				else
					return exports["sandbox-chat"]:SendSystemSingle(source, "Target Not Nearby")
				end
			end
		end
		exports["sandbox-chat"]:SendSystemSingle(source, "Invalid State ID")
	end, {
		help = "Give Your Cash to a Person",
		params = {
			{
				name = "State ID",
				help = "The person you want to give the cash to has to be nearby",
			},
			{
				name = "Amount",
				help = "The amount of money to give",
			},
		},
	}, 2)
end)

function ShowCash(source)
	exports['sandbox-base']:ExecuteClient(
		source,
		"Notification",
		"Success",
		"You have $" .. formatNumberToCurrency(exports['sandbox-finance']:WalletGet(source)),
		2500,
		"money-bill-wave"
	)
end

RegisterServerEvent("Wallet:ShowCash", function()
	local source = source
	ShowCash(source)
end)
