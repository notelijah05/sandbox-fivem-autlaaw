RegisterServerEvent('Characters:Server:Spawning', function()
    exports['sandbox-base']:MiddlewareTriggerEvent("Characters:Spawning", source)
end)

RegisterServerEvent('Ped:LeaveCreator', function()
    local char = exports['sandbox-characters']:FetchCharacterSource(source)
    if char ~= nil then
        if char:GetData("New") then
            char:SetData("New", false)
        end
    end
end)
