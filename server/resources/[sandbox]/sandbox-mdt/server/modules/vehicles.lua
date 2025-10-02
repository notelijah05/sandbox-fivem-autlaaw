function GetVehicleOwnerData(sid)
	local result = MySQL.single.await('SELECT First, Last, SID FROM characters WHERE SID = ?', { sid })
	return result
end

exports('VehiclesSearch', function(term, page, perPage)
	-- Add parameter validation and defaults
	page = page or 1
	perPage = perPage or 10

	-- Ensure they are numbers
	page = tonumber(page) or 1
	perPage = tonumber(perPage) or 10

	-- Ensure minimum values
	page = math.max(1, page)
	perPage = math.max(1, perPage)

	local skip = 0
	if page > 1 then
		skip = perPage * (page - 1)
	end

	local query = ""
	local params = {}

	if term and term:sub(1, 5) == "SID: " then
		local sid = tonumber(term:sub(6, #term))
		if sid then
			query = "WHERE OwnerType = ? AND OwnerId = ?"
			params = { 0, sid }
		end
	else
		query = "WHERE (VIN LIKE ? OR RegisteredPlate LIKE ? OR CONCAT(Make, ' ', Model) LIKE ?)"
		params = { "%" .. (term or "") .. "%", "%" .. (term or "") .. "%", "%" .. (term or "") .. "%" }
	end

	local finalParams = {}
	for i = 1, #params do
		table.insert(finalParams, params[i])
	end
	table.insert(finalParams, perPage + 1)
	table.insert(finalParams, skip)

	local results = MySQL.query.await(
		"SELECT * FROM vehicles " .. query .. " ORDER BY Created DESC LIMIT ? OFFSET ?",
		finalParams
	)

	if not results then
		return {
			data = {},
			pages = nil,
		}
	end

	local processedResults = {}
	for i = 1, #results do
		local vehicle = results[i]
		if vehicle then
			if vehicle.Properties and type(vehicle.Properties) == "string" then
				local success, properties = pcall(json.decode, vehicle.Properties)
				if success and properties then
					vehicle.Properties = properties
				else
					vehicle.Properties = {}
				end
			elseif not vehicle.Properties then
				vehicle.Properties = {}
			end

			if vehicle.Damage and type(vehicle.Damage) == "string" then
				local success, damage = pcall(json.decode, vehicle.Damage)
				if success and damage then
					vehicle.Damage = damage
				else
					vehicle.Damage = {}
				end
			elseif not vehicle.Damage then
				vehicle.Damage = {}
			end

			if vehicle.DamagedParts and type(vehicle.DamagedParts) == "string" then
				local success, damagedParts = pcall(json.decode, vehicle.DamagedParts)
				if success and damagedParts then
					vehicle.DamagedParts = damagedParts
				else
					vehicle.DamagedParts = {}
				end
			elseif not vehicle.DamagedParts then
				vehicle.DamagedParts = {}
			end

			vehicle.Type = vehicle.Type or 0
			vehicle.Make = vehicle.Make or "Unknown"
			vehicle.Model = vehicle.Model or "Unknown"
			vehicle.RegisteredPlate = vehicle.RegisteredPlate or "N/A"
			vehicle.OwnerType = vehicle.OwnerType or 0
			vehicle.OwnerId = vehicle.OwnerId or 0
			vehicle.VIN = vehicle.VIN or "N/A"
			vehicle.Class = vehicle.Class or "Unknown"
			vehicle.ModelType = vehicle.ModelType or "automobile"
			vehicle.Fuel = vehicle.Fuel or 100.0
			vehicle.Mileage = vehicle.Mileage or 0.0
			vehicle.Value = vehicle.Value or 0
			vehicle.FirstSpawn = vehicle.FirstSpawn or 0
			vehicle.FakePlate = vehicle.FakePlate or 0

			table.insert(processedResults, vehicle)
		end
	end

	local pageCount = nil
	if #processedResults > perPage then
		table.remove(processedResults)
		pageCount = page + 1
	end

	return {
		data = processedResults,
		pages = pageCount,
	}
end)

exports('VehiclesView', function(VIN)
	local vehicle = MySQL.single.await(
		"SELECT * FROM vehicles WHERE VIN = ?",
		{ VIN }
	)

	if not vehicle then
		return false
	end

	if vehicle.Properties then
		vehicle.Properties = json.decode(vehicle.Properties)
	end

	if vehicle.OwnerType == 0 then
		vehicle.Owner = {
			Type = vehicle.OwnerType,
			Id = vehicle.OwnerId,
			Person = GetVehicleOwnerData(vehicle.OwnerId)
		}
	elseif vehicle.OwnerType == 1 or vehicle.OwnerType == 2 then
		local jobData = exports['sandbox-jobs']:DoesExist(vehicle.OwnerId, vehicle.OwnerWorkplace)
		if jobData then
			local jobName = jobData.Name
			if jobData.Workplace then
				jobName = string.format('%s (%s)', jobData.Name, jobData.Workplace.Name)
			end
			if vehicle.OwnerType == 2 then
				jobName = jobName .. " (Dealership Buyback)"
			end
			vehicle.Owner = {
				Type = vehicle.OwnerType,
				Id = vehicle.OwnerId,
				Workplace = vehicle.OwnerWorkplace,
				JobName = jobName
			}
		end
	end

	if vehicle.StorageType ~= nil then
		local storageName = nil
		if vehicle.StorageType == 0 then
			storageName = exports['sandbox-vehicles']:GaragesImpound().name
		elseif vehicle.StorageType == 1 then
			local garage = exports['sandbox-vehicles']:GaragesGet(vehicle.StorageId)
			storageName = garage and garage.name or nil
		elseif vehicle.StorageType == 2 then
			local prop = exports['sandbox-properties']:Get(vehicle.StorageId)
			storageName = prop and prop.label or nil
		end

		if storageName then
			vehicle.Storage = {
				Type = vehicle.StorageType,
				Id = vehicle.StorageId,
				Name = storageName
			}
		end
	end

	if vehicle.RegisteredPlate then
		local flagged = exports['sandbox-radar']:CheckPlate(vehicle.RegisteredPlate)
		if flagged ~= "Vehicle Flagged in MDT" then
			vehicle.RadarFlag = flagged
		end
	end

	return vehicle
end)

exports('VehiclesFlagsAdd', function(VIN, data, plate)
	local success = MySQL.update.await(
		"UPDATE vehicles SET Properties = JSON_SET(COALESCE(Properties, '{}'), '$.Flags', ?) WHERE VIN = ?",
		{ json.encode(data), VIN }
	)

	if success and plate then
		exports['sandbox-radar']:FlagPlate(plate, data)
	end

	return success
end)

exports('VehiclesFlagsRemove', function(VIN, plate)
	local success = MySQL.update.await(
		"UPDATE vehicles SET Properties = JSON_REMOVE(Properties, '$.Flags') WHERE VIN = ?",
		{ VIN }
	)

	if success and plate then
		exports['sandbox-radar']:UnflagPlate(plate)
	end

	return success
end)

exports('VehiclesUpdateStrikes', function(VIN, strikes)
	local success = MySQL.update.await(
		"UPDATE vehicles SET Properties = JSON_SET(COALESCE(Properties, '{}'), '$.Strikes', ?) WHERE VIN = ?",
		{ json.encode(strikes), VIN }
	)

	return success
end)

exports('VehiclesGetStrikes', function(VIN)
	local vehicle = MySQL.single.await(
		"SELECT VIN, Properties, RegisteredPlate FROM vehicles WHERE VIN = ?",
		{ VIN }
	)

	if not vehicle then
		return 0
	end

	local strikes = 0
	if vehicle.Properties then
		local properties = json.decode(vehicle.Properties)
		if properties and properties.Strikes and #properties.Strikes > 0 then
			strikes = #properties.Strikes
		end
	end

	return strikes
end)

AddEventHandler("MDT:Server:RegisterCallbacks", function()
	exports["sandbox-base"]:RegisterServerCallback("MDT:Search:vehicle", function(source, data, cb)
		if CheckMDTPermissions(source, false) then
			local term = data.term or ""
			local page = data.page or 1
			local perPage = data.perPage or 10

			page = tonumber(page) or 1
			perPage = tonumber(perPage) or 10

			cb(exports['sandbox-mdt']:VehiclesSearch(term, page, perPage))
		else
			cb(false)
		end
	end)

	exports["sandbox-base"]:RegisterServerCallback("MDT:View:vehicle", function(source, data, cb)
		if CheckMDTPermissions(source, false) then
			cb(exports['sandbox-mdt']:VehiclesView(data))
		else
			cb(false)
		end
	end)

	exports["sandbox-base"]:RegisterServerCallback("MDT:Create:vehicle-flag", function(source, data, cb)
		if CheckMDTPermissions(source, false, 'police') then
			cb(exports['sandbox-mdt']:VehiclesFlagsAdd(data.parent, data.doc, data.plate))
		else
			cb(false)
		end
	end)

	exports["sandbox-base"]:RegisterServerCallback("MDT:Delete:vehicle-flag", function(source, data, cb)
		if CheckMDTPermissions(source, false, 'police') then
			cb(exports['sandbox-mdt']:VehiclesFlagsRemove(data.parent, data.id, data.plate, data.removeRadarFlag))
		else
			cb(false)
		end
	end)

	exports["sandbox-base"]:RegisterServerCallback("MDT:Update:vehicle-strikes", function(source, data, cb)
		if CheckMDTPermissions(source, false, 'police') then
			cb(exports['sandbox-mdt']:VehiclesUpdateStrikes(data.VIN, data.strikes))
		else
			cb(false)
		end
	end)
end)
