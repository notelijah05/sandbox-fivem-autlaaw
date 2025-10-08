local unitPasscodes = {}
local unitEntities = {
    [1] = 3000,
    [2] = 3001,
    [3] = 3002,
}

local unitLastAccessed = {}

AddEventHandler("Businesses:Server:Startup", function()
    StorageUnitStartup()

    exports["sandbox-chat"]:RegisterAdminCommand("unitadd", function(source, args, rawCommand)
        local ped = GetPlayerPed(source)
        local coords = GetEntityCoords(ped)

        local res = exports['sandbox-businesses']:StorageUnitsCreate(vector3(coords.x, coords.y, coords.z - 1.2), args
            [2],
            tonumber(args[1]), args[3])
        if res then
            exports["sandbox-chat"]:SendServerSingle(source, "Storage Unit Added, ID: " .. res)
        end
    end, {
        help = "Add New Storage Unit To Database (Location Is Where You\"re At)",
        params = {
            {
                name = "Unit Level",
                help = "Storage Unit Level 1-3"
            },
            {
                name = "Unit Label",
                help = "Name for the storage unit"
            },
            {
                name = "Managing Business",
                help = "Business who will manage this (e.g demonetti_storage)"
            },
        }
    }, 3)

    exports["sandbox-chat"]:RegisterAdminCommand("unitcopy", function(source, args, rawCommand)
        local near = exports['sandbox-businesses']:StorageUnitsGetNearUnit(source)
        if near.unitId then
            TriggerClientEvent("Admin:Client:CopyClipboard", source, near.unitId)
            exports['sandbox-hud']:NotifSuccess(source, "Copied Storage Unit ID")
        end
    end, {
        help = "[Dev] Copy ID of Closest Storage Unit",
    }, 0)

    exports["sandbox-chat"]:RegisterAdminCommand("unitdelete", function(source, args, rawCommand)
        local res = exports['sandbox-businesses']:StorageUnitsDelete(args[1])
        if res then
            exports["sandbox-chat"]:SendServerSingle(source, "Storage Unit Deleted")
        end
    end, {
        help = "Delete Storage Unit",
        params = {
            {
                name = "Unit ID",
                help = "Storage Unit ID"
            },
        }
    }, 1)

    exports["sandbox-chat"]:RegisterAdminCommand("unitown", function(source, args, rawCommand)
        local char = exports['sandbox-characters']:FetchCharacterSource(source)
        local unit = GlobalState[string.format("StorageUnit:%s", args[1])]
        if char and unit then
            if exports['sandbox-businesses']:StorageUnitsSell(args[1], {
                    First = char:GetData("First"),
                    Last = char:GetData("Last"),
                    SID = char:GetData("SID"),
                    ID = char:GetData("ID"),
                }, {
                    First = char:GetData("First"),
                    Last = char:GetData("Last"),
                    SID = char:GetData("SID"),
                    ID = char:GetData("ID"),
                }) then
                exports["sandbox-chat"]:SendServerSingle(source, "Storage Unit Owned")
            else
                exports["sandbox-chat"]:SendServerSingle(source, "Error")
            end
        end
    end, {
        help = "Own Storage Unit",
        params = {
            {
                name = "Unit ID",
                help = "Storage Unit ID"
            },
        }
    }, 1)

    exports["sandbox-base"]:RegisterServerCallback("StorageUnits:Access", function(source, data, cb)
        local unit = GlobalState[string.format("StorageUnit:%s", data)]
        if unit and unitPasscodes[unit.id] and unit.owner then
            exports["sandbox-base"]:ClientCallback(source, "StorageUnits:Passcode", unitPasscodes[unit.id],
                function(success, data)
                    if success and data.entered == unitPasscodes[unit.id] then
                        local storageType = unitEntities[unit.level] or 3000
                        local storageOwner = string.format("storage-unit:%s", unit.id)
                        exports["sandbox-base"]:ClientCallback(source, "Inventory:Compartment:Open", {
                            invType = storageType,
                            owner = storageOwner,
                        }, function()
                            exports.ox_inventory:OpenSecondary(source, storageType, storageOwner)

                            unitLastAccessed[unit.id] = os.time()

                            unit.lastAccessed = os.time()
                            GlobalState[string.format("StorageUnit:%s", unit.id)] = unit
                        end)
                    end
                end)
        end

        cb(true)
    end)

    exports["sandbox-base"]:RegisterServerCallback("StorageUnits:SellUnit", function(source, data, cb)
        local char = exports['sandbox-characters']:FetchCharacterSource(source)
        if char and data.unit and data.SID then
            local unit = GlobalState[string.format("StorageUnit:%s", data.unit)]
            if unit and exports['sandbox-jobs']:HasJob(source, unit.managedBy, false, false, false, false, "UNIT_SELL") then
                local target = exports['sandbox-characters']:FetchBySID(data.SID)
                if target then
                    local myCoords = GetEntityCoords(GetPlayerPed(source))
                    local targetCoords = GetEntityCoords(GetPlayerPed(target:GetData("Source")))

                    if #(myCoords - targetCoords) <= 3.0 then
                        if exports['sandbox-businesses']:StorageUnitsSell(data.unit, {
                                First = target:GetData("First"),
                                Last = target:GetData("Last"),
                                SID = target:GetData("SID"),
                                ID = target:GetData("ID"),
                            }, {
                                First = char:GetData("First"),
                                Last = char:GetData("Last"),
                                SID = char:GetData("SID"),
                                ID = char:GetData("ID"),
                            }) then
                            return cb(true)
                        else
                            return cb(false)
                        end
                    end
                end

                return cb(false, "Person Doesn't Exist or You Aren't Close Enough to Them")
            end
        end

        cb(false)
    end)

    exports["sandbox-base"]:RegisterServerCallback("StorageUnits:ChangePasscode", function(source, data, cb)
        local char = exports['sandbox-characters']:FetchCharacterSource(source)
        if char and data.unit and data.passcode then
            local unit = GlobalState[string.format("StorageUnit:%s", data.unit)]

            if unit and unit.owner and unit.owner.SID == char:GetData("SID") then
                cb(exports['sandbox-businesses']:StorageUnitsUpdate(unit.id, "passcode", data.passcode))
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)

    exports["sandbox-base"]:RegisterServerCallback("StorageUnits:PoliceRaid", function(source, data, cb)
        local char = exports['sandbox-characters']:FetchCharacterSource(source)
        if char and data and data.unit then
            local unit = GlobalState[string.format("StorageUnit:%s", data.unit)]
            if unit then
                if Player(source).state.onDuty == "police" and exports['sandbox-jobs']:HasPermissionInJob(source, "police", "PD_RAID") then
                    exports['sandbox-base']:LoggerWarn(
                        "Police",
                        string.format(
                            "Police Storage Unit Raid - Character %s %s (%s) - Accessing Storage Unit %s (%s)",
                            char:GetData("First"),
                            char:GetData("Last"),
                            char:GetData("SID"),
                            unit.label,
                            unit.id
                        ),
                        {
                            console = true,
                            discord = {
                                embed = true,
                                type = 'info',
                            }
                        }
                    )

                    local storageType = unitEntities[unit.level] or 3000
                    local storageOwner = string.format("storage-unit:%s", unit.id)
                    exports["sandbox-base"]:ClientCallback(source, "Inventory:Compartment:Open", {
                        invType = storageType,
                        owner = storageOwner,
                    }, function()
                        exports.ox_inventory:OpenSecondary(source, storageType, storageOwner)
                    end)

                    cb(true)
                else
                    cb(false)
                end
            else
                cb(false)
            end
        end
    end)
end)

