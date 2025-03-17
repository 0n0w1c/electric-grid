local order = 0

local function get_next_order()
    order = order + 1
    return string.format("a-%03d", order)
end

data.extend({
    {
        type = "int-setting",
        name = "eg-on-tick-interval",
        setting_type = "startup",
        default_value = 1,
        allowed_values = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
        order = get_next_order(),
        localised_name = { "setting-name.eg-on-tick-interval" },
        localised_description = { "setting-description.eg-on-tick-interval" }
    },
    {
        type = "double-setting",
        name = "eg-max-wire-transformator",
        setting_type = "startup",
        default_value = 16.0,
        minimum_value = 4.0,
        maximum_value = 24.0,
        order = get_next_order(),
        localised_name = { "setting-name.eg-max-wire-transformator" },
        localised_description = { "setting-description.eg-max-wire-transformator" }
    },
    {
        type = "bool-setting",
        name = "eg-transformator-sound",
        setting_type = "startup",
        default_value = true,
        order = get_next_order(),
        localised_name = { "setting-name.eg-transformator-sound" },
        localised_description = { "setting-description.eg-transformator-sound" }
    },
    {
        type = "bool-setting",
        name = "eg-overlay",
        setting_type = "startup",
        default_value = true,
        order = get_next_order(),
        localised_name = { "setting-name.eg-overlay" },
        localised_description = { "setting-description.eg-overlay" }
    },
    {
        type = "bool-setting",
        name = "eg-transformators-only",
        setting_type = "startup",
        default_value = false,
        order = get_next_order(),
        localised_name = { "setting-name.eg-transformators-only" },
        localised_description = { "setting-description.eg-transformators-only" }
    },
    {
        type = "bool-setting",
        name = "eg-medium-pole-lights",
        setting_type = "startup",
        default_value = true,
        order = get_next_order(),
        localised_name = { "setting-name.eg-medium-pole-lights" },
        localised_description = { "setting-description.eg-medium-pole-lights" }
    },
    {
        type = "bool-setting",
        name = "eg-big-pole-lights",
        setting_type = "startup",
        default_value = true,
        order = get_next_order(),
        localised_name = { "setting-name.eg-big-pole-lights" },
        localised_description = { "setting-description.eg-big-pole-lights" }
    },
    {
        type = "bool-setting",
        name = "eg-huge-pole-lights",
        setting_type = "startup",
        default_value = true,
        order = get_next_order(),
        localised_name = { "setting-name.eg-huge-pole-lights" },
        localised_description = { "setting-description.eg-huge-pole-lights" }
    },
    {
        type = "bool-setting",
        name = "eg-circuit-pole-lights",
        setting_type = "startup",
        default_value = true,
        order = get_next_order(),
        localised_name = { "setting-name.eg-circuit-pole-lights" },
        localised_description = { "setting-description.eg-circuit-pole-lights" }
    },
    {
        type = "double-setting",
        name = "eg-max-wire-small",
        setting_type = "startup",
        default_value = 9.0,
        minimum_value = 4.0,
        maximum_value = 12.0,
        order = get_next_order(),
        localised_name = { "setting-name.eg-max-wire-small" },
        localised_description = { "setting-description.eg-max-wire-small" }
    },
    {
        type = "double-setting",
        name = "eg-max-wire-small-iron",
        setting_type = "startup",
        default_value = 9.0,
        minimum_value = 4.0,
        maximum_value = 12.0,
        order = get_next_order(),
        localised_name = { "setting-name.eg-max-wire-small-iron" },
        localised_description = { "setting-description.eg-max-wire-small-iron" }
    },
    {
        type = "double-setting",
        name = "eg-max-wire-medium",
        setting_type = "startup",
        default_value = 9.0,
        minimum_value = 4.0,
        maximum_value = 12.0,
        order = get_next_order(),
        localised_name = { "setting-name.eg-max-wire-medium" },
        localised_description = { "setting-description.eg-max-wire-medium" }
    },
    {
        type = "double-setting",
        name = "eg-max-wire-big",
        setting_type = "startup",
        default_value = 18.0,
        minimum_value = 16.0,
        maximum_value = 24.0,
        order = get_next_order(),
        localised_name = { "setting-name.eg-max-wire-big" },
        localised_description = { "setting-description.eg-max-wire-big" }
    },
    {
        type = "double-setting",
        name = "eg-max-wire-huge",
        setting_type = "startup",
        default_value = 36.0,
        minimum_value = 24.0,
        maximum_value = 50.0,
        order = get_next_order(),
        localised_name = { "setting-name.eg-max-wire-huge" },
        localised_description = { "setting-description.eg-max-wire-huge" }
    },
    {
        type = "double-setting",
        name = "eg-max-wire-substation",
        setting_type = "startup",
        default_value = 18.0,
        minimum_value = 16.0,
        maximum_value = 24.0,
        order = get_next_order(),
        localised_name = { "setting-name.eg-max-wire-substation" },
        localised_description = { "setting-description.eg-max-wire-substation" }
    },
    {
        type = "double-setting",
        name = "eg-max-supply-small",
        setting_type = "startup",
        default_value = 7.0,
        minimum_value = 4.0,
        maximum_value = 10.0,
        order = get_next_order(),
        localised_name = { "setting-name.eg-max-supply-small" },
        localised_description = { "setting-description.eg-max-supply-small" }
    },
    {
        type = "double-setting",
        name = "eg-max-supply-small-iron",
        setting_type = "startup",
        default_value = 7.0,
        minimum_value = 4.0,
        maximum_value = 10.0,
        order = get_next_order(),
        localised_name = { "setting-name.eg-max-supply-small-iron" },
        localised_description = { "setting-description.eg-max-supply-small-iron" }
    },
    {
        type = "double-setting",
        name = "eg-max-supply-substation",
        setting_type = "startup",
        default_value = 18.0,
        minimum_value = 16.0,
        maximum_value = 24.0,
        order = get_next_order(),
        localised_name = { "setting-name.eg-max-supply-substation" },
        localised_description = { "setting-description.eg-max-supply-substation" }
    }
})
