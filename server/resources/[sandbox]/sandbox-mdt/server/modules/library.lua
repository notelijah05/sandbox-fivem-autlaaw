exports("LibraryCreate", function(label, link, job, workplace)
    local inserted = MySQL.insert.await("INSERT INTO mdt_library (label, link, job, workplace) VALUES (?, ?, ?, ?)",
        {
            label,
            link,
            job,
            workplace and workplace or nil,
        })

    return inserted
end)

exports("LibraryDelete", function(id)
    MySQL.query.await("DELETE FROM mdt_library WHERE id = ?", {
        id
    })

    return true
end)

AddEventHandler("MDT:Server:RegisterCallbacks", function()
    exports["sandbox-base"]:RegisterServerCallback("MDT:AddLibraryDocument", function(source, data, cb)
        if CheckMDTPermissions(source, true) then
            cb(exports['sandbox-mdt']:LibraryCreate(data.label, data.link, data.job, data.workplace))
        else
            cb(false)
        end
    end)

    exports["sandbox-base"]:RegisterServerCallback("MDT:RemoveLibraryDocument", function(source, data, cb)
        if CheckMDTPermissions(source, true) then
            cb(exports['sandbox-mdt']:LibraryDelete(data.id))
        else
            cb(false)
        end
    end)

    exports["sandbox-base"]:RegisterServerCallback("MDT:GetLibraryDocuments", function(source, data, cb)
        local char = exports['sandbox-characters']:FetchCharacterSource(source)
        if char then
            local dutyData = exports['sandbox-jobs']:DutyGet(source)

            if CheckMDTPermissions(source, true) then
                local res = MySQL.query.await("SELECT id, label, link FROM mdt_library ORDER BY label", {})

                cb(res)
            elseif dutyData then
                local res = MySQL.query.await(
                    "SELECT id, label, link FROM mdt_library WHERE (job = ? AND workplace IS NULL) OR (job = ? AND workplace = ?) ORDER BY label",
                    {
                        dutyData.Id,
                        dutyData.Id,
                        dutyData.WorkplaceId,
                    })
                cb(res)
            else
                cb({})
            end
        else
            cb({})
        end
    end)
end)
