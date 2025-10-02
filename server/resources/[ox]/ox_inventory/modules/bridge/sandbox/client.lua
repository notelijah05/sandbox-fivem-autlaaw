local statusNames = {
    hunger = "PLAYER_HUNGER",
    thirst = "PLAYER_THIRST",
    stress = "PLAYER_STRESS"
}

---@diagnostic disable-next-line: duplicate-set-field
function client.setPlayerStatus(values)
    for name, value in pairs(values) do
        name = statusNames[name]

        if value > 0 then
            exports['sandbox-status']:Add(name, value, false, false)
        else
            exports['sandbox-status']:Remove(name, value, false, false)
        end
    end
end

function client.hasGroup(group)
    if type(group) == 'table' then
        for name, rank in pairs(group) do
            local jobData = exports['sandbox-jobs']:HasJob(name)
            if jobData and type(jobData) == 'table' then
                return name, rank or 1
            end
        end
        return false
    else
        local jobData = exports['sandbox-jobs']:HasJob(group)
        if jobData and type(jobData) == 'table' then
            return group, 1
        end
        return false
    end
end

RegisterNetEvent("Characters:Client:Logout", client.onLogout)
