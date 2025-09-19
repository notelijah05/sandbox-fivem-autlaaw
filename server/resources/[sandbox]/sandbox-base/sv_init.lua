AddEventHandler("Core:Shared:Ready", function()
	-- exports['sandbox-base']:DatabaseAuthFind({
	-- 	collection = "roles",
	-- 	query = {},
	-- }, function(success, results)
	-- 	if not success or #results <= 0 then
	-- 		exports['sandbox-base']:LoggerCritical("Core", "Failed to Load User Groups", {
	-- 			console = true,
	-- 			file = true,
	-- 		})

	-- 		return
	-- 	end

	-- 	COMPONENTS.Config.Groups = {}

	-- 	for k, v in ipairs(results) do
	-- 		COMPONENTS.Config.Groups[v.Abv] = v
	-- 	end

	-- 	exports['sandbox-base']:LoggerInfo("Core", string.format("Loaded %s User Groups", #results), {
	-- 		console = true,
	-- 	})
	-- end)
end)
