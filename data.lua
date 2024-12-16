constants = require("constants")

if settings.startup["eg-hide-alt-overlay"].value then
    constants.EG_ALTOVERLAY = "hide-alt-info"
else
    constants.EG_ALTOVERLAY = nil
end

if settings.startup["eg-transformator-sound"].value then
    constants.EG_TRANSFORMATOR_VOLUME = 0.175
else
    constants.EG_TRANSFORMATOR_VOLUME = 0
end

constants.EG_TRANSFORMATORS_ONLY = settings.startup["eg-transformators-only"].value
constants.EG_MEDIUM_POLE_LIGHTS = settings.startup["eg-medium-pole-lights"].value
constants.EG_BIG_POLE_LIGHTS = settings.startup["eg-big-pole-lights"].value
constants.EG_HUGE_POLE_LIGHTS = settings.startup["eg-huge-pole-lights"].value
constants.EG_CIRCUIT_POLE_LIGHTS = settings.startup["eg-circuit-pole-lights"].value
constants.EG_EVEN_ALIGN_RADAR = settings.startup["eg-even-align-radar"].value

data:extend({
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

data:extend({
    {
        type = "custom-input",
        name = "transformator-rating-selection",
        key_sequence = "mouse-button-1",
        consuming = "none"
    },
    {
        type = "custom-input",
        name = "close-transformator-rating-selection-e",
        key_sequence = "E",
        consuming = "none"
    },
    {
        type = "custom-input",
        name = "close-transformator-rating-selection-esc",
        key_sequence = "ESCAPE",
        consuming = "none"
    }
})

data:extend({
    {
        type = "sprite",
        name = "eg-transformator-icon",
        filename = constants.EG_ICONS .. "eg-transformator.png",
        size = 128,
    }
})

for _, transformator in pairs(constants.EG_TRANSFORMATORS) do
    data:extend({ {
        type = "sprite",
        name = transformator.rating,
        layers = {
            {
                filename = constants.EG_ICONS .. "eg-unit-sprite-icon.png",
                flags = { "no-crop" },
                width = 270,
                height = 230,
                scale = 0.5,
            },
            {
                filename = constants.EG_ICONS .. "eg-unit-mask-icon.png",
                flags = { "no-crop", "mask" },
                width = 270,
                height = 230,
                scale = 0.5,
                blend_mode = constants.EG_TIER_BLEND_MODE,
                tint = transformator.tint,
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
require("prototypes/eg_huge_pole")
require("prototypes/eg_ugp_substation")
require("prototypes/eg_circuit_pole")
require("prototypes/eg_technology")
