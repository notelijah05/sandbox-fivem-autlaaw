Shops = {}
showingMarker = false
_isLoggedIn = false

function setupStores(shops)
	for k, v in pairs(shops) do
		if v.coords ~= nil then
			local menu = {
				icon = "fa-solid fa-sack-dollar",
				text = v.name or "Shop",
				event = "Shop:Client:OpenShop",
				data = v.id,
			}

			if v.restriction ~= nil then
				if v.restriction.job ~= nil then
					menu.groups = { v.restriction.job.id }
					menu.permissionKey = v.restriction.job.permissionKey
					menu.reqDuty = true
					menu.workplace = v.restriction.job.workplace
				end
			end

			exports['sandbox-pedinteraction']:Add(
				"shop-" .. v.id,
				GetHashKey(v.npc),
				vector3(v.coords.x, v.coords.y, v.coords.z),
				v.coords.h,
				25.0,
				{
					menu,
				},
				v.icon or "shop"
			)
			if v.blip then
				exports["sandbox-blips"]:Add(
					"inventory_shop_" .. v.id,
					v.name,
					vector3(v.coords.x, v.coords.y, v.coords.z),
					v.blip.sprite,
					v.blip.color,
					v.blip.scale
				)
			end
		end
	end
end

AddEventHandler("Shop:Client:OpenShop", function(data)
	exports['sandbox-inventory']:ShopOpen(data)
end)
