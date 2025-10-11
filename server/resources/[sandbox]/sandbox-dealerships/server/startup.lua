function LoadDealershipShit()
    GlobalState.DealershipShowrooms = {}
    exports['sandbox-dealerships']:ShowroomLoad()
    exports['sandbox-dealerships']:ManagementLoadData()

    -- exports['sandbox-dealerships']:StockEnsure('pdm', 'blista', 20, {
    --     make = 'Dinka',
    --     model = 'Blista',
    --     class = 'B',
    --     category = 'compact',
    --     price = 12500,
    -- })

    -- exports['sandbox-dealerships']:StockEnsure('pdm', 'asbo', 20, {
    --     make = 'Maxwell',
    --     model = 'Asbo',
    --     class = 'C',
    --     category = 'compact',
    --     price = 9000,
    -- })


    exports['sandbox-dealerships']:StockAdd("pdm", "faggio", "motorcycle", 10, {
        class = "M",
        price = 16000,
        make = "Pegassi",
        model = "Faggio",
        category = "motorcycles"
    })

    exports['sandbox-dealerships']:StockAdd("pdm", "seminole", "automobile", 10, {
        class = "C",
        price = 30500,
        make = "Canis",
        model = "Seminole",
        category = "suv"
    })
end
