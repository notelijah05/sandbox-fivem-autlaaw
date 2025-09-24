AddEventHandler('Businesses:Server:Startup', function()
    exports["sandbox-base"]:RegisterServerCallback('BH:MakeItRain', function(source, data, cb)
        local char = exports['sandbox-characters']:FetchCharacterSource(source)
        local targetChar = exports['sandbox-characters']:FetchCharacterSource(data?.target)

        if char and targetChar and data?.type and Player(targetChar:GetData('Source')).state.onDuty == 'bahama' then
            local itemData = exports['sandbox-inventory']:ItemsGetData(data.type)
            if data.type == 'cash' then
                if Wallet:Modify(char:GetData('Source'), -100) then
                    Wallet:Modify(targetChar:GetData('Source'), 100)
                    return cb(true)
                end
            elseif itemData then
                if exports['sandbox-inventory']:ItemsHas(char:GetData('SID'), 1, data.type, 1) then
                    if exports['sandbox-inventory']:Remove(char:GetData('SID'), 1, data.type, 1) then
                        Wallet:Modify(targetChar:GetData('Source'), math.floor(itemData.price * 0.1))
                        Wallet:Modify(char:GetData('Source'), math.floor(itemData.price * 0.8))

                        local f = exports['sandbox-finance']:AccountsGetOrganization("bahama")
                        exports['sandbox-finance']:BalanceDeposit(f.Account, math.floor(itemData.price * 0.05), {
                            type = "deposit",
                            title = "Private Dances",
                            description = string.format("5%% Tax On %s Private Dances", math.floor(itemData.price)),
                            data = data,
                        }, true)

                        return cb(true)
                    end
                end
            end
        end

        cb(false)
    end)
end)
