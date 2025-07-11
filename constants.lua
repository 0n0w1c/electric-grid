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

constants.EG_DEBUG_TRANSFORMATOR = false
constants.EG_TICK_INTERVAL = 60

constants.EG_MOD = "__electric-grid__"
constants.EG_GRAPHICS = constants.EG_MOD .. "/graphics/"
constants.EG_ENTITIES = constants.EG_GRAPHICS .. "entities/"
constants.EG_ICONS = constants.EG_GRAPHICS .. "icons/"
constants.EG_SOUND = constants.EG_MOD .. "/sound/"
constants.EG_TIER_BLEND_MODE = "additive"
constants.EG_OVERLAY_TINT = { r = 0.5, g = 0.5, b = 0.5, a = 1 }

constants.EG_MAX_HEALTH = 500
constants.EG_FLUID_VOLUME = 100

constants.EG_QUALITIES = {
    "normal",
    "uncommon",
    "rare",
    "epic",
    "legendary"
}

constants.EG_SUPPORTED_SURFACES = {
    ["aquilo"] = true,
    ["gleba"] = true,
    ["nauvis"] = true,
    ["vulcanus"] = true
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

constants.EG_PUMP_FLAGS = {
    "not-rotatable",
    "hide-alt-info",
    "placeable-neutral",
    "not-repairable",
    "not-on-map",
    "not-blueprintable",
    "not-deconstructable",
    "not-flammable",
    "not-upgradable",
    "not-in-kill-statistics",
    "not-in-made-in"
}

constants.EG_TRANSFORMATORS = {
    ["eg-unit-1"] = { rating = "1MW", tint = { r = 1.0, g = 0.0, b = 0.0, a = 1 } },
    ["eg-unit-2"] = { rating = "5MW", tint = { r = 1.0, g = 0.6, b = 0.0, a = 1 } },
    ["eg-unit-3"] = { rating = "10MW", tint = { r = 1.0, g = 1.0, b = 1.0, a = 1 } },
    ["eg-unit-4"] = { rating = "50MW", tint = { r = 1.0, g = 1.0, b = 0.0, a = 1 } },
    ["eg-unit-5"] = { rating = "100MW", tint = { r = 0.0, g = 1.0, b = 0.0, a = 1 } },
    ["eg-unit-6"] = { rating = "500MW", tint = { r = 0.0, g = 1.0, b = 1.0, a = 1 } },
    ["eg-unit-7"] = { rating = "1GW", tint = { r = 0.0, g = 0.5, b = 1.0, a = 1 } },
    ["eg-unit-8"] = { rating = "5GW", tint = { r = 0.5, g = 0.0, b = 1.0, a = 1 } },
    ["eg-unit-9"] = { rating = "10GW", tint = { r = 1.0, g = 0.0, b = 1.0, a = 1 } }
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
constants.EG_LIGHT_INTENSITY        = 0.7
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

constants.EG_SUPPLY_AREA_DISTANCE   = 0.49
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
    ["floating-electric-pole"] = true,
    ["power-combinator-meter-network"] = true
}

constants.EG_SUPPLY_POLES           =
{
    ["small-electric-pole"] = true,
    ["small-iron-electric-pole"] = true,
    ["substation"] = true,
    ["eg-ugp-substation"] = true,
    ["wooden-support"] = true,
    ["steel-support"] = true,
    ["kr-superior-substation"] = true,
    ["or_pole"] = true,
    ["electrical-distributor"] = true
}

constants.EG_HUGE_POLES             =
{
    ["huge-electric-pole"] = true,
    ["eg-huge-electric-pole"] = true,
    ["po-huge-electric-pole"] = true
}

constants.EG_WIRE_CONNECTIONS       = {
    ["small-electric-pole"] = {
        ["small-electric-pole"] = true,
        ["medium-electric-pole"] = true,
        ["small-iron-electric-pole"] = true,
        ["medium-wooden-electric-pole"] = true,
        ["power-combinator-meter-network"] = true,
        ["or_pole"] = true,
        ["james-rail-pole"] = true,
        ["po-small-electric-fuse"] = true,
    },
    ["medium-electric-pole"] = {
        ["medium-electric-pole"] = true,
        ["big-electric-pole"] = true,
        ["small-electric-pole"] = true,
        ["small-iron-electric-pole"] = true,
        ["medium-wooden-electric-pole"] = true,
        ["james-rail-pole"] = true,
        ["wooden-support"] = true,
        ["tunnel-entrance-cable"] = true,
        ["power-combinator-meter-network"] = true,
        ["or_pole"] = true,
        ["wire-buoy"] = true,
        ["po-small-electric-fuse"] = true,
        ["po-medium-electric-fuse"] = true,
    },
    ["big-electric-pole"] = {
        ["big-electric-pole"] = true,
        ["medium-electric-pole"] = true,
        ["substation"] = true,
        ["eg-ugp-substation"] = true,
        ["eg-circuit-pole"] = true,
        ["floating-electric-pole"] = true,
        ["electrical-distributor"] = true,
        ["power-combinator-meter-network"] = true,
        ["tunnel-entrance-cable"] = true,
        ["kr-superior-substation"] = true,
        ["or_pole"] = true,
        ["po-medium-electric-fuse"] = true,
        ["po-big-electric-fuse"] = true,
    },
    ["eg-huge-electric-pole"] = {
        ["power-combinator-meter-network"] = true,
        ["eg-huge-electric-pole"] = true
    },
    ["substation"] = {
        ["power-combinator-meter-network"] = true,
        ["big-electric-pole"] = true,
        ["po-big-electric-fuse"] = true,
    },
    ["eg-ugp-substation"] = {
        ["power-combinator-meter-network"] = true,
        ["big-electric-pole"] = true,
        ["po-big-electric-fuse"] = true,
    },
    ["eg-circuit-pole"] = {
        ["eg-circuit-pole"] = true,
        ["big-electric-pole"] = true
    },
    ["small-iron-electric-pole"] = { -- aai industry and EG
        ["small-electric-pole"] = true,
        ["medium-electric-pole"] = true,
        ["small-iron-electric-pole"] = true,
        ["medium-wooden-electric-pole"] = true,
        ["power-combinator-meter-network"] = true,
        ["or_pole"] = true,
        ["james-rail-pole"] = true,
        ["po-small-electric-fuse"] = true,
    },
    ["floating-electric-pole"] = { -- cargo ships
        ["floating-electric-pole"] = true,
        ["or_pole"] = true,
        ["big-electric-pole"] = true
    },
    ["or_pole"] = { -- cargo ships
        ["medium-wooden-electric-pole"] = true,
        ["small-electric-pole"] = true,
        ["medium-electric-pole"] = true,
        ["small-iron-electric-pole"] = true,
        ["or_pole"] = true,
        ["floating-electric-pole"] = true
    },
    ["james-rail-pole"] = { -- james' electric trains plus
        ["james-rail-pole"] = true,
        ["james-track-pole"] = true,
        ["medium-electric-pole"] = true
    },
    ["james-track-pole"] = {
        ["james-rail-pole"] = true,
        ["james-track-pole"] = true
    },
    ["huge-electric-pole"] = { -- factorioplus
        ["power-combinator-meter-network"] = true,
        ["huge-electric-pole"] = true
    },
    ["medium-wooden-electric-pole"] = { -- factorioplus
        ["medium-wooden-electric-pole"] = true,
        ["small-electric-pole"] = true,
        ["medium-electric-pole"] = true,
        ["small-iron-electric-pole"] = true,
        ["or_pole"] = true,
        ["james-rail-pole"] = true
    },
    ["electrical-distributor"] = { -- factorioplus
        ["power-combinator-meter-network"] = true,
        ["big-electric-pole"] = true
    },
    ["po-huge-electric-pole"] = { -- power overload
        ["power-combinator-meter-network"] = true,
        ["po-huge-electric-pole"] = true,
        ["po-huge-electric-fuse"] = true,
    },
    ["kr-superior-substation"] = { -- krastorio 2
        ["power-combinator-meter-network"] = true,
        ["big-electric-pole"] = true
    },
    ["wooden-support"] = { -- subsurface
        ["wooden-support"] = true,
        ["steel-support"] = true,
        ["tunnel-exit-cable"] = true
    },
    ["steel-support"] = { -- subsurface
        ["wooden-support"] = true,
        ["steel-support"] = true,
        ["tunnel-exit-cable"] = true
    },
    ["tunnel-entrance-cable"] = { -- subsurface
        ["medium-electric-pole"] = true,
        ["big-electric-pole"] = true
    },
    ["tunnel-exit-cable"] = { -- subsurface
        ["wooden-support"] = true,
        ["steel-support"] = true
    },
    ["wire-buoy"] = { -- dredgeworks
        ["wire-buoy"] = true,
        ["medium-electric-pole"] = true
    },
    ["power-combinator-meter-network"] = { -- energy combinator
        ["small-electric-pole"] = true,
        ["small-iron-electric-pole"] = true,
        ["medium-electric-pole"] = true,
        ["big-electric-pole"] = true,
        ["eg-huge-electric-pole"] = true,
        ["substation"] = true,
        ["huge-electric-pole"] = true,
        ["po-huge-electric-pole"] = true,
        ["electrical-distributor"] = true,
        ["kr-superior-substation"] = true
    },
    ["po-interface"] = { -- power overload
        ["po-huge-electric-fuse"] = true
    },
    ["po-small-electric-fuse"] = { -- power overload
        ["small-electric-pole"] = true,
        ["small-iron-electric-pole"] = true,
        ["medium-electric-pole"] = true
    },
    ["po-medium-electric-fuse"] = { -- power overload
        ["medium-electric-pole"] = true,
        ["big-electric-pole"] = true
    },
    ["po-big-electric-fuse"] = { -- power overload
        ["big-electric-pole"] = true,
        ["substation"] = true
    },
    ["po-huge-electric-fuse"] = { -- power overload
        ["po-huge-electric-pole"] = true,
        ["po-interface"] = true
    },
}

return constants
