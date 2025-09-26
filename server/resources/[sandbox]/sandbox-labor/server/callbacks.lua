function RegisterCallbacks()
	exports["sandbox-base"]:RegisterServerCallback("Labor:GetJobs", function(source, data, cb)
		cb(exports['sandbox-labor']:GetJobs())
	end)
	exports["sandbox-base"]:RegisterServerCallback("Labor:GetGroups", function(source, data, cb)
		cb(exports['sandbox-labor']:GetGroups())
	end)

	exports["sandbox-base"]:RegisterServerCallback("Labor:GetReputations", function(source, data, cb)
		cb(exports['sandbox-characters']:RepView(source))
	end)

	exports["sandbox-base"]:RegisterServerCallback("Labor:AcceptRequest", function(source, data, cb)
		if _pendingInvites[data.source] ~= nil then
			local state = exports['sandbox-labor']:JoinWorkgroup(_pendingInvites[data.source], data.source)

			if state then
				exports['sandbox-phone']:NotificationAdd(
					data.source,
					"Job Activity",
					"You Joined A Workgroup",
					os.time(),
					6000,
					"labor",
					{}
				)
			end

			_pendingInvites[data.source] = nil
			cb(state)
		else
			cb(false)
		end
	end)

	exports["sandbox-base"]:RegisterServerCallback("Labor:DeclineRequest", function(source, data, cb)
		if _pendingInvites[data.source] ~= nil then
			_pendingInvites[data.source] = nil

			exports['sandbox-phone']:NotificationAdd(
				data.source,
				"Job Activity",
				"Your Group Request Was Denied",
				os.time(),
				6000,
				"labor",
				{}
			)

			exports['sandbox-phone']:NotificationAdd(
				source,
				"Labor Activity",
				"You Denied A Group Request",
				os.time(),
				6000,
				"labor",
				{}
			)

			cb(true)
		else
			cb(false)
		end
	end)
end
