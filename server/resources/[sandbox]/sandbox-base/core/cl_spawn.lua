-- CreateThread(function()
-- 	exports["spawnmanager"]:setAutoSpawn(false)
-- end)

local firstLoad = true
AddEventHandler("Core:Shared:Ready", function()
	if firstLoad then
		exports['sandbox-characters']:SpawnInitCamera()
		exports['sandbox-characters']:SpawnInit()
		firstLoad = false
	end
end)
