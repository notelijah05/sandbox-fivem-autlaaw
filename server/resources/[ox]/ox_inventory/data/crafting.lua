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
}
