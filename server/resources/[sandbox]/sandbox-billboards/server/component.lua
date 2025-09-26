AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Wait(1000)
        FetchBillboardsData()

        exports["sandbox-chat"]:RegisterAdminCommand("setbillboard", function(source, args, rawCommand)
            local billboardId, billboardUrl = args[1], args[2]

            if #billboardUrl <= 10 then
                billboardUrl = false
            end

            exports['sandbox-billboards']:Set(billboardId, billboardUrl)
        end, {
            help = "Set a Billboard URL",
            params = {
                {
                    name = "ID",
                    help = "Billboard ID",
                },
                {
                    name = "URL",
                    help = "Billboard URL",
                },
            },
        }, 2)

        exports["sandbox-base"]:RegisterServerCallback("Billboards:UpdateURL", function(source, data, cb)
            local billboardData = _billboardConfig[data and data.id]
            if billboardData and billboardData.job and Player(source).state.onDuty == billboardData.job then
                local billboardUrl = data.link
                if #billboardUrl <= 5 then
                    billboardUrl = false
                end

                if not billboardUrl or exports['sandbox-base']:RegexTest(_billboardRegex, billboardUrl, "gim") then
                    cb(exports['sandbox-billboards']:Set(data.id, billboardUrl))
                else
                    cb(false, true)
                end
            else
                cb(false)
            end
        end)
    end
end)

exports("Set", function(id, url)
    if id and _billboardConfig[id] then
        local updated = SetBillboardURL(id, url)
        if updated then
            GlobalState[string.format("Billboards:%s", id)] = url

            TriggerClientEvent('Billboards:Client:UpdateBoardURL', -1, id, url)

            return true
        end
    end
    return false
end)

exports("Get", function(id)
    return GlobalState[string.format("Billboards:%s", id)]
end)

exports("GetCategory", function(cat)
    local cIds = {}

    for k, v in pairs(_billboardConfig) do
        if v.category == cat then
            table.insert(cIds, k)
        end
    end

    return cIds
end)

local started = false
function FetchBillboardsData()
    if started then return; end

    started = true

    local fetchedBillboards = {}
    local billboardIds = {}

    exports['sandbox-base']:DatabaseGameFind({
        collection = 'billboards',
        query = {}
    }, function(success, results)
        if success and #results > 0 then
            for k, v in ipairs(results) do
                if v.billboardId and v.billboardUrl then
                    fetchedBillboards[v.billboardId] = v.billboardUrl
                end
            end
        end

        for k, v in pairs(_billboardConfig) do
            GlobalState[string.format("Billboards:%s", k)] = fetchedBillboards[k]

            table.insert(billboardIds, k)
        end
    end)
end

function SetBillboardURL(billboardId, url)
    local p = promise.new()

    exports['sandbox-base']:DatabaseGameFindOneAndUpdate({
        collection = 'billboards',
        query = {
            billboardId = billboardId,
        },
        update = {
            ['$set'] = {
                billboardUrl = url,
            },
        },
        options = {
            returnDocument = 'after',
            upsert = true,
        }
    }, function(success, results)
        if success and results then
            p:resolve(true)
        else
            p:resolve(false)
        end
    end)

    local res = Citizen.Await(p)
    return res
end
