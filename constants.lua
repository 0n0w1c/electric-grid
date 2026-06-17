local function normalize_rating(rating)
    local value, unit = rating:match("^(%d+%.?%d*)(%a+)$")
    value = tonumber(value)

    if unit == "W" then
        return value
    elseif unit == "kW" then
        return value * 1e3
    elseif unit == "MW" then
        return value * 1e6
    elseif unit == "GW" then
        return value * 1e9
    end

    return 0
end

local constants = {}

constants.EG_DEBUG_TRANSFORMATOR = false
constants.EG_TICK_INTERVAL = 60
constants.EG_UGP_SUBSTATION_REPLACE_DELAY_TICKS = 3 * constants.EG_TICK_INTERVAL
constants.EG_PROCESS_PER_TICK = 5

constants.EG_BASE_TO_EG_POLES = {
    ["small-electric-pole"] = "eg-small-electric-pole",
    ["medium-electric-pole"] = "eg-medium-electric-pole",
    ["big-electric-pole"] = "eg-big-electric-pole",
    ["substation"] = "eg-substation",
    ["small-iron-electric-pole"] = "eg-small-iron-electric-pole"
}

constants.EG_MOD = "__electric-grid__"
constants.EG_GRAPHICS = constants.EG_MOD .. "/graphics/"
constants.EG_ENTITIES = constants.EG_GRAPHICS .. "entities/"
constants.EG_ICONS = constants.EG_GRAPHICS .. "icons/"
constants.EG_SOUND = constants.EG_MOD .. "/sound/"
constants.EG_TIER_BLEND_MODE = "additive"
constants.EG_OVERLAY_TINT = { r = 0.5, g = 0.5, b = 0.5, a = 1 }
constants.EG_BLUEPRINT_TIER_TAG = "eg_transformator_tier"
constants.EG_BLUEPRINT_WIRE_TAG = "eg_transformator_wires"
constants.EG_BLUEPRINT_WIRE_RETRY_COUNT = 60
constants.EG_SUBGROUP = "eg-electric-distribution"

constants.EG_MAX_HEALTH = 500
constants.EG_FLUID_VOLUME = 1
constants.DISABLED_FLUID = "eg-fluid-disable"

constants.EG_QUALITIES = {
    "normal",
    "uncommon",
    "rare",
    "epic",
    "legendary"
}

constants.TRANSFORMATOR_RATED_FLUID_RATE = 30
constants.TRANSFORMATOR_INPUT_TEMP = 15
constants.TRANSFORMATOR_OUTPUT_TEMP = 165
constants.TRANSFORMATOR_GENERATOR_DEFAULT_TEMP = 100

constants.HEAT_CAPACITY_PER_MW =
    1000 / (
        constants.TRANSFORMATOR_RATED_FLUID_RATE *
        (constants.TRANSFORMATOR_OUTPUT_TEMP - constants.TRANSFORMATOR_INPUT_TEMP)
    )

constants.STEAM_ENGINE_EFFECTIVITY =
    (constants.TRANSFORMATOR_OUTPUT_TEMP - constants.TRANSFORMATOR_INPUT_TEMP) /
    (constants.TRANSFORMATOR_OUTPUT_TEMP - constants.TRANSFORMATOR_GENERATOR_DEFAULT_TEMP)

constants.EG_DIRECTION_TO_CARDINAL = {
    [defines.direction.north] = "north",
    [defines.direction.east] = "east",
    [defines.direction.south] = "south",
    [defines.direction.west] = "west"
}

constants.EG_ENTITY_OFFSETS = {
    infinity_pipe = { x = 0.5, y = -0.5 },  -- Northeast quadrant
    pump = { x = 0.5, y = 0.5 },            -- Southeast quadrant
    boiler = { x = -0.5, y = 0.5 },         -- Southwest quadrant
    steam_engine = { x = -0.5, y = -0.5 },  -- Northwest quadrant
    high_voltage_pole = { x = 0, y = 1.0 }, -- Center south
    low_voltage_pole = { x = 0, y = -1.0 }, -- Center north
}

constants.EG_INTERNAL_ENTITY_FLAGS = {
    "not-rotatable",
    "hide-alt-info",
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
    "not-in-made-in"
}

constants.EG_PUMP_TINT = { r = 1.0, g = 1.0, b = 1.0, a = 1 }

