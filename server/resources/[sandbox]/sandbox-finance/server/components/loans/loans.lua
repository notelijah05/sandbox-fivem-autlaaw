local _ranStartup = false

function RunLoanStartup()
    if _ranStartup then return end
    _ranStartup = true

    exports['sandbox-base']:DatabaseGameCount({
        collection = 'loans',
        query = {
            Remaining = {
                ['$gt'] = 0,
            }
        }
    }, function(success, count)
        if success then
            exports['sandbox-base']:LoggerTrace('Loans', 'Loaded ^2' .. count .. '^7 Active Loans')
        end
    end)
end

AddEventHandler('Finance:Server:Startup', function()
    RunLoanStartup()
    RegisterLoanCallbacks()

    CreateLoanTasks()
end)

function CreateLoanTasks()
    exports['sandbox-base']:TasksRegister('loan_payment', 60, function()
        --RegisterCommand('testloans', function()
        local TASK_RUN_TIMESTAMP = os.time()

        exports['sandbox-base']:DatabaseGameAggregate({
            collection = 'loans',
            aggregate = {
                {
                    ['$match'] = {
                        ['$and'] = {
                            { -- Due now
                                NextPayment = {
                                    ['$gt'] = 0,
                                    ['$lte'] = (TASK_RUN_TIMESTAMP)
                                }
                            },
                            { -- There is still cost remaining
                                Defaulted = false,
                                Remaining = {
                                    ['$gte'] = 0
                                }
                            },
                        }
                    }
                },
                {
                    ['$set'] = {
                        InterestRate = {
                            ['$add'] = { '$InterestRate', _loanConfig.missedPayments.interestIncrease }
                        },
                        LastMissedPayment = TASK_RUN_TIMESTAMP,
                        MissedPayments = {
                            ['$add'] = { '$MissedPayments', 1 },
                        },
                        TotalMissedPayments = {
                            ['$add'] = { '$TotalMissedPayments', 1 },
                        },
                        NextPayment = {
                            ['$add'] = { '$NextPayment', _loanConfig.paymentInterval },
                        },
                        Remaining = {
                            ['$add'] = {
                                '$Remaining',
                                { ['$multiply'] = { '$Total', (_loanConfig.missedPayments.charge / 100) } }
                            }
                        }
                    },
                },
                {
                    ['$merge'] = {
                        into = 'loans',
                        on = '_id',
                        whenMatched = 'replace',
                        whenNotMatched = 'discard',
                    }
                }
            }
        }, function(success, results)
            if success then
                -- Get All the Loans are now need to be defaulted and notify/seize
                exports['sandbox-base']:DatabaseGameFind({
                    collection = 'loans',
                    query = {
                        ['$expr'] = {
                            ['$gte'] = {
                                "$MissedPayments",
                                "$MissablePayments"
                            }
                        },
                        Defaulted = false,
                    }
                }, function(success, results)
                    if success and #results > 0 then
                        local updatingAssets = {}

                        for k, v in ipairs(results) do
                            table.insert(updatingAssets, v.AssetIdentifier)
                        end

                        exports['sandbox-base']:DatabaseGameUpdate({
                            collection = 'loans',
                            query = {
                                AssetIdentifier = {
                                    ['$in'] = updatingAssets
                                }
                            },
                            update = {
                                ['$set'] = {
                                    Defaulted = true,
                                }
                            }
                        }, function(success, updated)
                            if success then
                                exports['sandbox-base']:LoggerInfo('Loans',
                                    '^2' .. #results .. '^7 Loans Have Just Been Defaulted')
                                for k, v in ipairs(results) do
                                    if v.SID then
                                        DecreaseCharacterCreditScore(v.SID, _creditScoreConfig.removal.defaultedLoan)
                                        local onlineChar = exports['sandbox-characters']:FetchBySID(v.SID)
                                        if onlineChar then
                                            SendDefaultedLoanNotification(onlineChar:GetData('Source'), v)
                                        end
                                    end

                                    if v.AssetIdentifier then
                                        if v.Type == 'vehicle' then
                                            exports['sandbox-vehicles']:OwnedSeize(v.AssetIdentifier, true)
                                        elseif v.Type == 'property' then
                                            Properties.Commerce:Foreclose(v.AssetIdentifier, true)
                                        end
                                    end
                                end
                            end
                        end)
                    end
                end)

                -- Notify if someone just missed a payment.
                exports['sandbox-base']:DatabaseGameFind({
                    collection = 'loans',
                    query = {
                        ['$expr'] = {
                            ['$lt'] = {
                                "$MissedPayments",
                                "$MissablePayments"
                            }
                        },
                        Defaulted = false,
                        LastMissedPayment = TASK_RUN_TIMESTAMP,
                    }
                }, function(success, results)
                    if success and #results > 0 then
                        exports['sandbox-base']:LoggerInfo('Loans',
                            '^2' .. #results .. '^7 Loan Payments Were Just Missed')
                        for k, v in ipairs(results) do
                            if v.SID then
                                DecreaseCharacterCreditScore(v.SID, _creditScoreConfig.removal.missedLoanPayment)

                                local onlineChar = exports['sandbox-characters']:FetchBySID(v.SID)
                                if onlineChar then
                                    SendMissedLoanNotification(onlineChar:GetData('Source'), v)
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end)

    exports['sandbox-base']:TasksRegister('loan_reminder', 120, function()
        local TASK_RUN_TIMESTAMP = os.time()
        -- Get All Loans That are Due Soon
        exports['sandbox-base']:DatabaseGameFind({
            collection = 'loans',
            query = {
                Remaining = {
                    ['$gt'] = 0,
                },
                Defaulted = false,
                ['$or'] = {
                    { -- The payment is due soon
                        NextPayment = {
                            ['$gt'] = 0,
                            ['$lte'] = (TASK_RUN_TIMESTAMP + (60 * 60 * 6)), -- Payment is due within the next 6 hours
                        }
                    },
                    { -- The last payment was missed, annoy them by constantly sending them notifications
                        MissedPayments = {
                            ['$gt'] = 0,
                        }
                    },
                }
            }
        }, function(success, results)
            if success and #results > 0 then
                for k, v in ipairs(results) do
                    if v.SID then
                        local onlineChar = exports['sandbox-characters']:FetchBySID(v.SID)
                        if onlineChar then
                            exports['sandbox-phone']:NotificationAdd(onlineChar:GetData("Source"),
                                "Loan Payment Due",
                                "You have a loan payment that is due very soon.", os.time(), 7500, "loans", {})
                        end

                        Wait(100)
                    end
                end
            end
        end)
    end)
end

function SendMissedLoanNotification(source, loanData)
    exports['sandbox-phone']:NotificationAdd(source, "Loan Payment Missed",
        "You just missed a loan payment on one of your loans.",
        os.time(), 7500, "loans", {})
end

function SendDefaultedLoanNotification(source, loanData)
    exports['sandbox-phone']:NotificationAdd(source, "Loan Defaulted",
        "One of your loans just got defaulted and the assets are going to be seized.", os.time(), 7500, "loans", {})
end

local typeNames = {
    vehicle = 'Vehicle Loan',
    property = 'Property Loan',
}

function GetLoanTypeName(type)
    return typeNames[type]
end
