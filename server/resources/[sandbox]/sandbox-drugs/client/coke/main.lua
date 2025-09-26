AddEventHandler("Drugs:Client:Startup", function()
    exports["sandbox-base"]:RegisterClientCallback("Drugs:Coke:Use", function(data, cb)
        Wait(400)
        exports['sandbox-games']:MinigamePlayRoundSkillbar(1.0, 6, {
            onSuccess = function()
                cb(true)
            end,
            onFail = function()
                cb(false)
            end,
        }, {
            useWhileDead = false,
            vehicle = false,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                animDict = "switch@trevor@trev_smoking_meth",
                anim = "trev_smoking_meth_loop",
                flags = 48,
            },
        })
    end)
end)
