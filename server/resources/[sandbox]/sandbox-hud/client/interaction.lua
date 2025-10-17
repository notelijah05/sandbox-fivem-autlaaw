local menus = {}
local currentItems = {}
local stack = {}

exports("InteractionHide", function()
	SetNuiFocus(false, false)
	SendNUIMessage({
		type = "SHOW_INTERACTION_MENU",
		data = {
			toggle = false,
		},
	})
end)

exports("InteractionShow", function()
	if not exports['sandbox-hud']:IsDisabledAllowDead() then
		exports['sandbox-phone']:Close()
		exports.ox_inventory:CloseAll()

		SetNuiFocus(true, true)
		SetCursorLocation(0.5, 0.5)
		local is = exports['sandbox-hud']:InteractionItemsAsMenu(menus)
		stack = { is }
		SendNUIMessage({
			type = "SET_INTERACTION_LAYER",
			data = {
				layer = 0,
			},
		})
		SendNUIMessage({
			type = "SHOW_INTERACTION_MENU",
			data = {
				toggle = true,
			},
		})
		SendNUIMessage({
			type = "SET_INTERACTION_MENU_ITEMS",
			data = {
				items = is,
			},
		})
	end
end)

exports("InteractionRegisterMenu", function(id, label, icon, action, shouldShow, labelFunc)
	if not action then
		action = function() end
	end
	menus[id] = {
		label = label,
		icon = icon,
		shouldShow = shouldShow,
		action = action,
		labelFunc = labelFunc,
	}
end)

exports("InteractionShowMenu", function(items)
	local is = exports['sandbox-hud']:InteractionItemsAsMenu(items)
	stack[#stack + 1] = is
	SendNUIMessage({
		type = "SET_INTERACTION_LAYER",
		data = {
			layer = #stack,
		},
	})
	SendNUIMessage({
		type = "SET_INTERACTION_MENU_ITEMS",
		data = {
			items = is,
		},
	})
end)

exports("InteractionBack", function()
	stack[#stack] = nil
	SendNUIMessage({
		type = "SET_INTERACTION_LAYER",
		data = {
			layer = #stack - 1,
		},
	})
	SendNUIMessage({
		type = "SET_INTERACTION_MENU_ITEMS",
		data = {
			items = stack[#stack],
		},
	})
end)

exports("InteractionItemsAsMenu", function(items)
	local is = {}
	for k, v in pairs(items) do
		local show = true
		if v.shouldShow then
			show = v.shouldShow()
		end

		if v.labelFunc then
			v.label = v.labelFunc()
		end

		if show then
			table.insert(is, {
				id = k,
				label = v.label,
				icon = v.icon,
				action = v.action,
				data = show,
			})
		end
	end
	return is
end)

RegisterNUICallback("Interaction:Trigger", function(data, cb)
	for k, v in ipairs(stack[#stack]) do
		if v.id == data.id then
			if v.action then
				v.action(v.data)
			end
			exports['sandbox-sounds']:UISoundsPlayFrontEnd(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET")
			return cb(true)
		end
	end
	cb(true)
end)

RegisterNUICallback("Interaction:Hide", function(data, cb)
	exports['sandbox-hud']:InteractionHide()
	exports['sandbox-sounds']:UISoundsPlayFrontEnd(-1, "CANCEL", "HUD_FRONTEND_DEFAULT_SOUNDSET")
	cb(true)
end)

RegisterNUICallback("Interaction:Back", function(data, cb)
	exports['sandbox-hud']:InteractionBack()
	exports['sandbox-sounds']:UISoundsPlayFrontEnd(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET")
	cb(true)
end)
