local constants = {}

constants.EG_MOD = "__electric-grid__"
constants.EG_GRAPHICS = constants.EG_MOD .. "/graphics"
constants.EG_SOUND = constants.EG_MOD .. "/sound"
constants.EG_TIER_BLEND_MODE = "additive"
constants.EG_DISPLAYER = "eg-transformator-displayer"
constants.EG_MAX_HEALTH = 200

constants.EG_CONSUMPTION_THRESHOLD = 0.98

constants.EG_DIRECTION_TO_CARDINAL = {
    [0] = "north",
    [4] = "east",
    [8] = "south",
    [12] = "west"
}

constants.EG_INTERNAL_ENTITY_FLAGS = {
    "not-rotatable",
    "placeable-neutral",
    "not-repairable",
    "not-on-map",
    "not-blueprintable",
    "not-deconstructable",
    "not-flammable",
    "no-copy-paste",
    "not-selectable-in-game",
    "not-upgradable",
    "not-in-kill-statistics",
}

constants.EG_TRANSFORMATORS = {
    --["eg-unit-1"] = { rating = "1MW", heat_capacity = "20J" },
    ["eg-unit-1"] = { rating = "1MW", heat_capacity = "0.263kJ", tint = { r = 1.0, g = 0.0, b = 0.0, a = 1 } },  -- Tier 1: Pure Red
    ["eg-unit-2"] = { rating = "5MW", heat_capacity = "100J", tint = { r = 1.0, g = 0.0, b = 0.5, a = 1 } },     -- Tier 2: Magenta (Red + Blue)
    ["eg-unit-3"] = { rating = "10MW", heat_capacity = "200J", tint = { r = 1.0, g = 0.0, b = 1.0, a = 1 } },    -- Tier 3: Pure Magenta
    ["eg-unit-4"] = { rating = "50MW", heat_capacity = "1000J", tint = { r = 0.5, g = 0.0, b = 1.0, a = 1 } },   -- Tier 4: Purple (Blue + Magenta)
    ["eg-unit-5"] = { rating = "100MW", heat_capacity = "2000J", tint = { r = 0.0, g = 0.0, b = 1.0, a = 1 } },  -- Tier 5: Pure Blue
    ["eg-unit-6"] = { rating = "500MW", heat_capacity = "10000J", tint = { r = 0.0, g = 1.0, b = 1.0, a = 1 } }, -- Tier 6: Cyan (Green + Blue)
    ["eg-unit-7"] = { rating = "1GW", heat_capacity = "20000J", tint = { r = 0.0, g = 1.0, b = 0.0, a = 1 } },   -- Tier 7: Pure Green
    ["eg-unit-8"] = { rating = "5GW", heat_capacity = "100000J", tint = { r = 0.5, g = 1.0, b = 0.0, a = 1 } },  -- Tier 8: Yellow-Green (Green + Yellow)
    ["eg-unit-9"] = { rating = "10GW", heat_capacity = "200000J", tint = { r = 1.0, g = 1.0, b = 0.0, a = 1 } }  -- Tier 9: Yellow (Red + Green)
}

constants.EG_NUM_TIERS = 0
for _ in pairs(constants.EG_TRANSFORMATORS) do
    constants.EG_NUM_TIERS = constants.EG_NUM_TIERS + 1
end

constants.EG_MAXIMUM_WIRE_DISTANCE = 4.5
constants.EG_SUPPLY_AREA_DISTANCE = 1
constants.EG_WIRE_CONNECTION_OFFSET = 0.1
constants.EG_POLE_CONNECTIONS = {
    eg_high_voltage_pole = {
        north = { wire = { 0.0, -1.8 }, shadow = { 2.2, 0.7 } },
        east  = { wire = { -0.4, -1.6 }, shadow = { 1.5, -1.2 } },
        south = { wire = { 0.0, -1.2 }, shadow = { 2.5, 0.6 } },
        west  = { wire = { 0.3, -1.6 }, shadow = { 2.0, 0.6 } },
    },
    eg_low_voltage_pole = {
        north = { wire = { 0.0, -1.6 }, shadow = { 3.0, 0.5 } },
        east  = { wire = { 0.3, -2.1 }, shadow = { 4.0, 0.5 } },
        south = { wire = { 0.0, -2.1 }, shadow = { 2.9, 0.7 } },
        west  = { wire = { -0.4, -2.0 }, shadow = { 1.8, 0.2 } },
    },
}

function constants.EG_TRANSFORMATOR_DISPLAYER_PICTURES()
    return {
        north = {
            layers = {
                {
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-sprites-hr.png",
                    x = 466,
                    width = 466,
                    height = 310,
                    shift = { 2.6, -0.45 },
                    scale = 0.5,
                },
                {
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-arrows-hr.png",
                    x = 466,
                    width = 466,
                    height = 310,
                    shift = { 2.6, -0.45 },
                    scale = 0.5,
                },
            },
        },
        east = {
            layers = {
                {
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-sprites-hr.png",
                    width = 466,
                    height = 310,
                    shift = { 1.5, -1.15 },
                    scale = 0.5,
                },
                {
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-arrows-hr.png",
                    width = 466,
                    height = 310,
                    shift = { 1.5, -1.15 },
                    scale = 0.5,
                },
            },
        },
        south = {
            layers = {
                {
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-sprites-hr.png",
                    x = 1398,
                    width = 466,
                    height = 310,
                    shift = { 2.6, -0.45 },
                    scale = 0.5,
                },
                {
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-arrows-hr.png",
                    x = 1398,
                    width = 466,
                    height = 310,
                    shift = { 2.6, -0.45 },
                    scale = 0.5,
                },
            },
        },
        west = {
            layers = {
                {
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-sprites-hr.png",
                    x = 932,
                    width = 466,
                    height = 310,
                    shift = { 1.5, -1.15 },
                    scale = 0.5,
                },
                {
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-arrows-hr.png",
                    x = 932,
                    width = 466,
                    height = 310,
                    shift = { 1.5, -1.15 },
                    scale = 0.5,
                },
            },
        },
    }
end

return constants
