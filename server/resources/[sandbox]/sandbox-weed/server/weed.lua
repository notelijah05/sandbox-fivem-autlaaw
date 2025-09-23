_plants = {}

AddEventHandler("Weed:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Locations = exports["sandbox-base"]:FetchComponent("Locations")
	Weed = exports["sandbox-base"]:FetchComponent("Weed")
	Routing = exports["sandbox-base"]:FetchComponent("Routing")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	Routing = exports["sandbox-base"]:FetchComponent("Routing")
	Tasks = exports["sandbox-base"]:FetchComponent("Tasks")
	Wallet = exports["sandbox-base"]:FetchComponent("Wallet")
	Reputation = exports["sandbox-base"]:FetchComponent("Reputation")
	WaitList = exports["sandbox-base"]:FetchComponent("WaitList")
	Status = exports["sandbox-base"]:FetchComponent("Status")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Weed", {
		"Locations",
		"Routing",
		"Weed",
		"Inventory",
		"Routing",
		"Tasks",
		"Wallet",
		"Reputation",
		"WaitList",
		"Status",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()
		Startup()
		RegisterMiddleware()
		RegisterCallbacks()
		RegisterTasks()
		RegisterItems()
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Weed", WEED)
end)

function getStageByPct(pct)
	local stagePct = 100 / (#Plants - 1)
	return math.floor((pct / stagePct) + 1.5)
end

function checkNearPlant(source, id)
	local coords = GetEntityCoords(GetPlayerPed(source))
	if _plants[id] ~= nil then
		return #(
			vector3(coords.x, coords.y, coords.z)
			- vector3(_plants[id].plant.location.x, _plants[id].plant.location.y, _plants[id].plant.location.z)
		) <= 5
	else
		return false
	end
end

WEED = {
	Planting = {
		Set = function(self, id, isUpdate, skipEvent)
			if _plants[id] ~= nil then
				local stage = getStageByPct(_plants[id].plant.growth)
				_plants[id].stage = stage

				if skipEvent then
					return { id = id, plant = _plants[id], update = isUpdate }
				else
					TriggerClientEvent("Weed:Client:Objects:Update", -1, id, _plants[id], isUpdate)
				end
			end
		end,
		Delete = function(self, id, skipRemove)
			if _plants[id] ~= nil then
				_plants[id] = nil
				TriggerClientEvent("Weed:Client:Objects:Delete", -1, id)
			end
		end,
		Create = function(self, isMale, location, material)
			local p = promise.new()
			local weed = {
				isMale = isMale,
				location = location,
				growth = 0,
				output = 1,
				material = material,
				planted = os.time(),
				water = 100.0,
			}
			MySQL.insert(
				'INSERT INTO weed (is_male, x, y, z, growth, output, material, planted, water) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
				{
					isMale and 1 or 0,
					location.x, location.y, location.z,
					0, 1, material, weed.planted, 100.0
				}, function(insertId)
					if not insertId then
						return p:resolve(nil)
					end
					weed._id = insertId
					return p:resolve(weed)
				end)
			return Citizen.Await(p)
		end,
	},
}
