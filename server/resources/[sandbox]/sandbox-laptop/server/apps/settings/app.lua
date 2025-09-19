AddEventHandler("Laptop:Server:RegisterCallbacks", function()
    Callbacks:RegisterServerCallback("Laptop:Settings:Update", function(source, data, cb)
        local char = exports['sandbox-characters']:FetchCharacterSource(source)
        if char then
            local settings = char:GetData("LaptopSettings")
            settings[data.type] = data.val
            char:SetData("LaptopSettings", settings)
        end
    end)
end)
