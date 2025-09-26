function RegisterEvents()
    CreateThread(function()
        exports["sandbox-base"]:ServerCallback('Pwnzor:GetEvents', {}, function(e)
            for k, v in ipairs(e) do
                AddEventHandler(v, function()
                    exports["sandbox-base"]:ServerCallback('Pwnzor:Trigger', {
                        check = v,
                        match = v,
                    }, function(s)
                        CancelEvent()
                        return
                    end)
                end)
            end
        end)
    end)
end
