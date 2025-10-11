-- Dealership Sale Records
exports('RecordsGet', function(dealership)
    if _dealerships[dealership] then
        local p = promise.new()
        exports.oxmysql:execute('SELECT * FROM dealer_records WHERE dealership = ? ORDER BY time DESC LIMIT 100',
            { dealership }, function(results)
                if results then
                    p:resolve(results or {})
                else
                    p:resolve(false)
                end
            end)
        return Citizen.Await(p)
    end
    return false
end)

exports('RecordsGetPage', function(category, term, dealership, page, perPage)
    if _dealerships[dealership] then
        local p = promise.new()

        local skip = 0
        if page > 1 then
            skip = perPage * (page - 1)
        end

        local whereConditions = { "dealership = ?" }
        local params = { dealership }

        if #term > 0 then
            table.insert(whereConditions,
                "(CONCAT(JSON_UNQUOTE(JSON_EXTRACT(seller, '$.First')), ' ', JSON_UNQUOTE(JSON_EXTRACT(seller, '$.Last'))) LIKE ? OR CONCAT(JSON_UNQUOTE(JSON_EXTRACT(buyer, '$.First')), ' ', JSON_UNQUOTE(JSON_EXTRACT(buyer, '$.Last'))) LIKE ? OR CONCAT(JSON_UNQUOTE(JSON_EXTRACT(vehicle, '$.data.make')), ' ', JSON_UNQUOTE(JSON_EXTRACT(vehicle, '$.data.model'))) LIKE ?)")
            local searchTerm = "%" .. term .. "%"
            table.insert(params, searchTerm)
            table.insert(params, searchTerm)
            table.insert(params, searchTerm)
        end

        if category ~= "all" then
            table.insert(whereConditions, "JSON_UNQUOTE(JSON_EXTRACT(vehicle, '$.data.category')) = ?")
            table.insert(params, category)
        end

        local whereClause = table.concat(whereConditions, " AND ")
        local query = "SELECT * FROM dealer_records WHERE " .. whereClause .. " ORDER BY time DESC LIMIT ? OFFSET ?"
        table.insert(params, perPage + 1)
        table.insert(params, skip)

        exports.oxmysql:execute(query, params, function(results)
            if results then
                local more = false
                if #results > perPage then
                    more = true
                    table.remove(results)
                end

                p:resolve({
                    data = results,
                    more = more,
                })
            else
                p:resolve(false)
            end
        end)
        return Citizen.Await(p)
    end
    return false
end)

exports('RecordsCreate', function(dealership, document)
    if type(document) == 'table' then
        document.dealership = dealership
        local p = promise.new()

        local sellerJson = document.seller and json.encode(document.seller) or nil
        local buyerJson = document.buyer and json.encode(document.buyer) or nil
        local vehicleJson = document.vehicle and json.encode(document.vehicle) or nil

        exports.oxmysql:execute(
            'INSERT INTO dealer_records (dealership, time, seller, buyer, vehicle, price, commission) VALUES (?, ?, ?, ?, ?, ?, ?)',
            { document.dealership, document.time, sellerJson, buyerJson, vehicleJson, document.price, document
                .commission },
            function(insertId)
                p:resolve(insertId and insertId > 0)
            end)
        return Citizen.Await(p)
    end
    return false
end)

exports('RecordsCreateBuyBack', function(dealership, document)
    if type(document) == 'table' then
        document.dealership = dealership
        local p = promise.new()

        local sellerJson = document.seller and json.encode(document.seller) or nil
        local buyerJson = document.buyer and json.encode(document.buyer) or nil
        local vehicleJson = document.vehicle and json.encode(document.vehicle) or nil

        exports.oxmysql:execute(
            'INSERT INTO dealer_records_buybacks (dealership, time, seller, buyer, vehicle, price, commission) VALUES (?, ?, ?, ?, ?, ?, ?)',
            { document.dealership, document.time, sellerJson, buyerJson, vehicleJson, document.price, document
                .commission },
            function(insertId)
                p:resolve(insertId and insertId > 0)
            end)
        return Citizen.Await(p)
    end
    return false
end)
