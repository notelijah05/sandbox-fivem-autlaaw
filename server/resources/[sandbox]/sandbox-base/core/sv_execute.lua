function ExecuteClient(source, component, method, ...)
	TriggerClientEvent("Execute:Client:Component", source, component, method, ...)
end

exports('ExecuteClient', ExecuteClient)

RegisterNetEvent("Execute:Server:Log", function(component, method, ...)
	local src = source
end)
