local _req = {}
local _deps = {}
if IsDuplicityVersion() then _req = { 'DatabaseReady' } end

local _ignored = {
    ["screenshot-basic"] = true,
}

COMPONENTS.Proxy = {
    _required = _req,
    _name = 'base',
}

AddEventHandler('onResourceStart', function(resource)
    if not _ignored[resource] then
        if resource ~= GetCurrentResourceName() then
            TriggerEvent('Proxy:Shared:RegisterReady')

            collectgarbage()
        end
    end
end)
