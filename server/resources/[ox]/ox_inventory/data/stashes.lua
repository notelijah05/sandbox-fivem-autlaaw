return {
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
        groups = { "ems" }
    },

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
    --     groups = { "government" }
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
        groups = { "government" },
        workplace = "doj"
    },
}
