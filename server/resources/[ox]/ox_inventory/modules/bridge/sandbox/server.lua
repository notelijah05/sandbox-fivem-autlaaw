local Inventory = require 'modules.inventory.server'
local Config = require 'modules.bridge.sandbox.config'

function server.setPlayerData(player)
    local char = exports['sandbox-characters']:FetchCharacterSource(player.source)
    if not char then return end

    local groups = {}
    local jobs = char:GetData("Jobs") or {}
    for _, job in ipairs(jobs) do
        if job.Id then
            groups[job.Id] = job.Grade and job.Grade.Level or 1
        end
    end

    return {
        source = char:GetData("Source"),
        name = ('%s %s'):format(char:GetData("First"), char:GetData("Last")),
        groups = groups,
        sex = char:GetData("Gender"),
        dateofbirth = char:GetData("DOB"),
        identifier = char:GetData("SID"),
    }
end

---@diagnostic disable-next-line: duplicate-set-field
function server.syncInventory(inv)
    local accounts = Inventory.GetAccountItemCounts(inv)

    if accounts then
        local char = exports['sandbox-characters']:FetchCharacterSource(inv.id)
        if char then
            char:SetData("Cash", accounts.money)
        end
    end
end

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        exports['sandbox-base']:MiddlewareAdd("Characters:Created", function(source, cData)
            local slot = 1
            for k, v in ipairs(Config.StartItems) do
                local metadata = v.metadata and v.metadata(source, cData) or nil

                Inventory.AddItem(source, v.name, v.countTo, metadata, slot)

                slot += 1
            end

            return true
        end, 2)

        exports['sandbox-base']:MiddlewareAdd("Characters:Spawning", function(source)
            local char = exports['sandbox-characters']:FetchCharacterSource(source)
            server.setPlayerInventory({
                source = source,
                identifier = char:GetData("SID"),
                name = ('%s %s'):format(char:GetData("First"), char:GetData("Last")),
            })

            Inventory.SetItem(source, 'money', char:GetData("Cash"))
        end, 2)

        exports['sandbox-base']:MiddlewareAdd('playerDropped', server.playerDropped, 5)
        exports['sandbox-base']:MiddlewareAdd('Characters:Logout', server.playerDropped, 5)

        CreateThread(function()
            for _, playerId in ipairs(GetPlayers()) do
                local playerSource = tonumber(playerId)
                if playerSource then
                    local char = exports['sandbox-characters']:FetchCharacterSource(playerSource)
                    if char then
                        server.setPlayerInventory({
                            source = playerSource,
                            identifier = char:GetData("SID"),
                            name = ('%s %s'):format(char:GetData("First"), char:GetData("Last")),
                        })

                        Inventory.SetItem(playerSource, 'money', char:GetData("Cash"))
                    end
                end
            end
        end)
    end
end)

AddEventHandler("Characters:Server:SetData", function(src, key, value)
    if key ~= "Cash" then
        return
    end

    Inventory.SetItem(src, "money", value)
end)

AddEventHandler('ox_inventory:itemCount', function(name, count)
    if name == 'money' then
        local char = exports['sandbox-characters']:FetchCharacterSource(source)
        if char then
            char:SetData("Cash", count)
        end
    end
end)
