local function GetPlayer()
    return COMPONENTS.Player.LocalPlayer
end

local function GetCharacter()
    return COMPONENTS.Player.LocalPlayer:GetData('Character')
end

exports('FetchPlayer', GetPlayer)
exports('FetchCharacter', GetCharacter)
