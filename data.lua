constants = require("constants")
local defaults = require("settings_defaults")
local visibility = require("settings_visibility")

local function get_startup_value(setting_name)
    if visibility.is_setting_hidden(setting_name) then
        return defaults[setting_name]
    end
    return settings.startup[setting_name].value
end

if settings.startup["eg-transformator-sound"].value == true then
    constants.EG_TRANSFORMATOR_VOLUME = 0.175
else
    constants.EG_TRANSFORMATOR_VOLUME = 0
end

constants.EG_OVERLAY = settings.startup["eg-overlay"].value == true
constants.EG_INVERT_OVERLAY = settings.startup["eg-invert-overlay"].value == true
constants.EG_OLD_HUGE_POLE = settings.startup["eg-old-huge-pole"].value == true

constants.EG_TRANSFORMATORS_ONLY = settings.startup["eg-transformators-only"].value == true
if mods["bobpower"] and settings.startup["bobmods-power-poles"].value == true then
    constants.EG_TRANSFORMATORS_ONLY = true
end

constants.EG_MEDIUM_POLE_LIGHTS = settings.startup["eg-medium-pole-lights"].value == true
constants.EG_BIG_POLE_LIGHTS = settings.startup["eg-big-pole-lights"].value == true
constants.EG_HUGE_POLE_LIGHTS = settings.startup["eg-huge-pole-lights"].value == true
constants.EG_CIRCUIT_POLE_LIGHTS = settings.startup["eg-circuit-pole-lights"].value == true

constants.EG_MAX_WIRE_TRANSFORMATOR = tonumber(get_startup_value("eg-max-wire-transformator"))
constants.EG_MAX_WIRE_SMALL = tonumber(get_startup_value("eg-max-wire-small"))
constants.EG_MAX_WIRE_SMALL_IRON = tonumber(get_startup_value("eg-max-wire-small-iron"))
constants.EG_MAX_WIRE_MEDIUM = tonumber(get_startup_value("eg-max-wire-medium"))
constants.EG_MAX_WIRE_BIG = tonumber(get_startup_value("eg-max-wire-big"))
constants.EG_MAX_WIRE_HUGE = tonumber(get_startup_value("eg-max-wire-huge"))
constants.EG_MAX_WIRE_SUBSTATION = tonumber(get_startup_value("eg-max-wire-substation"))

constants.EG_MAX_SUPPLY_SMALL = get_startup_value("eg-max-supply-small") / 2
constants.EG_MAX_SUPPLY_SMALL_IRON = get_startup_value("eg-max-supply-small-iron") / 2
constants.EG_MAX_SUPPLY_SUBSTATION = get_startup_value("eg-max-supply-substation") / 2

constants.EG_MAX_WIRE_WOODEN_SUPPORT = tonumber(get_startup_value("eg-max-wire-wooden-support"))
constants.EG_MAX_SUPPLY_WOODEN_SUPPORT = get_startup_value("eg-max-supply-wooden-support") / 2
constants.EG_MAX_WIRE_STEEL_SUPPORT = tonumber(get_startup_value("eg-max-wire-steel-support"))

data:extend({
    {
        type = "custom-input",
        name = "eg-wire-build",
        key_sequence = "mouse-button-1",
        linked_game_control = "build"
    }
})

data.extend({
    {
        type = "item-subgroup",
        name = "eg-electric-distribution",
        group = "logistics",
        order = "da"
    }
})

data.extend({
    {
        type = "sound",
        name = "eg-transformator-gui-open",
        filename = "__base__/sound/electric-network-open.ogg",
        volume = 0.5
    },
    {
        type = "sound",
        name = "eg-transformator-gui-close",
        filename = "__base__/sound/electric-network-close.ogg",
        volume = 0.5
    }
})

data.extend({
    {
        type                  = "virtual-signal",
        name                  = "eg-alert",
        icon_size             = 32,
        hidden                = true,
        localised_name        = { "virtual-signal.eg-alert" },
        localised_description = { "virtual-signal-description.eg-alert" },
        icons                 = { {
            icon = constants.EG_ICONS .. "eg-flash.png",
            tint = { r = 1, g = 1, b = 0 },
            icon_size = 32,
        } }
    }
})

data.extend({
    {
        type = "sprite",
        name = "eg-transformator-icon",
        filename = constants.EG_ICONS .. "eg-transformator.png",
        size = 128
    }
})

for _, transformator in pairs(constants.EG_TRANSFORMATORS) do
    data.extend({ {
        type = "sprite",
        name = transformator.rating,
        layers = {
            {
                filename = constants.EG_ICONS .. "eg-unit-sprite-icon.png",
                flags = { "no-crop" },
                width = 270,
                height = 230,
                scale = 0.5
            },
            {
                filename = constants.EG_ICONS .. "eg-unit-mask-icon.png",
                flags = { "no-crop", "mask" },
                width = 270,
                height = 230,
                scale = 0.5,
                shift = { 23.1, 0.05 },
                blend_mode = constants.EG_TIER_BLEND_MODE,
                tint = transformator.tint
            }
        }
    } })
end

require("prototypes/eg_fluids")
require("prototypes/eg_infinity_pipe")
require("prototypes/eg_pump")
require("prototypes/eg_boiler")
require("prototypes/eg_steam_engine")
require("prototypes/eg_voltage_poles")
require("prototypes/eg_transformator")
require("prototypes/eg_small_iron_pole")
require("prototypes/eg_huge_pole")
require("prototypes/eg_ugp_substation")
require("prototypes/eg_circuit_pole")
require("prototypes/eg_technology")
