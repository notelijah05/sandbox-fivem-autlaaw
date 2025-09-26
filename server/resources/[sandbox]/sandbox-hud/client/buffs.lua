local _runningIds = 1
local _buffDefs = {}

exports("RegisterBuff", function(id, icon, color, duration, type)
	_buffDefs[id] = {
		icon = icon,
		color = color,
		duration = duration,
		type = type,
	}
	SendNUIMessage({
		type = "REGISTER_BUFF",
		data = {
			id = id,
			data = {
				icon = icon,
				color = color,
				duration = duration,
				type = type,
			},
		},
	})
end)

exports("ApplyBuff", function(buffId, val, override, options)
	SendNUIMessage({
		type = "BUFF_APPLIED",
		data = {
			instance = {
				buff = buffId,
				override = override,
				val = math.ceil(val or 0),
				options = options or {},
				startTime = GetCloudTimeAsInt(),
			},
		},
	})
end)

exports("ApplyUniqueBuff", function(buffId, val, override, options)
	SendNUIMessage({
		type = "BUFF_APPLIED_UNIQUE",
		data = {
			instance = {
				buff = buffId,
				override = override,
				val = math.ceil(val or 0),
				options = options or {},
				startTime = GetCloudTimeAsInt(),
			},
		},
	})
end)

exports("UpdateBuff", function(buffId, nVal)
	SendNUIMessage({
		type = "BUFF_UPDATED",
		data = {
			buff = buffId,
			val = nVal,
		},
	})
end)

exports("BuffsIconOverride", function(buffId, override)
	SendNUIMessage({
		type = "BUFF_UPDATED",
		data = {
			buff = buffId,
			override = override,
		},
	})
end)

exports("RemoveBuffType", function(buffId)
	SendNUIMessage({
		type = "REMOVE_BUFF_BY_TYPE",
		data = {
			type = buffId,
		},
	})
end)

RegisterNetEvent("Characters:Client:Spawned", function()
	exports['sandbox-hud']:RegisterBuff("prog_mod", "mug-hot", "#D6451A", -1, "timed")
	exports['sandbox-hud']:RegisterBuff("stress_ticks", "joint", "#de3333", -1, "timed")
	exports['sandbox-hud']:RegisterBuff("heal_ticks", "suitcase-medical", "#52984a", -1, "timed")
	exports['sandbox-hud']:RegisterBuff("armor_ticks", "dumbbell", "#4056b3", -1, "timed")
end)

RegisterNetEvent("Characters:Client:Logout", function()
	exports['sandbox-hud']:RemoveBuffType("prog_mod")
	exports['sandbox-hud']:RemoveBuffType("stress_ticks")
	exports['sandbox-hud']:RemoveBuffType("heal_ticks")
	exports['sandbox-hud']:RemoveBuffType("armor_ticks")
end)
