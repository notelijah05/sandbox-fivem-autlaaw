local _nonLog = {
	["Logger"] = true,
	["Notification"] = true,
	["Animations"] = true,
	["Phone"] = true,
}

RegisterNetEvent("Execute:Client:Component", function(component, method, ...)
	if not _nonLog[component] then
		TriggerServerEvent("Execute:Server:Log", component, method, ...)
	end

	-- Doing this for now, because notifications are not a component and we need to call the exports directly
	if component == "Notification" then
		if method == "Clear" then
			exports["sandbox-hud"]:NotifClear()
		elseif method == "Success" then
			exports["sandbox-hud"]:NotifSuccess(...)
		elseif method == "Warn" then
			exports["sandbox-hud"]:NotifWarn(...)
		elseif method == "Error" then
			exports["sandbox-hud"]:NotifError(...)
		elseif method == "Info" then
			exports["sandbox-hud"]:NotifInfo(...)
		elseif method == "Standard" then
			exports["sandbox-hud"]:NotifStandard(...)
		elseif method == "Custom" then
			exports["sandbox-hud"]:NotifCustom(...)
		end
		return
	end

	if COMPONENTS[component] ~= nil then
		if COMPONENTS[component][method] ~= nil then
			COMPONENTS[component][method](COMPONENTS[component][method], ...)
		else
			exports['sandbox-base']:LoggerWarn("Execute", "Attempted To Execute Non-Method Attribute",
				{ console = true })
		end
	else
		exports['sandbox-base']:LoggerWarn(
			"Attempted To Execute Method Attribute In Non-Existing Component",
			{ console = true }
		)
	end
end)
