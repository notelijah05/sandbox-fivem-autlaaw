AddEventHandler("Arcade:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Status = exports["sandbox-base"]:FetchComponent("Status")
	Jail = exports["sandbox-base"]:FetchComponent("Jail")
	Animations = exports["sandbox-base"]:FetchComponent("Animations")
	Jobs = exports["sandbox-base"]:FetchComponent("Jobs")
	Arcade = exports["sandbox-base"]:FetchComponent("Arcade")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Arcade", {
		"Status",
		"Jail",
		"Animations",
		"Jobs",
		"Arcade",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()

		TriggerEvent("Arcade:Client:Setup")

		exports['sandbox-pedinteraction']:Add("ArcadeMaster", `cs_jimmydisanto`, vector3(-1658.916, -1062.421, 11.160),
			228.868, 25.0, {
				{
					icon = "clipboard-check",
					text = "Clock In",
					event = "Arcade:Client:ClockIn",
					data = { job = "avast_arcade" },
					jobPerms = {
						{
							job = "avast_arcade",
							reqOffDuty = true,
						},
					},
				},
				{
					icon = "clipboard",
					text = "Clock Out",
					event = "Arcade:Client:ClockOut",
					data = { job = "avast_arcade" },
					jobPerms = {
						{
							job = "avast_arcade",
							reqDuty = true,
						},
					},
				},
				{
					icon = "heart-pulse",
					text = "Open Arcade",
					event = "Arcade:Client:Open",
					jobPerms = {
						{
							job = "avast_arcade",
							reqDuty = true,
						},
					},
					isEnabled = function()
						return not GlobalState["Arcade:Open"]
					end,
				},
				{
					icon = "heart-pulse",
					text = "Close Arcade",
					event = "Arcade:Client:Close",
					jobPerms = {
						{
							job = "arcade",
							reqDuty = true,
						},
					},
					isEnabled = function()
						return GlobalState["Arcade:Open"]
					end,
				},
				{
					icon = "heart-pulse",
					text = "Create New Game",
					event = "Arcade:Client:CreateNew",
					isEnabled = function()
						return GlobalState["Arcade:Open"]
					end,
				},
			}, "joystick", "WORLD_HUMAN_STAND_IMPATIENT")
	end)
end)

AddEventHandler("Arcade:Client:ClockIn", function(_, data)
	if data and data.job then
		Jobs.Duty:On(data.job)
	end
end)

AddEventHandler("Arcade:Client:ClockOut", function(_, data)
	if data and data.job then
		Jobs.Duty:Off(data.job)
	end
end)

AddEventHandler("Arcade:Client:Open", function()
	exports["sandbox-base"]:ServerCallback("Arcade:Open", false, function() end)
end)

AddEventHandler("Arcade:Client:Close", function()
	exports["sandbox-base"]:ServerCallback("Arcade:Close", false, function() end)
end)

AddEventHandler("Arcade:Client:CreateNew", function(entity, data)
	exports['sandbox-hud']:InputShow("Create New Match", "Match Configuration", {
		{
			id = "gamemode",
			type = "select",
			select = {
				{
					label = "Team Deathmatch",
					value = "tdm",
				},
			},
			options = {},
		},
		{
			id = "map",
			type = "select",
			select = {
				{
					label = "Random",
					value = "random",
				},
				{
					label = "Legion Square",
					value = "legionsquare",
				},
			},
			options = {},
		},
	}, "Arcade:Client:SubmitGame", data)
end)

_ARCADE = {
	Gamemode = {
		Register = function(self, id, label) end,
	},
}

AddEventHandler("Proxy:Shared:RegisterReady", function(component)
	exports["sandbox-base"]:RegisterComponent("Arcade", _ARCADE)
end)
