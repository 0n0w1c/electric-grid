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

constants.EG_MOD = "__electric-grid__"
constants.EG_GRAPHICS = constants.EG_MOD .. "/graphics"
constants.EG_SOUND = constants.EG_MOD .. "/sound"
constants.EG_TIER_BLEND_MODE = "additive"

constants.EG_DISPLAYER = "eg-transformator-displayer"
constants.EG_MAX_HEALTH = 200

-- 0.256 is too low for 1 MW
-- 0.257 is too high for 500 MW
-- Works well to at least 1000 GW (for gui)
constants.HEAT_CAPACITY_PER_MW = 0.2565

--Maybe quality effect here?
--constants.EG_EFFICIENCY = 0.98
constants.EG_EFFICIENCY = 1

constants.EG_DIRECTION_TO_CARDINAL = {
    [0] = "north",
    [4] = "east",
    [8] = "south",
    [12] = "west"
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
    ["eg-unit-1"] = { rating = "1MW", tint = { r = 1.0, g = 0.0, b = 0.0, a = 1 } },   -- Tier 1: Pure Red
    ["eg-unit-2"] = { rating = "5MW", tint = { r = 1.0, g = 0.0, b = 0.5, a = 1 } },   -- Tier 2: Magenta (Red + Blue)
    ["eg-unit-3"] = { rating = "10MW", tint = { r = 1.0, g = 0.0, b = 1.0, a = 1 } },  -- Tier 3: Pure Magenta
    ["eg-unit-4"] = { rating = "50MW", tint = { r = 0.5, g = 0.0, b = 1.0, a = 1 } },  -- Tier 4: Purple (Blue + Magenta)
    ["eg-unit-5"] = { rating = "100MW", tint = { r = 0.0, g = 0.0, b = 1.0, a = 1 } }, -- Tier 5: Pure Blue
    ["eg-unit-6"] = { rating = "500MW", tint = { r = 0.0, g = 1.0, b = 1.0, a = 1 } }, -- Tier 6: Cyan (Green + Blue)
    ["eg-unit-7"] = { rating = "1GW", tint = { r = 0.0, g = 1.0, b = 0.0, a = 1 } },   -- Tier 7: Pure Green
    ["eg-unit-8"] = { rating = "5GW", tint = { r = 0.5, g = 1.0, b = 0.0, a = 1 } },   -- Tier 8: Yellow-Green (Green + Yellow)
    ["eg-unit-9"] = { rating = "10GW", tint = { r = 1.0, g = 1.0, b = 0.0, a = 1 } }   -- Tier 9: Yellow (Red + Green)
}

-- Calculate the heat capacities based on rating, adding the heat_capacity field to constants.EG_TRANSFORMATORS
for key, transformator in pairs(constants.EG_TRANSFORMATORS) do
    local rating_in_watts = normalize_rating(transformator.rating)
    local rating_in_MW = rating_in_watts / 1e6
    transformator.heat_capacity = (rating_in_MW * constants.HEAT_CAPACITY_PER_MW) .. "kJ"
end

constants.EG_NUM_TIERS = 0
for _ in pairs(constants.EG_TRANSFORMATORS) do
    constants.EG_NUM_TIERS = constants.EG_NUM_TIERS + 1
end

constants.EG_POLE_LIGHT = { r = 1.0, g = 1.0, b = 0.7 }
constants.EG_MAXIMUM_WIRE_DISTANCE = 6
constants.EG_SUPPLY_AREA_DISTANCE = 0.8
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

constants.EG_WIRE_CONNECTIONS = {
    ["small-electric-pole"] = {
        ["small-electric-pole"] = true,
        ["medium-electric-pole"] = true,
    },
    ["medium-electric-pole"] = {
        ["small-electric-pole"] = true,
        ["medium-electric-pole"] = true,
    },
    ["big-electric-pole"] = {
        ["big-electric-pole"] = true,
        ["substation"] = true,
        ["eg-ugp-substation"] = true,
    },
    ["eg-huge-electric-pole"] = {
        ["eg-huge-electric-pole"] = true,
    },
    ["substation"] = {
        ["big-electric-pole"] = true,
    },
    ["eg-ugp-substation"] = {
        ["big-electric-pole"] = true,
    }
}

return constants
