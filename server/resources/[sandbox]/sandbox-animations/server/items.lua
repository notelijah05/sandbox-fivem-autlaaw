function RegisterItems()
    exports['sandbox-inventory']:RegisterUse('camping_chair', 'Animations', function(source, itemData)
        TriggerClientEvent('Animations:Client:CampChair', source)
    end)

    exports['sandbox-inventory']:RegisterUse('beanbag', 'Animations', function(source, itemData)
        TriggerClientEvent('Animations:Client:BeanBag', source)
    end)

    exports['sandbox-inventory']:RegisterUse('binoculars', 'Animations', function(source, itemData)
        TriggerClientEvent('Animations:Client:Binoculars', source)
    end)

    exports['sandbox-inventory']:RegisterUse('camera', 'Animations', function(source, itemData)
        TriggerClientEvent('Animations:Client:Camera', source)
    end)
end
