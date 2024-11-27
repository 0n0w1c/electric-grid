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

data:extend({
    {
        type = "custom-input",
        name = "transformator_rating_selection",
        key_sequence = "mouse-button-1",
        consuming = "none"
    }
})

require("prototypes/eg_signals")
require("prototypes/eg_fluids")
require("prototypes/eg_infinity_pipe")
require("prototypes/eg_pump")
require("prototypes/eg_boiler")
require("prototypes/eg_steam_engine")
require("prototypes/eg_voltage_poles")
require("prototypes/eg_transformator")
require("prototypes/eg_huge_pole")
require("prototypes/eg_ugp_substation")
require("prototypes/eg_technology")
