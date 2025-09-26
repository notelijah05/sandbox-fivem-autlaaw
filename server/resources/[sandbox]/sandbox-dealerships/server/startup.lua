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


    exports['sandbox-base']:DefaultAdd(
        "dealer_stock",
        1630877439,
        {
            {
                vehicle = "faggio",
                quantity = 10,
                dealership = "pdm",
                data = {
                    class = "M",
                    price = 16000,
                    make = "Pegassi",
                    model = "Faggio",
                    category = "motorcycles"
                },
                lastStocked = os.time(),
            },
            {
                vehicle = "seminole",
                quantity = 10,
                dealership = "pdm",
                data = {
                    class = "C",
                    price = 30500,
                    make = "Canis",
                    model = "Seminole",
                    category = "suv"
                },
                lastStocked = os.time(),
            },
        }
    )
end
