local function GetSource(source)
	return COMPONENTS.Players[source]
end

local function GetPlayerData(key, value)
	for k, v in pairs(COMPONENTS.Players) do
		if v:GetData(key) == value then
			return v
		end
	end
	return nil
end

local function GetWebsite(type, id)
	if type == "account" then
		local data = COMPONENTS.WebAPI.GetMember:AccountID(id)
		if data ~= nil then
			return exports["sandbox-base"]:CreateStore('Fetch', data.id, {
				ID = data.id,
				AccountID = data.id,
				Identifier = data.identifier,
				Name = data.name,
				Roles = data.roles,
			})
		end
	elseif type == "identifier" then
		local data = COMPONENTS.WebAPI.GetMember:Identifier(id)
		if data ~= nil then
			return exports["sandbox-base"]:CreateStore('Fetch', data.id, {
				ID = data.id,
				AccountID = data.id,
				Identifier = data.identifier,
				Name = data.name,
				Roles = data.roles,
			})
		end
	end
	return nil
end

local function GetAll()
	return COMPONENTS.Players
end

local function GetCount()
	local c = 0
	for k, v in pairs(COMPONENTS.Players) do
		if v ~= nil then
			c = c + 1
		end
	end
	return c
end

exports('FetchSource', GetSource)
exports('FetchPlayerData', GetPlayerData)
exports('FetchWebsite', GetWebsite)
exports('FetchAll', GetAll)
exports('FetchCount', GetCount)
