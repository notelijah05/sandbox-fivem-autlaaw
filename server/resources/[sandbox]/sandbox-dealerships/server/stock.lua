exports('StockFetchAll', function()
    local p = promise.new()
    exports['sandbox-base']:DatabaseGameFind({
        collection = 'dealer_stock',
        query = {}
    }, function(success, result)
        if success then
            p:resolve(result)
        else
            p:resolve(false)
        end
    end)
    return Citizen.Await(p)
end)

exports('StockFetchDealer', function(dealerId)
    local p = promise.new()
    exports['sandbox-base']:DatabaseGameFind({
        collection = 'dealer_stock',
        query = {
            dealership = dealerId,
        }
    }, function(success, result)
        if success then
            p:resolve(result)
        else
            p:resolve(false)
        end
    end)
    return Citizen.Await(p)
end)

exports('StockFetchDealerVehicle', function(dealerId, vehModel)
    local p = promise.new()
    exports['sandbox-base']:DatabaseGameFindOne({
        collection = 'dealer_stock',
        query = {
            dealership = dealerId,
            vehicle = vehModel,
        }
    }, function(success, result)
        if success and #result > 0 then
            p:resolve(result[1])
        else
            p:resolve(false)
        end
    end)
    return Citizen.Await(p)
end)

exports('StockHasVehicle', function(dealerId, vehModel)
    local vehicle = exports['sandbox-dealerships']:StockFetchDealerVehicle(dealerId, vehModel)
    if vehicle and vehicle.quantity > 0 then
        return vehicle.quantity
    else
        return false
    end
end)

exports('StockAdd', function(dealerId, vehModel, modelType, quantity, vehData)
    vehData = ValidateVehicleData(vehData)
    if _dealerships[dealerId] and vehModel and vehData and quantity > 0 then
        local isStocked = exports['sandbox-dealerships']:StockFetchDealerVehicle(dealerId, vehModel)
        local p = promise.new()
        if isStocked then -- The vehicle is already stocked
            exports['sandbox-base']:DatabaseGameUpdateOne({
                collection = 'dealer_stock',
                query = {
                    dealership = dealerId,
                    vehicle = vehModel,
                },
                update = {
                    ['$inc'] = {
                        quantity = quantity,
                    },
                    ['$set'] = {
                        data = vehData,
                        lastStocked = os.time(),
                    }
                }
            }, function(success, result)
                if success and result > 0 then
                    p:resolve({
                        success = true,
                        existed = true,
                    })
                else
                    p:resolve(false)
                end
            end)
        else
            exports['sandbox-base']:DatabaseGameInsertOne({
                collection = 'dealer_stock',
                document = {
                    dealership = dealerId,
                    vehicle = vehModel,
                    modelType = modelType,
                    data = vehData,
                    quantity = quantity,
                    lastStocked = os.time(),
                }
            }, function(success, result)
                if success and result > 0 then
                    p:resolve({
                        success = true,
                        existed = false,
                    })
                else
                    p:resolve(false)
                end
            end)
        end
        return Citizen.Await(p)
    end
    return false
end)

exports('StockIncrease', function(dealerId, vehModel, amount)
    if _dealerships[dealerId] and vehModel and amount > 0 then
        local isStocked = exports['sandbox-dealerships']:StockFetchDealerVehicle(dealerId, vehModel)
        if isStocked then -- The vehicle is already stocked
            local p = promise.new()
            exports['sandbox-base']:DatabaseGameUpdateOne({
                collection = 'dealer_stock',
                query = {
                    dealership = dealerId,
                    vehicle = vehModel,
                },
                update = {
                    ['$inc'] = {
                        quantity = amount,
                    },
                    ['$set'] = {
                        lastStocked = os.time(),
                    }
                }
            }, function(success, result)
                if success and result > 0 then
                    p:resolve({ success = true })
                else
                    p:resolve(false)
                end
            end)
            return Citizen.Await(p)
        else
            return false
        end
    end
    return false
end)

exports('StockUpdate', function(dealerId, vehModel, setting)
    if _dealerships[dealerId] and vehModel and type(setting) == "table" then
        local isStocked = exports['sandbox-dealerships']:StockFetchDealerVehicle(dealerId, vehModel)
        if isStocked then -- The vehicle is already stocked
            local p = promise.new()
            exports['sandbox-base']:DatabaseGameUpdateOne({
                collection = 'dealer_stock',
                query = {
                    dealership = dealerId,
                    vehicle = vehModel,
                },
                update = {
                    ['$set'] = setting
                }
            }, function(success, result)
                if success and result > 0 then
                    p:resolve({ success = true })
                else
                    p:resolve(false)
                end
            end)
            return Citizen.Await(p)
        else
            return false
        end
    end
    return false
end)

exports('StockEnsure', function(dealerId, vehModel, quantity, vehData)
    if _dealerships[dealerId] and vehModel then
        local isStocked = exports['sandbox-dealerships']:StockFetchDealerVehicle(dealerId, vehModel)
        if isStocked then
            local missingQuantity = quantity - isStocked.quantity
            if missingQuantity >= 1 then
                return exports['sandbox-dealerships']:StockAdd(dealerId, vehModel, missingQuantity, vehData)
            end
        else
            return exports['sandbox-dealerships']:StockAdd(dealerId, vehModel, quantity, vehData)
        end
    end
    return false
end)

exports('StockRemove', function(dealerId, vehModel, quantity)
    if _dealerships[dealerId] and vehModel and quantity > 0 then
        local isStocked = exports['sandbox-dealerships']:StockFetchDealerVehicle(dealerId, vehModel)

        if isStocked and isStocked.quantity > 0 then
            local newQuantity = isStocked.quantity - quantity
            if newQuantity >= 0 then
                local p = promise.new()
                exports['sandbox-base']:DatabaseGameUpdateOne({
                    collection = 'dealer_stock',
                    query = {
                        dealership = dealerId,
                        vehicle = vehModel,
                    },
                    update = {
                        ['$set'] = {
                            quantity = newQuantity,
                            lastPurchase = os.time(),
                        }
                    }
                }, function(success, result)
                    if success and result > 0 then
                        p:resolve(newQuantity)
                    else
                        p:resolve(false)
                    end
                end)
                return Citizen.Await(p)
            end
        end
    end
    return false
end)

local requiredAttributes = {
    make = 'string',
    model = 'string',
    class = 'string',
    --category = 'string',
    price = 'number'
}

function ValidateVehicleData(data)
    if type(data) ~= 'table' then
        return false
    end
    for k, v in pairs(requiredAttributes) do
        if data[k] == nil or type(data[k]) ~= v then
            return false
        end
    end

    return data
end
