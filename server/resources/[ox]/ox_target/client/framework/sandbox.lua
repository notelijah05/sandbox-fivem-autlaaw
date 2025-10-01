local utils = require 'client.utils'

---@diagnostic disable-next-line: duplicate-set-field
function utils.hasPlayerGotGroup(filter, reqDuty, reqOffDuty, workplace, permissionKey)
    local function checkJob(jobName)
        if type(jobName) ~= "string" then
            return false
        end

        local jobInfo = exports['sandbox-jobs']:HasJob(jobName)

        if not jobInfo then
            return false
        end

        if workplace ~= nil then
            local hasWorkplace = jobInfo.Workplace and jobInfo.Workplace.Id == workplace
            if not hasWorkplace then
                return false
            end
        end

        if reqDuty ~= nil or reqOffDuty ~= nil then
            local isOnDuty = exports['sandbox-jobs']:DutyGet(jobName)

            if reqDuty ~= nil then
                if reqDuty and not isOnDuty then
                    return false
                elseif not reqDuty and isOnDuty then
                    return false
                end
            end

            if reqOffDuty ~= nil then
                if reqOffDuty and isOnDuty then
                    return false
                elseif not reqOffDuty and not isOnDuty then
                    return false
                end
            end
        end

        if permissionKey ~= nil then
            local hasPermission = exports['sandbox-jobs']:HasPermissionInJob(jobName, permissionKey)
            if not hasPermission then
                return false
            end
        end

        return true
    end

    local filterType = type(filter)

    if filterType == "string" then
        return checkJob(filter)
    elseif filterType == "table" then
        local tableType = table.type(filter)

        if tableType == "array" or #filter > 0 then
            for i, jobEntry in ipairs(filter) do
                local jobName = jobEntry

                if type(jobEntry) == "table" then
                    jobName = jobEntry.job or jobEntry.name
                    if not jobName then
                        for k, v in pairs(jobEntry) do
                            jobName = v
                            break
                        end
                    end
                end

                if jobName and checkJob(jobName) then
                    return true
                end
            end
            return false
        elseif tableType == "hash" then
            for jobName, grade in pairs(filter) do
                if type(jobName) == "string" then
                    local jobInfo = exports['sandbox-jobs']:HasJob(jobName)
                    if jobInfo then
                        local playerGrade = jobInfo.Grade and jobInfo.Grade.Level or 0
                        if playerGrade >= grade then
                            if workplace ~= nil then
                                local hasWorkplace = jobInfo.Workplace and jobInfo.Workplace.Id == workplace
                                if not hasWorkplace then
                                    goto continue
                                end
                            end

                            if reqDuty ~= nil or reqOffDuty ~= nil then
                                local isOnDuty = exports['sandbox-jobs']:DutyGet(jobName)

                                if reqDuty ~= nil then
                                    if reqDuty and not isOnDuty then
                                        goto continue
                                    elseif not reqDuty and isOnDuty then
                                        goto continue
                                    end
                                end

                                if reqOffDuty ~= nil then
                                    if reqOffDuty and isOnDuty then
                                        goto continue
                                    elseif not reqOffDuty and not isOnDuty then
                                        goto continue
                                    end
                                end
                            end

                            if permissionKey ~= nil then
                                local hasPermission = exports['sandbox-jobs']:HasPermissionInJob(jobName, permissionKey)
                                if not hasPermission then
                                    goto continue
                                end
                            end

                            return true
                        end
                    end
                end
                ::continue::
            end
            return false
        else
            local jobName = filter.job or filter.name
            if type(jobName) == "string" then
                return checkJob(jobName)
            end
            return false
        end
    end

    return false
end
