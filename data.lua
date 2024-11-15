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
        type = "collision-layer",
        name = "eg-ugp-substation-layer"
    }
})

data:extend({
    {
        type = "collision-layer",
        name = "eg-guts-layer"
    }
})

data:extend({
    {
        type = "custom-input",
        name = "transformator_rating_selection",
        key_sequence = "CONTROL + mouse-button-1", -- CTRL + left-click
        consuming = "none"
    }
})

require("prototypes/eg_signals")
require("prototypes/eg_water")
require("prototypes/eg_infinity_pipe")
require("prototypes/eg_steam")
require("prototypes/eg_boiler")
require("prototypes/eg_steam_engine")
require("prototypes/eg_poles")
require("prototypes/eg_transformator")
require("prototypes/eg_huge_pole")
require("prototypes/eg_ugp_substation")
require("prototypes/eg_technology")
