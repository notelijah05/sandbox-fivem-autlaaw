_todaysDayNumber = nil
_existingTree = nil

AddEventHandler("Core:Shared:Ready", function()
	TriggerEvent("Xmas:Client:RegisterStartups")
end)

RegisterNetEvent("Xmas:Client:Init", function(dayNumber, tree, hasLooted)
	exports['sandbox-targeting']:ZonesAddBox("legion-present", "gift", vector3(184.33, -963.19, 30.1), 3.0, 5.8, {
		heading = 331,
		--debugPoly=true,
		minZ = 28.7,
		maxZ = 31.9,
	}, {
		{
			icon = "gift",
			text = "Pickup Daily Gift",
			event = "Xmas:Client:Daily",
			isEnabled = function()
				local xmasDaily = LocalPlayer.state.Character:GetData("XmasDaily")
				local xmasDailyCount = LocalPlayer.state.Character:GetData("XmasDailyCount") or 0
				return xmasDaily ~= _todaysDayNumber
					and (
						(_todaysDayNumber ~= 25 and xmasDailyCount < 1)
						or (_todaysDayNumber == 25 and xmasDailyCount < 3)
					)
			end,
		},
	}, 3.0, true)
	exports['sandbox-targeting']:ZonesRefresh()

	_todaysDayNumber = dayNumber
	SetupTree(tree, hasLooted)
end)

RegisterNetEvent("Xmas:Client:NewTree", function(tree)
	if LocalPlayer.state.loggedIn then
		SetupTree(tree, false)
		exports["sandbox-sounds"]:PlayOne("xmas.ogg", 0.05)
	end
end)

RegisterNetEvent("Characters:Client:Logout", function()
	if _existingTree ~= nil then
		DeleteEntity(_existingTree.entity)
		exports['sandbox-targeting']:RemoveEntity(_existingTree.entity)
		_existingTree = nil
	end
end)

AddEventHandler("Xmas:Client:Daily", function()
	exports['sandbox-hud']:Progress({
		name = "xmas",
		duration = 15000,
		label = "Picking Up Present",
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
			anim = "machinic_loop_mechandplayer",
			flags = 49,
		},
	}, function(cancelled)
		if not cancelled then
			exports["sandbox-base"]:ServerCallback("Xmas:Daily", {})
		end
	end)
end)

AddEventHandler("Xmas:Client:Tree", function()
	exports['sandbox-hud']:Progress({
		name = "xmas",
		duration = 15000,
		label = "Picking Up Present",
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
			anim = "machinic_loop_mechandplayer",
			flags = 49,
		},
	}, function(cancelled)
		if not cancelled then
			exports["sandbox-base"]:ServerCallback("Xmas:Tree", {}, function(s)
				_existingTree.hasLooted = s
			end)
		end
	end)
end)
