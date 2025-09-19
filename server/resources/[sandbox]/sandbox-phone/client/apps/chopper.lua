RegisterNetEvent("Phone:Client:Spawn", function(data)

end)

PHONE.Chopper = {

}

RegisterNUICallback("GetChopperDetails", function(data, cb)
    exports["sandbox-base"]:ServerCallback("Laptop:LSUnderground:GetDetails", {
        phone = true
    }, function(data)
        cb(data)
    end)
end)
