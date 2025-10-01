characterLoaded = false
_withinShowroom = false
_withinCatalog = false

_justBoughtFuckingBike = {}

AddEventHandler('onClientResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Wait(1000)
		CreateDealerships()

		CreateRentalSpots()
		CreateBikeStands()
		CreateGovermentFleetShops()

		CreateDonorDealerships()
	end
end)

RegisterNetEvent("Characters:Client:Spawn")
AddEventHandler("Characters:Client:Spawn", function()
	characterLoaded = true

	CreateDealershipBlips()
	CreateRentalSpotsBlips()
	CreateBikeStandBlips()
end)

RegisterNetEvent("Characters:Client:Logout")
AddEventHandler("Characters:Client:Logout", function()
	characterLoaded = false

	_justBoughtFuckingBike = {}
end)

function CreatePolyzone(id, zone, data)
	if zone.type == "poly" then
		exports['sandbox-polyzone']:CreatePoly("dealerships_" .. id, zone.points, zone.options, data)
	elseif zone.type == "box" then
		exports['sandbox-polyzone']:CreateBox("dealerships_" .. id, zone.center, zone.length, zone.width, zone.options,
			data)
	elseif zone.type == "circle" then
		exports['sandbox-polyzone']:CreateCircle("dealerships_" .. id, zone.center, zone.radius, zone.options, data)
	end
end

function CreateDealerships()
	for dealerId, data in pairs(_dealerships) do
		-- Polyzones
		if data.zones then
			if data.zones.dealership then
				CreatePolyzone(dealerId .. "_main", data.zones.dealership, {
					dealer = true,
					dealerId = dealerId,
					type = "main",
				})
			end

			if #data.zones.catalog > 0 then
				for k, v in ipairs(data.zones.catalog) do
					CreatePolyzone((dealerId .. "_catalog_" .. k), v, {
						dealer = true,
						dealerId = dealerId,
						type = "catalog",
					})
				end
			end

			if data.zones.buyback then
				CreatePolyzone(dealerId .. "_buyback", data.zones.buyback, {
					dealer = true,
					dealerId = dealerId,
					type = "buyback",
					dealerBuyback = true,
				})
			end
		end

		-- Targets
		if data.zones and #data.zones.employeeInteracts > 0 then
			for k, v in ipairs(data.zones.employeeInteracts) do
				exports.ox_target:addBoxZone({
					id = string.format("dealership_%s_employee_%s", dealerId, k),
					coords = v.center,
					size = vector3(v.length, v.width, 2.0),
					rotation = v.options.heading or 0,
					debug = false,
					minZ = v.options.minZ,
					maxZ = v.options.maxZ,
					options = {
						{
							icon = "car-garage",
							label = "Edit Showroom",
							event = "Dealerships:Client:ShowroomManagement",
							onSelect = function()
								TriggerEvent("Dealerships:Client:ShowroomManagement", { dealerId = dealerId })
							end,
							groups = { dealerId },
							reqDuty = true,
							canInteract = function()
								return LocalPlayer.state.Character:HasPermission("dealership_showroom")
							end,
						},
						{
							icon = "briefcase-clock",
							label = "Go On Duty",
							event = "Dealerships:Client:ToggleDuty",
							onSelect = function()
								TriggerEvent("Dealerships:Client:ToggleDuty", { dealerId = dealerId, state = true })
							end,
							groups = { dealerId },
							reqOffDuty = true,
						},
						{
							icon = "briefcase-clock",
							label = "Go Off Duty",
							event = "Dealerships:Client:ToggleDuty",
							onSelect = function()
								TriggerEvent("Dealerships:Client:ToggleDuty", { dealerId = dealerId, state = false })
							end,
							groups = { dealerId },
							reqDuty = true,
						},
					}
				})
			end
		end
	end
end

function CreateDealershipBlips()
	for dealerId, data in pairs(_dealerships) do
		if data.blip then
			exports["sandbox-blips"]:Add(
				"dealership_" .. dealerId,
				data.name,
				data.blip.coords,
				data.blip.sprite,
				data.blip.colour,
				data.blip.scale
			)
		end
	end
end

AddEventHandler("Polyzone:Enter", function(id, point, insideZones, data)
	if characterLoaded and data and data.dealer and data.dealerId and data.type then
		if data.type == "main" then
			_withinShowroom = data.dealerId
			SpawnShowroom(data.dealerId)
		elseif data.type == "catalog" and _dealerships[data.dealerId] then
			_withinCatalog = data.dealerId
			exports['sandbox-hud']:ActionShow(
				"pdm",
				"{keybind}primary_action{/keybind} View " .. _dealerships[data.dealerId].abbreviation .. " Catalog"
			)
		end
	end
end)

AddEventHandler("Polyzone:Exit", function(id, point, insideZones, data)
	if data and data.dealer and data.dealerId and data.type then
		if data.type == "main" then
			DeleteShowroom(data.dealerId)
			_withinShowroom = false
		elseif data.type == "catalog" then
			exports['sandbox-hud']:ActionHide("pdm")
			_withinCatalog = false
			ForceCloseCatalog()
		end
	end
end)

AddEventHandler("Keybinds:Client:KeyUp:primary_action", function()
	if _withinCatalog then
		exports['sandbox-hud']:ActionHide("pdm")
		OpenCatalog(_withinCatalog)
	end
end)

AddEventHandler("Dealerships:Client:ToggleDuty", function(entityData, data)
	if data and data.dealerId then
		if data.state then
			exports['sandbox-jobs']:DutyOn(data.dealerId)
		else
			exports['sandbox-jobs']:DutyOff(data.dealerId)
		end
	end
end)
