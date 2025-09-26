RegisterNUICallback("Home:GetMyProperties", function(data, cb)
	local props = exports['sandbox-properties']:GetPropertiesWithAccess() or {}

	local upgrades = exports['sandbox-properties']:GetUpgradesConfig()

	cb({
		properties = props,
		upgrades = upgrades,
	})
end)

RegisterNUICallback("Home:StartPlacement", function(data, cb)
	cb(false)
end)

RegisterNUICallback("Home:CreateDigiKey", function(data, cb)
	exports["sandbox-base"]:ServerCallback("Phone:Home:CreateDigiKey", data, cb)
end)

RegisterNUICallback("Home:RevokeDigiKey", function(data, cb)
	exports["sandbox-base"]:ServerCallback("Phone:Home:RevokeDigiKey", data, cb)
end)

RegisterNUICallback("Home:RemoveMyKey", function(data, cb)
	exports["sandbox-base"]:ServerCallback("Phone:Home:RemoveMyKey", data, cb)
end)

RegisterNUICallback("Home:LockProperty", function(data, cb)
	exports["sandbox-base"]:ServerCallback("Phone:Home:LockProperty", data, cb)
end)

RegisterNUICallback("Home:EditMode", function(data, cb)
	exports['sandbox-properties']:EditMode()
	cb("OK")
end)

RegisterNUICallback("Home:GetCurrentFurniture", function(data, cb)
	local p = exports['sandbox-properties']:GetCurrent(data.property)
	cb(p)
end)

RegisterNUICallback("Home:PlaceFurniture", function(data, cb)
	-- model, category
	cb(exports['sandbox-properties']:Place(data.model, data.category))
end)

RegisterNUICallback("Home:EditFurniture", function(data, cb)
	cb(exports['sandbox-properties']:Move(data.id))
end)

RegisterNUICallback("Home:DeleteFurniture", function(data, cb)
	cb(exports['sandbox-properties']:Delete(data.id))
end)

RegisterNUICallback("Home:HighlightFurniture", function(data, cb)
	cb(false)
	--cb(Properties.Furniture:Find(data.id))
end)

RegisterNUICallback("PurchasePropertyInterior", function(data, cb)
	-- data.int
	exports["sandbox-base"]:ServerCallback("Properties:ChangeInterior", data, cb)
end)

RegisterNUICallback("PurchasePropertyUpgrade", function(data, cb)
	-- data.upgrade
	exports["sandbox-base"]:ServerCallback("Properties:Upgrade", data, cb)
end)

RegisterNUICallback("PreviewPropertyInterior", function(data, cb)
	-- data.int
	cb("OK")
	exports['sandbox-properties']:Preview(data.int)
end)
