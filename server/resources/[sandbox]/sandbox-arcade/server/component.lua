AddEventHandler("Arcade:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Chat = exports["sandbox-base"]:FetchComponent("Chat")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Arcade", {
		"Chat",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()

		exports["sandbox-base"]:RegisterServerCallback("Arcade:Open", function(source, data, cb)
			local char = exports['sandbox-characters']:FetchCharacterSource(source)
			if char ~= nil then
				if Player(source).state.onDuty == "avast_arcade" then
					GlobalState["Arcade:Open"] = true
				end
			end
		end)

		exports["sandbox-base"]:RegisterServerCallback("Arcade:Close", function(source, data, cb)
			local char = exports['sandbox-characters']:FetchCharacterSource(source)
			if char ~= nil then
				if Player(source).state.onDuty == "avast_arcade" then
					GlobalState["Arcade:Open"] = false
				end
			end
		end)
	end)
end)
