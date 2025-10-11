function RegisterBallisticsCallbacks()
	exports["sandbox-base"]:RegisterServerCallback("Evidence:Ballistics:FileGun", function(source, data, cb)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if char and data and data.slotNum and data.serial then
			-- Files a Gun So Evidence Can Be Found
			local item = exports.ox_inventory:GetSlot(char:GetData("SID"), data.slotNum, 1)
			if item and item.MetaData and (item.MetaData.ScratchedSerialNumber or item.MetaData.SerialNumber) then
				local firearmRecord, policeWeapId

				if item.MetaData.ScratchedSerialNumber and item.MetaData.ScratchedSerialNumber == data.serial then
					firearmRecord = MySQL.single.await(
						"SELECT serial, scratched, model, owner_sid, owner_name, police_filed, police_id FROM firearms WHERE serial = ? AND scratched = ?",
						{
							item.MetaData.ScratchedSerialNumber,
							1
						})
				elseif item.MetaData.SerialNumber and item.MetaData.SerialNumber == data.serial then
					firearmRecord = MySQL.single.await(
						"SELECT serial, scratched, model, owner_sid, owner_name, police_filed, police_id FROM firearms WHERE serial = ? AND scratched = ?",
						{
							item.MetaData.SerialNumber,
							0
						})
				end

				if firearmRecord then
					if not firearmRecord.police_filed then
						local updated = false
						if item.MetaData.ScratchedSerialNumber or item.MetaData.SerialNumber then
							MySQL.query.await("UPDATE firearms SET police_filed = ? WHERE serial = ?", {
								1,
								firearmRecord.serial,
							})

							if item.MetaData.ScratchedSerialNumber then
								exports.ox_inventory:SetMetaDataKey(item.id, "PoliceWeaponId",
									firearmRecord.police_id, source)
							end

							return cb(
								true,
								false,
								GetMatchingEvidenceProjectiles(firearmRecord.serial),
								firearmRecord.scratched and string.format("PWI-%s", firearmRecord.police_id) or nil
							)
						end
					else
						return cb(
							true,
							true,
							GetMatchingEvidenceProjectiles(firearmRecord.serial),
							string.format("PWI-%s", firearmRecord.police_id)
						)
					end
				end
			end
		end
		cb(false)
	end)
end

function RegisterBallisticsItemUses()
	exports.ox_inventory:RegisterUse("evidence-projectile", "Evidence", function(source, itemData)
		if itemData and itemData.MetaData and itemData.MetaData.EvidenceId and itemData.MetaData.EvidenceWeapon then
			exports["sandbox-base"]:ClientCallback(source, "Polyzone:IsCoordsInZone", {
				coords = GetEntityCoords(GetPlayerPed(source)),
				key = "ballistics",
				val = true,
			}, function(inZone)
				if inZone then
					if not itemData.MetaData.EvidenceDegraded then
						local filedEvidence = GetEvidenceProjectileRecord(itemData.MetaData.EvidenceId)
						local matchingWeapon = MySQL.single.await(
							"SELECT serial, scratched, model, owner_sid, owner_name, police_filed, police_id FROM firearms WHERE serial = ? AND police_filed = ?",
							{
								itemData.MetaData.EvidenceWeapon.serial,
								1
							})

						if filedEvidence then -- Already Exists
							TriggerClientEvent(
								"Evidence:Client:FiledProjectile",
								source,
								false,
								true,
								true,
								filedEvidence,
								matchingWeapon,
								itemData.MetaData.EvidenceId
							)
						else
							local newFiledEvidence = CreateEvidenceProjectileRecord({
								Id = itemData.MetaData.EvidenceId,
								Weapon = itemData.MetaData.EvidenceWeapon,
								Coords = itemData.MetaData.EvidenceCoords,
								AmmoType = itemData.MetaData.EvidenceAmmoType,
							})

							if newFiledEvidence then
								TriggerClientEvent(
									"Evidence:Client:FiledProjectile",
									source,
									false,
									true,
									false,
									newFiledEvidence,
									matchingWeapon,
									itemData.MetaData.EvidenceId
								)
							else
								TriggerClientEvent("Evidence:Client:FiledProjectile", source, false, false)
							end
						end
					else
						TriggerClientEvent("Evidence:Client:FiledProjectile", source, true)
					end
				end
			end)
		end
	end)

	exports.ox_inventory:RegisterUse("evidence-dna", "Evidence", function(source, itemData)
		if itemData and itemData.MetaData and itemData.MetaData.EvidenceId and itemData.MetaData.EvidenceDNA then
			exports["sandbox-base"]:ClientCallback(source, "Polyzone:IsCoordsInZone", {
				coords = GetEntityCoords(GetPlayerPed(source)),
				key = "dna",
				val = true,
			}, function(inZone)
				if inZone then
					if not itemData.MetaData.EvidenceDegraded then
						local char = GetCharacter(itemData.MetaData.EvidenceDNA)
						if char then
							TriggerClientEvent(
								"Evidence:Client:RanDNA",
								source,
								false,
								char,
								itemData.MetaData.EvidenceId
							)
						else
							TriggerClientEvent("Evidence:Client:RanDNA", source, false, false)
						end
					else
						TriggerClientEvent("Evidence:Client:RanDNA", source, true)
					end
				end
			end)
		end
	end)
