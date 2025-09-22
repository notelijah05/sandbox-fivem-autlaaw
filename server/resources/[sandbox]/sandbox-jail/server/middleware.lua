function RegisterMiddleware()
	exports['sandbox-base']:MiddlewareAdd("Characters:Creating", function(source, cData)
		return {
			{
				Jailed = false,
			},
		}
	end)

	exports['sandbox-base']:MiddlewareAdd("Characters:Spawning", function(source)
		local _src = source
		local currentTime = os.time() * 1000

		local char = exports['sandbox-characters']:FetchCharacterSource(_src)
		if char ~= nil then
			local jailed = char:GetData("Jailed")
			if
				(jailed and jailed.Jailed and jailed.Jailed.Time ~= nil and jailed.Jailed.Duration ~= nil)
				and (os.time() >= jailed.Time + (jailed.Duration * 60))
			then
				char:SetData("Jailed", false)
			end
		end
	end, 2)

	local function CheckJailed(source)
		local char = exports['sandbox-characters']:FetchCharacterSource(source)
		if char ~= nil then
			local jailed = char:GetData("Jailed") or false
			if
				(jailed and jailed.Jailed and jailed.Jailed.Time ~= nil and jailed.Jailed.Duration ~= nil)
				and (os.time() >= jailed.Time + (jailed.Duration * 60))
			then
				char:SetData("Jailed", false)
			end
		end
	end

	exports['sandbox-base']:MiddlewareAdd("Characters:Logout", CheckJailed, 1)
	exports['sandbox-base']:MiddlewareAdd("playerDropped", CheckJailed, 1)
end
