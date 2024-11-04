local constants = {}

constants.EG_MOD = "__electric-grid__"
constants.EG_GRAPHICS = constants.EG_MOD .. "/graphics"
constants.EG_SOUND = constants.EG_MOD .. "/sound"
constants.EG_TIER_BLEND_MODE = "additive"

if settings.startup["eg-hide-alt-overlay"].value then
    constants.EG_ALTOVERLAY = "hide-alt-info"
else
    constants.EG_ALTOVERLAY = nil
end

constants.EG_INTERNAL_ENTITY_FLAGS = {
    "not-rotatable",
    "placeable-neutral",
    "not-repairable",
    "not-on-map",
    "not-blueprintable",
    "not-deconstructable",
    --"hidden",
    "not-flammable",
    "no-copy-paste",
    "not-selectable-in-game",
    "not-upgradable",
    "not-in-kill-statistics",
}

constants.EG_TRANSFORMATORS = {
    --["eg-transformator-1-unit"] = { rating = "1MW", heat_capacity = "20J" },
    ["eg-transformator-1-unit"] = { rating = "1MW", heat_capacity = "0.263kJ" },
    ["eg-transformator-2-unit"] = { rating = "5MW", heat_capacity = "100J" },
    ["eg-transformator-3-unit"] = { rating = "10MW", heat_capacity = "200J" },
    ["eg-transformator-4-unit"] = { rating = "50MW", heat_capacity = "1000J" },
    ["eg-transformator-5-unit"] = { rating = "100MW", heat_capacity = "2000J" },
    ["eg-transformator-6-unit"] = { rating = "500MW", heat_capacity = "10000J" },
    ["eg-transformator-7-unit"] = { rating = "1GW", heat_capacity = "20000J" },
    ["eg-transformator-8-unit"] = { rating = "5GW", heat_capacity = "100000J" },
    ["eg-transformator-9-unit"] = { rating = "10GW", heat_capacity = "200000J" }
}

constants.EG_NUM_TIERS = 0
for _ in pairs(constants.EG_TRANSFORMATORS) do
    constants.EG_NUM_TIERS = constants.EG_NUM_TIERS + 1
end

constants.EG_CONSUMPTION_THRESHOLD = 0.98
constants.EG_MAXIMUM_WIRE_DISTANCE = 4.5
constants.EG_SUPPLY_AREA_DISTANCE = 1

constants.EG_TINT = {
    { r = 1.0, g = 0.0, b = 0.0, a = 1 }, -- Tier 1: Pure Red
    { r = 1.0, g = 0.0, b = 0.5, a = 1 }, -- Tier 2: Magenta (Red + Blue)
    { r = 1.0, g = 0.0, b = 1.0, a = 1 }, -- Tier 3: Pure Magenta
    { r = 0.5, g = 0.0, b = 1.0, a = 1 }, -- Tier 4: Purple (Blue + Magenta)
    { r = 0.0, g = 0.0, b = 1.0, a = 1 }, -- Tier 5: Pure Blue
    { r = 0.0, g = 1.0, b = 1.0, a = 1 }, -- Tier 6: Cyan (Green + Blue)
    { r = 0.0, g = 1.0, b = 0.0, a = 1 }, -- Tier 7: Pure Green
    { r = 0.5, g = 1.0, b = 0.0, a = 1 }, -- Tier 8: Yellow-Green (Green + Yellow)
    { r = 1.0, g = 1.0, b = 0.0, a = 1 }, -- Tier 9: Yellow (Red + Green)
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
