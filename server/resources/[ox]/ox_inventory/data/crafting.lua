return {
    -- {
    --     name = 'debug_crafting',
    --     items = {
    --         {
    --             name = 'lockpick',
    --             ingredients = {
    --                 scrapmetal = 5,
    --                 WEAPON_HAMMER = 0.05
    --             },
    --             duration = 5000,
    --             count = 2,
    --         },
    --         {
    --             name = 'WEAPON_PISTOLXM3',
    --             ingredients = {
    --                 scrapmetal = 50,
    --                 WEAPON_HAMMER = 0.1,
    --             },
    --             duration = 10000,
    --         }
    --     },
    --     points = {
    --         vec3(-1147.083008, -2002.662109, 13.180260),
    --         vec3(-345.374969, -130.687088, 39.009613)
    --     },
    --     zones = {
    --         {
    --             coords = vec3(-1146.2, -2002.05, 13.2),
    --             size = vec3(3.8, 1.05, 0.15),
    --             distance = 1.5,
    --             rotation = 315.0,
    --         },
    --         {
    --             coords = vec3(-346.1, -130.45, 39.0),
    --             size = vec3(3.8, 1.05, 0.15),
    --             distance = 1.5,
    --             rotation = 70.0,
    --         },
    --     },
    --     blip = { id = 566, colour = 31, scale = 0.8 },
    -- },

    { -- Salvage Exchange
        name = 'salvage-exchange',
        label = 'Salvage Exchange',
        items = {
            {
                name = 'ironbar',
                ingredients = {
                    salvagedparts = 25,
                },
                duration = 5000,
                count = 10,
            },
            {
                name = 'scrapmetal',
                ingredients = {
                    salvagedparts = 10,
                },
                duration = 5000,
                count = 20,
            },
            {
                name = 'heavy_glue',
                ingredients = {
                    salvagedparts = 10,
                },
                duration = 5000,
                count = 20,
            },
            {
                name = 'rubber',
                ingredients = {
                    salvagedparts = 8,
                },
                duration = 5000,
                count = 16,
            },
            {
                name = 'plastic',
                ingredients = {
                    salvagedparts = 3,
                },
                duration = 5000,
                count = 6,
            },
            {
                name = 'copperwire',
                ingredients = {
                    salvagedparts = 2,
                },
                duration = 5000,
                count = 4,
            },
            {
                name = 'electronic_parts',
                ingredients = {
                    salvagedparts = 8,
                },
                duration = 5000,
                count = 32,
            },
        },
        peds = {
            {
                model = 's_m_m_gardener_01',
                coords = vec3(2350.925, 3145.093, 47.209),
                heading = 169.500,
                distance = 2.0,
                renderDistance = 25.0,
                label = 'Salvage Exchange',
                icon = 'fas fa-ring',
                animation = 'WORLD_HUMAN_LEANING',
            },
        },
    },

    { -- Smelter
        name = 'material-refiner',
        label = 'Material Refiner',
        items = {
            {
                name = 'refined_metal',
                ingredients = {
                    scrapmetal = 1000,
                },
                duration = 5000,
                count = 1,
            },
            {
                name = 'refined_iron',
                ingredients = {
                    ironbar = 1000,
                },
                duration = 5000,
                count = 1,
            },
            {
                name = 'refined_copper',
                ingredients = {
                    copperwire = 1000,
                },
                duration = 5000,
                count = 1,
            },
            {
                name = 'refined_plastic',
                ingredients = {
                    plastic = 1000,
                },
                duration = 5000,
                count = 1,
            },
            {
                name = 'refined_glue',
                ingredients = {
                    heavy_glue = 1000,
                },
                duration = 5000,
                count = 1,
            },
            {
                name = 'refined_electronics',
                ingredients = {
                    electronic_parts = 1000,
                },
                duration = 5000,
                count = 1,
            },
            {
                name = 'refined_rubber',
                ingredients = {
                    rubber = 1000,
                },
                duration = 5000,
                count = 1,
            },
        },
        props = {
            {
                model = 'gr_prop_gr_lathe_01a',
                coords = vec3(-582.435, -1612.158, 26.011),
                heading = 86.292,
                distance = 3.0,
                renderDistance = 25.0,
                label = 'Material Refiner',
                icon = 'fas fa-minimize',
            },
        },
    },

    { -- Sign Exchange
        name = 'sign-exchange',
        label = 'Sign Exchange',
        items = {
            {
                name = 'ironbar',
                ingredients = {
                    sign_dontblock = 5,
                    sign_leftturn = 5,
                    sign_nopark = 5,
                    sign_notresspass = 5,
                },
                duration = 5000,
                count = 50,
            },
            {
                name = 'scrapmetal',
                ingredients = {
                    sign_rightturn = 5,
                    sign_stop = 5,
                    sign_uturn = 5,
                    sign_walkingman = 5,
                    sign_yield = 5,
                },
                duration = 5000,
                count = 75,
            }
        },
        peds = {
            {
                model = 's_m_m_dockwork_01',
                coords = vec3(-185.572, 6270.046, 30.489),
                heading = 56.226,
                distance = 2.0,
                renderDistance = 25.0,
                label = 'Sign Exchange',
                icon = 'fas fa-ring',
                animation = 'WORLD_HUMAN_JANITOR',
            },
        },
    },

    { -- Sign Exchange 2
        name = 'sign-exchange-2',
        label = 'Sign Exchange',
        items = {
            {
                name = 'at_clip_extended_pistol',
                ingredients = {
                    refined_metal = 1,
                    refined_glue = 1,
                    refined_plastic = 1,
                },
                duration = 5000,
                count = 1,
            },
        },
        peds = {
            {
                model = 's_m_m_dockwork_01',
                coords = vec3(-1746.624, 3688.159, 33.334),
                heading = 343.688,
                distance = 2.0,
                renderDistance = 25.0,
                label = 'Sign Exchange',
                icon = 'fas fa-ring',
                animation = 'WORLD_HUMAN_CLIPBOARD',
            },
        },
    },

    { -- Recycle Exchange
        name = 'recycle-exchange',
        label = 'Recycle Exchange',
        items = {
            {
                name = 'ironbar',
                ingredients = {
                    recycledgoods = 25,
                },
                duration = 5000,
                count = 10,
            },
            {
                name = 'scrapmetal',
                ingredients = {
                    recycledgoods = 10,
                },
                duration = 5000,
                count = 20,
            },
            {
                name = 'heavy_glue',
                ingredients = {
                    recycledgoods = 10,
                },
                duration = 5000,
                count = 20,
            },
            {
                name = 'rubber',
                ingredients = {
                    recycledgoods = 8,
                },
                duration = 5000,
                count = 16,
            },
            {
                name = 'plastic',
                ingredients = {
                    recycledgoods = 3,
                },
                duration = 5000,
                count = 6,
            },
            {
                name = 'copperwire',
                ingredients = {
                    recycledgoods = 2,
                },
                duration = 5000,
                count = 4,
            },
            {
                name = 'glue',
                ingredients = {
                    recycledgoods = 2,
                },
                duration = 5000,
                count = 4,
            }
        },
        peds = {
            {
                model = 's_m_m_dockwork_01',
                coords = vec3(-334.833, -1577.247, 24.222),
                heading = 20.715,
                distance = 2.0,
                renderDistance = 25.0,
                label = 'Sign Exchange',
                icon = 'fas fa-recycle',
                animation = 'WORLD_HUMAN_JANITOR',
            },
        },
    },

    { -- Smelter
        name = 'smelter',
        label = 'Smelter',
        items = {
            {
                name = 'goldbar',
                ingredients = {
                    goldore = 1,
                },
                duration = 5000,
                count = 1,
            },
            {
                name = 'silverbar',
                ingredients = {
                    silverore = 1,
                },
                duration = 5000,
                count = 1,
            },
            {
                name = 'ironbar',
                ingredients = {
                    ironore = 1,
                },
                duration = 5000,
                count = 1,
            }
        },
        props = {
            {
                model = 'gr_prop_gr_bench_02b',
                coords = vec3(1112.165, -2030.834, 29.914),
                heading = 235.553,
                distance = 3.0,
                renderDistance = 25.0,
                label = 'Smelter',
                icon = 'fas fa-fire-burner',
            },
        },
    },

    -- Schematic Benches Start --

    { -- City Tunnels Schematic Bench
        name = 'city-tunnels',
        label = 'Tool Bench',
        items = {
            -- Don't know how I'll do schematics just yet / leaving it for now
        },
        props = {
            {
                model = 'prop_tool_bench02',
                coords = vec3(42.20, -641.86, 9.77),
                heading = 337.98,
                distance = 3.0,
                renderDistance = 25.0,
                label = 'Use Tool Bench',
                icon = 'fas fa-toolbox',
            },
        },
    },
    { -- East Train Schematic Bench
        name = 'east-train',
        label = 'Tool Bench',
        items = {
            -- Don't know how I'll do schematics just yet / leaving it for now
        },
        props = {
            {
                model = 'prop_tool_bench02',
                coords = vec3(925.916, -1488.888, 29.4938),
                heading = 89.19,
                distance = 3.0,
                renderDistance = 25.0,
                label = 'Use Tool Bench',
                icon = 'fas fa-toolbox',
            },
        },
    },
    { -- Cluck Factory Schematic Bench
        name = 'cluck-factory',
        label = 'Tool Bench',
        items = {
            -- Don't know how I'll do schematics just yet / leaving it for now
        },
        props = {
            {
                model = 'prop_tool_bench02',
                coords = vec3(-180.69, 6155.62, 30.21),
                heading = 314.045,
                distance = 3.0,
                renderDistance = 25.0,
                label = 'Use Tool Bench',
                icon = 'fas fa-toolbox',
            },
        },
    },

    -- Schematic Benches End --

    -- Weed Packaging  Start --

    { -- Weed Packaging Bench
        name = 'weed-packaging',
        label = 'Weed Processing',
        items = {
            {
                name = 'weed_brick',
                ingredients = {
                    plastic_wrap = 2,
                    weed_bud = 200,
                },
                duration = 8000,
                count = 1,
            },
            {
                name = 'weed_baggy',
                ingredients = {
                    baggy = 1,
                    weed_bud = 2,
                },
                duration = 2000,
                count = 1,
            },
        },
        zones = {
            {
                label = 'Open Crafting Bench',
                icon = 'fa-solid fa-wrench',
                coords = vec3(1056.47, -2450.58, 29.29),
                size = vec3(2.8, 1.0, 2.0),
                distance = 1.5,
                rotation = 0.0,
            },
        },
    },

    -- Weed Packaging End --

    -- Mechanic Crafting Benches Start --

    { -- Redline Mechanic Shop
        name = 'redline-mechanic-1',
        label = 'Mechanic Workbench',
        groups = { 'redline' },
        reqDuty = true,
        items = {
            {
                name = 'repair_part_electronics',
                ingredients = {
                    electronic_parts = 5,
                    plastic = 4,
                    rubber = 1,
                    copperwire = 8,
                },
                duration = 3500,
                count = 10,
            },
            {
                name = 'repair_part_axle',
                ingredients = {
                    ironbar = 4,
                },
                duration = 5000,
                count = 5,
            },
            {
                name = 'repair_part_injectors',
                ingredients = {
                    ironbar = 2,
                    plastic = 2,
                    copperwire = 4,
                    glue = 1,
                },
                duration = 4500,
                count = 20,
            },
            {
                name = 'repair_part_clutch',
                ingredients = {
                    ironbar = 6,
                    rubber = 1,
                },
                duration = 5000,
                count = 8,
            },
            {
                name = 'repair_part_brakes',
                ingredients = {
                    ironbar = 2,
                    glue = 1,
                },
                duration = 4500,
                count = 5,
            },
            {
                name = 'repair_part_transmission',
                ingredients = {
                    ironbar = 3,
                    electronic_parts = 1,
                    plastic = 1,
                },
                duration = 3500,
                count = 2,
            },
            {
                name = 'repair_part_rad',
                ingredients = {
                    ironbar = 3,
                    rubber = 1,
                    glue = 1,
                },
                duration = 2000,
                count = 2,
            },
        },
        zones = {
            {
                label = 'Mechanic Workbench',
                icon = 'fa-solid fa-wrench',
                coords = vec3(-584.07, -939.57, 23.89),
                size = vec3(3.8, 1.0, 1.6),
                distance = 1.5,
                rotation = 270.0,
            },
        },
    },

    { -- Redline Mechanic Shop 2
        name = 'redline-mechanic-2',
        label = 'Mechanic Workbench',
        groups = { 'redline' },
        reqDuty = true,
        items = {
            {
                name = 'repair_part_electronics',
                ingredients = {
                    electronic_parts = 5,
                    plastic = 4,
                    rubber = 1,
                    copperwire = 8,
                },
                duration = 3500,
                count = 10,
            },
            {
                name = 'repair_part_axle',
                ingredients = {
                    ironbar = 4,
                },
                duration = 5000,
                count = 5,
            },
            {
                name = 'repair_part_injectors',
                ingredients = {
                    ironbar = 2,
                    plastic = 2,
                    copperwire = 4,
                    glue = 1,
                },
                duration = 4500,
                count = 20,
            },
            {
                name = 'repair_part_clutch',
                ingredients = {
                    ironbar = 6,
                    rubber = 1,
                },
                duration = 5000,
                count = 8,
            },
            {
                name = 'repair_part_brakes',
                ingredients = {
                    ironbar = 2,
                    glue = 1,
                },
                duration = 4500,
                count = 5,
            },
            {
                name = 'repair_part_transmission',
                ingredients = {
                    ironbar = 3,
                    electronic_parts = 1,
                    plastic = 1,
                },
                duration = 3500,
                count = 2,
            },
            {
                name = 'repair_part_rad',
                ingredients = {
                    ironbar = 3,
                    rubber = 1,
                    glue = 1,
                },
                duration = 2000,
                count = 2,
            },
        },
        zones = {
            {
                label = 'Mechanic Workbench',
                icon = 'fa-solid fa-wrench',
                coords = vec3(-589.19, -926.07, 28.14),
                size = vec3(2.0, 1.0, 1.6),
                distance = 1.5,
                rotation = 270.0,
            },
        },
    },

    { -- Tuna Mechanic Shop
        name = 'tuna-mechanic',
        label = 'Mechanic Workbench',
        groups = { 'tuna' },
        reqDuty = true,
        items = {
            {
                name = 'repair_part_electronics',
                ingredients = {
                    electronic_parts = 5,
                    plastic = 4,
                    rubber = 1,
                    copperwire = 8,
                },
                duration = 3500,
                count = 10,
            },
            {
                name = 'repair_part_axle',
                ingredients = {
                    ironbar = 4,
                },
                duration = 5000,
                count = 5,
            },
            {
                name = 'repair_part_injectors',
                ingredients = {
                    ironbar = 2,
                    plastic = 2,
                    copperwire = 4,
                    glue = 1,
                },
                duration = 4500,
                count = 20,
            },
            {
                name = 'repair_part_clutch',
                ingredients = {
                    ironbar = 6,
                    rubber = 1,
                },
                duration = 5000,
                count = 8,
            },
            {
                name = 'repair_part_brakes',
                ingredients = {
                    ironbar = 2,
                    glue = 1,
                },
                duration = 4500,
                count = 5,
            },
            {
                name = 'repair_part_transmission',
                ingredients = {
                    ironbar = 3,
                    electronic_parts = 1,
                    plastic = 1,
                },
                duration = 3500,
                count = 2,
            },
            {
                name = 'repair_part_rad',
                ingredients = {
                    ironbar = 3,
                    rubber = 1,
                    glue = 1,
                },
                duration = 2000,
                count = 2,
            },
        },
        zones = {
            {
                label = 'Mechanic Workbench',
                icon = 'fa-solid fa-wrench',
                coords = vec3(133.37, -3051.24, 7.04),
                size = vec3(11.8, 1.8, 2.2),
                distance = 1.5,
                rotation = 0.0,
            },
        },
    },

    { -- Tirenutz Mechanic Shop
        name = 'tirenutz-mechanic',
        label = 'Mechanic Workbench',
        groups = { 'tirenutz' },
        reqDuty = true,
        items = {
            {
                name = 'repair_part_electronics',
                ingredients = {
                    electronic_parts = 5,
                    plastic = 4,
                    rubber = 1,
                    copperwire = 8,
                },
                duration = 3500,
                count = 10,
            },
            {
                name = 'repair_part_axle',
                ingredients = {
                    ironbar = 4,
                },
                duration = 5000,
                count = 5,
            },
            {
                name = 'repair_part_injectors',
                ingredients = {
                    ironbar = 2,
                    plastic = 2,
                    copperwire = 4,
                    glue = 1,
                },
                duration = 4500,
                count = 20,
            },
            {
                name = 'repair_part_clutch',
                ingredients = {
                    ironbar = 6,
                    rubber = 1,
                },
                duration = 5000,
                count = 8,
            },
            {
                name = 'repair_part_brakes',
                ingredients = {
                    ironbar = 2,
                    glue = 1,
                },
                duration = 4500,
                count = 5,
            },
            {
                name = 'repair_part_transmission',
                ingredients = {
                    ironbar = 3,
                    electronic_parts = 1,
                    plastic = 1,
                },
                duration = 3500,
                count = 2,
            },
            {
                name = 'repair_part_rad',
                ingredients = {
                    ironbar = 3,
                    rubber = 1,
                    glue = 1,
                },
                duration = 2000,
                count = 2,
            },
        },
        zones = {
            {
                label = 'Mechanic Workbench',
                icon = 'fa-solid fa-wrench',
                coords = vec3(-57.5, -1325.07, 29.27),
                size = vec3(4.2, 1.0, 2.8),
                distance = 1.5,
                rotation = 0.0,
            },
        },
    },

    { -- Hayes Mechanic Shop
        name = 'hayes-mechanic',
        label = 'Mechanic Workbench',
        groups = { 'hayes' },
        reqDuty = true,
        items = {
            {
                name = 'repair_part_electronics',
                ingredients = {
                    electronic_parts = 5,
                    plastic = 4,
                    rubber = 1,
                    copperwire = 8,
                },
                duration = 3500,
                count = 10,
            },
            {
                name = 'repair_part_axle',
                ingredients = {
                    ironbar = 4,
                },
                duration = 5000,
                count = 5,
            },
            {
                name = 'repair_part_injectors',
                ingredients = {
                    ironbar = 2,
                    plastic = 2,
                    copperwire = 4,
                    glue = 1,
                },
                duration = 4500,
                count = 20,
            },
            {
                name = 'repair_part_clutch',
                ingredients = {
                    ironbar = 6,
                    rubber = 1,
                },
                duration = 5000,
                count = 8,
            },
            {
                name = 'repair_part_brakes',
                ingredients = {
                    ironbar = 2,
                    glue = 1,
                },
                duration = 4500,
                count = 5,
            },
            {
                name = 'repair_part_transmission',
                ingredients = {
                    ironbar = 3,
                    electronic_parts = 1,
                    plastic = 1,
                },
                duration = 3500,
                count = 2,
            },
            {
                name = 'repair_part_rad',
                ingredients = {
                    ironbar = 3,
                    rubber = 1,
                    glue = 1,
                },
                duration = 2000,
                count = 2,
            },
        },
        zones = {
            {
                label = 'Mechanic Workbench',
                icon = 'fa-solid fa-wrench',
                coords = vec3(-1421.67, -456.38, 35.91),
                size = vec3(3.8, 1.0, 2.4),
                distance = 1.5,
                rotation = 302.0,
            },
        },
    },

    { -- Atomic Mechanic Shop
        name = 'atomic-mechanic',
        label = 'Mechanic Workbench',
        groups = { 'atomic' },
        reqDuty = true,
        items = {
            {
                name = 'repair_part_electronics',
                ingredients = {
                    electronic_parts = 5,
                    plastic = 4,
                    rubber = 1,
                    copperwire = 8,
                },
                duration = 3500,
                count = 10,
            },
            {
                name = 'repair_part_axle',
                ingredients = {
                    ironbar = 4,
                },
                duration = 5000,
                count = 5,
            },
            {
                name = 'repair_part_injectors',
                ingredients = {
                    ironbar = 2,
                    plastic = 2,
                    copperwire = 4,
                    glue = 1,
                },
                duration = 4500,
                count = 20,
            },
            {
                name = 'repair_part_clutch',
                ingredients = {
                    ironbar = 6,
                    rubber = 1,
                },
                duration = 5000,
                count = 8,
            },
            {
                name = 'repair_part_brakes',
                ingredients = {
                    ironbar = 2,
                    glue = 1,
                },
                duration = 4500,
                count = 5,
            },
            {
                name = 'repair_part_transmission',
                ingredients = {
                    ironbar = 3,
                    electronic_parts = 1,
                    plastic = 1,
                },
                duration = 3500,
                count = 2,
            },
            {
                name = 'repair_part_rad',
                ingredients = {
                    ironbar = 3,
                    rubber = 1,
                    glue = 1,
                },
                duration = 2000,
                count = 2,
            },
        },
        zones = {
            {
                label = 'Mechanic Workbench',
                icon = 'fa-solid fa-wrench',
                coords = vec3(476.67, -1876.93, 26.09),
                size = vec3(4.0, 1.2, 3.0),
                distance = 1.5,
                rotation = 25.0,
            },
        },
    },

    { -- Harmony Mechanic Shop
        name = 'harmony-mechanic',
        label = 'Mechanic Workbench',
        groups = { 'harmony' },
        reqDuty = true,
        items = {
            {
                name = 'repair_part_electronics',
                ingredients = {
                    electronic_parts = 5,
                    plastic = 4,
                    rubber = 1,
                    copperwire = 8,
                },
                duration = 3500,
                count = 10,
            },
            {
                name = 'repair_part_axle',
                ingredients = {
                    ironbar = 4,
                },
                duration = 5000,
                count = 5,
            },
            {
                name = 'repair_part_injectors',
                ingredients = {
                    ironbar = 2,
                    plastic = 2,
                    copperwire = 4,
                    glue = 1,
                },
                duration = 4500,
                count = 20,
            },
            {
                name = 'repair_part_clutch',
                ingredients = {
                    ironbar = 6,
                    rubber = 1,
                },
                duration = 5000,
                count = 8,
            },
            {
                name = 'repair_part_brakes',
                ingredients = {
                    ironbar = 2,
                    glue = 1,
                },
                duration = 4500,
                count = 5,
            },
            {
                name = 'repair_part_transmission',
                ingredients = {
                    ironbar = 3,
                    electronic_parts = 1,
                    plastic = 1,
                },
                duration = 3500,
                count = 2,
            },
            {
                name = 'repair_part_rad',
                ingredients = {
                    ironbar = 3,
                    rubber = 1,
                    glue = 1,
                },
                duration = 2000,
                count = 2,
            },
        },
        zones = {
            {
                label = 'Mechanic Workbench',
                icon = 'fa-solid fa-wrench',
                coords = vec3(1176.15, 2635.21, 37.75),
                size = vec3(3.8, 1.4, 2.8),
                distance = 1.5,
                rotation = 0.0,
            },
        },
    },

    { -- Auto Exotics Mechanic Shop
        name = 'autoexotics-mechanic',
        label = 'Mechanic Workbench',
        groups = { 'autoexotics' },
        reqDuty = true,
        items = {
            {
                name = 'repair_part_electronics',
                ingredients = {
                    electronic_parts = 5,
                    plastic = 4,
                    rubber = 1,
                    copperwire = 8,
                },
                duration = 3500,
                count = 10,
            },
            {
                name = 'repair_part_axle',
                ingredients = {
                    ironbar = 4,
                },
                duration = 5000,
                count = 5,
            },
            {
                name = 'repair_part_injectors',
                ingredients = {
                    ironbar = 2,
                    plastic = 2,
                    copperwire = 4,
                    glue = 1,
                },
                duration = 4500,
                count = 20,
            },
            {
                name = 'repair_part_clutch',
                ingredients = {
                    ironbar = 6,
                    rubber = 1,
                },
                duration = 5000,
                count = 8,
            },
            {
                name = 'repair_part_brakes',
                ingredients = {
                    ironbar = 2,
                    glue = 1,
                },
                duration = 4500,
                count = 5,
            },
            {
                name = 'repair_part_transmission',
                ingredients = {
                    ironbar = 3,
                    electronic_parts = 1,
                    plastic = 1,
                },
                duration = 3500,
                count = 2,
            },
            {
                name = 'repair_part_rad',
                ingredients = {
                    ironbar = 3,
                    rubber = 1,
                    glue = 1,
                },
                duration = 2000,
                count = 2,
            },
        },
        zones = {
            {
                label = 'Mechanic Workbench',
                icon = 'fa-solid fa-wrench',
                coords = vec3(558.99, -171.67, 54.51),
                size = vec3(3.6, 1.2, 2.6),
                distance = 1.5,
                rotation = 0.0,
            },
        },
    },

    { -- Ottos Mechanic Shop
        name = 'ottos-mechanic',
        label = 'Mechanic Workbench',
        groups = { 'ottos' },
        reqDuty = true,
        items = {
            {
                name = 'repair_part_electronics',
                ingredients = {
                    electronic_parts = 5,
                    plastic = 4,
                    rubber = 1,
                    copperwire = 8,
                },
                duration = 3500,
                count = 10,
            },
            {
                name = 'repair_part_axle',
                ingredients = {
                    ironbar = 4,
                },
                duration = 5000,
                count = 5,
            },
            {
                name = 'repair_part_injectors',
                ingredients = {
                    ironbar = 2,
                    plastic = 2,
                    copperwire = 4,
                    glue = 1,
                },
                duration = 4500,
                count = 20,
            },
            {
                name = 'repair_part_clutch',
                ingredients = {
                    ironbar = 6,
                    rubber = 1,
                },
                duration = 5000,
                count = 8,
            },
            {
                name = 'repair_part_brakes',
                ingredients = {
                    ironbar = 2,
                    glue = 1,
                },
                duration = 4500,
                count = 5,
            },
            {
                name = 'repair_part_transmission',
                ingredients = {
                    ironbar = 3,
                    electronic_parts = 1,
                    plastic = 1,
                },
                duration = 3500,
                count = 2,
            },
            {
                name = 'repair_part_rad',
                ingredients = {
                    ironbar = 3,
                    rubber = 1,
                    glue = 1,
                },
                duration = 2000,
                count = 2,
            },
        },
        zones = {
            {
                label = 'Mechanic Workbench',
                icon = 'fa-solid fa-wrench',
                coords = vec3(950.91, -979.09, 39.5),
                size = vec3(3.8, 1.2, 2.2),
                distance = 1.5,
                rotation = 4.0,
            },
        },
    },

    { -- Bennys Mechanic Shop
        name = 'bennys-mechanic',
        label = 'Mechanic Workbench',
        groups = { 'bennys' },
        reqDuty = true,
        items = {
            {
                name = 'repair_part_electronics',
                ingredients = {
                    electronic_parts = 5,
                    plastic = 4,
                    rubber = 1,
                    copperwire = 8,
                },
                duration = 3500,
                count = 10,
            },
            {
                name = 'repair_part_axle',
                ingredients = {
                    ironbar = 4,
                },
                duration = 5000,
                count = 5,
            },
            {
                name = 'repair_part_injectors',
                ingredients = {
                    ironbar = 2,
                    plastic = 2,
                    copperwire = 4,
                    glue = 1,
                },
                duration = 4500,
                count = 20,
            },
            {
                name = 'repair_part_clutch',
                ingredients = {
                    ironbar = 6,
                    rubber = 1,
                },
                duration = 5000,
                count = 8,
            },
            {
                name = 'repair_part_brakes',
                ingredients = {
                    ironbar = 2,
                    glue = 1,
                },
                duration = 4500,
                count = 5,
            },
            {
                name = 'repair_part_transmission',
                ingredients = {
                    ironbar = 3,
                    electronic_parts = 1,
                    plastic = 1,
                },
                duration = 3500,
                count = 2,
            },
            {
                name = 'repair_part_rad',
                ingredients = {
                    ironbar = 3,
                    rubber = 1,
                    glue = 1,
                },
                duration = 2000,
                count = 2,
            },
        },
        zones = {
            {
                label = 'Mechanic Workbench',
                icon = 'fa-solid fa-wrench',
                coords = vec3(-205.3346, -1335.6605, 31.300),
                size = vec3(5.0, 1.0, 3.0),
                distance = 1.5,
                rotation = 270.0,
            },
        },
    },

    { -- Paleto Tuners Mechanic Shop
        name = 'paleto-tuners-mechanic',
        label = 'Mechanic Workbench',
        groups = { 'paleto_tuners' },
        reqDuty = true,
        items = {
            {
                name = 'repair_part_electronics',
                ingredients = {
                    electronic_parts = 5,
                    plastic = 4,
                    rubber = 1,
                    copperwire = 8,
                },
                duration = 3500,
                count = 10,
            },
            {
                name = 'repair_part_axle',
                ingredients = {
                    ironbar = 4,
                },
                duration = 5000,
                count = 5,
            },
            {
                name = 'repair_part_injectors',
                ingredients = {
                    ironbar = 2,
                    plastic = 2,
                    copperwire = 4,
                    glue = 1,
                },
                duration = 4500,
                count = 20,
            },
            {
                name = 'repair_part_clutch',
                ingredients = {
                    ironbar = 6,
                    rubber = 1,
                },
                duration = 5000,
                count = 8,
            },
            {
                name = 'repair_part_brakes',
                ingredients = {
                    ironbar = 2,
                    glue = 1,
                },
                duration = 4500,
                count = 5,
            },
            {
                name = 'repair_part_transmission',
                ingredients = {
                    ironbar = 3,
                    electronic_parts = 1,
                    plastic = 1,
                },
                duration = 3500,
                count = 2,
            },
            {
                name = 'repair_part_rad',
                ingredients = {
                    ironbar = 3,
                    rubber = 1,
                    glue = 1,
                },
                duration = 2000,
                count = 2,
            },
        },
        zones = {
            {
                label = 'Mechanic Workbench',
                icon = 'fa-solid fa-wrench',
                coords = vec3(163.12, 6364.78, 31.27),
                size = vec3(4.4, 2.0, 2.4),
                distance = 1.5,
                rotation = 30.0,
            },
        },
    },

    { -- Dreamworks Mechanic Shop
        name = 'dreamworks-mechanic',
        label = 'Mechanic Workbench',
        groups = { 'dreamworks' },
        reqDuty = true,
        items = {
            {
                name = 'repair_part_electronics',
                ingredients = {
                    electronic_parts = 5,
                    plastic = 4,
                    rubber = 1,
                    copperwire = 8,
                },
                duration = 3500,
                count = 10,
            },
            {
                name = 'repair_part_axle',
                ingredients = {
                    ironbar = 4,
                },
                duration = 5000,
                count = 5,
            },
            {
                name = 'repair_part_injectors',
                ingredients = {
                    ironbar = 2,
                    plastic = 2,
                    copperwire = 4,
                    glue = 1,
                },
                duration = 4500,
                count = 20,
            },
            {
                name = 'repair_part_clutch',
                ingredients = {
                    ironbar = 6,
                    rubber = 1,
                },
                duration = 5000,
                count = 8,
            },
            {
                name = 'repair_part_brakes',
                ingredients = {
                    ironbar = 2,
                    glue = 1,
                },
                duration = 4500,
                count = 5,
            },
            {
                name = 'repair_part_transmission',
                ingredients = {
                    ironbar = 3,
                    electronic_parts = 1,
                    plastic = 1,
                },
                duration = 3500,
                count = 2,
            },
            {
                name = 'repair_part_rad',
                ingredients = {
                    ironbar = 3,
                    rubber = 1,
                    glue = 1,
                },
                duration = 2000,
                count = 2,
            },
        },
        zones = {
            {
                label = 'Mechanic Workbench',
                icon = 'fa-solid fa-wrench',
                coords = vec3(-726.39, -1505.64, 5.06),
                size = vec3(5.0, 1.0, 2.6),
                distance = 1.5,
                rotation = 293.0,
            },
        },
    },

    -- Mechanic Crafting Benches End --

    -- Taco Shop Crafting Benches Start --

    { -- Taco Shop Food Prep Table
        name = 'taco-shop-food',
        label = 'Taco Farmer Prep Table',
        items = {
            {
                name = 'beef_taco',
                ingredients = {
                    taco_cheese = 2,
                    taco_beef = 2,
                    taco_tortilla = 4,
                },
                duration = 3000,
                count = 4,
            },
            {
                name = 'tostada',
                ingredients = {
                    taco_cheese = 2,
                    taco_beef = 2,
                    taco_tortilla = 4,
                },
                duration = 3000,
                count = 4,
            },
            {
                name = 'quesadilla',
                ingredients = {
                    taco_cheese = 2,
                    taco_chicken = 2,
                    taco_tortilla = 4,
                },
                duration = 3000,
                count = 4,
            },
            {
                name = 'burrito',
                ingredients = {
                    taco_cheese = 2,
                    taco_chicken = 2,
                    taco_tortilla = 4,
                },
                duration = 3000,
                count = 4,
            },
            {
                name = 'enchilada',
                ingredients = {
                    taco_cheese = 2,
                    taco_beef = 2,
                    taco_tortilla = 4,
                },
                duration = 3000,
                count = 4,
            },
            {
                name = 'carne_asada',
                ingredients = {
                    taco_cheese = 2,
                    taco_steak = 4,
                },
                duration = 3000,
                count = 4,
            },
            {
                name = 'torta',
                ingredients = {
                    taco_cheese = 2,
                    taco_chicken = 2,
                    torta_roll = 4,
                },
                duration = 3000,
                count = 4,
            },
        },
        zones = {
            {
                label = 'Taco Farmer Prep Table',
                icon = 'fa-solid fa-utensils',
                coords = vec3(9.81, -1600.51, 29.38),
                size = vec3(1.8, 0.8, 4.0),
                distance = 1.5,
                rotation = 320.0,
            },
        },
    },

    { -- Taco Shop Drinks Fountain
        name = 'taco-shop-drinks',
        label = 'Taco Farmer Fountain Drinks',
        items = {
            {
                name = 'jugo',
                ingredients = {
                    taco_plastic_cups = 4,
                },
                duration = 2000,
                count = 4,
            },
            {
                name = 'taco_soda',
                ingredients = {
                    taco_plastic_cups = 4,
                },
                duration = 2000,
                count = 4,
            },
        },
        zones = {
            {
                label = 'Taco Farmer Fountain Drinks',
                icon = 'fa-solid fa-glass-water',
                coords = vec3(7.5, -1606.48, 29.38),
                size = vec3(0.8, 1.8, 1.4),
                distance = 1.5,
                rotation = 320.0,
            },
        },
    },

    -- Taco Shop Crafting Benches End --
}
