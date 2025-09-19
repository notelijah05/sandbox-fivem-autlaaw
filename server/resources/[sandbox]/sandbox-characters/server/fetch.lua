exports('FetchCharacterSource', function(source)
	if source then
		return ONLINE_CHARACTERS[source]
	end
end)

exports('FetchAllCharacters', function()
	return ONLINE_CHARACTERS
end)

exports('FetchCharacterData', function(key, value)
	for source, char in pairs(ONLINE_CHARACTERS) do
		if char and char:GetData(key) == value then
			return char
		end
	end
end)

exports('FetchCountCharacters', function()
	local c = 0
	for k, v in pairs(ONLINE_CHARACTERS) do
		if v ~= nil then
			c = c + 1
		end
	end
	return c
end)

exports('FetchByID', function(value)
	local source = _pleaseFuckingWorkID[value]
	if source then
		return ONLINE_CHARACTERS[tonumber(source)]
	end
end)

exports('FetchBySID', function(value)
	local source = _pleaseFuckingWorkSID[value]
	if source then
		return ONLINE_CHARACTERS[tonumber(source)]
	end
end)

exports('FetchGetOfflineData', function(stateId, key)
	local p = promise.new()
	Database.Game:findOne({
		collection = "characters",
		query = {
			SID = stateId,
		},
		options = {
			projection = {
				[key] = true,
			},
		},
	}, function(success, results)
		if not success then
			return p:resolve(nil)
		end
		return p:resolve(results[1][key])
	end)
	return Citizen.Await(p)
end)