function StorageUnitStartup()
    exports['sandbox-base']:DatabaseGameFind({
        collection = "storage_units",
        query = {},
    }, function(success, results)
        if not success then
            return
        end
        exports['sandbox-base']:LoggerTrace("StorageUnits", "Loaded ^2" .. #results .. "^7 Storage Units",
            { console = true })
        local unitIds = {}
        for k, v in ipairs(results) do
            unitPasscodes[v._id] = v.passcode

            local unit = FormatStorageUnit(v)
            table.insert(unitIds, unit.id)

            GlobalState[string.format("StorageUnit:%s", unit.id)] = unit
        end

        GlobalState["StorageUnits"] = unitIds
    end)
end

exports('StorageUnitsCreate', function(location, label, level, managedBy)
    if level > 3 or level < 0 then
        return false
    end

    local p = promise.new()

    local doc = {
        label = label,
        owner = false,
        level = level,
        location = {
            x = location.x,
            y = location.y,
            z = location.z,
        },
        managedBy = managedBy,
        lastAccessed = false,
        passcode = "0000",
    }

    exports['sandbox-base']:DatabaseGameInsertOne({
        collection = "storage_units",
        document = doc,
    }, function(success, result, insertedIds)
        if success then
            doc.id = insertedIds[1]
            doc.location = location

            local unitIds = GlobalState["StorageUnits"]
            table.insert(unitIds, doc.id)
            GlobalState["StorageUnits"] = unitIds

            GlobalState[string.format("StorageUnit:%s", doc.id)] = doc

            unitPasscodes[doc.id] = "0000"

            p:resolve(doc.id)
        else
            p:resolve(false)
        end
    end)

    return Citizen.Await(p)
end)

