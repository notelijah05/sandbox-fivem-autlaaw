local badgeCooldowns = {}

AddEventHandler("MDT:Server:RegisterCallbacks", function()
    exports["sandbox-base"]:RegisterServerCallback("MDT:PrintBadge", function(source, data, cb)
        local now = GetGameTimer()

        if not badgeCooldowns[source] or (now - badgeCooldowns[source]) > 20000 then
            badgeCooldowns[source] = GetGameTimer()
            local char = exports['sandbox-characters']:FetchCharacterSource(source)
            if char and CheckMDTPermissions(source, { 'PD_HIGH_COMMAND', 'SAFD_HIGH_COMMAND', 'DOJ_JUDGE', 'DOC_HIGH_COMMAND' }) then
                local officer = exports['sandbox-mdt']:PeopleView(data.SID)
                if officer then
                    local departmentName = false
                    local departmentData = false
                    local titleData = false
                    if officer.Jobs then
                        for k, v in ipairs(officer.Jobs) do
                            if v.Id == data.JobId and v.Workplace then
                                departmentData = v.Workplace.Id
                                departmentName = v.Workplace.Name
                                titleData = v.Grade.Name
                            end
                        end
                    end

                    if departmentData then
                        exports['sandbox-inventory']:AddItem(char:GetData('SID'), 'government_badge', 1, {
                            ['Department Name'] = departmentName,
                            Title = titleData,
                            First = officer.First,
                            Last = officer.Last,
                            SID = officer.SID,
                            Callsign = officer.Callsign,
                            Mugshot = officer.Mugshot,
                            Department = departmentData,
                            DOB = officer.DOB,
                        }, 1)
                    else
                        cb(false)
                    end
                else
                    cb(false)
                end
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)

    exports['sandbox-inventory']:RegisterUse("government_badge", "MDT", function(source, itemData)
        if itemData and itemData.MetaData and itemData.MetaData.Department then
            exports["sandbox-base"]:ClientCallback(source, "MDT:Client:CanShowBadge", itemData.MetaData,
                function(canShow)
                    TriggerClientEvent("MDT:Client:ShowBadge", -1, source, itemData.MetaData)
                end)
        end
    end)

    exports('govid', function(event, item, inventory, slot, data)
        if event == 'usingItem' then
            local source = inventory.id
            local char = exports['sandbox-characters']:FetchCharacterSource(source)

            if not char or not data or not data.StateID then
                TriggerClientEvent('ox_lib:notify', source,
                    { type = 'error', description = 'Invalid government ID data' })

                return false
            end

            return
        end

        if event == 'usedItem' then
            local source = inventory.id
            local char = exports['sandbox-characters']:FetchCharacterSource(source)

            if char and data and data.StateID then
                exports["sandbox-base"]:ClientCallback(source, "MDT:Client:CanShowLicense", data,
                    function(canShow)
                        TriggerClientEvent("MDT:Client:ShowLicense", -1, source, {
                            SID = data.StateID,
                            Name = data.Name,
                            Gender = data.Gender,
                            DOB = data.DOB,
                            Mugshot = data.Mugshot,
                        })
                    end)
            end

            return
        end

        if event == 'buying' then
            return TriggerClientEvent('ox_lib:notify', inventory.id,
                { type = 'success', description = 'You bought a government ID' })
        end
    end)
end)
