_currentTree = {}
_treeLooted = {}
_currentDate = os.date("*t", os.time())
XMAS_MONTH = 12

AddEventHandler("Xmas:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Inventory = exports["sandbox-base"]:FetchComponent("Inventory")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Xmas", {
		"Inventory",
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

		exports['sandbox-base']:MiddlewareAdd("Characters:Spawning", function(source)
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
