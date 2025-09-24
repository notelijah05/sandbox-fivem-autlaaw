_DRUGS = _DRUGS or {}
local _addictionTemplate = {
	Meth = {
		LastUse = false,
		Factor = 0.0,
	},
	Coke = {
		LastUse = false,
		Factor = 0.0,
	},
	Moonshine = {
		LastUse = false,
		Factor = 0.0,
	},
}

function table.copy(t)
	local u = {}
	for k, v in pairs(t) do
		u[k] = v
	end
	return setmetatable(u, getmetatable(t))
end

AddEventHandler("Drugs:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Crypto = exports["sandbox-base"]:FetchComponent("Crypto")
	Drugs = exports["sandbox-base"]:FetchComponent("Drugs")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["sandbox-base"]:RequestDependencies("Drugs", {
		"Crypto",
		"Drugs",
	}, function(error)
		if #error > 0 then
			exports['sandbox-base']:LoggerCritical("Drugs", "Failed To Load All Dependencies")
			return
		end
		RetrieveComponents()
		RegisterItemUse()
		RunDegenThread()

		exports['sandbox-base']:MiddlewareAdd("Characters:Spawning", function(source)
			local char = exports['sandbox-characters']:FetchCharacterSource(source)
			if char ~= nil then
				local addictions = char:GetData("Addiction")
				if char:GetData("Addiction") == nil then
					char:SetData("Addiction", _addictionTemplate)
				else
					for k, v in pairs(_addictionTemplate) do
						if addictions[k] == nil then
							addictions[k] = table.copy(v)
						end
					end
					char:SetData("Addiction", addictions)
				end
			end
		end, 1)

		TriggerEvent("Drugs:Server:Startup")
		TriggerEvent("Drugs:Server:StartCookThreads")
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["sandbox-base"]:RegisterComponent("Drugs", _DRUGS)
end)
