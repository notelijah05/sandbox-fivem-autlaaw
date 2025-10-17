if not lib then return end

local function fetchSlotRestrictions()
    local restrictions = {
        [1] = { name = "WEAPON SLOT 1", restrictions = { type = "weapon_prefix", prefix = "WEAPON_", exclude = false } },
        [2] = { name = "WEAPON SLOT 2", restrictions = { type = "weapon_prefix", prefix = "WEAPON_", exclude = false } },
        [3] = {
            name = "HOTKEY SLOT 3",
            exclude_items = { "backpack", "large_backpack", "military_backpack", "armor", "heavyarmor", "phone", "parachute" },
            restrictions = {
                type = "weapon_prefix",
                prefix = "WEAPON_",
                exclude = true
            },
        },
        [4] = {
            name = "HOTKEY SLOT 4",
            exclude_items = { "backpack", "large_backpack", "military_backpack", "armor", "heavyarmor", "phone", "parachute" },
            restrictions = {
                type = "weapon_prefix",
                prefix = "WEAPON_",
                exclude = true
            },
        },
        [5] = {
            name = "HOTKEY SLOT 5",
            exclude_items = { "backpack", "large_backpack", "military_backpack", "armor", "heavyarmor", "phone", "parachute" },
            restrictions = {
                type = "weapon_prefix",
                prefix = "WEAPON_",
                exclude = true
            },
        },
        [6] = { name = "BACKPACK", restrictions = { type = "allowed_items", items = { "backpack", "large_backpack", "military_backpack" } } },
        [7] = { name = "BODY ARMOR", restrictions = { type = "allowed_items", items = { "armor", "heavyarmor" } } },
        [8] = { name = "PHONE", restrictions = { type = "allowed_items", items = { "phone" } } },
        [9] = { name = "PARACHUTE", restrictions = { type = "allowed_items", items = { "parachute" } } }
    }

    local formattedRestrictions = {}
    for i = 1, 9 do
        formattedRestrictions[tostring(i)] = restrictions[i]
    end

    return formattedRestrictions
end

lib.callback.register('ox_inventory:fetchSlotRestrictions', function(source)
    return fetchSlotRestrictions()
end)

return {
    fetch = fetchSlotRestrictions,
}
