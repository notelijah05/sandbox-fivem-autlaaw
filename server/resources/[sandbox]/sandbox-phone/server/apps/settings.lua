AddEventHandler("Phone:Server:RegisterCallbacks", function()
	exports["sandbox-base"]:RegisterServerCallback("Phone:Settings:Update", function(source, data, cb)
		local src = source
		local char = exports['sandbox-characters']:FetchCharacterSource(src)
		local settings = char:GetData("PhoneSettings")
		settings[data.type] = data.val
		char:SetData("PhoneSettings", settings)
	end)
end)
