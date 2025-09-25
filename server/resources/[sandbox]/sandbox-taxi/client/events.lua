local _inVeh = nil

AddEventHandler("Vehicles:Client:EnterVehicle", function(currentVehicle, currentSeat)
	if currentSeat == -1 and _models[GetEntityModel(currentVehicle)] then
		exports['sandbox-taxi']:HudShow()
	end
end)

AddEventHandler("Vehicles:Client:ExitVehicle", function()
	_inVeh = nil
	exports['sandbox-taxi']:HudHide()
end)

RegisterNetEvent("UI:Client:Reset", function(force)
	_inVeh = nil
	exports['sandbox-taxi']:HudReset()
end)
