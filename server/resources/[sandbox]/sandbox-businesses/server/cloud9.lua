_DRIFTLICENSECOST = 25000

AddEventHandler("Businesses:Server:Startup", function()
	Chat:RegisterCommand(
		"checkdriftlicense",
		function(source, args, rawCommand)
			if tonumber(args[1]) then
				local char = exports['sandbox-characters']:FetchBySID(tonumber(args[1]))
				if char ~= nil then
					Chat.Send.System:Single(
						source,
						string.format("Drift License: %s", _DRIFT:Check(tonumber(args[1]), source))
					)
				else
					Chat.Send.System:Single(source, "State ID Not Logged In")
				end
			else
				Chat.Send.System:Single(source, "Invalid Arguments")
			end
		end,
		{
			help = "Check State DMV for Drift License",
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
				Id = "cloud9",
			},
		}
	)
	Chat:RegisterCommand(
		"revokedriftlicense",
		function(source, args, rawCommand)
			if tonumber(args[1]) then
				local char = exports['sandbox-characters']:FetchBySID(tonumber(args[1]))
				if char ~= nil then
					_DRIFT:Revoke(tonumber(args[1]), source)
				else
					Chat.Send.System:Single(source, "State ID Not Logged In")
				end
			else
				Chat.Send.System:Single(source, "Invalid Arguments")
			end
		end,
		{
			help = "Revoke Drift License",
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
				Id = "cloud9",
			},
		}
	)
	Chat:RegisterCommand(
		"adddriftlicense",
		function(source, args, rawCommand)
			if tonumber(args[1]) then
				local char = exports['sandbox-characters']:FetchBySID(tonumber(args[1]))
				if char ~= nil then
					_DRIFT:Give(tonumber(args[1]), source)
				else
					Chat.Send.System:Single(source, "State ID Not Logged In")
				end
			else
				Chat.Send.System:Single(source, "Invalid Arguments")
			end
		end,
		{
			help = "Give Drift License",
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
				Id = "cloud9",
			},
		}
	)
end)

_DRIFT = {
	Revoke = function(self, sid, source)
		if Jobs.Permissions:HasPermissionInJob(source, "cloud9", "JOB_DRIFT_LICENSE") then
			local char = exports['sandbox-characters']:FetchBySID(tonumber(sid))
			if char then
				local licenses = char:GetData("Licenses")
				local targetSrc = char:GetData("Source")
				if licenses["Drift"].Active ~= nil and licenses["Drift"].Active == true then
					licenses["Drift"].Active = false
					licenses["Drift"].Suspended = true
					char:SetData("Licenses", licenses)
					exports['sandbox-base']:TriggerEvent("Characters:ForceStore", targetSrc)
					exports['sandbox-base']:ExecuteClient(targetSrc, "Notification", "Error",
						"Your Drift License has been revoked.")
					exports['sandbox-base']:ExecuteClient(source, "Notification", "Success",
						"Revoking Drift License Successful")
				end
			else
				exports['sandbox-base']:ExecuteClient(source, "Notification", "Error", "State ID Not Logged In")
			end
		else
			exports['sandbox-base']:ExecuteClient(source, "Notification", "Error", "Insufficient Privileges")
		end
	end,
	Give = function(self, sid, source)
		if Jobs.Permissions:HasPermissionInJob(source, "cloud9", "JOB_DRIFT_LICENSE") then
			local char = exports['sandbox-characters']:FetchBySID(tonumber(sid))
			if char then
				local licenses = char:GetData("Licenses")
				local targetSrc = char:GetData("Source")
				if licenses["Drift"].Active ~= nil and licenses["Drift"].Active == false then
					local PlayerAccount = char:GetData("BankAccount")
					local paymentSuccess = false
					if PlayerAccount then
						paymentSuccess = Banking.Balance:Charge(PlayerAccount, _DRIFTLICENSECOST, {
							type = "bill",
							title = "DMV Licenses",
							description = "Drift License Cost",
							data = {},
						})

						if paymentSuccess then
							licenses["Drift"].Suspended = false
							licenses["Drift"].Active = true
							char:SetData("Licenses", licenses)
							exports['sandbox-base']:TriggerEvent("Characters:ForceStore", targetSrc)
							Phone.Notification:Add(
								targetSrc,
								"Payment Successful",
								string.format("Cloud 9 Drift License - $%s", _DRIFTLICENSECOST),
								os.time(),
								3000,
								"bank",
								{}
							)
							local f = Banking.Accounts:GetOrganization("cloud9")
							Banking.Balance:Deposit(f.Account, math.abs(_DRIFTLICENSECOST), {
								type = "deposit",
								title = "Cloud 9",
								description = string.format(
									"Cloud 9 Drift License - %s %s",
									char:GetData("First"),
									char:GetData("Last")
								),
								data = {},
							}, true)
							exports['sandbox-base']:ExecuteClient(targetSrc, "Notification", "Success",
								"You've received a Drift License.")
							exports['sandbox-base']:ExecuteClient(source, "Notification", "Success",
								"Drift License Given Successfully")
						else
							exports['sandbox-base']:ExecuteClient(source, "Notification", "Error",
								"Bank: Declined - Insufficient Funds")
						end
					end
				else
					exports['sandbox-base']:ExecuteClient(source, "Notification", "Error",
						"Drift License already exists!")
				end
			else
				exports['sandbox-base']:ExecuteClient(source, "Notification", "Error", "State ID Not Logged In")
			end
		else
			exports['sandbox-base']:ExecuteClient(source, "Notification", "Error", "Insufficient Privileges")
		end
	end,
	Check = function(self, sid, source)
		local char = exports['sandbox-characters']:FetchBySID(tonumber(sid))
		if char then
			local licenses = char:GetData("Licenses")
			return licenses["Drift"].Active or false
		end
		return false
	end,
}
