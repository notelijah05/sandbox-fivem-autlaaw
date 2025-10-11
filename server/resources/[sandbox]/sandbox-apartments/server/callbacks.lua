function RegisterCallbacks()
	exports["sandbox-base"]:RegisterServerCallback("Apartment:Validate", function(source, data, cb)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		local pState = Player(source).state

		local isMyApartment = pState.inApartment and pState.inApartment.id == char:GetData("SID")

		if data.id then
			if data.type == "wardrobe" and isMyApartment then
				cb(true)
			elseif data.type == "logout" and isMyApartment then
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)

	exports["sandbox-base"]:RegisterServerCallback("Apartment:SpawnInside", function(source, data, cb)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		cb(exports['sandbox-apartments']:Enter(source, char:GetData("Apartment"), -1, true))
	end)

	exports["sandbox-base"]:RegisterServerCallback("Apartment:Enter", function(source, data, cb)
		cb(exports['sandbox-apartments']:Enter(source, data.tier, data.id))
	end)

	exports["sandbox-base"]:RegisterServerCallback("Apartment:Exit", function(source, data, cb)
		cb(exports['sandbox-apartments']:Exit(source))
	end)

	exports["sandbox-base"]:RegisterServerCallback("Apartment:GetVisitRequests", function(source, data, cb)
		cb(exports['sandbox-apartments']:RequestsGet(source))
	end)

	exports["sandbox-base"]:RegisterServerCallback("Apartment:Visit", function(source, data, cb)
		cb(exports['sandbox-apartments']:Enter(source, data.tier, data.id))
	end)
end
