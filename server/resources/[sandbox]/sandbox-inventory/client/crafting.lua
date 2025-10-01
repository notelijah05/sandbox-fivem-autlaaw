exports("CraftingBenchesOpen", function(bench)
	TriggerServerEvent("Inventory:Server:Request", {
		crafting = true,
		id = bench,
	})
end)

exports("CraftingBenchesCleanup", function()
	for k, v in ipairs(_benchObjs) do
		exports.ox_target:removeEntity(v)
		DeleteEntity(v)
	end
	_benchObjs = {}
end)

exports("CraftingBenchesRefresh", function(interior)
	exports['sandbox-inventory']:CraftingBenchesCleanup()

	if _benches then
		for k, v in ipairs(_benches) do
			if v.targeting and not v.targeting.manual then
				if
					v.restrictions.interior == nil
					or v.restrictions.interior
					== GlobalState[string.format("%s:Property", LocalPlayer.state.ID)]
				then
					local obj = nil
					if v.targeting.model ~= nil then
						obj = CreateObject(
							GetHashKey(v.targeting.model),
							v.location.x,
							v.location.y,
							v.location.z,
							false,
							true,
							false
						)
						FreezeEntityPosition(obj, true)
						table.insert(_benchObjs, obj)
						SetEntityHeading(obj, v.location.h)
					end

					if
						v.restrictions.shared
						or (v.restrictions.char ~= nil and v.restrictions.char == LocalPlayer.state.Character:GetData(
							"SID"
						))
						or (v.restrictions.job ~= nil and exports['sandbox-jobs']:HasJob(
							v.restrictions.job.id,
							v.restrictions.job.workplace,
							v.restrictions.job.grade,
							false,
							false,
							v.restrictions.job.permissionKey or "JOB_CRAFTING"
						))
						or (
							v.restrictions.rep ~= nil
							and exports['sandbox-characters']:RepGetLevel(v.restrictions.rep.id) >= v.restrictions.rep.level
						)
					then
						local menu = {
							{
								icon = v.targeting.icon,
								label = v.label,
								event = "Crafting:Client:OpenCrafting",
								groups = v.restrictions.job ~= nil and { v.restrictions.job.id } or nil,
								canInteract = function()
									if v.restrictions.job then
										return exports['sandbox-jobs']:HasJob(
											v.restrictions.job.id,
											v.restrictions.job.workplace,
											v.restrictions.job.grade,
											false,
											false,
											v.restrictions.job.permissionKey or "JOB_CRAFTING"
										) and (v.restrictions.job.onDuty == LocalPlayer.state.duty)
									end
									return true
								end,
							},
						}

						if v.canUseSchematics then
							table.insert(menu, {
								icon = "memo-circle-check",
								label = "Add Schematic To Bench",
								event = "Crafting:Client:AddSchematic",
								groups = v.restrictions.job ~= nil and { v.restrictions.job.id } or nil,
								canInteract = function()
									return exports['sandbox-inventory']:ItemsHasType(17, 1) and
										(v.restrictions.job == nil or (exports['sandbox-jobs']:HasJob(
											v.restrictions.job.id,
											v.restrictions.job.workplace,
											v.restrictions.job.grade,
											false,
											false,
											v.restrictions.job.permissionKey or "JOB_CRAFTING"
										) and (v.restrictions.job.onDuty == LocalPlayer.state.duty)))
								end,
							})
						end

						if obj ~= nil then
							exports.ox_target:addEntity(obj, menu)
						elseif v.targeting.ped ~= nil then
							exports['sandbox-pedinteraction']:Add(
								v.id,
								GetHashKey(v.targeting.ped.model),
								vector3(v.location.x, v.location.y, v.location.z),
								v.location.h,
								25.0,
								menu,
								v.targeting.icon,
								v.targeting.ped.task
							)
						elseif v.targeting.poly ~= nil then
							exports.ox_target:addBoxZone({
								id = v.id,
								coords = v.targeting.poly.coords,
								size = vector3(v.targeting.poly.w, v.targeting.poly.l, 2.0),
								rotation = v.targeting.poly.options.heading or 0,
								debug = false,
								minZ = v.targeting.poly.options.minZ,
								maxZ = v.targeting.poly.options.maxZ,
								options = menu
							})
						end
					else
						if obj ~= nil then
						elseif v.targeting.ped ~= nil then
							exports['sandbox-pedinteraction']:Remove(v.id)
						elseif v.targeting.poly ~= nil then
							exports.ox_target:removeZone(v.id)
						end
					end
				end
			end
		end
	end
end)

_benchObjs = {}
_benches = nil
RegisterNetEvent("Crafting:Client:CreateBenches", function(benches)
	_benches = benches
	exports['sandbox-inventory']:CraftingBenchesRefresh(nil)
end)

AddEventHandler("Characters:Client:Updated", function(key)
	if key == -1 then
		exports['sandbox-inventory']:CraftingBenchesRefresh(nil)
	end
end)

RegisterNetEvent("Job:Client:DutyChanged", function(state)
	exports['sandbox-inventory']:CraftingBenchesRefresh(nil)
end)

RegisterNetEvent("Crafting:Client:ForceBenchRefresh", function()
	exports['sandbox-inventory']:CraftingBenchesRefresh(nil)
end)

RegisterNetEvent("Characters:Client:Logout", function()
	exports['sandbox-inventory']:CraftingBenchesCleanup()
end)

AddEventHandler("Crafting:Client:OpenCrafting", function(ent, data)
	exports['sandbox-inventory']:CraftingBenchesOpen(data.id)
end)

AddEventHandler("Crafting:Client:AddSchematic", function(ent, data)
	exports["sandbox-base"]:ServerCallback("Crafting:GetSchematics", data, function(schematics)
		if #schematics > 0 then
			for k, v in ipairs(schematics) do
				schematics[k].data = {
					bench = data.id,
					schematic = schematics[k].data,
				}
			end

			exports['sandbox-hud']:ListMenuShow({
				main = {
					label = "Crafting Schematics",
					items = schematics,
				},
			})
		else
			exports["sandbox-hud"]:NotifError("You Have No Schematics")
		end
	end)
end)

AddEventHandler("Crafting:Client:UseSchematic", function(data)
	exports['sandbox-hud']:Progress({
		name = "schematic_action",
		duration = 8000,
		label = "Using Schematic",
		useWhileDead = false,
		canCancel = true,
		ignoreModifier = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
	}, function(cancelled)
		if not cancelled then
			exports["sandbox-base"]:ServerCallback("Crafting:UseSchematic", data, function(s) end)
		end
	end)
end)

RegisterNUICallback("Crafting:Craft", function(data, cb)
	exports["sandbox-base"]:ServerCallback("Crafting:Craft", data, function(state)
		if not state.error then
			cb(state)
		else
			exports["sandbox-hud"]:NotifError(string.format("Error - %s",
				state.message or "Something Is Broken, Report This"))
			cb(false)
		end
	end)
end)

function RegisterBenches() end
