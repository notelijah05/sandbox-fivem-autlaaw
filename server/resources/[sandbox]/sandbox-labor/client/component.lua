AddEventHandler("Labor:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	PedInteraction = exports["sandbox-base"]:FetchComponent("PedInteraction")
	Minigame = exports["sandbox-base"]:FetchComponent("Minigame")
	Polyzone = exports["sandbox-base"]:FetchComponent("Polyzone")
	Targeting = exports["sandbox-base"]:FetchComponent("Targeting")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	EmergencyAlerts = exports["sandbox-base"]:FetchComponent("EmergencyAlerts")
	Status = exports["sandbox-base"]:FetchComponent("Status")
	Labor = exports["sandbox-base"]:FetchComponent("Labor")
	Properties = exports["sandbox-base"]:FetchComponent("Properties")
	Reputation = exports["sandbox-base"]:FetchComponent("Reputation")
	Vehicles = exports["sandbox-base"]:FetchComponent("Vehicles")
	Animations = exports["sandbox-base"]:FetchComponent("Animations")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Labor", {
		"PedInteraction",
		"Minigame",
		"Polyzone",
		"Targeting",
		"Inventory",
		"EmergencyAlerts",
		"Status",
		"Labor",
		"Properties",
		"Reputation",
		"Vehicles",
		"Animations",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()
		TriggerEvent("Labor:Client:Setup")
	end)
end)

function Draw3DText(x, y, z, text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local px, py, pz = table.unpack(GetGameplayCamCoords())

	SetTextScale(0.25, 0.25)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 245)
	SetTextOutline(true)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x, _y)
end

function PedFaceCoord(pPed, pCoords)
	TaskTurnPedToFaceCoord(pPed, pCoords.x, pCoords.y, pCoords.z)

	Wait(100)

	while GetScriptTaskStatus(pPed, 0x574bb8f5) == 1 do
		Wait(0)
	end
end

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Labor", LABOR)
end)

AddEventHandler("Labor:Client:AcceptRequest", function(data)
	exports["sandbox-base"]:ServerCallback("Labor:AcceptRequest", data)
end)

AddEventHandler("Labor:Client:DeclineRequest", function(data)
	exports["sandbox-base"]:ServerCallback("Labor:DeclineRequest", data)
end)

LABOR = {
	Get = {
		Jobs = function(self)
			local p = promise.new()
			exports["sandbox-base"]:ServerCallback("Labor:GetJobs", {}, function(jobs)
				p:resolve(jobs)
			end)
			return Citizen.Await(p)
		end,
		Groups = function(self)
			local p = promise.new()
			exports["sandbox-base"]:ServerCallback("Labor:GetGroups", {}, function(groups)
				p:resolve(groups)
			end)
			return Citizen.Await(p)
		end,
		Reputations = function(self)
			local p = promise.new()
			exports["sandbox-base"]:ServerCallback("Labor:GetReputations", {}, function(jobs)
				p:resolve(jobs)
			end)
			return Citizen.Await(p)
		end,
	},
}
