data:extend({
    {
        type = "bool-setting",
        name = "eg-medium-pole-lights",
        setting_type = "startup",
        default_value = true,
        order = "a1",
        localised_name = "Enable medium pole lights",
        localised_description = "Add a light to medium poles"
    },
    {
        type = "bool-setting",
        name = "eg-big-pole-lights",
        setting_type = "startup",
        default_value = true,
        order = "a2",
        localised_name = "Enable big pole lights",
        localised_description = "Add a light to big poles"
    },
    {
        type = "bool-setting",
        name = "eg-huge-pole-lights",
        setting_type = "startup",
        default_value = true,
        order = "a3",
        localised_name = "Enable huge pole lights",
        localised_description = "Add a light to huge poles"
    },
    {
        type = "bool-setting",
        name = "eg-circuit-pole-lights",
        setting_type = "startup",
        default_value = true,
        order = "a4",
        localised_name = "Enable circuit pole lights",
        localised_description = "Add a light to circuit poles"
    },
    {
        type = "bool-setting",
        name = "eg-transformator-sound",
        setting_type = "startup",
        default_value = true,
        order = "a5",
        localised_name = "Enable Transformator sound",
        localised_description = "Generates a 50Hz Main's hum"
    },
    {
        type = "bool-setting",
        name = "eg-hide-alt-overlay",
        setting_type = "startup",
        default_value = false,
        order = "a6",
        localised_name = "Enable Transformator connection icons",
        localised_description = "Displays icons for source and load connections"
    },
    {
        type = "int-setting",
        name = "eg-on-tick-interval",
        setting_type = "startup",
        default_value = 1,
        allowed_values = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
        order = "a7",
        localised_name = "On tick interval",
        localised_description = "Number of seconds between electric grid checks"
    },
    {
        type = "double-setting",
        name = "eg-max-wire-huge",
        setting_type = "startup",
        default_value = 36.0,
        minimum_value = 30.0,
        maximum_value = 64.0,
        order = "a8",
        localised_name = "Huge pole wire reach",
        localised_description = "Min: 30.0  Max: 64.0"
    },
    {
        type = "bool-setting",
        name = "eg-even-align-radar",
        setting_type = "startup",
        default_value = false,
        order = "a9",
        localised_name = "Even-align radar placement",
        localised_description = "Effectively resizes the radar to be 4x4"
    }
})
