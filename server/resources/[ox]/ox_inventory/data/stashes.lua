return {
    -- Police Lockers Start --

    {
        target = {
            loc = vec3(461.59, -1000.0, 30.69),
            length = 1.0,
            width = 3.8,
            heading = 0,
            minZ = 29.69,
            maxZ = 32.69,
            label = 'Open Personal Locker'
        },
        name = 'police-locker',
        label = 'Personal Locker',
        owner = true,
        slots = 70,
        weight = 70000,
        groups = shared.police
    },

    {
        target = {
            loc = vec3(1841.51, 3682.08, 34.19),
            length = 2.0,
            width = 1.0,
            heading = 30,
            minZ = 33.19,
            maxZ = 35.59,
            label = 'Open Personal Locker'
        },
        name = 'police-locker-2',
        label = 'Personal Locker',
        owner = true,
        slots = 70,
        weight = 70000,
        groups = shared.police
    },

    {
        target = {
            loc = vec3(-436.32, 6009.79, 37.0),
            length = 0.2,
            width = 2.2,
            heading = 45,
            minZ = 36.3,
            maxZ = 38.1,
            label = 'Open Personal Locker'
        },
        name = 'police-locker-3',
        label = 'Personal Locker',
        owner = true,
        slots = 70,
        weight = 70000,
        groups = shared.police
    },

    {
        target = {
            loc = vec3(360.08, -1592.9, 25.45),
            length = 0.5,
            width = 2.8,
            heading = 50,
            minZ = 24.45,
            maxZ = 27.45,
            label = 'Open Personal Locker'
        },
        name = 'police-locker-4',
        label = 'Personal Locker',
        owner = true,
        slots = 70,
        weight = 70000,
        groups = shared.police
    },

    {
        target = {
            loc = vec3(844.8, -1286.55, 28.24),
            length = 2.0,
            width = 1.2,
            heading = 0,
            minZ = 27.24,
            maxZ = 29.84,
            label = 'Open Personal Locker'
        },
        name = 'police-locker-5',
        label = 'Personal Locker',
        owner = true,
        slots = 70,
        weight = 70000,
        groups = shared.police
    },

    {
        target = {
            loc = vec3(-1061.09, -247.43, 39.74),
            length = 3.6,
            width = 1.0,
            heading = 27,
            minZ = 38.74,
            maxZ = 41.34,
            label = 'Open Personal Locker'
        },
        name = 'police-locker-6',
        label = 'Personal Locker',
        owner = true,
        slots = 70,
        weight = 70000,
        groups = shared.police
    },

    -- Police Lockers End --

    -- EMS Lockers Start --

    {
        target = {
            loc = vec3(1142.12, -1539.54, 35.03),
            length = 4.2,
            width = 0.6,
            heading = 0,
            minZ = 32.23,
            maxZ = 36.23,
            label = 'Open Personal Locker'
        },
        name = 'ems-locker',
        label = 'Personal Locker',
        owner = true,
        slots = 70,
        weight = 70000,
        groups = "ems",
        workplace = "safd"
    },

    -- EMS Lockers End --

    -- Government Storage Start --

    -- {
    --     target = {
    --         loc = vec3(-586.32, -213.18, 42.84),
    --         length = 0.8,
    --         width = 1.0,
    --         heading = 30,
    --         minZ = 41.84,
    --         maxZ = 44.24,
    --         label = 'Open Safe'
    --     },
    --     name = 'doj-chief-justice-storage',
    --     label = 'Chief Justice Storage',
    --     owner = false,
    --     slots = 70,
    --     weight = 70000,
    --     groups = "government",
    --     workplace = "doj"
    -- },

    {
        target = {
            loc = vec3(-586.64, -203.5, 38.23),
            length = 0.8,
            width = 1.4,
            heading = 30,
            minZ = 37.23,
            maxZ = 39.43,
            label = 'Open Storage'
        },
        name = 'doj-storage',
        label = 'DOJ Storage',
        owner = false,
        slots = 70,
        weight = 70000,
        groups = "government",
        workplace = "doj"
    },

    -- Government Storage End --

    -- Business Safes / Storages Start --
    {
        target = {
            loc = vec3(-1648.3, -1072.7, 13.76),
            length = 0.6,
            width = 1.0,
            heading = 320,
            minZ = 11.96,
            maxZ = 14.56,
            label = 'Open Safe'
        },
        name = 'avast-arcade-safe',
        label = 'Avast Arcade Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "avast_arcade",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(796.54, -749.24, 31.27),
            length = 0.6,
            width = 1.0,
            heading = 0,
            minZ = 29.47,
            maxZ = 32.07,
            label = 'Open Safe'
        },
        name = 'pizza-this-safe',
        label = 'Pizza This Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "pizza_this",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(2474.25, 4111.19, 41.24),
            length = 0.6,
            width = 1.0,
            heading = 355,
            minZ = 39.44,
            maxZ = 42.04,
            label = 'Open Safe'
        },
        name = 'greycat-shipping-safe',
        label = 'Greycat Shipping Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "greycat_shipping",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(2467.2, 4090.4, 34.83),
            length = 2.0,
            width = 2.0,
            heading = 0,
            minZ = 33.83,
            maxZ = 36.83,
            label = 'Open Storage'
        },
        name = 'greycat-shipping-storage',
        label = 'Greycat Shipping Storage',
        owner = false,
        slots = 100,
        weight = 100000,
        groups = "greycat_shipping",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(-595.65, -914.12, 28.14),
            length = 0.6,
            width = 1.0,
            heading = 1,
            minZ = 26.34,
            maxZ = 28.94,
            label = 'Open Safe'
        },
        name = 'redline-safe',
        label = 'Redline Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "redline",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(-580.84, -928.21, 23.89),
            length = 2.2,
            width = 2.2,
            heading = 0,
            minZ = 22.89,
            maxZ = 25.09,
            label = 'Open Safe'
        },
        name = 'redline-safe2',
        label = 'Redline Safe 2',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "redline",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(994.78, -1489.84, 31.5),
            length = 3.2,
            width = 3.2,
            heading = 270,
            minZ = 30.5,
            maxZ = 33.1,
            label = 'Open Storage'
        },
        name = 'blackline-storage',
        label = 'Blackline Storage',
        owner = false,
        slots = 100,
        weight = 100000,
        groups = "blackline"
    },

    {
        target = {
            loc = vec3(-597.39, -1049.57, 22.34),
            length = 1.0,
            width = 1.0,
            heading = 0,
            minZ = 21.34,
            maxZ = 23.94,
            label = 'Open Safe'
        },
        name = 'uwu-safe',
        label = 'UwU Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "uwu",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(-598.09, -1065.24, 22.34),
            length = 5.2,
            width = 7.6,
            heading = 0,
            minZ = 21.34,
            maxZ = 24.74,
            label = 'Open Storage'
        },
        name = 'uwu_warehouse_storage',
        label = 'UwU Warehouse Storage',
        owner = false,
        slots = 150,
        weight = 150000,
        groups = "uwu"
    },

    {
        target = {
            loc = vec3(-23.87, -1102.85, 27.27),
            length = 1.0,
            width = 2.2,
            heading = 340,
            minZ = 26.27,
            maxZ = 28.27,
            label = 'Open Safe'
        },
        name = 'pdm-safe',
        label = 'PDM Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "pdm",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(-27.056, -1097.984, 27.274),
            length = 1.0,
            width = 2.2,
            heading = 160,
            minZ = 26.27,
            maxZ = 28.27,
            label = 'Open Storage'
        },
        name = 'pdm-storage',
        label = 'PDM Storage',
        owner = false,
        slots = 100,
        weight = 100000,
        groups = "pdm"
    },

    {
        target = {
            loc = vec3(146.27, -3007.82, 6.04),
            length = 2.0,
            width = 2.0,
            heading = 0,
            minZ = 6.04,
            maxZ = 8.04,
            label = 'Open Safe'
        },
        name = 'tuna-safe',
        label = 'Tuna Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "tuna",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(145.68, -3011.15, 6.04),
            length = 1.0,
            width = 1.0,
            heading = 0,
            minZ = 6.04,
            maxZ = 8.24,
            label = 'Open Safe'
        },
        name = 'tuna-safe_2',
        label = 'Tuna Safe 2',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "tuna",
        permissionKey = "JOB_ACCESS_SAFE"
    },

    {
        target = {
            loc = vec3(-816.53, -696.26, 32.14),
            length = 1.0,
            width = 1.0,
            heading = 0,
            minZ = 30.94,
            maxZ = 33.34,
            label = 'Open Safe'
        },
        name = 'triad-safe',
        label = 'Triad Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "triad",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(757.46, -775.95, 26.34),
            length = 0.8,
            width = 0.8,
            heading = 0,
            minZ = 25.34,
            maxZ = 27.14,
            label = 'Open Safe'
        },
        name = 'bobs-safe',
        label = 'Bobs Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "bobs",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(-2579.55, 1884.19, 163.79),
            length = 3.6,
            width = 1.4,
            heading = 310,
            minZ = 162.79,
            maxZ = 165.39,
            label = 'Open Safe'
        },
        name = 'dmansion_safe_1',
        label = 'D Mansion Safe 1',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "dgang",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(-2598.18, 1888.33, 163.75),
            length = 2.4,
            width = 1.6,
            heading = 220,
            minZ = 162.75,
            maxZ = 165.35,
            label = 'Open Safe'
        },
        name = 'dmansion_safe_2',
        label = 'D Mansion Safe 2',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "dgang",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(-2604.13, 1923.33, 167.3),
            length = 2.4,
            width = 1.6,
            heading = 95,
            minZ = 166.3,
            maxZ = 168.9,
            label = 'Open Safe'
        },
        name = 'dmansion_safe_3',
        label = 'D Mansion Safe 3',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "dgang",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(-2601.2, 1875.18, 163.79),
            length = 1.2,
            width = 5.0,
            heading = 40,
            minZ = 162.79,
            maxZ = 165.19,
            label = 'Open Safe'
        },
        name = 'dmansion_safe_4',
        label = 'D Mansion Safe 4',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "dgang",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(-2588.94, 1893.82, 163.72),
            length = 2.0,
            width = 3.0,
            heading = 310,
            minZ = 162.72,
            maxZ = 165.32,
            label = 'Open Safe'
        },
        name = 'dmansion_safe_5',
        label = 'D Mansion Safe 5',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "dgang",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(-2590.74, 1911.72, 167.3),
            length = 1.8,
            width = 2.0,
            heading = 7,
            minZ = 166.3,
            maxZ = 168.9,
            label = 'Open Safe'
        },
        name = 'dmansion_safe_6',
        label = 'D Mansion Safe 6',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "dgang",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(-1428.22, -459.8, 35.91),
            length = 1.6,
            width = 1.2,
            heading = 300,
            minZ = 34.91,
            maxZ = 37.11,
            label = 'Open Safe'
        },
        name = 'hayes_safe',
        label = 'Hayes Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "hayes",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(1187.2834, 2635.8643, 38.4020),
            length = 1.6,
            width = 1.2,
            heading = 186.5794,
            minZ = 36.940201,
            maxZ = 40.4020,
            label = 'Open Safe'
        },
        name = 'harmony_safe',
        label = 'Harmony Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "harmony",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(-1372.069, -629.168, 29.320),
            length = 1.25,
            width = 1.0,
            heading = 123,
            minZ = 28.26,
            maxZ = 31.320,
            label = 'Open Safe'
        },
        name = 'bahama_safe',
        label = 'Bahama Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "bahama",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(-296.13, 6268.23, 31.53),
            length = 1.6,
            width = 1.6,
            heading = 43,
            minZ = 30.28,
            maxZ = 32.48,
            label = 'Open Safe'
        },
        name = 'woods_saloon_safe',
        label = 'Woods Saloon Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "woods_saloon",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(93.78, -1290.6, 29.26),
            length = 1.0,
            width = 1.4,
            heading = 30,
            minZ = 28.26,
            maxZ = 29.86,
            label = 'Open Safe'
        },
        name = 'unicorn_safe',
        label = 'Unicorn Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "unicorn",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(-725.948, 261.153, 84.101),
            length = 1.0,
            width = 1.0,
            heading = 120,
            minZ = 83.14,
            maxZ = 85.54,
            label = 'Open Safe'
        },
        name = 'dynasty8_safe',
        label = 'Dynasty8 Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "dynasty8",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(-716.067, 266.820, 84.101),
            length = 2.0,
            width = 1.0,
            heading = 290,
            minZ = 83.14,
            maxZ = 85.54,
            label = 'Open Storage'
        },
        name = 'dynasty8_storage',
        label = 'Dynasty8 Storage',
        owner = false,
        slots = 100,
        weight = 100000,
        groups = "dynasty8"
    },

    {
        target = {
            loc = vec3(-69.95, -1327.76, 29.27),
            length = 1.0,
            width = 1.0,
            heading = 0,
            minZ = 28.27,
            maxZ = 30.27,
            label = 'Open Safe'
        },
        name = 'nutz_safe',
        label = 'Tire Nutz Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "tirenutz",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(-1162.64, -1572.16, 4.66),
            length = 3.2,
            width = 3.2,
            heading = 305,
            minZ = 3.66,
            maxZ = 6.06,
            label = 'Open Storage'
        },
        name = 'weed_storage',
        label = 'Weed Storage',
        owner = false,
        slots = 100,
        weight = 100000,
        groups = "weed",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(-1166.66, -1567.7, 4.66),
            length = 1.0,
            width = 1.0,
            heading = 310,
            minZ = 3.66,
            maxZ = 5.86,
            label = 'Open Safe'
        },
        name = 'weed_safe',
        label = 'Weed Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "weed",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(-571.53, 289.01, 79.18),
            length = 1.0,
            width = 1.0,
            heading = 355,
            minZ = 78.18,
            maxZ = 80.38,
            label = 'Open Safe'
        },
        name = 'tequila_safe',
        label = 'Tequila Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "tequila",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(380.74, -824.81, 29.3),
            length = 1.0,
            width = 1.0,
            heading = 0,
            minZ = 28.3,
            maxZ = 30.9,
            label = 'Open Safe'
        },
        name = 'digitalden_safe',
        label = 'Digital Den Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "digitalden",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(268.22, -1786.8, 31.27),
            length = 1.0,
            width = 1.0,
            heading = 50,
            minZ = 30.27,
            maxZ = 33.07,
            label = 'Open Safe'
        },
        name = 'superperformance_safe',
        label = 'Super Performance Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "superperformance",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(-1184.16, -1149.45, 7.67),
            length = 1.0,
            width = 1.0,
            heading = 15,
            minZ = 6.67,
            maxZ = 9.07,
            label = 'Open Safe'
        },
        name = 'noodle_safe',
        label = 'Noodle Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "noodle",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(560.4, -198.45, 58.15),
            length = 1.0,
            width = 6.0,
            heading = 0,
            minZ = 57.15,
            maxZ = 59.95,
            label = 'Open Safe'
        },
        name = 'ae_safe',
        label = 'Auto Exotics Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "autoexotics",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(540.52, -170.44, 57.68),
            length = 1.0,
            width = 1.0,
            heading = 0,
            minZ = 56.68,
            maxZ = 58.88,
            label = 'Open Safe'
        },
        name = 'ae_safe2',
        label = 'Auto Exotics Safe 2',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "autoexotics",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(543.46, -184.23, 54.51),
            length = 4.6,
            width = 3.8,
            heading = 0,
            minZ = 53.51,
            maxZ = 56.31,
            label = 'Open Safe'
        },
        name = 'ae_safe3',
        label = 'Auto Exotics Safe 3',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "autoexotics",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(-1007.72, -262.54, 44.8),
            length = 1.0,
            width = 1.0,
            heading = 325,
            minZ = 43.8,
            maxZ = 47.8,
            label = 'Open Safe'
        },
        name = 'rockford_records_safe',
        label = 'Rockford Records Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "rockford_records",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(31.14, -119.98, 56.22),
            length = 1.0,
            width = 0.8,
            heading = 340,
            minZ = 55.22,
            maxZ = 57.22,
            label = 'Open Safe'
        },
        name = 'securoserv_safe',
        label = 'SecuroServ Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "securoserv",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(-330.72, -96.75, 47.05),
            length = 1.6,
            width = 2.0,
            heading = 340,
            minZ = 44.65,
            maxZ = 48.65,
            label = 'Open Safe'
        },
        name = 'pepega_pawn_safe',
        label = 'Pepega Pawn Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "pepega_pawn",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(-214.22, 6230.05, 31.79),
            length = 2.0,
            width = 1.6,
            heading = 0,
            minZ = 29.39,
            maxZ = 33.39,
            label = 'Open Safe'
        },
        name = 'garcon_pawn_safe',
        label = 'Garcon Pawn Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "garcon_pawn",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(950.44, -969.84, 39.51),
            length = 2.6,
            width = 1.2,
            heading = 4,
            minZ = 38.3,
            maxZ = 40.7,
            label = 'Open Safe'
        },
        name = 'ottos_autos_safe',
        label = 'Ottos Autos Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "ottos",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(952.56, -974.43, 39.5),
            length = 2.6,
            width = 1.2,
            heading = 275,
            minZ = 38.3,
            maxZ = 40.7,
            label = 'Open Safe'
        },
        name = 'ottos_autos_safe2',
        label = 'Ottos Autos Safe 2',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "ottos",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(-192.8473, -1314.6613, 31.3005),
            length = 1.0,
            width = 1.4,
            heading = 280,
            minZ = 29.4571,
            maxZ = 33.4571,
            label = 'Open Safe'
        },
        name = 'bennys_safe',
        label = 'Bennys Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "bennys",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(-192.4591, -1337.8313, 31.3005),
            length = 1.5,
            width = 0.75,
            heading = 280,
            minZ = 29.4571,
            maxZ = 33.4571,
            label = 'Open Safe'
        },
        name = 'bennys_safe2',
        label = 'Bennys Safe 2',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "bennys",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(978.63, 50.69, 116.17),
            length = 2.6,
            width = 1.0,
            heading = 328,
            minZ = 115.17,
            maxZ = 118.17,
            label = 'Open Safe'
        },
        name = 'casino_safe',
        label = 'Casino Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "casino",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(1000.85, 52.78, 75.06),
            length = 2.0,
            width = 2.0,
            heading = 330,
            minZ = 74.06,
            maxZ = 76.46,
            label = 'Open Safe'
        },
        name = 'casino_safe2',
        label = 'Casino Safe 2',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "casino",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(-1123.2, -1460.47, 5.11),
            length = 2.0,
            width = 2.2,
            heading = 35,
            minZ = 4.11,
            maxZ = 5.91,
            label = 'Open Safe'
        },
        name = 'prego_safe',
        label = 'Prego Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "prego",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(-381.858, 268.998, 86.459),
            length = 1.0,
            width = 1.2,
            heading = 303.559,
            minZ = 85.459,
            maxZ = 87.459,
            label = 'Open Safe'
        },
        name = 'lasttrain_safe',
        label = 'Last Train Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "lasttrain",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(122.380, -1045.557, 29.278),
            length = 1.0,
            width = 1.0,
            heading = 250,
            minZ = 27.9742,
            maxZ = 30.9742,
            label = 'Open Safe'
        },
        name = 'beanmachine_safe',
        label = 'Bean Machine Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "beanmachine",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(-1200.774, -896.674, 13.798),
            length = 1.5,
            width = 1.5,
            heading = 35,
            minZ = 11.9742,
            maxZ = 15.9742,
            label = 'Open Safe'
        },
        name = 'burgershot_safe',
        label = 'Burger Shot Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "burgershot",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(164.93, 248.94, 107.05),
            length = 1.4,
            width = 0.9,
            heading = 340,
            minZ = 104.65,
            maxZ = 108.65,
            label = 'Open Safe'
        },
        name = 'rustybrowns_safe',
        label = 'Rusty Browns Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "rustybrowns",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(1073.0, -2399.06, 25.9),
            length = 1.2,
            width = 1.4,
            heading = 0,
            minZ = 24.9,
            maxZ = 26.9,
            label = 'Open Storage'
        },
        name = 'triad_boxing_storage',
        label = 'Triad Boxing Storage',
        owner = false,
        slots = 100,
        weight = 100000,
        groups = "triad_boxing"
    },

    {
        target = {
            loc = vec3(1002.536, -128.212, 74.063),
            length = 3.0,
            width = 1.4,
            heading = 239,
            minZ = 70.0,
            maxZ = 76.0,
            label = 'Open Safe'
        },
        name = 'odmc_storage_safe',
        label = 'ODMC Storage Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "odmc",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(958.58, -108.79, 74.37),
            length = 1.4,
            width = 3.6,
            heading = 315,
            minZ = 72.37,
            maxZ = 76.37,
            label = 'Open Storage'
        },
        name = 'odmc_storage',
        label = 'ODMC Storage',
        owner = false,
        slots = 100,
        weight = 100000,
        groups = "odmc"
    },

    {
        target = {
            loc = vec3(-18.51, -1438.82, 31.1),
            length = 1.8,
            width = 1.6,
            heading = 0,
            minZ = 28.5,
            maxZ = 32.5,
            label = 'Open Safe'
        },
        name = 'saints_storage_safe',
        label = 'Saints Storage Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "saints",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(-16.51, -1430.47, 31.1),
            length = 2.2,
            width = 1.6,
            heading = 0,
            minZ = 28.9,
            maxZ = 32.9,
            label = 'Open Storage'
        },
        name = 'saints_storage',
        label = 'Saints Storage',
        owner = false,
        slots = 100,
        weight = 100000,
        groups = "saints"
    },

    {
        target = {
            loc = vec3(1616.17, 4830.96, 33.14),
            length = 1.4,
            width = 1.0,
            heading = 10,
            minZ = 31.69,
            maxZ = 33.89,
            label = 'Open Safe'
        },
        name = 'lsfc_storage_safe',
        label = 'LSFC Storage Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "lsfc",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(173.31, 6391.96, 31.27),
            length = 1.0,
            width = 1.0,
            heading = 30,
            minZ = 30.27,
            maxZ = 32.27,
            label = 'Open Safe'
        },
        name = 'paleto_tuners_storage_safe',
        label = 'Paleto Tuners Safe',
        owner = false,
        slots = 100,
        weight = 100000,
        groups = "paleto_tuners",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(176.64, 6385.5, 31.27),
            length = 1.0,
            width = 1.0,
            heading = 30,
            minZ = 30.27,
            maxZ = 32.47,
            label = 'Open Safe'
        },
        name = 'paleto_tuners_storage_safe2',
        label = 'Paleto Tuners Safe',
        owner = false,
        slots = 100,
        weight = 100000,
        groups = "paleto_tuners",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(143.54, 6376.71, 31.27),
            length = 1.0,
            width = 1.0,
            heading = 25,
            minZ = 30.27,
            maxZ = 33.07,
            label = 'Open Safe'
        },
        name = 'paleto_tuners_storage_safe3',
        label = 'Paleto Tuners Safe',
        owner = false,
        slots = 100,
        weight = 100000,
        groups = "paleto_tuners",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(-700.44, -1399.22, 8.55),
            length = 1.0,
            width = 1.4,
            heading = 50,
            minZ = 7.55,
            maxZ = 9.95,
            label = 'Open Safe'
        },
        name = 'dreamworks_safe',
        label = 'Dreamworks Safe',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "dreamworks",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    {
        target = {
            loc = vec3(-742.05, -1526.34, 5.06),
            length = 1.5,
            width = 1.5,
            heading = 24,
            minZ = 4.06,
            maxZ = 6.06,
            label = 'Open Safe'
        },
        name = 'dreamworks_safe2',
        label = 'Dreamworks Safe 2',
        owner = false,
        slots = 50,
        weight = 50000,
        groups = "dreamworks",
        permissionKey = "JOB_ACCESS_SAFE",
    },

    -- Business Safes / Storages End --
}
