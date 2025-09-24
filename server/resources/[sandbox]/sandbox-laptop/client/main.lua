_openCd = false -- Prevents spamm open/close
_settings = {}
_loggedIn = false

local _ignoreEvents = {
	"Health",
	"HP",
	"Armor",
	"Status",
	"Damage",
	"Wardrobe",
	"Animations",
	"Ped",
}

AddEventHandler("Laptop:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Labor = exports["sandbox-base"]:FetchComponent("Labor")
	Jail = exports["sandbox-base"]:FetchComponent("Jail")
	Reputation = exports["sandbox-base"]:FetchComponent("Reputation")
	Laptop = exports["sandbox-base"]:FetchComponent("Laptop")
	Properties = exports["sandbox-base"]:FetchComponent("Properties")
	Admin = exports["sandbox-base"]:FetchComponent("Admin")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Laptop", {
		"Labor",
		"Jail",
		"Reputation",
		"Properties",
		"Admin",
		"Laptop",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()

		exports["sandbox-keybinds"]:Add("laptop_open", "", "keyboard", "Laptop - Open", function()
			OpenLaptop()
		end)

		RegisterBoostingCallbacks()
	end)
end)

function OpenLaptop()
	if
		_loggedIn
		and not exports['sandbox-hud']:IsDisabled()
		and not Jail:IsJailed()
		and hasValue(LocalPlayer.state.Character:GetData("States"), "LAPTOP")
		and not LocalPlayer.state.laptopOpen
	then
		Laptop:Open()
	end
end

RegisterNetEvent("Laptop:Client:Open", OpenLaptop)

AddEventHandler("Inventory:Client:ItemsLoaded", function()
	while Laptop == nil do
		Wait(10)
	end
	Laptop.Data:Set("items", exports['sandbox-inventory']:ItemsGetData())
end)

AddEventHandler("Characters:Client:Updated", function(key)
	if hasValue(_ignoreEvents, key) then
		return
	end
	_settings = LocalPlayer.state.Character:GetData("LaptopSettings")
	Laptop.Data:Set("player", LocalPlayer.state.Character:GetData())

	if
		key == "States"
		and LocalPlayer.state.laptopOpen
		and (not hasValue(LocalPlayer.state.Character:GetData("States"), "LAPTOP"))
	then
		Laptop:Close(true)
	end
end)

AddEventHandler("Ped:Client:Died", function()
	Laptop:Close(true)
end)

RegisterNetEvent("Job:Client:DutyChanged", function(state)
	Laptop.Data:Set("onDuty", state)
end)

RegisterNetEvent("UI:Client:Reset", function(manual)
	SetNuiFocus(false, false)
	SendNUIMessage({
		type = "UI_RESET",
		data = {},
	})

	if manual then
		TriggerServerEvent("Laptop:Server:UIReset")
		if LocalPlayer.state.tabletOpen then
			Laptop:Close()
		end
	end
end)

AddEventHandler("UI:Client:Close", function(context)
	if context ~= "laptop" then
		Laptop:Close()
	end
end)

AddEventHandler("Ped:Client:Died", function()
	if LocalPlayer.state.laptopOpen then
		Laptop:Close()
	end
end)

RegisterNetEvent("Laptop:Client:SetApps", function(apps)
	LAPTOP_APPS = apps
	SendNUIMessage({
		type = "SET_APPS",
		data = apps,
	})
end)

AddEventHandler("Characters:Client:Spawn", function()
	_loggedIn = true

	CreateThread(function()
		while _loggedIn do
			SendNUIMessage({
				type = "SET_TIME",
				data = GlobalState["Sync:Time"],
			})
			Wait(15000)
		end
	end)
end)

RegisterNetEvent("Characters:Client:Logout", function()
	_loggedIn = false
end)

function hasValue(tbl, value)
	for k, v in ipairs(tbl or {}) do
		if v == value or (type(v) == "table" and hasValue(v, value)) then
			return true
		end
	end
	return false
end

RegisterNUICallback("AcceptPopup", function(data, cb)
	cb("OK")
	if data.data ~= nil and data.data.server then
		TriggerServerEvent(data.event, data.data)
	else
		TriggerEvent(data.event, data.data)
	end
end)

RegisterNUICallback("CancelPopup", function(data, cb)
	cb("OK")
	if data.data ~= nil and data.data.server then
		TriggerServerEvent(data.event, data.data)
	else
		TriggerEvent(data.event, data.data)
	end
end)

RegisterNUICallback("CDExpired", function(data, cb)
	cb("OK")
	_openCd = false
end)
