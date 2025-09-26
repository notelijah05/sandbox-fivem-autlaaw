local _req = { 'ExportsReady' }
local _deps = {}
if IsDuplicityVersion() then _req = { 'ExportsReady', 'DatabaseReady' } end

local _ignored = {
    pac_os = true,
    pac_iec = true,
    ["screenshot-basic"] = true,
}

COMPONENTS.Proxy = {
    _required = _req,
    _name = 'base',
    ExportsReady = false,
}

AddEventHandler('onResourceStart', function(resource)
    if COMPONENTS.Proxy.ExportsReady and not _ignored[resource] then
        if resource ~= GetCurrentResourceName() then
            TriggerEvent('Proxy:Shared:RegisterReady')

            if GetGameTimer() > 10000 then
                TriggerEvent('Core:Shared:Ready')
            end
            collectgarbage()
        end
    end
end)
