function RegisterItems()
    exports('camping_chair', function(event, item, inventory, slot, data)
        if event == 'usingItem' then
            TriggerClientEvent('Animations:Client:CampChair', inventory.id)
            return
        end
    end)

    exports('beanbag', function(event, item, inventory, slot, data)
        if event == 'usingItem' then
            TriggerClientEvent('Animations:Client:BeanBag', inventory.id)
            return
        end
    end)

    exports('binoculars', function(event, item, inventory, slot, data)
        if event == 'usingItem' then
            TriggerClientEvent('Animations:Client:Binoculars', inventory.id)
            return
        end
    end)

    exports('camera', function(event, item, inventory, slot, data)
        if event == 'usingItem' then
            TriggerClientEvent('Animations:Client:Camera', inventory.id)
            return
        end
    end)
end