constants.EG_TRANSFORMATORS = {
    { rating = "1MW",   tint = { r = 1.0, g = 0.0, b = 0.0, a = 1 } },  -- red
    { rating = "5MW",   tint = { r = 1.0, g = 0.5, b = 0.0, a = 1 } },  -- orange
    { rating = "10MW",  tint = { r = 1.0, g = 0.85, b = 0.2, a = 1 } }, -- gold
    { rating = "50MW",  tint = { r = 1.0, g = 1.0, b = 0.0, a = 1 } },  -- yellow
    { rating = "100MW", tint = { r = 0.0, g = 1.0, b = 0.0, a = 1 } },  -- green
    { rating = "500MW", tint = { r = 0.0, g = 1.0, b = 1.0, a = 1 } },  -- cyan
    { rating = "1GW",   tint = { r = 0.0, g = 0.5, b = 1.0, a = 1 } },  -- blue
    { rating = "5GW",   tint = { r = 0.5, g = 0.0, b = 1.0, a = 1 } },  -- violet
    { rating = "10GW",  tint = { r = 1.0, g = 0.0, b = 1.0, a = 1 } }   -- magenta
}

for _, transformator in ipairs(constants.EG_TRANSFORMATORS) do
    local rating_in_watts = normalize_rating(transformator.rating)
    local rating_in_MW = rating_in_watts / 1e6
    transformator.rating_watts = rating_in_watts
    transformator.heat_capacity = (rating_in_MW * constants.HEAT_CAPACITY_PER_MW) .. "kJ"
end

constants.EG_NUM_TIERS                  = #constants.EG_TRANSFORMATORS

constants.EG_LIGHT_COLOR                = { r = 1.0, g = 1.0, b = 0.7 }
constants.EG_LIGHT_INTENSITY            = 0.7
constants.EG_LIGHT_SIZE                 = 12

constants.EG_HUGE_POLE_LIGHT            =
{
    color = constants.EG_LIGHT_COLOR,
    intensity = constants.EG_LIGHT_INTENSITY,
    size = constants.EG_LIGHT_SIZE
}

constants.EG_BIG_POLE_LIGHT             =
{
    color = constants.EG_LIGHT_COLOR,
    intensity = constants.EG_LIGHT_INTENSITY / 1.1,
    size = constants.EG_LIGHT_SIZE / 1.2
}

constants.EG_MEDIUM_POLE_LIGHT          =
{
    color = constants.EG_LIGHT_COLOR,
    intensity = constants.EG_LIGHT_INTENSITY / 1.25,
    size = constants.EG_LIGHT_SIZE / 1.5
}

constants.EG_MINI_POLE_LIGHT            =
{
    color = constants.EG_LIGHT_COLOR,
    intensity = constants.EG_LIGHT_INTENSITY / 2,
    size = constants.EG_LIGHT_SIZE / 3
}

constants.EG_SUPPLY_AREA_DISTANCE       = 0.24
constants.EG_WIRE_CONNECTION_OFFSET     = 0.1
constants.EG_WIRE_CONNECTION_POINTS     = {
    eg_high_voltage_pole = {
        north = { wire = { 0.0, -2.1 }, shadow = { 3.0, 0.7 } },
        east  = { wire = { -0.4, -2.1 }, shadow = { 0.6, -1.0 } },
        south = { wire = { 0.0, -1.6 }, shadow = { 2.9, 0.5 } },
        west  = { wire = { 0.3, -2.0 }, shadow = { 3.8, 0.5 } },
    },
    eg_low_voltage_pole = {
        north = { wire = { 0.0, -1.2 }, shadow = { 2.2, 0.6 } },
        east  = { wire = { 0.3, -1.6 }, shadow = { 3.2, 0.5 } },
        south = { wire = { 0.0, -1.8 }, shadow = { 2.5, 0.7 } },
        west  = { wire = { -0.4, -1.6 }, shadow = { 0.5, -1.1 } },
    },
}

constants.EG_TRANSFORMATOR_POLE_PATTERN = "^eg%-[high%-low]+%-voltage%-pole%-"
constants.EG_TRANSFORMATOR_POLE_NAMES   = {}
for direction, _ in pairs(constants.EG_DIRECTION_TO_CARDINAL) do
    constants.EG_TRANSFORMATOR_POLE_NAMES["eg-high-voltage-pole-" .. direction] = true
    constants.EG_TRANSFORMATOR_POLE_NAMES["eg-low-voltage-pole-" .. direction] = true
end


return constants
