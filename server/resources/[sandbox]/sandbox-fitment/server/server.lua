AddEventHandler("Core:Shared:Ready", function()
	exports['sandbox-inventory']:RegisterUse("camber_controller", "Vehicles", function(source, item)
		exports["sandbox-base"]:ClientCallback(source, "Vehicles:UseCamberController", {}, function(veh)
			if not veh then
				return
			end
			veh = NetworkGetEntityFromNetworkId(veh)
			if veh and DoesEntityExist(veh) then
				local vehState = Entity(veh).state
				if not vehState.VIN then
					return
				end

				TriggerClientEvent("Fitment:Client:CamberController:UseItem", source)
			end
		end)
	end)
end)
