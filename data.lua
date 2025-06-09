constants = require("constants")

if settings.startup["eg-transformator-sound"].value == true then
    constants.EG_TRANSFORMATOR_VOLUME = 0.175
else
    constants.EG_TRANSFORMATOR_VOLUME = 0
end

constants.EG_OVERLAY = settings.startup["eg-overlay"].value == true

constants.EG_TRANSFORMATORS_ONLY = settings.startup["eg-transformators-only"].value == true
if mods["bobpower"] then constants.EG_TRANSFORMATORS_ONLY = true end

constants.EG_MEDIUM_POLE_LIGHTS = settings.startup["eg-medium-pole-lights"].value == true
constants.EG_BIG_POLE_LIGHTS = settings.startup["eg-big-pole-lights"].value == true
constants.EG_HUGE_POLE_LIGHTS = settings.startup["eg-huge-pole-lights"].value == true
constants.EG_CIRCUIT_POLE_LIGHTS = settings.startup["eg-circuit-pole-lights"].value == true

constants.EG_MAX_WIRE_TRANSFORMATOR = tonumber(settings.startup["eg-max-wire-transformator"].value)
constants.EG_MAX_WIRE_SMALL = tonumber(settings.startup["eg-max-wire-small"].value)
constants.EG_MAX_WIRE_SMALL_IRON = tonumber(settings.startup["eg-max-wire-small-iron"].value)
constants.EG_MAX_WIRE_MEDIUM = tonumber(settings.startup["eg-max-wire-medium"].value)
constants.EG_MAX_WIRE_BIG = tonumber(settings.startup["eg-max-wire-big"].value)
constants.EG_MAX_WIRE_HUGE = tonumber(settings.startup["eg-max-wire-huge"].value)
constants.EG_MAX_WIRE_SUBSTATION = tonumber(settings.startup["eg-max-wire-substation"].value)

constants.EG_MAX_SUPPLY_SMALL = settings.startup["eg-max-supply-small"].value / 2
constants.EG_MAX_SUPPLY_SMALL_IRON = settings.startup["eg-max-supply-small-iron"].value / 2
constants.EG_MAX_SUPPLY_SUBSTATION = settings.startup["eg-max-supply-substation"].value / 2

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
        type = "custom-input",
        name = "transformator-rating-selection",
        key_sequence = "mouse-button-1",
        linked_game_control = "open-gui"
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