exports('StorageUnitsUpdate', function(id, key, value, skipRefresh)
    if not id or not GlobalState[string.format("StorageUnit:%s", id)] then
        return false
    end

    local p = promise.new()
    exports['sandbox-base']:DatabaseGameUpdateOne({
        collection = "storage_units",
        query = {
            _id = id,
        },
        update = {
            ["$set"] = {
                [key] = value,
            },
        },
    }, function(success, results)
        if success and not skipRefresh then
            if key ~= "passcode" then
                local unit = GlobalState[string.format("StorageUnit:%s", id)]
                if unit then
                    unit[key] = value
                    GlobalState[string.format("StorageUnit:%s", id)] = unit
                end
            else
                unitPasscodes[id] = value
            end
        end

        p:resolve(success)
    end)
    return Citizen.Await(p)
end)

exports('StorageUnitsDelete', function(id)
    local p = promise.new()
    exports['sandbox-base']:DatabaseGameDeleteOne({
        collection = "storage_units",
        query = {
            _id = id,
        },
    }, function(success, result)
        if success then
            local newUnitIds = {}
            for k, v in ipairs(GlobalState["StorageUnits"]) do
                if v ~= id then
                    table.insert(newUnitIds, v)
                end
            end

            GlobalState["StorageUnits"] = newUnitIds
            GlobalState[string.format("StorageUnit:%s", id)] = nil
        end
        p:resolve(success)
    end)

    return Citizen.Await(p)
end)

exports('StorageUnitsSell', function(id, owner, seller)
    local p = promise.new()
    exports['sandbox-base']:DatabaseGameUpdateOne({
        collection = "storage_units",
        query = {
            _id = id,
        },
        update = {
            ["$set"] = {
                owner = owner,
                soldBy = seller,
                soldAt = os.time(),
                lastAccessed = os.time(),
            },
        },
    }, function(success, results)
        if success then
            local unit = GlobalState[string.format("StorageUnit:%s", id)]
            if unit then
                unit["owner"] = owner
                unit["soldBy"] = seller
                unit["soldAt"] = os.time()
                unit["lastAccessed"] = os.time()

                unitLastAccessed[unit.id] = os.time()

                GlobalState[string.format("StorageUnit:%s", id)] = unit
            end
        end

        p:resolve(success)
    end)
    return Citizen.Await(p)
end)

exports('StorageUnitsGet', function(id)
    return GlobalState[string.format("StorageUnit:%s", id)]
end)

exports('StorageUnitsGetAll', function()
    local allUnits = {}
    for k, v in ipairs(GlobalState["StorageUnits"]) do
        table.insert(allUnits, GlobalState[string.format("StorageUnit:%s", v)])
    end

    return allUnits
end)

exports('StorageUnitsGetAllManagedBy', function(managedBy)
    local allUnits = {}
    for k, v in ipairs(GlobalState["StorageUnits"]) do
        local unit = GlobalState[string.format("StorageUnit:%s", v)]
        if unit.managedBy == managedBy then
            table.insert(allUnits, unit)
        end
    end

    return allUnits
end)

exports('StorageUnitsGetNearUnit', function(source)
    local pedPos = GetEntityCoords(GetPlayerPed(source))

    if GlobalState["StorageUnits"] == nil then
        return false
    else
        local closest = nil
        for k, v in ipairs(GlobalState["StorageUnits"]) do
            local unit = GlobalState[string.format("StorageUnit:%s", v)]

            if unit then
                local dist = #(pedPos - unit.location)
                if dist < 3.0 and (not closest or dist < closest.dist) then
                    closest = {
                        dist = dist,
                        unitId = unit.id,
                    }
                end
            end
        end
        return closest
    end
end)

function FormatStorageUnit(data)
    data.id = data._id
    data.location = vector3(data.location.x + 0.0, data.location.y + 0.0, data.location.z + 0.0)
    data.passcode = nil

    return data
end

function SaveStorageUnitLastAccess()
    for k, v in pairs(unitLastAccessed) do
        exports['sandbox-base']:DatabaseGameUpdateOne({
            collection = "storage_units",
            query = {
                _id = k,
            },
            update = {
                ["$set"] = {
                    lastAccessed = v,
                },
            },
        })
    end
end

AddEventHandler("Core:Server:ForceSave", function()
    SaveStorageUnitLastAccess()
end)
