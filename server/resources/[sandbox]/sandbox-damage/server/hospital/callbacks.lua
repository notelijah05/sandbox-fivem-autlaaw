function HospitalCallbacks()
	exports["sandbox-chat"]:RegisterCommand(
		"icu",
		function(source, args, rawCommand)
			if tonumber(args[1]) then
				local char = exports['sandbox-characters']:FetchBySID(tonumber(args[1]))
				if char ~= nil then
					exports['sandbox-damage']:HospitalICUSend(char:GetData("Source"))
					exports["sandbox-chat"]:SendSystemSingle(source,
						string.format("%s Has Been Admitted To ICU", args[1]))
				else
					exports["sandbox-chat"]:SendSystemSingle(source, "State ID Not Logged In")
				end
			else
				exports["sandbox-chat"]:SendSystemSingle(source, "Invalid Arguments")
			end
		end,
		{
			help = "Sends Patient To ICU, Where They Will Remain Until Released By Medical Staff",
			params = {
				{
					name = "Target",
					help = "State ID of target",
				},
			},
		},
		1,
		{
			{
				Id = "ems",
			},
		}
	)
	exports["sandbox-chat"]:RegisterCommand(
		"release",
		function(source, args, rawCommand)
			if tonumber(args[1]) then
				local char = exports['sandbox-characters']:FetchBySID(tonumber(args[1]))
				if char ~= nil and char:GetData("ICU") ~= nil and not char:GetData("ICU").Released then
					exports['sandbox-damage']:HospitalICURelease(char:GetData("Source"))
					exports["sandbox-chat"]:SendSystemSingle(source,
						string.format("%s Has Been Released From ICU", args[1]))
				else
					exports["sandbox-chat"]:SendSystemSingle(source, "State ID Not Logged In")
				end
			else
				exports["sandbox-chat"]:SendSystemSingle(source, "Invalid Arguments")
			end
		end,
		{
			help = "Releases a patient from ICU",
			params = {
				{
					name = "Target",
					help = "State ID of target",
				},
			},
		},
		1,
		{
			{
				Id = "ems",
			},
		}
	)

	exports["sandbox-base"]:RegisterServerCallback("Hospital:Treat", function(source, data, cb)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		local bed = exports['sandbox-damage']:HospitalRequestBed(source)

		local cost = 1500
		-- if not GlobalState["Duty:ems"] or GlobalState["Duty:ems"] == 0 then
		-- 	cost = 150
		-- end

		exports['sandbox-finance']:BillingCharge(source, cost, "Medical Services",
			"Use of facilities at St. Fiacre Medical Center")

		local f = exports['sandbox-finance']:AccountsGetOrganization("ems")
		exports['sandbox-finance']:BalanceDeposit(f.Account, cost / 2, {
			type = "deposit",
			title = "Medical Treatment",
			description = string.format("Medical Bill For %s %s", char:GetData("First"), char:GetData("Last")),
			data = {},
		}, true)

		f = exports['sandbox-finance']:AccountsGetOrganization("government")
		exports['sandbox-finance']:BalanceDeposit(f.Account, cost / 2, {
			type = "deposit",
			title = "Medical Treatment",
			description = string.format("Medical Bill For %s %s", char:GetData("First"), char:GetData("Last")),
			data = {},
		}, true)

		cb(bed)
	end)

	exports["sandbox-base"]:RegisterServerCallback("Hospital:Respawn", function(source, data, cb)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if os.time() >= Player(source).state.releaseTime then
			exports['sandbox-pwnzor']:TempPosIgnore(source)
			local bed = exports['sandbox-damage']:HospitalRequestBed(source)

			local cost = 1500
			-- if not GlobalState["Duty:ems"] or GlobalState["Duty:ems"] == 0 then
			-- 	cost = 150
			-- end

			exports['sandbox-finance']:BillingCharge(source, cost, "Medical Services",
				"Use of facilities at St. Fiacre Medical Center")
			exports['sandbox-base']:LoggerInfo(
				"Robbery",
				string.format(
					"%s %s (%s) Respawned Via Local EMS",
					char:GetData("First"),
					char:GetData("Last"),
					char:GetData("SID")
				),
				{
					console = true,
					file = true,
					database = true,
					discord = {
						embed = true,
						type = "info",
						webhook = GetConvar("discord_log_webhook", ""),
					},
				}
			)

			local f = exports['sandbox-finance']:AccountsGetOrganization("ems")
			exports['sandbox-finance']:BalanceDeposit(f.Account, cost / 2, {
				type = "deposit",
				title = "Medical Treatment",
				description = string.format("Medical Bill For %s %s", char:GetData("First"), char:GetData("Last")),
				data = {},
			}, true)

			f = exports['sandbox-finance']:AccountsGetOrganization("government")
			exports['sandbox-finance']:BalanceDeposit(f.Account, cost / 2, {
				type = "deposit",
				title = "Medical Treatment",
				description = string.format("Medical Bill For %s %s", char:GetData("First"), char:GetData("Last")),
				data = {},
			}, true)

			cb(bed)
		else
			cb(nil)
		end
	end)

	exports["sandbox-base"]:RegisterServerCallback("Hospital:FindBed", function(source, data, cb)
		cb(exports['sandbox-damage']:HospitalFindBed(source, data))
	end)

	exports["sandbox-base"]:RegisterServerCallback("Hospital:OccupyBed", function(source, data, cb)
		cb(exports['sandbox-damage']:HospitalOccupyBed(source, data))
	end)

	exports["sandbox-base"]:RegisterServerCallback("Hospital:LeaveBed", function(source, data, cb)
		cb(exports['sandbox-damage']:HospitalLeaveBed(source))
	end)

	exports["sandbox-base"]:RegisterServerCallback("Hospital:RetreiveItems", function(source, data, cb)
		exports['sandbox-damage']:HospitalICUGetItems(source)
	end)

	exports["sandbox-base"]:RegisterServerCallback("Hospital:HiddenRevive", function(source, data, cb)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		local p = Player(source).state
		if p.isEscorting ~= nil then
			local t = Player(p.isEscorting).state
			if t ~= nil and t.isDead then
				if exports['sandbox-finance']:CryptoExchangeRemove("MALD", char:GetData("CryptoWallet"), 20) then
					cb(true)
					local tChar = exports['sandbox-characters']:FetchCharacterSource(p.isEscorting)
					if tChar ~= nil then
						exports["sandbox-base"]:ClientCallback(tChar:GetData("Source"), "Damage:Heal", true)
					else
						exports['sandbox-base']:ExecuteClient(source, "Notification", "Error", "Invalid Target")
					end
				else
					cb(false)
					exports['sandbox-base']:ExecuteClient(source, "Notification", "Error", "Not Enough Crypto")
				end
			end
		end
	end)

	exports["sandbox-base"]:RegisterServerCallback("Hospital:SpawnICU", function(source, data, cb)
		exports["sandbox-base"]:RoutePlayerToGlobalRoute(source)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		Player(source).state.ICU = false
		TriggerClientEvent("Hospital:Client:ICU:Enter", source)
		cb(true)
	end)
end
