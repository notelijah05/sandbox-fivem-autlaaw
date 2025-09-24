function RegisterJobCallbacks()
	exports["sandbox-base"]:RegisterServerCallback("Jobs:OnDuty", function(source, jobId, cb)
		cb(exports['sandbox-jobs']:DutyOn(source, jobId))
	end)

	exports["sandbox-base"]:RegisterServerCallback("Jobs:OffDuty", function(source, jobId, cb)
		cb(exports['sandbox-jobs']:DutyOff(source, jobId))
	end)
	exports["sandbox-base"]:RegisterServerCallback("MetalDetector:Server:Sync", function(source, data, cb)
		TriggerClientEvent("MetalDetector:Client:Sync", -1, data)
		cb(true)
	end)
end
