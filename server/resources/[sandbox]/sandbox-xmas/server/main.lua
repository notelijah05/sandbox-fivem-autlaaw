_currentTree = {}
_treeLooted = {}
_currentDate = os.date("*t", os.time())
XMAS_MONTH = 12

AddEventHandler("Xmas:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Middleware = exports["sandbox-base"]:FetchComponent("Middleware")
	Chat = exports["sandbox-base"]:FetchComponent("Chat")
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
	Loot = exports["sandbox-base"]:FetchComponent("Loot")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Xmas", {
		"Middleware",
		"Chat",
		"Inventory",
		"Loot",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded

		RetrieveComponents()
		RegisterCommands()
		RegisterCallbacks()
		RegisterItems()
		Startup()
		StartThreading()

		exports['sandbox-base']:Add("Characters:Spawning", function(source)
			if _currentDate.month == XMAS_MONTH then
				local char = exports['sandbox-characters']:FetchCharacterSource(source)
				if char ~= nil then
					local sid = char:GetData("SID")
					TriggerClientEvent("Xmas:Client:Init", source, _currentDate.day, _currentTree,
						_treeLooted[sid] ~= nil)
				end
			end
		end, 2)
	end)
end)
