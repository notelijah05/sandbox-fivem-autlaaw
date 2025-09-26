local function GetPlayer()
    return exports["sandbox-base"]:GetLocalPlayer()
end

local function GetCharacter()
    return exports["sandbox-base"]:GetPlayerData('Character')
end

exports('FetchPlayer', GetPlayer)
exports('FetchCharacter', GetCharacter)
