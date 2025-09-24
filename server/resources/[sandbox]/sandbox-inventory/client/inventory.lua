_cachedInventory = nil
SecondInventory = {}

_inUse = false
_reloading = false
local _openCd = false
local _timedCd = false
local _hkCd = false
local _container = nil
local trunkOpen = false

local _itemDefs = nil
local _schems = {}

local _playerDataOpen = false
local _secondaryDataOpen = false

function dropAnim(drop)
	if LocalPlayer.state.doingAction then
		return
	end
	if LocalPlayer.state.isK9Ped then
		loadAnimDict("creatures@rottweiler@move")
		if drop then
			TaskPlayAnim(PlayerPedId(), "creatures@rottweiler@move", "fetch_pickup", 5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
		else
			TaskPlayAnim(PlayerPedId(), "creatures@rottweiler@move", "fetch_drop", 5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
		end
		return
	end
	if drop then
		loadAnimDict("pickup_object")
		TaskPlayAnim(PlayerPedId(), "pickup_object", "putdown_low", 5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
	else
		loadAnimDict("pickup_object")
		TaskPlayAnim(PlayerPedId(), "pickup_object", "pickup_low", 5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
	end
end

local function DoItemLoad(items)
	if _loading then
		return
	end

	SendNUIMessage({
		type = "ITEMS_UNLOADED",
		data = {},
	})
	Wait(100)
	SendNUIMessage({
		type = "RESET_ITEMS",
		data = {},
	})

	for k, v in pairs(_itemsSource) do
		for k2, v2 in ipairs(v) do
			_items[v2.name] = v2
		end
	end

	if items ~= nil then
		for k, v in pairs(items) do
			_items[v.name] = v
		end
	end

	SendNUIMessage({
		type = "SET_ITEMS",
		data = {
			items = _items,
		},
	})

	SendNUIMessage({
		type = "ITEMS_LOADED",
	})
	TriggerEvent("Inventory:Client:ItemsLoaded")
	_startup = true
	_loading = false
	_reloading = false
end

AddEventHandler("Inventory:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Polyzone = exports["sandbox-base"]:FetchComponent("Polyzone")
	Jobs = exports["sandbox-base"]:FetchComponent("Jobs")
	Reputation = exports["sandbox-base"]:FetchComponent("Reputation")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Inventory", {
		"Polyzone",
		"Jobs",
		"Reputation",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()
		RegisterKeyBinds()
		RegisterRandomItems()
		DoItemLoad()
		CreateDonorVanityItems()

		exports["sandbox-base"]:RegisterClientCallback("Inventory:ForceClose", function(data, cb)
			exports['sandbox-inventory']:CloseAll()
			cb(true)
		end)

		exports["sandbox-base"]:RegisterClientCallback("Inventory:Container:Open", function(data, cb)
			if SecondInventory.owner ~= nil then
				exports["sandbox-base"]:ServerCallback("Inventory:CloseSecondary", SecondInventory, function()
					_container = data.item
					SecondInventory = { invType = _items[data.item.Name].container, owner = data.container }
					cb(true)
				end)
			else
				_container = data.item
				SecondInventory = { invType = _items[data.item.Name].container, owner = data.container }
				cb(true)
			end
		end)

		exports["sandbox-base"]:RegisterClientCallback("Inventory:Compartment:Open", function(data, cb)
			if SecondInventory.owner ~= nil then
				exports["sandbox-base"]:ServerCallback("Inventory:CloseSecondary", SecondInventory, function()
					SecondInventory = data
					cb(true)
				end)
			else
				SecondInventory = data
				cb(true)
			end
		end)

		exports["sandbox-base"]:RegisterClientCallback("Inventory:ItemUse", function(item, cb)
			if item.anim and (not item.pbConfig or not item.pbConfig.animation) then
				exports['sandbox-animations']:EmotesPlay(item.anim, false, item.time, true)
			end

			if item.pbConfig ~= nil then
				exports['sandbox-hud']:Progress({
					name = item.pbConfig.name,
					duration = item.time,
					label = item.pbConfig.label,
					useWhileDead = item.pbConfig.useWhileDead,
					canCancel = item.pbConfig.canCancel,
					vehicle = item.pbConfig.vehicle,
					disarm = item.pbConfig.disarm,
					ignoreModifier = item.pbConfig.ignoreModifier or true,
					animation = item.pbConfig.animation or false,
					controlDisables = {
						disableMovement = item.pbConfig.disableMovement,
						disableCarMovement = item.pbConfig.disableCarMovement,
						disableMouse = item.pbConfig.disableMouse,
						disableCombat = item.pbConfig.disableCombat,
					},
				}, function(cancelled)
					exports['sandbox-animations']:EmotesForceCancel()
					cb(not cancelled)
				end)
			else
				cb(true)
			end
		end)

		CreateVendingMachines()
	end)
end)

RegisterNetEvent("Inventory:Client:LoadItems", DoItemLoad)

RegisterNetEvent("Inventory:Client:ReloadItems", function()
	_reloading = true
	exports["sandbox-hud"]:NotifPersistentInfo("INVENTORY_RELOAD",
		"Requesting Updated Item Definitions, Inventory Temporarily Unavailable")
	TriggerServerEvent("Inventory:Server:ReloadItems")
end)

RegisterNetEvent("Inventory:Client:NewItemCreated", function(itemData)
	_items[itemData.name] = itemData
	SendNUIMessage({
		type = "ADD_ITEM",
		data = {
			id = itemData.name,
			item = itemData,
		},
	})
end)

RegisterNetEvent("Inventory:Client:ReceiveReload", function(items)
	LoadItems()
	DoItemLoad(items)
	exports["sandbox-hud"]:NotifPersistentRemove("INVENTORY_RELOAD")
	exports["sandbox-hud"]:NotifInfo("Item Reload Has Completed")
end)

function startCd()
	CreateThread(function()
		_timedCd = true
		Wait(1000)
		_timedCd = false
	end)
end

RegisterNetEvent("UI:Client:Reset", function(force)
	if force then
		_startup = false
		LoadItems()
	end
	exports['sandbox-inventory']:CloseAll()
	exports['sandbox-inventory']:Enable()
end)

RegisterNetEvent("Inventory:Client:Cache", function(inventory, refresh)
	_cachedInventory = inventory
end)

RegisterNetEvent("Inventory:Client:Open", function(inventory, inventory2)
	if inventory ~= nil then
		_openCd = true
		LocalPlayer.state.inventoryOpen = true
		exports['sandbox-inventory']:SetPlayerInventory(inventory)
		_playerDataOpen = true

		if inventory2 and inventory2.crafting then
			_secondaryDataOpen = true
			SendNUIMessage({
				type = "SET_MODE",
				data = {
					mode = "crafting",
				},
			})
			SendNUIMessage({
				type = "SET_BENCH",
				data = {
					bench = inventory2.bench,
					cooldowns = inventory2.cooldowns,
					recipes = inventory2.recipes,
				},
			})
			SendNUIMessage({
				type = "APP_SHOW",
			})
			SetNuiFocus(true, true)
		else
			if SecondInventory and SecondInventory.invType == 10 then
				dropAnim(true)
			end

			if inventory2 ~= nil then
				exports['sandbox-inventory']:SetSecondaryInventory(inventory2)

				SendNUIMessage({
					type = "SET_MODE",
					data = {
						mode = "inventory",
					},
				})

				_secondaryDataOpen = true
				exports['sandbox-inventory']:OpenSecondary()
			else
				_secondaryDataOpen = false
			end

			SendNUIMessage({
				type = "APP_SHOW",
			})
			SetNuiFocus(true, true)
		end

		CreateThread(function()
			while LocalPlayer.state.inventoryOpen do
				Wait(50)
			end
			TriggerServerEvent("Inventory:server:closePlayerInventory", LocalPlayer.state.Character:GetData("SID"))
		end)
	else
		LocalPlayer.state.inventoryOpen = false
	end
end)

RegisterNetEvent("Inventory:Client:Load", function(inventory, inventory2)
	if inventory ~= nil then
		exports['sandbox-inventory']:SetPlayerInventory(inventory)
		if inventory2 ~= nil then
			exports['sandbox-inventory']:SetSecondaryInventory(inventory2)
		end
	else
		LocalPlayer.state.inventoryOpen = false
	end
	_openCd = false
end)

AddEventHandler("Characters:Client:Updated", function(key)
	if key == "InventorySettings" then
		SendNUIMessage({
			type = "UPDATE_SETTINGS",
			data = {
				settings = LocalPlayer.state.Character:GetData("InventorySettings") or {},
			}
		})
	end
end)

AddEventHandler("Vehicles:Client:ExitVehicle", function()
	if LocalPlayer.state.inventoryOpen then
		exports['sandbox-inventory']:CloseAll()
	end
end)

exports("IsEnabled", function()
	return _startup and not _openCd and not _timedCd and not exports['sandbox-hud']:IsDisabled()
end)

exports("OpenPlayer", function(doSecondary)
	if exports['sandbox-inventory']:IsEnabled() then
		exports['sandbox-phone']:Close()
		exports['sandbox-hud']:InteractionHide()
		if not LocalPlayer.state.inventoryOpen then
			LocalPlayer.state.inventoryOpen = true
			TriggerServerEvent("Inventory:Server:Request", doSecondary and SecondInventory or false)
		end
	end
end)

exports("OpenSecondary", function()
	SendNUIMessage({
		type = "SHOW_SECONDARY_INVENTORY",
	})
end)

exports("CloseAll", function()
	SendNUIMessage({
		type = "APP_HIDE",
	})
	SetNuiFocus(false, false)

	LocalPlayer.state.inventoryOpen = false
	LocalPlayer.state.craftingOpen = false
	_playerDataOpen = false

	if trunkOpen and trunkOpen > 0 then
		exports['sandbox-vehicles']:SyncDoorsShut(trunkOpen, 5, false)
		trunkOpen = false
	end

	if _secondaryDataOpen then
		exports['sandbox-inventory']:CloseSecondary()
	end
end)

exports("CloseSecondary", function()
	if trunkOpen and trunkOpen > 0 then
		exports['sandbox-vehicles']:SyncDoorsShut(trunkOpen, 5, false)
		trunkOpen = false
	end

	if _secondaryDataOpen then
		exports["sandbox-base"]:ServerCallback("Inventory:CloseSecondary", SecondInventory, function()
			SecondInventory = {}
			_container = nil
			_secondaryDataOpen = false
		end)
	end
end)

exports("SetPlayerInventory", function(data)
	if not data then
		LocalPlayer.state.inventoryOpen = false
		LocalPlayer.state.craftingOpen = false
		_playerDataOpen = false
		return
	end

	SendNUIMessage({
		type = "SET_PLAYER_INVENTORY",
		data = data,
	})
end)

exports("SetPlayerSlot", function(slot)
	SendNUIMessage({
		type = "SET_PLAYER_SLOT",
		data = {
			slot = slot,
		},
	})
end)

exports("SetSecondaryInventory", function(data)
	_secondaryDataOpen = true
	SendNUIMessage({
		type = "SET_SECONDARY_INVENTORY",
		data = data,
	})
end)

exports("SetSecondarySlot", function(slot)
	SendNUIMessage({
		type = "SET_SECONDARY_SLOT",
		data = {
			slot = slot,
		},
	})
end)

exports("UsedHotKey", function(control)
	if not _hkCd and not _inUse and not exports['sandbox-hud']:IsDisabled() then
		SendNUIMessage({
			type = "USE_ITEM_PLAYER",
			data = {
				originSlot = control,
			},
		})
		_hkCd = true
		exports["sandbox-base"]:ServerCallback("Inventory:UseSlot", { slot = control }, function(state)
			if not state then
				SendNUIMessage({
					type = "SLOT_NOT_USED",
					data = {
						originSlot = control,
					},
				})
			end

			Citizen.SetTimeout(3000, function()
				_hkCd = false
			end)
		end)
	end
end)

exports("ItemsGetInstance", function(item)
	if _cachedInventory == nil or _cachedInventory.inventory == nil or #_cachedInventory.inventory == 0 then
		return nil
	end

	for k, v in ipairs(_cachedInventory.inventory) do
		if v.Name == item
			and (
				_items[v.Name].durability == nil
				or not _items[v.Name].isDestroyed
				or (((v.CreateDate or 0) + _items[v.Name].durability) >= GetCloudTimeAsInt())

			) then
			return v
		end
	end
end)

exports("ItemsGetCount", function(item, bundleWeapons)
	local counts = exports['sandbox-inventory']:ItemsGetCounts(bundleWeapons)
	return counts[item] or 0
end)

exports("ItemsGetCounts", function(bundleWeapons)
	if _cachedInventory == nil or _cachedInventory.inventory == nil or #_cachedInventory.inventory == 0 then
		return {}
	end
	local counts = {}

	if LocalPlayer.state.Character == nil then
		return counts
	end

	for k, v in ipairs(_cachedInventory.inventory) do
		if _items[v.Name] then
			if
				_items[v.Name].durability == nil
				or not _items[v.Name].isDestroyed
				or (((v.CreateDate or 0) + _items[v.Name].durability) >= GetCloudTimeAsInt())
			then
				local itemData = exports['sandbox-inventory']:ItemsGetData(v.Name)

				if bundleWeapons and itemData and itemData.weapon then
					counts[itemData.weapon] = (counts[itemData.weapon] or 0) + v.Count
				end
				counts[v.Name] = (counts[v.Name] or 0) + v.Count
			end
		end
	end

	return counts
end)

exports("ItemsGetTypeCounts", function()
	local counts = {}

	if LocalPlayer.state.Character == nil or _cachedInventory == nil or _items == nil then
		return counts
	end

	for k, v in ipairs(_cachedInventory.inventory) do
		if _items[v.Name] ~= nil then
			if
				_items[v.Name].durability == nil
				or not _items[v.Name].isDestroyed
				or (((v.CreateDate or 0) + _items[v.Name].durability) >= GetCloudTimeAsInt())
			then
				local itemData = exports['sandbox-inventory']:ItemsGetData(v.Name)
				counts[itemData.type] = (counts[itemData.type] or 0) + v.Count
			end
		end
	end

	return counts
end)

exports("ItemsHas", function(item, count, bundleWeapons)
	return exports['sandbox-inventory']:ItemsGetCount(item, bundleWeapons) >= count
end)

exports("ItemsHasType", function(itemType, count)
	return (exports['sandbox-inventory']:ItemsGetTypeCounts()[itemType] or 0) >= count
end)

exports("ItemsGetData", function(name)
	if name ~= nil then
		return _items[name]
	else
		return _items
	end
end)

exports("ItemsGetWithStaticMetadata", function(masterKey, mainIdName, textureIdName, gender, data)
	for k, v in pairs(_items) do
		if
			v.staticMetadata ~= nil
			and v.staticMetadata[masterKey] ~= nil
			and v.staticMetadata[masterKey][gender][mainIdName] == data[mainIdName]
			and v.staticMetadata[masterKey][gender][textureIdName] == data[textureIdName]
		then
			return k
		end
	end

	return nil
end)

exports("CheckPlayerHasItem", function(item, count)
	return exports['sandbox-inventory']:ItemsHas(item, count)
end)

exports("CheckPlayerHasItems", function(items)
	for k, v in ipairs(items) do
		if not exports['sandbox-inventory']:ItemsHas(v.item, v.count, true) then
			return false
		end
	end
	return true
end)

exports("CheckPlayerHasAnyItems", function(items)
	for k, v in ipairs(items) do
		if exports['sandbox-inventory']:ItemsHas(v.item, v.count) then
			return true
		end
	end

	return false
end)

exports("Enable", function()
	LocalPlayer.state.InventoryDisabled = false
end)

exports("Disable", function()
	LocalPlayer.state.InventoryDisabled = true
end)

exports("Toggle", function()
	LocalPlayer.state.InventoryDisabled = not LocalPlayer.state.InventoryDisabled
end)

exports("DumbfuckOpen", function(data)
	exports["sandbox-base"]:ServerCallback("Inventory:Server:Open", data, function(state)
		if state then
			SecondInventory = { invType = data.invType, owner = data.owner }
		end
	end)
end)

exports("StashOpen", function(type, identifier)
	exports["sandbox-base"]:ServerCallback("Stash:Server:Open", {
		type = type,
		identifier = identifier,
	}, function(state)
		if state ~= nil then
			SecondInventory = state
		end
	end)
end)

exports("ShopOpen", function(identifier)
	exports["sandbox-base"]:ServerCallback("Shop:Server:Open", {
		identifier = identifier,
	}, function(state)
		if state then
			SecondInventory = { invType = state, owner = string.format("shop:%s", identifier) }
		end
	end)
end)

exports("PlayerShopOpen", function(shopId)
	exports["sandbox-base"]:ServerCallback("PlayerShop:Server:Open", {
		id = shopId,
	}, function(state)
		if state then
			SecondInventory = { invType = state, owner = shopId }
		end
	end)
end)

exports("SearchCharacter", function(serverId)
	exports["sandbox-base"]:ServerCallback("Inventory:Search", {
		serverId = serverId,
	}, function(owner)
		if owner then
			SecondInventory = { invType = 1, owner = owner }
		end
	end)
end)

exports("StaticTooltipOpen", function(item)
	SendNUIMessage({
		type = "OPEN_STATIC_TOOLTIP",
		data = {
			item = item,
		}
	})
end)

exports("StaticTooltipClose", function()
	SendNUIMessage({
		type = "CLOSE_STATIC_TOOLTIP",
	})
end)

exports("UpdateCachedMD", function(slot, md, triggeredKey)
	if _cachedInventory and _cachedInventory.inventory then
		for k, v in ipairs(_cachedInventory.inventory) do
			if v.Slot == slot then
				v.MetaData = md

				local itemData = _items[v.Name]
				if WEAPON_PROPS[itemData and itemData.weapon or v.name] and triggeredKey == "WeaponComponents" then

				end

				return
			end
		end
	end
end)

local Sounds = {
	["SELECT"] = { id = -1, sound = "SELECT", library = "HUD_FRONTEND_DEFAULT_SOUNDSET" },
	["BACK"] = { id = -1, sound = "CANCEL", library = "HUD_FRONTEND_DEFAULT_SOUNDSET" },
	["UPDOWN"] = { id = -1, sound = "NAV_UP_DOWN", library = "HUD_FRONTEND_DEFAULT_SOUNDSET" },
	["DISABLED"] = { id = -1, sound = "ERROR", library = "HUD_FRONTEND_DEFAULT_SOUNDSET" },
	["SHOP_ADD"] = { id = -1, sound = "ATM_WINDOW", library = "HUD_FRONTEND_DEFAULT_SOUNDSET" }
}
RegisterNUICallback("FrontEndSound", function(data, cb)
	cb("ok")
	if Sounds[data] ~= nil then
		exports['sandbox-sounds']:UISoundsPlayFrontEnd(Sounds[data].id, Sounds[data].sound, Sounds[data].library)
	end
end)

RegisterNUICallback("UpdateSettings", function(data, cb)
	cb('OK')
	TriggerServerEvent("Inventory:Server:UpdateSettings", data)
end)

RegisterNUICallback("SubmitAction", function(data, cb)
	cb('OK')
	exports['sandbox-inventory']:CloseAll()
	TriggerServerEvent("Inventory:Server:TriggerAction", data)
end)

RegisterNUICallback("Close", function(data, cb)
	startCd()
	cb(true)
	exports['sandbox-inventory']:CloseAll()
	exports['sandbox-inventory']:Enable()
end)

RegisterNUICallback("Crashed", function(data, cb)
	startCd()
	cb(true)
	exports['sandbox-inventory']:CloseAll()
	exports['sandbox-inventory']:Enable()
	_openCd = false
end)

RegisterNUICallback("BrokeShit", function(data, cb)
	startCd()
	cb(true)
	exports['sandbox-inventory']:CloseAll()
	exports['sandbox-inventory']:Enable()
	_openCd = false
	exports["sandbox-hud"]:NotifError(
		"Something Is Broken And Your Inventory Isn't Working, You May Need To Hard Nap To Fix")
end)

RegisterNetEvent("Inventory:Client:ReceiveItems", function(items)
	_itemDefs = items or {}
end)

RegisterNetEvent("Characters:Client:Spawn", function()
	exports["sandbox-base"]:ServerCallback("Inventory:Server:retreiveStores", {}, function(shopsData)
		Shops = shopsData
		setupStores(shopsData)
		startDropsTick()
	end)

	SendNUIMessage({
		type = "SET_SCHEMS",
		data = _schematics
	})

	SendNUIMessage({
		type = "UPDATE_SETTINGS",
		data = {
			settings = LocalPlayer.state.Character:GetData("InventorySettings") or {},
		}
	})

	WeaponsThread()
end)

RegisterNetEvent("Characters:Client:Logout", function()
	Shops = {}
	_cachedInventory = nil
end)

AddEventHandler("Ped:Client:Died", function()
	exports['sandbox-inventory']:CloseAll()
end)

AddEventHandler("Inventory:Client:Trunk", function(entity, data)
	local vehClass = GetVehicleClass(entity.entity)
	local vehModel = GetEntityModel(entity.entity)

	exports["sandbox-base"]:ServerCallback("Inventory:OpenTrunk", {
		netId = VehToNet(entity.entity),
		class = vehClass,
		model = vehModel,
	}, function(s)
		if s then
			SecondInventory = {
				netId = VehToNet(entity.entity),
				invType = 4,
				owner = Entity(entity.entity).state.VIN,
				class = vehClass,
				model = vehModel,
			}
			trunkOpen = entity.entity
			SetVehicleHasBeenOwnedByPlayer(entity.entity, true)
			SetEntityAsMissionEntity(entity.entity, true, true)
			--SetVehicleDoorOpen(entity.entity, 5, true, false)
			exports['sandbox-vehicles']:SyncDoorsOpen(entity.entity, 5, false, false)
		end
	end)
end)

RegisterNetEvent("Inventory:Client:InUse", function(state)
	LocalPlayer.state.inUse = state
	SendNUIMessage({
		type = "USE_IN_PROGRESS",
		data = {
			state = state,
		},
	})
end)

RegisterNetEvent("Inventory:Container:Move", function(from, to)
	if _container ~= nil and _container.Slot == from then
		_container.Slot = to
	end
end)

RegisterNetEvent("Inventory:Container:Remove", function(data, from)
	if _container ~= nil and _container.Slot == from then
		exports['sandbox-inventory']:CloseAll()
	end
end)

RegisterNetEvent("Inventory:Client:SetSlot", function(owner, type, slot)
	if SecondInventory and SecondInventory.owner == owner and SecondInventory and SecondInventory.invType == type then
		exports['sandbox-inventory']:SetSecondarySlot(slot)
	else
		exports['sandbox-inventory']:SetPlayerSlot(slot)
	end
end)

local runningId = 0
RegisterNetEvent("Inventory:Client:Changed", function(type, item, count, slot)
	if type == "holster" then
		local equipped = exports['sandbox-inventory']:WeaponsGetEquippedItem()
		if equipped ~= nil and equipped.Slot == slot and equipped.Name == item then
			type = "Holstered"
		else
			type = "Equipped"
		end
	end
	runningId = runningId + 1
	SendNUIMessage({
		type = "ADD_ALERT",
		data = {
			alert = {
				id = runningId,
				type = type,
				item = item,
				count = count,
			},
		},
	})
end)

function OpenInventory()
	if exports['sandbox-inventory']:IsEnabled() then
		local playerPed = PlayerPedId()
		local requestSecondary = false
		local isPedInVehicle = IsPedInAnyVehicle(playerPed, true)

		-- do trunk check here as well maybe?
		if isPedInVehicle then
			local v = GetVehiclePedIsIn(playerPed)
			if v ~= nil and v > 0 then
				local vin = Entity(v).state.VIN
				if vin ~= nil then
					SecondInventory = {
						netId = VehToNet(v),
						invType = 5,
						owner = vin,
						class = GetVehicleClass(v),
						model = GetEntityModel(v),
					}
					requestSecondary = true
				end
			end
		elseif _inInvPoly ~= nil then
			SecondInventory = { invType = _inInvPoly.inventory.invType, owner = _inInvPoly.inventory.owner }
			requestSecondary = true
		elseif not IsPedFalling(playerPed) and not IsPedClimbing(playerPed) and not IsPedDiving(playerPed) and not LocalPlayer.state.playingCasino then
			if GetEntitySpeed(playerPed) < 8.0 then
				local p = promise.new()
				if exports['sandbox-inventory']:IsEnabled() then
					exports["sandbox-base"]:ServerCallback("Inventory:CheckIfNearDropZone", {}, function(dropzone)
						if dropzone ~= nil and not isPedInVehicle and not requestSecondary then
							p:resolve({ invType = 10, owner = dropzone.id, position = dropzone.position })
						else
							local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 0, -0.99))
							if LocalPlayer.state.isK9Ped then
								z = z + 0.5
							end
							p:resolve({
								invType = 10,
								owner = string.format("%s:%s:%s", math.ceil(x), math.ceil(y),
									LocalPlayer.state.currentRoute),
								position = vector3(x, y, z),
							})
						end
					end)
					local s = Citizen.Await(p)
					if s ~= nil then
						SecondInventory = s
						requestSecondary = true
					end
				end
			end
		end

		exports['sandbox-inventory']:OpenPlayer(requestSecondary)
		-- if requestSecondary then
		-- 	TriggerServerEvent("Inventory:Server:requestSecondaryInventory", SecondInventory)
		-- end
	end
end

RegisterNUICallback("MergeSlot", function(data, cb)
	cb("OK")
	data.class = SecondInventory.class
	data.model = SecondInventory.model
	data.inventory = SecondInventory

	exports["sandbox-base"]:ServerCallback("Inventory:MergeItem", data, function(success)
		if success and success.success then
			if SecondInventory.netId then
				local veh = NetToVeh(SecondInventory.netId)
				if veh then
					local vEnt = Entity(veh)
					if vEnt and not vEnt.state.Owned and not vEnt.state.PleaseDoNotFuckingDelete then
						TriggerServerEvent("Vehicles:Server:StopDespawn", SecondInventory.netId)
					end
				end
			end
			if SecondInventory ~= nil and SecondInventory.invType == 10 and (data.ownerFrom ~= data.ownerTo) then
				dropAnim(data.invTypeTo == 10)
			end
		else
			if success and success.reason then
				exports["sandbox-hud"]:NotifError(success.reason, 3600)
			end
		end
	end)
end)

RegisterNUICallback("SwapSlot", function(data, cb)
	cb("OK")
	data.class = SecondInventory.class
	data.model = SecondInventory.model
	data.inventory = SecondInventory

	exports["sandbox-base"]:ServerCallback("Inventory:SwapItem", data, function(success)
		if success and success.success then
			if SecondInventory.netId then
				local veh = NetToVeh(SecondInventory.netId)
				if veh then
					local vEnt = Entity(veh)
					if vEnt and not vEnt.state.Owned and not vEnt.state.PleaseDoNotFuckingDelete then
						TriggerServerEvent("Vehicles:Server:StopDespawn", SecondInventory.netId)
					end
				end
			end
			if SecondInventory ~= nil and SecondInventory.invType == 10 and (data.ownerFrom ~= data.ownerTo) then
				dropAnim(data.invTypeTo == 10)
			end
		else
			if success and success.reason then
				exports["sandbox-hud"]:NotifError(success.reason, 3600)
			end
		end
	end)
end)

RegisterNUICallback("MoveSlot", function(data, cb)
	cb("OK")
	data.class = SecondInventory.class
	data.model = SecondInventory.model
	data.inventory = SecondInventory

	exports["sandbox-base"]:ServerCallback("Inventory:MoveItem", data, function(success)
		if success and success.success then
			if SecondInventory.netId then
				local veh = NetToVeh(SecondInventory.netId)
				if veh then
					local vEnt = Entity(veh)
					if vEnt and not vEnt.state.Owned and not vEnt.state.PleaseDoNotFuckingDelete then
						TriggerServerEvent("Vehicles:Server:StopDespawn", SecondInventory.netId)
					end
				end
			end
			if SecondInventory ~= nil and SecondInventory.invType == 10 and (data.ownerFrom ~= data.ownerTo) then
				dropAnim(data.invTypeTo == 10)
			end
		else
			if success and success.reason then
				exports["sandbox-hud"]:NotifError(success.reason, 3600)
			end
		end
	end)
end)

RegisterNUICallback("SendNotify", function(data, cb)
	cb("OK")
	if data then
		if data.alert == "success" then
			exports["sandbox-hud"]:NotifSuccess(data.message, data.time)
		elseif data.alert == "warning" then
			Notification:Warning(data.message, data.time)
		elseif data.alert == "error" then
			exports["sandbox-hud"]:NotifError(data.message, data.time)
		end
	end
end)

RegisterNUICallback("UseItem", function(data, cb)
	cb("OK")
	if LocalPlayer.state.doingAction then
		return
	end
	exports["sandbox-base"]:ServerCallback("Inventory:UseItem", {
		slot = data.slot,
		owner = data.owner,
		invType = data.invType,
	}, function(success) end)
end)

RegisterNetEvent("Inventory:CloseUI", function()
	startCd()
	exports['sandbox-inventory']:CloseAll()
	exports['sandbox-inventory']:Enable()
end)

RegisterNetEvent("Inventory:Client:UpdateMetadata", function(slot, md, key)
	exports['sandbox-inventory']:UpdateCachedMD(slot, md, key)
end)

local _shops = {}
RegisterNetEvent("Inventory:Client:BasicShop:Set", function(shops)
	_shops = shops
	for k, v in pairs(shops) do
		local menus = {
			{
				icon = "sack-dollar",
				text = v.name or "Shop",
				event = "Shop:Client:BasicShop:Open",
				data = v.id,
				isEnabled = function(data, ent)
					return GlobalState[string.format("BasicShop:%s", data)]
				end,
			}
		}

		if v.job == nil and LocalPlayer.state.Character ~= nil and v.owner == LocalPlayer.state.Character:GetData("SID") then
			table.insert(menus, {
				icon = "sack-dollar",
				text = "Add Shop Moderator",
				event = "Shop:Client:BasicShop:AddModerator",
				data = v.id,
			})
			table.insert(menus, {
				icon = "bars",
				text = "View Shop Moderator",
				event = "Shop:Client:BasicShop:ViewModerators",
				data = v.id,
			})
			table.insert(menus, {
				icon = "octagon-check",
				text = "Open Shop",
				event = "Shop:Client:BasicShop:OpenShop",
				data = v.id,
				isEnabled = function(data, ent)
					return not GlobalState[string.format("BasicShop:%s", data)]
				end,
			})
			table.insert(menus, {
				icon = "octagon-xmark",
				text = "Close Shop",
				event = "Shop:Client:BasicShop:CloseShop",
				data = v.id,
				isEnabled = function(data, ent)
					return GlobalState[string.format("BasicShop:%s", data)]
				end,
			})
		else
			if Jobs.Permissions:HasPermissionInJob(v.job, "JOB_SHOP_CONTROL") then
				table.insert(menus, {
					icon = "octagon-check",
					text = "Open Shop",
					event = "Shop:Client:BasicShop:OpenShop",
					data = v.id,
					isEnabled = function(data, ent)
						return not GlobalState[string.format("BasicShop:%s", data)]
					end,
				})
				table.insert(menus, {
					icon = "octagon-xmark",
					text = "Close Shop",
					event = "Shop:Client:BasicShop:CloseShop",
					data = v.id,
					isEnabled = function(data, ent)
						return GlobalState[string.format("BasicShop:%s", data)]
					end,
				})
			end
		end

		exports['sandbox-pedinteraction']:Add(
			"player-shop-" .. v.id,
			GetHashKey(v.ped_model or 'S_F_Y_SweatShop_01'),
			vector3(v.position.x, v.position.y, v.position.z),
			v.position.h,
			25.0,
			menus,
			"shop"
		)
	end
end)

RegisterNetEvent("Characters:Client:Logout", function()
	for k, v in pairs(_shops) do
		exports['sandbox-pedinteraction']:Remove("player-shop-" .. v.id)
	end
end)

RegisterNetEvent("Inventory:Client:BasicShop:Create", function(shop)
	local menus = {
		{
			icon = "sack-dollar",
			text = shop.name or "Shop",
			event = "Shop:Client:BasicShop:Open",
			data = shop.id,
			isEnabled = function(data, ent)
				return GlobalState[string.format("BasicShop:%s", data)]
			end,
		}
	}

	if shop.job == nil and LocalPlayer.state.Character ~= nil and tonumber(shop.owner) == LocalPlayer.state.Character:GetData("SID") then
		table.insert(menus, {
			icon = "sack-dollar",
			text = "Add Shop Moderator",
			event = "Shop:Client:BasicShop:AddModerator",
			data = shop.id,
		})
		table.insert(menus, {
			icon = "octagon-check",
			text = "Open Shop",
			event = "Shop:Client:BasicShop:OpenShop",
			data = shop.id,
			isEnabled = function(data, ent)
				return not GlobalState[string.format("BasicShop:%s", data)]
			end,
		})
		table.insert(menus, {
			icon = "octagon-xmark",
			text = "Close Shop",
			event = "Shop:Client:BasicShop:CloseShop",
			data = shop.id,
			isEnabled = function(data, ent)
				return GlobalState[string.format("BasicShop:%s", data)]
			end,
		})
	else
		if Jobs.Permissions:HasPermissionInJob(shop.job, "JOB_SHOP_CONTROL") then
			table.insert(menus, {
				icon = "octagon-check",
				text = "Open Shop",
				event = "Shop:Client:BasicShop:OpenShop",
				data = shop.id,
				isEnabled = function(data, ent)
					return not GlobalState[string.format("BasicShop:%s", data)]
				end,
			})
			table.insert(menus, {
				icon = "octagon-xmark",
				text = "Close Shop",
				event = "Shop:Client:BasicShop:CloseShop",
				data = shop.id,
				isEnabled = function(data, ent)
					return GlobalState[string.format("BasicShop:%s", data)]
				end,
			})
		end
	end


	exports['sandbox-pedinteraction']:Add(
		"player-shop-" .. shop.id,
		GetHashKey(shop.ped_model or 'S_F_Y_SweatShop_01'),
		vector3(shop.position.x, shop.position.y, shop.position.z),
		shop.position.h,
		25.0,
		menus,
		"shop"
	)
end)

RegisterNetEvent("Inventory:Client:BasicShop:Delete", function(shopId)
	exports['sandbox-pedinteraction']:Remove("player-shop-" .. shopId)
end)

RegisterNUICallback("AddToShop", function(data, cb)
	exports["sandbox-base"]:ServerCallback("Inventory:PlayerShop:AddItem", data, cb)
end)

RegisterNetEvent("StoreFailedPurchase", function(data)
	SendNUIMessage({
		type = "SET_INVENTORIES",
		data = data,
	})
end)

AddEventHandler("Shop:Client:BasicShop:Open", function(obj, shopId)
	exports['sandbox-inventory']:PlayerShopOpen(shopId)
end)

AddEventHandler("Shop:Client:BasicShop:AddModerator", function(obj, shopId)
	exports['sandbox-hud']:InputShow(
		"Add Shop Moderator",
		"Add Shop Moderator",
		{
			{
				id = "sid",
				type = "number",
				options = {
					inputProps = {
						maxLength = 11,
					},
				},
			},
		},
		"Shop:Client:BasicShop:AddModeratorInput",
		shopId
	)
end)

AddEventHandler("Shop:Client:BasicShop:AddModeratorInput", function(values, shopId)
	exports["sandbox-base"]:ServerCallback("Inventory:PlayerShop:AddModerator", {
		shop = shopId,
		sid = values.sid
	})
end)

AddEventHandler("Shop:Client:BasicShop:ViewModerators", function(obj, shopId)
	exports["sandbox-base"]:ServerCallback("Inventory:PlayerShop:ViewModerators", shopId, function(list)
		if list then
			exports['sandbox-hud']:ListMenuShow({
				main = {
					label = "Shop Moderators",
					items = list,
				},
			})
		end
	end)
end)

AddEventHandler("Shop:Client:BasicShop:RemoveModerator", function(data)
	exports["sandbox-base"]:ServerCallback("Inventory:PlayerShop:RemoveModerator", data)
end)

AddEventHandler("Shop:Client:BasicShop:OpenShop", function(obj, shopId)
	exports["sandbox-base"]:ServerCallback("Inventory:PlayerShop:ChangeState", {
		id = shopId,
		state = true
	})
end)

AddEventHandler("Shop:Client:BasicShop:CloseShop", function(obj, shopId)
	exports["sandbox-base"]:ServerCallback("Inventory:PlayerShop:ChangeState", {
		id = shopId,
		state = false
	})
end)
