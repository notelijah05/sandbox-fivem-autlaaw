AddEventHandler("Wardrobe:Shared:DependencyUpdate", RetrieveWardrobeComponents)
function RetrieveWardrobeComponents()
	ListMenu = exports["sandbox-base"]:FetchComponent("ListMenu")
	Input = exports["sandbox-base"]:FetchComponent("Input")
	Wardrobe = exports["sandbox-base"]:FetchComponent("Wardrobe")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("ListMenu", {
		"ListMenu",
		"Input",
		"Wardrobe",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveWardrobeComponents()
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Wardrobe", WARDROBE)
end)

AddEventHandler("Wardrobe:Client:SaveNew", function(data)
	Input:Show("Outfit Name", "Outfit Name", {
		{
			id = "name",
			type = "text",
			options = {
				inputProps = {
					maxLength = 24,
				},
			},
		},
	}, "Wardrobe:Client:DoSave", data)
end)

AddEventHandler("Wardrobe:Client:SaveExisting", function(data)
	exports["sandbox-base"]:ServerCallback("Wardrobe:SaveExisting", data.index, function(state)
		if state then
			exports["sandbox-hud"]:NotifSuccess("Outfit Saved")
			Wardrobe:Show()
		else
			exports["sandbox-hud"]:NotifError("Unable to Save Outfit")
		end
	end)
end)

AddEventHandler("Wardrobe:Client:DoSave", function(values, data)
	exports["sandbox-base"]:ServerCallback("Wardrobe:Save", {
		index = data,
		name = values.name,
	}, function(state)
		if state then
			exports["sandbox-hud"]:NotifSuccess("Outfit Saved")
			Wardrobe:Show()
		else
			exports["sandbox-hud"]:NotifError("Unable to Save Outfit")
		end
	end)
end)

AddEventHandler("Wardrobe:Client:Delete", function(data)
	exports['sandbox-hud']:ConfirmShow(string.format("Delete %s?", data.label), {
		yes = "Wardrobe:Client:Delete:Yes",
		no = "Wardrobe:Client:Delete:No",
	}, "", data.index)
end)

AddEventHandler("Wardrobe:Client:Delete:Yes", function(data)
	exports["sandbox-base"]:ServerCallback("Wardrobe:Delete", data, function(s)
		if s then
			exports["sandbox-hud"]:NotifSuccess("Outfit Deleted")
			Wardrobe:Show()
		end
	end)
end)

AddEventHandler("Wardrobe:Client:Equip", function(data)
	exports["sandbox-base"]:ServerCallback("Wardrobe:Equip", data.index, function(state)
		if state then
			exports["sandbox-sounds"]:PlayOne("outfit_change.ogg", 0.3)
			exports["sandbox-hud"]:NotifSuccess("Outfit Equipped")
		else
			exports["sandbox-hud"]:NotifError("Unable to Equip Outfit")
		end
	end)
end)

RegisterNetEvent("Wardrobe:Client:ShowBitch", function(eventRoutine)
	Wardrobe:Show()
end)

WARDROBE = {
	Show = function(self)
		exports["sandbox-base"]:ServerCallback("Wardrobe:GetAll", {}, function(data)
			local items = {}
			for k, v in pairs(data) do
				if v.label ~= nil then
					table.insert(items, {
						label = v.label,
						description = string.format("Outfit #%s", k),
						actions = {
							{
								icon = "floppy-disks",
								event = "Wardrobe:Client:SaveExisting",
							},
							{
								icon = "shirt",
								event = "Wardrobe:Client:Equip",
							},
							{
								icon = "x",
								event = "Wardrobe:Client:Delete",
							},
						},
						data = {
							index = k,
							label = v.label,
						},
					})
				end
			end

			table.insert(items, {
				label = "Save New Outfit",
				event = "Wardrobe:Client:SaveNew",
			})

			ListMenu:Show({
				main = {
					label = "Wardrobe",
					items = items,
				},
			})
		end)
	end,
	Close = function(self)
		SetNuiFocus(false, false)
		SendNUIMessage({
			type = "CLOSE_LIST_MENU",
		})
	end,
}
