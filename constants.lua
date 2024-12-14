--- Parses the rating string to extract the numeric value and converts it to watts (W).
-- The input string should be formatted as a number followed by a unit (e.g., "5.5MW").
-- This function converts the numeric value based on the unit to return the value in watts (W).
-- Supported units are W, kW, MW, and GW. If an unsupported unit is provided, the function returns 0.
-- @param rating string The energy string to parse, which should contain a number followed by an energy unit (e.g., "10MW", "5.5GW").
-- @return number The numeric value converted to watts (W), or 0 if the unit is unsupported.
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

constants.EG_FIRST_TICK = 1
constants.EG_DEBUG_TRANSFORMATOR = false

constants.EG_MOD = "__electric-grid__"
constants.EG_GRAPHICS = constants.EG_MOD .. "/graphics/"
constants.EG_ENTITIES = constants.EG_GRAPHICS .. "entities/"
constants.EG_ICONS = constants.EG_GRAPHICS .. "icons/"
constants.EG_SOUND = constants.EG_MOD .. "/sound/"
constants.EG_TIER_BLEND_MODE = "additive"

constants.EG_MAX_HEALTH = 500
constants.EG_FLUID_VOLUME = 100

constants.EG_QUALITIES = {
    "normal",
    "uncommon",
    "rare",
    "epic",
    "legendary"
}

constants.EG_EFFICIENCY = 1
constants.HEAT_CAPACITY_PER_MW = 0.2565

constants.EG_DIRECTION_TO_CARDINAL = {
    [defines.direction.north] = "north",
    [defines.direction.east] = "east",
    [defines.direction.south] = "south",
    [defines.direction.west] = "west"
}

constants.EG_ENTITY_OFFSETS = {
    unit = { x = 0, y = 0 },                -- Centered on the axis
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

constants.EG_TRANSFORMATORS = {
    ["eg-unit-1"] = { rating = "1MW", tint = { r = 1.0, g = 0.0, b = 0.0, a = 1 }, icon = constants.EG_ICONS .. "eg-unit-1.png" },
    ["eg-unit-2"] = { rating = "5MW", tint = { r = 1.0, g = 0.0, b = 0.5, a = 1 }, icon = constants.EG_ICONS .. "eg-unit-2.png" },
    ["eg-unit-3"] = { rating = "10MW", tint = { r = 1.0, g = 0.0, b = 1.0, a = 1 }, icon = constants.EG_ICONS .. "eg-unit-3.png" },
    ["eg-unit-4"] = { rating = "50MW", tint = { r = 0.5, g = 0.0, b = 1.0, a = 1 }, icon = constants.EG_ICONS .. "eg-unit-4.png" },
    ["eg-unit-5"] = { rating = "100MW", tint = { r = 0.0, g = 0.0, b = 1.0, a = 1 }, icon = constants.EG_ICONS .. "eg-unit-5.png" },
    ["eg-unit-6"] = { rating = "500MW", tint = { r = 0.0, g = 1.0, b = 1.0, a = 1 }, icon = constants.EG_ICONS .. "eg-unit-6.png" },
    ["eg-unit-7"] = { rating = "1GW", tint = { r = 0.0, g = 1.0, b = 0.0, a = 1 }, icon = constants.EG_ICONS .. "eg-unit-7.png" },
    ["eg-unit-8"] = { rating = "5GW", tint = { r = 0.5, g = 1.0, b = 0.0, a = 1 }, icon = constants.EG_ICONS .. "eg-unit-8.png" },
    ["eg-unit-9"] = { rating = "10GW", tint = { r = 1.0, g = 1.0, b = 0.0, a = 1 }, icon = constants.EG_ICONS .. "eg-unit-9.png" }
}

for _, transformator in pairs(constants.EG_TRANSFORMATORS) do
    local rating_in_watts = normalize_rating(transformator.rating)
    local rating_in_MW = rating_in_watts / 1e6
    transformator.heat_capacity = (rating_in_MW * constants.HEAT_CAPACITY_PER_MW) .. "kJ"
end

constants.EG_NUM_TIERS = 0
for _ in pairs(constants.EG_TRANSFORMATORS) do
    constants.EG_NUM_TIERS = constants.EG_NUM_TIERS + 1
end

constants.EG_LIGHT_COLOR            = { r = 1.0, g = 1.0, b = 0.7 }
constants.EG_LIGHT_INTENSITY        = 0.8
constants.EG_LIGHT_SIZE             = 12

constants.EG_HUGE_POLE_LIGHT        =
{
    color = constants.EG_LIGHT_COLOR,
    intensity = constants.EG_LIGHT_INTENSITY,
    size = constants.EG_LIGHT_SIZE
}

constants.EG_BIG_POLE_LIGHT         =
{
    color = constants.EG_LIGHT_COLOR,
    intensity = constants.EG_LIGHT_INTENSITY / 1.1,
    size = constants.EG_LIGHT_SIZE / 1.2
}

constants.EG_MEDIUM_POLE_LIGHT      =
{
    color = constants.EG_LIGHT_COLOR,
    intensity = constants.EG_LIGHT_INTENSITY / 1.25,
    size = constants.EG_LIGHT_SIZE / 1.5
}

constants.EG_MINI_POLE_LIGHT        =
{
    color = constants.EG_LIGHT_COLOR,
    intensity = constants.EG_LIGHT_INTENSITY / 2,
    size = constants.EG_LIGHT_SIZE / 3
}

constants.EG_MAXIMUM_WIRE_DISTANCE  = 6
constants.EG_SUPPLY_AREA_DISTANCE   = 0.8
constants.EG_WIRE_CONNECTION_OFFSET = 0.1
constants.EG_WIRE_CONNECTION_POINTS = {
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

constants.EG_TRANSFORMATOR_POLES    = "^eg%-[high%-low]+%-voltage%-pole%-"

constants.EG_TRANSMISSION_POLES     =
{
    ["big-electric-pole"] = true,
    ["medium-electric-pole"] = true,
    ["eg-huge-electric-pole"] = true
}

constants.EG_WIRE_CONNECTIONS       = {
    ["small-electric-pole"] = {
        ["small-electric-pole"] = true,
        ["medium-electric-pole"] = true,
        ["small-iron-electric-pole"] = true
    },
    ["medium-electric-pole"] = {
        ["small-electric-pole"] = true,
        ["medium-electric-pole"] = true,
        ["small-iron-electric-pole"] = true
    },
    ["big-electric-pole"] = {
        ["big-electric-pole"] = true,
        ["substation"] = true,
        ["eg-ugp-substation"] = true,
        ["eg-circuit-pole"] = true
    },
    ["eg-huge-electric-pole"] = {
        ["eg-huge-electric-pole"] = true,
        ["floating-electric-pole"] = true
    },
    ["substation"] = {
        ["big-electric-pole"] = true
    },
    ["eg-ugp-substation"] = {
        ["big-electric-pole"] = true
    },
    ["eg-circuit-pole"] = {
        ["eg-circuit-pole"] = true,
        ["big-electric-pole"] = true
    },
    ["small-iron-electric-pole"] = {
        ["small-electric-pole"] = true,
        ["medium-electric-pole"] = true,
        ["small-iron-electric-pole"] = true
    },
    ["floating-electric-pole"] = {
        ["floating-electric-pole"] = true,
        ["eg-huge-electric-pole"] = true
    },
}

return constants
