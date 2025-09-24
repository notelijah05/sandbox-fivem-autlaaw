local _timeout = false

AddEventHandler("Escort:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Targeting = exports["sandbox-base"]:FetchComponent("Targeting")
	Escort = exports["sandbox-base"]:FetchComponent("Escort")
	Vehicles = exports["sandbox-base"]:FetchComponent("Vehicles")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Escort", {
		"Targeting",
		"Escort",
		"Vehicles",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()

		exports["sandbox-keybinds"]:Add("escort", "k", "keyboard", "Escort", function()
			if _timeout then
				exports["sandbox-hud"]:NotifError("Stop spamming you pepega.")
				return
			end
			_timeout = true
			DoEscort()
			Citizen.SetTimeout(1000, function()
				_timeout = false
			end)
		end)

		exports["sandbox-base"]:RegisterClientCallback("Escort:StopEscort", function(data, cb)
			DetachEntity(LocalPlayer.state.ped, true, true)
			cb(true)
		end)
	end)
end)

ESCORT = {
	DoEscort = function(self, target, tPlayer)
		if target ~= nil then
			if LocalPlayer.state.AllowEscorting == false then
				exports["sandbox-hud"]:NotifError("Unable to escort in this location.")
				return
			end
			exports["sandbox-base"]:ServerCallback("Escort:DoEscort", {
				target = target,
				inVeh = IsPedInAnyVehicle(GetPlayerPed(tPlayer)),
				isSwimming = IsPedSwimming(LocalPlayer.state.ped),
			}, function(state)
				if state then
					StartEscortThread(tPlayer)
				end
			end)
		end
	end,
	StopEscort = function(self)
		exports["sandbox-base"]:ServerCallback("Escort:StopEscort", function() end)
	end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Escort", ESCORT)
end)

AddEventHandler("Interiors:Exit", function()
	if LocalPlayer.state.isEscorting ~= nil then
		Escort:StopEscort()
	end
end)

--[[ TODO
Add Dragging When Dead
Place In vehicle while Dead Slump Animation
Police Drag Maybe Cuff Also
Get In Trunk or Place in trunk???
]]
