_evald = {}

AddEventHandler("Police:Shared:DependencyUpdate", EMSComponents)
function EMSComponents()
	Damage = exports["sandbox-base"]:FetchComponent("Damage")
end

local _calledForHelp = false
AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("EMS", {
		"Damage",
	}, function(error)
		if #error > 0 then
			return
		end
		EMSComponents()

		exports['sandbox-hud']:InteractionRegisterMenu("call-911", "Call For Help", "siren-on", function(data)
			exports['sandbox-hud']:InteractionHide()
			TriggerServerEvent("EMS:Server:RequestHelp")
			_calledForHelp = GetCloudTimeAsInt() + (60 * 5)
		end, function()
			return LocalPlayer.state.onDuty ~= "ems"
				and LocalPlayer.state.onDuty ~= "police"
				and LocalPlayer.state.isDead
				and GetCloudTimeAsInt() > LocalPlayer.state.isDeadTime + (60 * 2)
				and (not _calledForHelp or GetCloudTimeAsInt() > _calledForHelp)
		end)

		exports['sandbox-hud']:InteractionRegisterMenu("ems", false, "siren-on", function(data)
			exports['sandbox-hud']:InteractionShowMenu({
				{
					icon = "siren-on",
					label = "13-A",
					action = function()
						exports['sandbox-hud']:InteractionHide()
						TriggerServerEvent("EMS:Server:Panic", true)
					end,
					shouldShow = function()
						return LocalPlayer.state.isDead
					end,
				},
				{
					icon = "siren",
					label = "13-B",
					action = function()
						exports['sandbox-hud']:InteractionHide()
						TriggerServerEvent("EMS:Server:Panic", false)
					end,
					shouldShow = function()
						return LocalPlayer.state.isDead
					end,
				},
			})
		end, function()
			return LocalPlayer.state.onDuty == "ems" and LocalPlayer.state.onDuty and LocalPlayer.state.isDead
		end)

		exports['sandbox-hud']:InteractionRegisterMenu("ems-utils", "EMS Utilities", "tablet-rugged", function(data)
			exports['sandbox-hud']:InteractionShowMenu({
				{
					icon = "tablet-screen-button",
					label = "MDT",
					action = function()
						exports['sandbox-hud']:InteractionHide()
						TriggerEvent("MDT:Client:Toggle")
					end,
					shouldShow = function()
						return LocalPlayer.state.onDuty == "ems"
					end,
				},
				{
					icon = "video",
					label = "Toggle Body Cam",
					action = function()
						exports['sandbox-hud']:InteractionHide()
						TriggerEvent("MDT:Client:ToggleBodyCam")
					end,
					shouldShow = function()
						return LocalPlayer.state.onDuty == "ems"
					end,
				},
			})
		end, function()
			return LocalPlayer.state.onDuty == "ems"
		end)

		exports["sandbox-base"]:RegisterClientCallback("EMS:ApplyBandage", function(data, cb)
			SetEntityHealth(LocalPlayer.state.ped, GetEntityHealth(LocalPlayer.state.ped) + 10)
			cb(true)
		end)

		exports["sandbox-base"]:RegisterClientCallback("EMS:Heal", function(data, cb)
			SetEntityHealth(LocalPlayer.state.ped, GetEntityHealth(LocalPlayer.state.ped) + data)
			cb(true)
		end)
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("EMS", _EMS)
end)

_EMS = {
	HaveEvaluated = function(self, id)
		return _evald[id] ~= nil and _evald[id] > GetGameTimer()
	end,
}

RegisterNetEvent("Characters:Client:Spawn", function()
	exports["sandbox-blips"]:Add("st_fiacre", "Hospital", vector3(1149.516, -1531.912, 35.381), 61, 42, 0.8)
	-- exports["sandbox-blips"]:Add("mt_zonah", "Hospital", vector3(-457.019, -333.263, 69.521), 61, 42, 0.8)
	-- exports["sandbox-blips"]:Add("pb_hospital", "Hospital", vector3(297.840, -584.339, 43.261), 61, 42, 0.8)
end)