end

function GetEvidenceProjectileRecord(evidenceId)
	local p = promise.new()

	exports.oxmysql:execute('SELECT * FROM firearms_projectiles WHERE Id = ?', { evidenceId }, function(results)
		if results and #results > 0 and results[1] then
			local record = results[1]
			if record.Weapon then
				record.Weapon = json.decode(record.Weapon)
			end
			if record.Coords then
				record.Coords = json.decode(record.Coords)
			end
			p:resolve(record)
		else
			p:resolve(false)
		end
	end)

	return Citizen.Await(p)
end

function CreateEvidenceProjectileRecord(document)
	local p = promise.new()
	local weaponJson = json.encode(document.Weapon)
	local coordsJson = json.encode(document.Coords)

	exports.oxmysql:execute(
		'INSERT INTO firearms_projectiles (Id, Weapon, Coords, AmmoType) VALUES (?, ?, ?, ?)',
		{ document.Id, weaponJson, coordsJson, document.AmmoType },
		function(insertId)
			if insertId and insertId > 0 then
				p:resolve(document)
			else
				p:resolve(false)
			end
		end)

	return Citizen.Await(p)
end

function GetMatchingEvidenceProjectiles(weaponSerial)
	local p = promise.new()

	exports.oxmysql:execute(
		'SELECT Id FROM firearms_projectiles WHERE JSON_UNQUOTE(JSON_EXTRACT(Weapon, "$.serial")) = ?', { weaponSerial },
		function(results)
			if results and #results > 0 then
				local foundEvidence = {}

				for k, v in ipairs(results) do
					table.insert(foundEvidence, v.Id)
				end
				p:resolve(foundEvidence)
			else
				p:resolve({})
			end
		end)

	return Citizen.Await(p)
end

function GetCharacter(stateId)
	local query = "SELECT * FROM characters WHERE SID = ?"
	local results = MySQL.query.await(query, { stateId })
	if results and #results > 0 then
		local char = results[1]
		if char and char.SID and char.First and char.Last then
			return {
				SID = char.SID,
				First = char.First,
				Last = char.Last,
				Age = math.floor((os.time() - char.DOB) / 3.156e+7),
			}
		end
	else
		return false
	end
end

AddEventHandler('Evidence:Server:RunBallistics', function(source, data)
	local char = exports['sandbox-characters']:FetchCharacterSource(source)
	if char ~= nil then
		local pState = Player(source).state
		if pState.onDuty == "police" then
			local its = exports.ox_inventory:GetInventory(source, data.owner, data.invType)
			if #its > 0 then
				local item = its[1]
				local md = json.decode(item.MetaData)
				local itemData = exports.ox_inventory:ItemsGetData(item.Name)
				if itemData ~= nil and itemData.type == 2 then
					if item and md and (md.ScratchedSerialNumber or md.SerialNumber) then
						local firearmRecord, policeWeapId

						if md.ScratchedSerialNumber then
							firearmRecord = MySQL.single.await(
								"SELECT serial, scratched, model, owner_sid, owner_name, police_filed, police_id FROM firearms WHERE serial = ? AND scratched = ?",
								{
									md.ScratchedSerialNumber,
									1
								})
						elseif md.SerialNumber then
							firearmRecord = MySQL.single.await(
								"SELECT serial, scratched, model, owner_sid, owner_name, police_filed, police_id FROM firearms WHERE serial = ? AND scratched = ?",
								{
									md.SerialNumber,
									0
								})
						end

						if firearmRecord then
							if not firearmRecord.police_filed then
								local updated = false
								if md.ScratchedSerialNumber or md.SerialNumber then
									MySQL.query.await("UPDATE firearms SET police_filed = ? WHERE serial = ?", {
										1,
										firearmRecord.serial,
									})

									if md.ScratchedSerialNumber then
										exports.ox_inventory:SetMetaDataKey(item.id, "PoliceWeaponId",
											firearmRecord.police_id,
											source)
									end

									exports.ox_inventory:BallisticsClear(source, data.owner, data.invType)
									exports["sandbox-base"]:ClientCallback(source, "Evidence:RunBallistics", {
										true,
										false,
										GetMatchingEvidenceProjectiles(firearmRecord.serial),
										firearmRecord.scratched and string.format("PWI-%s", firearmRecord.police_id) or
										nil,
										md.SerialNumber or nil
									})
								end
							else
								exports.ox_inventory:BallisticsClear(source, data.owner, data.invType)
								exports["sandbox-base"]:ClientCallback(source, "Evidence:RunBallistics", {
									true,
									true,
									GetMatchingEvidenceProjectiles(firearmRecord.serial),
									string.format("PWI-%s", firearmRecord.police_id),
									md.SerialNumber or nil
								})
							end
						else
							exports.ox_inventory:BallisticsClear(source, data.owner, data.invType)
							exports["sandbox-base"]:ClientCallback(source, "Evidence:RunBallistics", {
								false,
								false,
								false,
								false,
								false,
								nil
							})
						end
					end
				else
					exports['sandbox-hud']:Notification(source, "error", "Item Must Be A Weapon")
				end
			end
		end
	end
end)
