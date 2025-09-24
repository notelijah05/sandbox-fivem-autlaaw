function RegisterKeyBinds()
	exports["sandbox-keybinds"]:Add("open_hotbar", "", "keyboard", "Inventory - Show Hotbar", function()
		if not _startup or _reloading or _loading then
			return
		end
		OpenHotBar()
	end)

	exports["sandbox-keybinds"]:Add("open_inventory", "TAB", "keyboard", "Inventory - Open Inventory", function()
		if not _startup or _reloading or _loading then
			return
		end
		OpenInventory()
	end)

	function HotBarAction(key)
		exports["sandbox-keybinds"]:Add(
			"hotbar_action_" .. tostring(key),
			key,
			"keyboard",
			"Inventory - Hotbar Action " .. tostring(key),
			function()
				if not _startup then
					return
				end
				exports['sandbox-inventory']:UsedHotKey(key)
			end
		)
	end

	for i = 1, 5 do
		HotBarAction(i)
	end
end
