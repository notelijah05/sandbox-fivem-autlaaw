AddEventHandler("Phone:Server:RegisterMiddleware", function()
	exports['sandbox-base']:MiddlewareAdd("Phone:Spawning", function(source, char)
		return {
			{
				type = "jobs",
				data = exports['sandbox-labor']:GetJobs(),
			},
			{
				type = "workGroups",
				data = exports['sandbox-labor']:GetGroups(),
			},
		}
	end)
end)

AddEventHandler("Phone:Server:RegisterCallbacks", function()
	exports["sandbox-base"]:RegisterServerCallback("Phone:Labor:CreateWorkgroup", function(source, data, cb)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		local myDuty = Player(source).state.onDuty

		if myDuty and (myDuty == "police" or myDuty == "ems") then
			exports['sandbox-base']:LoggerTrace(
				"Labor",
				string.format(
					"%s %s (%s) Attempted To Create Workgroup (%s)",
					char:GetData("First"),
					char:GetData("Last"),
					char:GetData("SID"),
					myDuty
				)
			)
			-- DropPlayer(
			-- 	source,
			-- 	string.format("%s", "Double dipping jobs is not allowed. Don't do it again - instead, go off duty.")
			-- )
			exports['sandbox-hud']:Notification(source, "error",
				'Double dipping jobs is not allowed. Instead, go off duty.')
			cb(false)
		else
			if char:GetData("ICU") ~= nil and not char:GetData("ICU").Released then
				cb(false)
			else
				cb(exports['sandbox-labor']:CreateWorkgroup(source))
			end
		end
	end)

	exports["sandbox-base"]:RegisterServerCallback("Phone:Labor:DisbandWorkgroup", function(source, data, cb)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if char:GetData("ICU") ~= nil and not char:GetData("ICU").Released then
			cb(false)
		else
			cb(exports['sandbox-labor']:DisbandWorkgroup(source, true))
		end
	end)

	exports["sandbox-base"]:RegisterServerCallback("Phone:Labor:JoinWorkgroup", function(source, data, cb)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		local myDuty = Player(source).state.onDuty
		if myDuty and (myDuty == "police" or myDuty == "ems") then
			exports['sandbox-base']:LoggerTrace(
				"Labor",
				string.format(
					"%s %s (%s) Attempted To Join Workgroup (%s)",
					char:GetData("First"),
					char:GetData("Last"),
					char:GetData("SID"),
					myDuty
				)
			)
			-- DropPlayer(
			-- 	source,
			-- 	string.format("%s", "Double dipping jobs is not allowed. Don't do it again - instead, go off duty.")
			-- )
			exports['sandbox-hud']:Notification(source, "error",
				'Double dipping jobs is not allowed. Instead, go off duty.')
			cb(false)
		else
			if char:GetData("ICU") ~= nil and not char:GetData("ICU").Released then
				cb(false)
			else
				cb(exports['sandbox-labor']:RequestWorkgroup(data, source))
			end
		end
	end)

	exports["sandbox-base"]:RegisterServerCallback("Phone:Labor:LeaveWorkgroup", function(source, data, cb)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if char:GetData("ICU") ~= nil and not char:GetData("ICU").Released then
			cb(false)
		else
			cb(exports['sandbox-labor']:LeaveWorkgroup(data, source))
		end
	end)

	exports["sandbox-base"]:RegisterServerCallback("Phone:Labor:StartLaborJob", function(source, data, cb)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		local myDuty = Player(source).state.onDuty
		if myDuty and (myDuty == "police" or myDuty == "ems") then
			exports['sandbox-base']:LoggerTrace(
				"Labor",
				string.format(
					"%s %s (%s) Attempted To Double Dip Jobs (%s and %s)",
					char:GetData("First"),
					char:GetData("Last"),
					char:GetData("SID"),
					myDuty,
					data.job
				)
			)
			-- DropPlayer(
			-- 	source,
			-- 	string.format("%s", "Double dipping jobs is not allowed. Don't do it again - instead, go off duty.")
			-- )
			exports['sandbox-hud']:Notification(source, "error",
				'Double dipping jobs is not allowed. Instead, go off duty.')
			cb(false)
		else
			if char:GetData("ICU") ~= nil and not char:GetData("ICU").Released then
				cb(false)
			else
				cb(exports['sandbox-labor']:OnDuty(data.job, source, data.isWorkgroup))
			end
		end
	end)

	exports["sandbox-base"]:RegisterServerCallback("Phone:Labor:QuitLaborJob", function(source, data, cb)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if char:GetData("ICU") ~= nil and not char:GetData("ICU").Released then
			cb(false)
		else
			cb(exports['sandbox-labor']:OffDuty(data, source))
		end
	end)
end)
