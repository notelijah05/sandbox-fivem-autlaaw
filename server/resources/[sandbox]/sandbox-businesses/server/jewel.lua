local _jobName = "jewel"

AddEventHandler("Businesses:Server:Startup", function()
	exports["sandbox-base"]:RegisterServerCallback("Businesses:JEWEL:OpenTable", function(source, data, cb)
		exports['sandbox-inventory']:OpenSecondary(source, 149, data)
	end)

	exports["sandbox-base"]:RegisterServerCallback("Businesses:JEWEL:Sell", function(source, data, cb)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if Jobs.Permissions:HasJob(source, _jobName, false, false, false, false, "JOB_SELL_GEMS") then
			local its = exports['sandbox-inventory']:GetAllOfTypeNoStack(char:GetData("SID"), 1, 11)

			if its and #its > 0 then
				local totalSold = 0
				local totalPayout = 0
				for k, v in ipairs(its) do
					local md = json.decode(v.MetaData)
					local itemData = exports['sandbox-inventory']:ItemsGetData(v.Name)
					local gemWorth = (itemData.price * ((md.Quality or 1) / 100))

					if exports['sandbox-inventory']:RemoveId(char:GetData("SID"), 1, v) then
						totalPayout += gemWorth
						totalSold += 1
					end
				end

				local f = exports['sandbox-finance']:AccountsGetOrganization(_jobName)
				if f ~= nil then
					exports['sandbox-finance']:BalanceDeposit(f.Account, math.ceil(math.abs(totalPayout) * 0.8), {
						type = "deposit",
						title = "Sold Goods",
						description = string.format("Sold %s Gems", totalSold),
						data = {},
					})
					exports['sandbox-base']:ExecuteClient(
						source,
						"Notification",
						"Success",
						string.format(
							"Sold %s Gems For $%s (Deposited To Company Account)",
							totalSold,
							math.ceil(math.abs(totalPayout) * 0.8)
						)
					)
				else
					exports['sandbox-finance']:WalletModify(source, totalPayout)
				end

				f = exports['sandbox-finance']:AccountsGetOrganization("government")
				exports['sandbox-finance']:BalanceDeposit(f.Account, math.ceil(math.abs(totalPayout) * 0.1), {
					type = "deposit",
					title = "Sold Goods Tax",
					description = string.format("10%% Tax On %s Sold Gems", totalSold),
					data = data,
				}, true)

				-- KEKW
				f = exports['sandbox-finance']:AccountsGetOrganization("dgang")
				exports['sandbox-finance']:BalanceDeposit(f.Account, math.ceil(math.abs(totalPayout) * 0.1), {
					type = "deposit",
					title = "Sold Goods Tax",
					description = string.format("10%% Tax On %s Sold Gems", totalSold),
					data = data,
				}, true)
			else
				exports['sandbox-base']:ExecuteClient(source, "Notification", "Error", "You Don't Have Any Gems To Sell")
			end
		end
	end)
end)

AddEventHandler("Businesses:Server:JEWEL:ViewGem", function(source, data)
	local char = exports['sandbox-characters']:FetchCharacterSource(source)
	if char ~= nil then
		if Jobs.Permissions:HasJob(source, _jobName, false, false, false, true, "JOB_USE_GEM_TABLE") then
			local its = exports['sandbox-inventory']:GetInventory(source, data.owner, data.invType)
			if #its > 0 then
				local md = json.decode(its[1].MetaData)
				local itemData = exports['sandbox-inventory']:ItemsGetData(its[1].Name)
				if itemData ~= nil and itemData.type == 11 and itemData.gemProperties ~= nil then
					TriggerClientEvent(
						"Businesses:Client:JEWEL:ViewGem",
						source,
						data.owner,
						itemData.gemProperties,
						md.Quality,
						its[1]
					)
				end
			end
		end
	end
end)
