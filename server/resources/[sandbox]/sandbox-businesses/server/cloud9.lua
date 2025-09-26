_DRIFTLICENSECOST = 25000

AddEventHandler("Businesses:Server:Startup", function()
	exports["sandbox-chat"]:RegisterCommand(
		"checkdriftlicense",
		function(source, args, rawCommand)
			if tonumber(args[1]) then
				local char = exports['sandbox-characters']:FetchBySID(tonumber(args[1]))
				if char ~= nil then
					exports["sandbox-chat"]:SendSystemSingle(
						source,
						string.format("Drift License: %s", _DRIFT:Check(tonumber(args[1]), source))
					)
				else
					exports["sandbox-chat"]:SendSystemSingle(source, "State ID Not Logged In")
				end
			else
				exports["sandbox-chat"]:SendSystemSingle(source, "Invalid Arguments")
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
	exports["sandbox-chat"]:RegisterCommand(
		"revokedriftlicense",
		function(source, args, rawCommand)
			if tonumber(args[1]) then
				local char = exports['sandbox-characters']:FetchBySID(tonumber(args[1]))
				if char ~= nil then
					_DRIFT:Revoke(tonumber(args[1]), source)
				else
					exports["sandbox-chat"]:SendSystemSingle(source, "State ID Not Logged In")
				end
			else
				exports["sandbox-chat"]:SendSystemSingle(source, "Invalid Arguments")
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
	exports["sandbox-chat"]:RegisterCommand(
		"adddriftlicense",
		function(source, args, rawCommand)
			if tonumber(args[1]) then
				local char = exports['sandbox-characters']:FetchBySID(tonumber(args[1]))
				if char ~= nil then
					_DRIFT:Give(tonumber(args[1]), source)
				else
					exports["sandbox-chat"]:SendSystemSingle(source, "State ID Not Logged In")
				end
			else
				exports["sandbox-chat"]:SendSystemSingle(source, "Invalid Arguments")
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
		if exports['sandbox-jobs']:HasPermissionInJob(source, "cloud9", "JOB_DRIFT_LICENSE") then
			local char = exports['sandbox-characters']:FetchBySID(tonumber(sid))
			if char then
				local licenses = char:GetData("Licenses")
				local targetSrc = char:GetData("Source")
				if licenses["Drift"].Active ~= nil and licenses["Drift"].Active == true then
					licenses["Drift"].Active = false
					licenses["Drift"].Suspended = true
					char:SetData("Licenses", licenses)
					exports['sandbox-base']:MiddlewareTriggerEvent("Characters:ForceStore", targetSrc)
					exports['sandbox-hud']:NotifError(targetSrc, "Your Drift License has been revoked.")
					exports['sandbox-hud']:NotifSuccess(source,
						"Revoking Drift License Successful")
				end
			else
				exports['sandbox-hud']:NotifError(source, "State ID Not Logged In")
			end
		else
			exports['sandbox-hud']:NotifError(source, "Insufficient Privileges")
		end
	end,
	Give = function(self, sid, source)
		if exports['sandbox-jobs']:HasPermissionInJob(source, "cloud9", "JOB_DRIFT_LICENSE") then
			local char = exports['sandbox-characters']:FetchBySID(tonumber(sid))
			if char then
				local licenses = char:GetData("Licenses")
				local targetSrc = char:GetData("Source")
				if licenses["Drift"].Active ~= nil and licenses["Drift"].Active == false then
					local PlayerAccount = char:GetData("BankAccount")
					local paymentSuccess = false
					if PlayerAccount then
						paymentSuccess = exports['sandbox-finance']:BalanceCharge(PlayerAccount, _DRIFTLICENSECOST, {
							type = "bill",
							title = "DMV Licenses",
							description = "Drift License Cost",
							data = {},
						})

						if paymentSuccess then
							licenses["Drift"].Suspended = false
							licenses["Drift"].Active = true
							char:SetData("Licenses", licenses)
							exports['sandbox-base']:MiddlewareTriggerEvent("Characters:ForceStore", targetSrc)
							exports['sandbox-phone']:NotificationAdd(
								targetSrc,
								"Payment Successful",
								string.format("Cloud 9 Drift License - $%s", _DRIFTLICENSECOST),
								os.time(),
								3000,
								"bank",
								{}
							)
							local f = exports['sandbox-finance']:AccountsGetOrganization("cloud9")
							exports['sandbox-finance']:BalanceDeposit(f.Account, math.abs(_DRIFTLICENSECOST), {
								type = "deposit",
								title = "Cloud 9",
								description = string.format(
									"Cloud 9 Drift License - %s %s",
									char:GetData("First"),
									char:GetData("Last")
								),
								data = {},
							}, true)
							exports['sandbox-hud']:NotifSuccess(targetSrc, "You've received a Drift License.")
							exports['sandbox-hud']:NotifSuccess(source,
								"Drift License Given Successfully")
						else
							exports['sandbox-hud']:NotifError(source,
								"Bank: Declined - Insufficient Funds")
						end
					end
				else
					exports['sandbox-hud']:NotifError(source,
						"Drift License already exists!")
				end
			else
				exports['sandbox-hud']:NotifError(source, "State ID Not Logged In")
			end
		else
			exports['sandbox-hud']:NotifError(source, "Insufficient Privileges")
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
