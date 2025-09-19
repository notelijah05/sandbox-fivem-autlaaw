function RegisterCallbacks()
	exports["sandbox-base"]:RegisterServerCallback("Labor:GetJobs", function(source, data, cb)
		cb(Labor.Get:Jobs())
	end)
	exports["sandbox-base"]:RegisterServerCallback("Labor:GetGroups", function(source, data, cb)
		cb(Labor.Get:Groups())
	end)

	exports["sandbox-base"]:RegisterServerCallback("Labor:GetReputations", function(source, data, cb)
		cb(Reputation:View(source))
	end)

	exports["sandbox-base"]:RegisterServerCallback("Labor:AcceptRequest", function(source, data, cb)
		if _pendingInvites[data.source] ~= nil then
			local state = Labor.Workgroups:Join(_pendingInvites[data.source], data.source)

			if state then
				Phone.Notification:Add(
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

			Phone.Notification:Add(
				data.source,
				"Job Activity",
				"Your Group Request Was Denied",
				os.time(),
				6000,
				"labor",
				{}
			)

			Phone.Notification:Add(
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
