_managementData = {}

exports('ManagementLoadData', function()
    local p = promise.new()
    exports['sandbox-base']:DatabaseGameFind({
        collection = 'dealer_data',
        query = {}
    }, function(success, results)
        if success then
            local fuckface = {}
            for k, v in ipairs(results) do
                if v.dealership then
                    fuckface[v.dealership] = v
                end
            end

            for k, v in pairs(_dealerships) do
                if fuckface[k] then
                    _managementData[k] = fuckface[k]
                else
                    _managementData[k] = _defaultDealershipSalesData
                end
            end
            p:resolve(true)
        else
            p:resolve(false)
        end
    end)
    return Citizen.Await(p)
end)

exports('ManagementSetData', function(dealerId, key, val)
    local data = _managementData[dealerId]
    if data then
        local dealerData = table.copy(data)
        dealerData.dealership = nil
        dealerData._id = nil
        dealerData[key] = val

        local p = promise.new()
        exports['sandbox-base']:DatabaseGameUpdateOne({
            collection = 'dealer_data',
            query = {
                dealership = dealerId,
            },
            update = {
                ['$set'] = dealerData
            },
            options = {
                upsert = true,
            }
        }, function(success, results)
            if success then
                _managementData[dealerId] = dealerData
                p:resolve(_managementData[dealerId])
            else
                p:resolve(false)
            end
        end)
        return Citizen.Await(p)
    end
    return false
end)

exports('ManagementSetMultipleData', function(dealerId, updatingData)
    local data = _managementData[dealerId]
    if data then
        local dealerData = table.copy(data)
        dealerData.dealership = nil
        dealerData._id = nil

        for k, v in pairs(updatingData) do
            dealerData[k] = v
        end

        local p = promise.new()
        exports['sandbox-base']:DatabaseGameUpdateOne({
            collection = 'dealer_data',
            query = {
                dealership = dealerId,
            },
            update = {
                ['$set'] = dealerData
            },
            options = {
                upsert = true,
            }
        }, function(success, results)
            if success then
                _managementData[dealerId] = dealerData
                p:resolve(_managementData[dealerId])
            else
                p:resolve(false)
            end
        end)
        return Citizen.Await(p)
    end
    return false
end)

exports('ManagementGetAllData', function(dealerId)
    return _managementData[dealerId]
end)

exports('ManagementGetData', function(dealerId, key)
    local data = _managementData[dealerId]
    if data then
        return data[key]
    end
    return false
end)
