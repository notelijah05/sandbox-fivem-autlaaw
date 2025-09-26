_requests = {}
_requestors = {}

AddEventHandler("Core:Shared:Ready", function()
	RegisterCallbacks()
	RegisterMiddleware()
	Startup()
end)

exports("Enter", function(source, targetType, target, wakeUp)
	local f = false
	local rTarget = target
	if rTarget == -1 then
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		rTarget = char:GetData("SID")
		f = true
	end

	if not f then
		if _requestors[source] ~= nil then
			for k, v in ipairs(_requests[_requestors[source]]) do
				if v.source == source then
					f = true
				end
			end
		end

		if exports['sandbox-police']:IsInBreach(source, "apartment", rTarget) then
			f = true
		end
	end

	if f then
		Player(source).state.inApartment = {
			type = targetType,
			id = rTarget
		}

		local routeId = exports["sandbox-base"]:RequestRouteId(string.format("Apartment:%s", rTarget), false)
		exports['sandbox-pwnzor']:TempPosIgnore(source)
		exports["sandbox-base"]:AddPlayerToRoute(source, routeId)
		GlobalState[string.format("%s:", source)] = rTarget
		TriggerClientEvent("Apartment:Client:InnerStuff", source, targetType or 1, rTarget, wakeUp)

		local apartment = GlobalState[string.format("Apartment:%s", targetType or 1)]
		if apartment and apartment.coords then
			Player(source).state.tpLocation = {
				x = apartment.coords.x,
				y = apartment.coords.y,
				z = apartment.coords.z,
			}
		end

		return targetType
	end

	return false
end)

exports("Exit", function(source)
	exports["sandbox-base"]:RoutePlayerToGlobalRoute(source)
	GlobalState[string.format("%s:", source)] = nil
	exports['sandbox-pwnzor']:TempPosIgnore(source)
	Player(source).state.inApartment = nil
	Player(source).state.tpLocation = nil

	return true
end)

exports("GetInteriorLocation", function(apartment)
	local apartment = GlobalState[string.format("Apartment:%s", apartment or 1)]
	if apartment and apartment.interior and apartment.interior.spawn then
		return apartment.interior.spawn
	end
	return nil
end)

exports("RequestsGet", function(source)
	if GlobalState[string.format("%s:", source)] ~= nil then
		return _requests[GlobalState[string.format("%s:", source)]]
	else
		return {}
	end
end)

exports("RequestsCreate", function(source, target, inZone)
	if source == target then return end

	local char = exports['sandbox-characters']:FetchCharacterSource(source)
	local tChar = exports['sandbox-characters']:FetchBySID(target)

	if tChar ~= nil and string.format("apt-%s", tChar:GetData("Apartment") or 1) == inZone then
		_requests[target] = _requests[target] or {}
		for k, v in ipairs(_requests[target]) do
			if v.source == source then
				return
			end
		end

		_requestors[source] = target
		table.insert(_requests[target], {
			source = source,
			SID = char:GetData("SID"),
			First = char:GetData("First"),
			Last = char:GetData("Last"),
		})
	end
end)

exports("ClientEnter", function(source, targetType, target, wakeUp)
	TriggerClientEvent("Apartment:Client:Enter", source, targetType, target, wakeUp)
end)
