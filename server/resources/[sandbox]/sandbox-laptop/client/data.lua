RegisterNetEvent("Laptop:Client:SetData", function(type, data, options)
	while Laptop == nil do
		Wait(10)
	end
	exports['sandbox-laptop']:SetData(type, data)
end)

RegisterNetEvent("Laptop:Client:AddData", function(type, data, id)
	exports['sandbox-laptop']:AddData(type, data, id)
end)

RegisterNetEvent("Laptop:Client:UpdateData", function(type, id, data)
	exports['sandbox-laptop']:UpdateData(type, id, data)
end)

RegisterNetEvent("Laptop:Client:RemoveData", function(type, id)
	exports['sandbox-laptop']:RemoveData(type, id)
end)

RegisterNetEvent("Laptop:Client:ResetData", function()
	exports['sandbox-laptop']:ResetData()
end)

RegisterNetEvent("Characters:Client:Logout", function()
	SendNUIMessage({ type = "LAPTOP_NOT_VISIBLE" })
	exports['sandbox-laptop']:ResetData()
	exports['sandbox-laptop']:ResetNotifications()
	exports['sandbox-laptop']:ResetRoute()
	SendNUIMessage({ type = "CLOSE_ALL_APPS" })
end)
