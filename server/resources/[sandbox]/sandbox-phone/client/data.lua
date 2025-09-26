RegisterNetEvent("Phone:Client:SetData", function(type, data, options)
	exports['sandbox-phone']:DataSet(type, data)
end)

RegisterNetEvent("Phone:Client:SetDataMulti", function(data)
	for k, v in ipairs(data) do
		exports['sandbox-phone']:DataSet(v.type, v.data)
	end
end)

RegisterNetEvent("Phone:Client:AddData", function(type, data, id)
	exports['sandbox-phone']:DataAdd(type, data, id)
end)

RegisterNetEvent("Phone:Client:UpdateData", function(type, id, data)
	exports['sandbox-phone']:DataUpdate(type, id, data)
end)

RegisterNetEvent("Phone:Client:RemoveData", function(type, id)
	exports['sandbox-phone']:DataRemove(type, id)
end)

RegisterNetEvent("Phone:Client:ResetData", function()
	exports['sandbox-phone']:DataReset()
end)

RegisterNetEvent("Characters:Client:Logout", function()
	SendNUIMessage({ type = "PHONE_NOT_VISIBLE" })
	exports['sandbox-phone']:DataReset()
	exports['sandbox-phone']:NotificationReset()
	exports['sandbox-phone']:ResetRoute()
end)
