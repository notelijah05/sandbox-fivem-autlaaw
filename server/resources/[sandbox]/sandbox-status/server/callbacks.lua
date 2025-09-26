function RegisterCallbacks()
    exports["sandbox-base"]:RegisterServerCallback('Status:Get', function(source, data, cb)
        local char = exports['sandbox-characters']:FetchCharacterSource(source)
        if char ~= nil then
            local s = char:GetData('Status')
            cb(s)
        else
            cb({})
        end
    end)
end
