function RegisterChatCommands()
	exports["sandbox-chat"]:RegisterAdminCommand("setcallsign", function(source, args, rawCommand)
		local newCallsign = args[2]
		local target = exports['sandbox-characters']:FetchBySID(tonumber(args[1]))
		if target ~= nil then
			if
				Jobs.Permissions:HasJob(target:GetData("Source"), "police")
				or Jobs.Permissions:HasJob(target:GetData("Source"), "ems")
			then
				if MDT.People:Update(-1, target:GetData("SID"), "Callsign", newCallsign) then
					exports["sandbox-chat"]:SendSystemSingle(source, "Updated Callsign")
				else
					exports["sandbox-chat"]:SendSystemSingle(source, "Error Updating Callsign")
				end
			else
				exports["sandbox-chat"]:SendSystemSingle(source, "Target is not Emergency Personnel")
			end
		else
			exports["sandbox-chat"]:SendSystemSingle(source, "Invalid State ID")
		end
	end, {
		help = "Assign a callsign to an emergency worker",
		params = {
			{
				name = "Target",
				help = "State ID",
			},
			{
				name = "Callsign",
				help = "The callsign you want to assign to the player. This must be unique",
			},
		},
	}, 2)

	exports["sandbox-chat"]:RegisterAdminCommand("reclaimcallsign", function(source, args, rawCommand)
		exports['sandbox-base']:DatabaseGameFindOneAndUpdate({
			collection = "characters",
			query = {
				Callsign = args[1],
			},
			update = {
				['$set'] = {
					Callsign = false,
				},
			},
			options = {
				projection = {
					SID = 1,
					User = 1,
					First = 1,
					Last = 1,
				},
			},
		}, function(success, results)
			if success and results then
				local char = exports['sandbox-characters']:FetchBySID(results.SID)
				if char then
					char:SetData("Callsign", false)
				end

				exports["sandbox-chat"]:SendSystemSingle(source,
					string.format("Callsign Reclaimed From %s %s (%s)", results.First, results.Last, results.SID))
			else
				exports["sandbox-chat"]:SendSystemSingle(source, "Nobody With That Callsign")
			end
		end)
	end, {
		help = "Force Reclaim a Callsign",
		params = {
			{
				name = "Callsign",
				help = "The callsign you want to reclaim.",
			},
		},
	}, 1)

	exports["sandbox-chat"]:RegisterCommand(
		"mdt",
		function(source, args, rawCommand)
			TriggerClientEvent("MDT:Client:Toggle", source)
		end,
		{
			help = "Open MDT",
		},
		0,
		{
			{
				Id = "police",
			},
			{
				Id = "government",
			},
			{
				Id = "ems",
			},
			{
				Id = "prison",
			},
		}
	)

	exports["sandbox-chat"]:RegisterAdminCommand("addmdtsysadmin", function(source, args, rawCommand)
		local targetStateId = math.tointeger(args[1])
		local success = MDT.People:Update(-1, targetStateId, "MDTSystemAdmin", true)
		if success then
			exports["sandbox-chat"]:SendSystemSingle(source, "Granted System Admin to State ID: " .. targetStateId)
		else
			exports["sandbox-chat"]:SendSystemSingle(source, "Error Granting System Admin")
		end
	end, {
		help = "Grant MDT System Admin [Danger!]",
		params = {
			{
				name = "Target State ID",
				help = "State ID of Character",
			},
		},
	}, 1)

	exports["sandbox-chat"]:RegisterAdminCommand("removemdtsysadmin", function(source, args, rawCommand)
		local targetStateId = math.tointeger(args[1])
		local success = MDT.People:Update(-1, targetStateId, "MDTSystemAdmin", false)
		if success then
			exports["sandbox-chat"]:SendSystemSingle(source, "Revoked System Admin from State ID: " .. targetStateId)
		else
			exports["sandbox-chat"]:SendSystemSingle(source, "Error Revoking System Admin")
		end
	end, {
		help = "Revoke MDT System Admin",
		params = {
			{
				name = "Target State ID",
				help = "State ID of Character",
			},
		},
	}, 1)

	exports["sandbox-chat"]:RegisterCommand(
		"clearblips",
		function(source, args, rawCommand)
			TriggerClientEvent("EmergencyAlerts:Client:Clear", source)
		end,
		{
			help = "Clear Emergency Alert Blips",
		},
		0,
		{
			{
				Id = "police",
			},
			{
				Id = "ems",
			},
			{
				Id = "tow",
			}
		}
	)
end
