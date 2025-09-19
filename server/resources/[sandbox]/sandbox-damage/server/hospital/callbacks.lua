function HospitalCallbacks()
	Chat:RegisterCommand(
		"icu",
		function(source, args, rawCommand)
			if tonumber(args[1]) then
				local char = exports['sandbox-characters']:FetchBySID(tonumber(args[1]))
				if char ~= nil then
					Hospital.ICU:Send(char:GetData("Source"))
					Chat.Send.System:Single(source, string.format("%s Has Been Admitted To ICU", args[1]))
				else
					Chat.Send.System:Single(source, "State ID Not Logged In")
				end
			else
				Chat.Send.System:Single(source, "Invalid Arguments")
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
	Chat:RegisterCommand(
		"release",
		function(source, args, rawCommand)
			if tonumber(args[1]) then
				local char = exports['sandbox-characters']:FetchBySID(tonumber(args[1]))
				if char ~= nil and char:GetData("ICU") ~= nil and not char:GetData("ICU").Released then
					Hospital.ICU:Release(char:GetData("Source"))
					Chat.Send.System:Single(source, string.format("%s Has Been Released From ICU", args[1]))
				else
					Chat.Send.System:Single(source, "State ID Not Logged In")
				end
			else
				Chat.Send.System:Single(source, "Invalid Arguments")
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
		local bed = Hospital:RequestBed(source)

		local cost = 1500
		-- if not GlobalState["Duty:ems"] or GlobalState["Duty:ems"] == 0 then
		-- 	cost = 150
		-- end

		Billing:Charge(source, cost, "Medical Services", "Use of facilities at St. Fiacre Medical Center")

		local f = Banking.Accounts:GetOrganization("ems")
		Banking.Balance:Deposit(f.Account, cost / 2, {
			type = "deposit",
			title = "Medical Treatment",
			description = string.format("Medical Bill For %s %s", char:GetData("First"), char:GetData("Last")),
			data = {},
		}, true)

		f = Banking.Accounts:GetOrganization("government")
		Banking.Balance:Deposit(f.Account, cost / 2, {
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
			Pwnzor.Players:TempPosIgnore(source)
			local bed = Hospital:RequestBed(source)

			local cost = 1500
			-- if not GlobalState["Duty:ems"] or GlobalState["Duty:ems"] == 0 then
			-- 	cost = 150
			-- end

			Billing:Charge(source, cost, "Medical Services", "Use of facilities at St. Fiacre Medical Center")
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

			local f = Banking.Accounts:GetOrganization("ems")
			Banking.Balance:Deposit(f.Account, cost / 2, {
				type = "deposit",
				title = "Medical Treatment",
				description = string.format("Medical Bill For %s %s", char:GetData("First"), char:GetData("Last")),
				data = {},
			}, true)

			f = Banking.Accounts:GetOrganization("government")
			Banking.Balance:Deposit(f.Account, cost / 2, {
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
		cb(Hospital:FindBed(source, data))
	end)

	exports["sandbox-base"]:RegisterServerCallback("Hospital:OccupyBed", function(source, data, cb)
		cb(Hospital:OccupyBed(source, data))
	end)

	exports["sandbox-base"]:RegisterServerCallback("Hospital:LeaveBed", function(source, data, cb)
		cb(Hospital:LeaveBed(source))
	end)

	exports["sandbox-base"]:RegisterServerCallback("Hospital:RetreiveItems", function(source, data, cb)
		Hospital.ICU:GetItems(source)
	end)

	exports["sandbox-base"]:RegisterServerCallback("Hospital:HiddenRevive", function(source, data, cb)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		local p = Player(source).state
		if p.isEscorting ~= nil then
			local t = Player(p.isEscorting).state
			if t ~= nil and t.isDead then
				if Crypto.Exchange:Remove("MALD", char:GetData("CryptoWallet"), 20) then
					cb(true)
					local tChar = exports['sandbox-characters']:FetchCharacterSource(p.isEscorting)
					if tChar ~= nil then
						exports["sandbox-base"]:ClientCallback(tChar:GetData("Source"), "Damage:Heal", true)
					else
						Execute:Client(source, "Notification", "Error", "Invalid Target")
					end
				else
					cb(false)
					Execute:Client(source, "Notification", "Error", "Not Enough Crypto")
				end
			end
		end
	end)

	exports["sandbox-base"]:RegisterServerCallback("Hospital:SpawnICU", function(source, data, cb)
		Routing:RoutePlayerToGlobalRoute(source)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		Player(source).state.ICU = false
		TriggerClientEvent("Hospital:Client:ICU:Enter", source)
		cb(true)
	end)
end
