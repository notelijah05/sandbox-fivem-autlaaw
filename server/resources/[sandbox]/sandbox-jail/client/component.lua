_inPickup = false
_inLogout = false
_doingMugshot = false

AddEventHandler("Jail:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Characters = exports["sandbox-base"]:FetchComponent("Characters")
	Jail = exports["sandbox-base"]:FetchComponent("Jail")
	Reputation = exports["sandbox-base"]:FetchComponent("Reputation")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Jail", {
		"Characters",
		"Reputation",
		"Jail",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()

		exports["sandbox-blips"]:Add("prison", "Bolingbroke Penitentiary", vector3(1852.444, 2585.973, 45.672), 188, 65,
			0.8)

		exports['sandbox-polyzone']:CreatePoly("prison", Config.Prison.points, Config.Prison.options)
		exports['sandbox-polyzone']:CreatePoly("prison-logout", Config.Logout.points, Config.Logout.options)
		exports['sandbox-polyzone']:CreateBox(
			"prison-pickup",
			Config.Pickup.coords,
			Config.Pickup.length,
			Config.Pickup.width,
			Config.Pickup.options
		)

		exports['sandbox-targeting']:ZonesAddBox(
			string.format("bb-retreive", aptId),
			"hands-holding",
			Config.Retreival.coords,
			Config.Retreival.length,
			Config.Retreival.width,
			Config.Retreival.options,
			{
				{
					icon = "hand-holding",
					text = "Retrieve Items",
					event = "Jail:Client:RetreiveItems",
					isEnabled = function()
						return _inPickup
					end,
				},
			},
			3.0,
			true
		)

		exports['sandbox-targeting']:ZonesAddBox(
			string.format("prison-inmates-list"),
			"clipboard",
			Config.VisitorLog.coords,
			Config.VisitorLog.length,
			Config.VisitorLog.width,
			Config.VisitorLog.options,
			{
				{
					icon = "users-viewfinder",
					text = "View Inmates",
					event = "Jail:Client:ViewInmates",
				},
			},
			3.0,
			true
		)

		exports['sandbox-targeting']:ZonesAddBox(
			"prison-check",
			"police-box",
			Config.Payphone.coords,
			Config.Payphone.length,
			Config.Payphone.width,
			Config.Payphone.options,
			{
				{
					icon = "stopwatch",
					text = "Check Remaining Sentence",
					event = "Jail:Client:CheckSentence",
					isEnabled = function()
						return Jail:IsJailed()
					end,
				},
				{
					icon = "person-from-portal",
					text = "Process Release",
					event = "Jail:Client:Released",
					isEnabled = function()
						return Jail:IsJailed() and Jail:IsReleaseEligible()
					end,
				},
			},
			3.0,
			true
		)

		exports['sandbox-targeting']:ZonesAddBox(
			"prison-food",
			"fork-knife",
			Config.Cafeteria.Food.coords,
			Config.Cafeteria.Food.length,
			Config.Cafeteria.Food.width,
			Config.Cafeteria.Food.options,
			{
				{
					text = "Make Food",
					event = "Jail:Client:MakeFood",
				},
			},
			3.0,
			true
		)

		exports['sandbox-targeting']:ZonesAddBox(
			"prison-drink",
			"cup-straw-swoosh",
			Config.Cafeteria.Drink.coords,
			Config.Cafeteria.Drink.length,
			Config.Cafeteria.Drink.width,
			Config.Cafeteria.Drink.options,
			{
				{
					text = "Make Drink",
					event = "Jail:Client:MakeDrink",
				},
			},
			3.0,
			true
		)

		exports['sandbox-targeting']:ZonesAddBox(
			"prison-juice",
			"cup-straw-swoosh",
			Config.Cafeteria.Juice.coords,
			Config.Cafeteria.Juice.length,
			Config.Cafeteria.Juice.width,
			Config.Cafeteria.Juice.options,
			{
				{
					text = "Make Fruit Punch",
					event = "Jail:Client:MakeJuice",
					data = {
						name = "fruitpunchslushie",
					},
				},
				{
					text = "Make BerryRazz",
					event = "Jail:Client:MakeJuice",
					data = {
						name = "beatdownberryrazz",
					},
				},
			},
			3.0,
			true
		)

		exports['sandbox-targeting']:ZonesAddBox(
			"prison-payphone",
			"square-phone-flip",
			Config.Payphones.coords,
			Config.Payphones.length,
			Config.Payphones.width,
			Config.Payphones.options,
			{
				{
					text = "Use Payphone",
					event = "Phone:Client:OpenLimited",
				},
			},
			3.0,
			true
		)

		exports['sandbox-pedinteraction']:Add("PrisonJobs", `csb_janitor`, Config.Foreman.coords, Config.Foreman.heading,
			25.0, {
				{
					icon = "clipboard-check",
					text = "Start Work",
					event = "Jail:Client:StartWork",
					data = {},
					isEnabled = function()
						return LocalPlayer.state.Character:GetData("TempJob") == nil
					end,
				},
				{
					icon = "clipboard",
					text = "Quit Work",
					event = "Jail:Client:QuitWork",
					tempjob = "Prison",
					data = {},
				},
			}, "user-helmet-safety", "WORLD_HUMAN_JANITOR")

		exports["sandbox-base"]:RegisterClientCallback("Jail:DoMugshot", function(data, cb)
			_disabled = true
			_doingMugshot = true

			exports['sandbox-phone']:Close()
			exports['sandbox-hud']:InteractionHide()
			exports['sandbox-inventory']:CloseAll()

			DoScreenFadeOut(1000)
			while not IsScreenFadedOut() do
				Wait(10)
			end

			exports['sandbox-animations']:EmotesPlay("mugshot", false, -1, true)

			DoBoardShit(data.jailer, data.duration, data.date)
			DisableControls()
			SetEntityCoords(
				LocalPlayer.state.ped,
				Config.Mugshot.coords.x,
				Config.Mugshot.coords.y,
				Config.Mugshot.coords.z,
				0,
				0,
				0,
				false
			)
			Wait(100)
			SetEntityHeading(LocalPlayer.state.ped, Config.Mugshot.headings[1])
			FreezeEntityPosition(LocalPlayer.state.ped, true)

			DoScreenFadeIn(1000)
			while not IsScreenFadedIn() do
				Wait(10)
			end

			exports["sandbox-sounds"]:PlayOne("mugshot.ogg", 0.2)
			Wait(2000)
			for i = 2, #Config.Mugshot.headings do
				if LocalPlayer.state.loggedIn then
					SetEntityHeading(LocalPlayer.state.ped, Config.Mugshot.headings[i])
					Wait(1000)
					exports["sandbox-sounds"]:PlayOne("mugshot.ogg", 0.2)
					Wait(3000)
				end
			end

			SetEntityHeading(LocalPlayer.state.ped, Config.Mugshot.headings[1])
			exports["sandbox-sounds"]:PlayOne("mugshot.ogg", 0.2)
			Wait(2000)

			exports['sandbox-animations']:EmotesForceCancel()
			_doingMugshot = false

			DoScreenFadeOut(1000)
			while not IsScreenFadedOut() do
				Wait(10)
			end

			FreezeEntityPosition(LocalPlayer.state.ped, false)
			cb()
		end)
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Jail", _JAIL)
end)

_JAIL = {
	IsJailed = function(self)
		if LocalPlayer.state.Character == nil then
			return false
		else
			local jailed = LocalPlayer.state.Character:GetData("Jailed")
			if jailed and not jailed.Released then
				return true
			else
				return false
			end
		end
	end,
	IsReleaseEligible = function(self)
		local jailed = LocalPlayer.state.Character:GetData("Jailed")
		if jailed and jailed.Duration < 9999 and GetCloudTimeAsInt() >= (jailed.Release or 0) then
			return true
		else
			return false
		end
	end,
}
