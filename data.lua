constants = require("constants")

if settings.startup["eg-hide-alt-overlay"].value then
    constants.EG_ALTOVERLAY = "hide-alt-info"
else
    constants.EG_ALTOVERLAY = nil
end

require("prototypes/eg_signals")
require("prototypes/eg_water")
require("prototypes/eg_infinity_pipe")
require("prototypes/eg_steam")
require("prototypes/eg_boiler")
require("prototypes/eg_steam_engine")
require("prototypes/eg_poles")
require("prototypes/eg_transformator")
require("prototypes/eg_technology")

data:extend({
    {
        type = "custom-input",
        name = "transformator_rating_selection",   -- This is the custom input name we’re using
        key_sequence = "CONTROL + mouse-button-1", -- CTRL + left-click
        consuming = "none"
    }
})
