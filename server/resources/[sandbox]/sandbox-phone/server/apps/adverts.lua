local _adverts = {
	["0"] = {},
	-- Lua, Suck My Dick
}

exports("AdvertsCreate", function(source, advert)
	_adverts[source] = advert
	TriggerClientEvent("Phone:Client:AddData", -1, "adverts", advert, source)
end)

exports("AdvertsUpdate", function(source, advert)
	_adverts[source] = advert
	TriggerClientEvent("Phone:Client:UpdateData", -1, "adverts", source, advert)
end)

exports("AdvertsDelete", function(source)
	if _adverts[source] ~= nil then
		_adverts[source] = nil
		TriggerClientEvent("Phone:Client:RemoveData", -1, "adverts", source)
	end
end)

AddEventHandler("Phone:Server:RegisterCallbacks", function()
	exports["sandbox-base"]:RegisterServerCallback("Phone:Adverts:Create", function(source, data, cb)
		exports['sandbox-phone']:AdvertsCreate(source, data)
	end)
	exports["sandbox-base"]:RegisterServerCallback("Phone:Adverts:Update", function(source, data, cb)
		exports['sandbox-phone']:AdvertsUpdate(source, data)
	end)
	exports["sandbox-base"]:RegisterServerCallback("Phone:Adverts:Delete", function(source, data, cb)
		exports['sandbox-phone']:AdvertsDelete(source)
	end)
end)

AddEventHandler("Phone:Server:RegisterMiddleware", function()
	exports['sandbox-base']:MiddlewareAdd("Phone:Spawning", function(source, char)
		return {
			{
				type = "adverts",
				data = _adverts,
			},
		}
	end)
end)

AddEventHandler("Characters:Server:PlayerLoggedOut", function(source, cData)
	exports['sandbox-phone']:AdvertsDelete(source)
end)

AddEventHandler("Characters:Server:PlayerDropped", function(source, cData)
	exports['sandbox-phone']:AdvertsDelete(source)
end)
