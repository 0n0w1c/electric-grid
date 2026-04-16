local visibility = require("settings_visibility")

local function is_setting_hidden(setting_name)
    return visibility.is_setting_hidden(setting_name)
end

local order = 0
local function get_next_order()
    order = order + 1
    return string.format("a-%03d", order)
end

local huge_localised = { "", "[item=eg-huge-electric-pole] ", { "mod-setting-name.eg-max-wire-huge" } }
if mods["PowerOverload"] then
    huge_localised = { "", "[item=po-huge-electric-pole] ", { "mod-setting-name.eg-max-wire-huge" } }
end

data.extend({
    {
        type = "bool-setting",
        name = "eg-transformators-only",
        setting_type = "startup",
        default_value = false,
        order = get_next_order(),
        localised_name = { "mod-setting-name.eg-transformators-only" },
        localised_description = { "mod-setting-description.eg-transformators-only" },
        hidden = is_setting_hidden("eg-transformators-only")
    },
    {
        type = "bool-setting",
        name = "eg-enable-transformator-overload",
        setting_type = "startup",
        default_value = false,
        order = get_next_order(),
        localised_name = { "mod-setting-name.eg-enable-transformator-overload" },
        localised_description = { "mod-setting-description.eg-enable-transformator-overload" },
        hidden = is_setting_hidden("eg-enable-transformator-overload")
    },
    {
        type = "bool-setting",
        name = "eg-old-huge-pole",
        setting_type = "startup",
        default_value = false,
        order = get_next_order(),
        localised_name = { "mod-setting-name.eg-old-huge-pole" },
        localised_description = { "mod-setting-description.eg-old-huge-pole" }
    },
    {
        type = "bool-setting",
        name = "eg-transformator-sound",
        setting_type = "startup",
        default_value = true,
        order = get_next_order(),
        localised_name = { "mod-setting-name.eg-transformator-sound" },
        localised_description = { "mod-setting-description.eg-transformator-sound" }
    },
    {
        type = "bool-setting",
        name = "eg-overlay",
        setting_type = "startup",
        default_value = true,
        order = get_next_order(),
        localised_name = { "mod-setting-name.eg-overlay" },
        localised_description = { "mod-setting-description.eg-overlay" }
    },
    {
        type = "bool-setting",
        name = "eg-invert-overlay",
        setting_type = "startup",
        default_value = true,
        order = get_next_order(),
        localised_name = { "mod-setting-name.eg-invert-overlay" },
        localised_description = { "mod-setting-description.eg-invert-overlay" }
    },
    {
        type = "bool-setting",
        name = "eg-medium-pole-lights",
        setting_type = "startup",
        default_value = true,
        order = get_next_order(),
        localised_name = { "mod-setting-name.eg-medium-pole-lights" },
        localised_description = { "mod-setting-description.eg-medium-pole-lights" },
        hidden = is_setting_hidden("eg-medium-pole-lights")
    },
    {
        type = "bool-setting",
        name = "eg-big-pole-lights",
        setting_type = "startup",
        default_value = true,
        order = get_next_order(),
        localised_name = { "mod-setting-name.eg-big-pole-lights" },
        localised_description = { "mod-setting-description.eg-big-pole-lights" },
        hidden = is_setting_hidden("eg-big-pole-lights")
    },
    {
        type = "bool-setting",
        name = "eg-huge-pole-lights",
        setting_type = "startup",
        default_value = true,
        order = get_next_order(),
        localised_name = { "mod-setting-name.eg-huge-pole-lights" },
        localised_description = { "mod-setting-description.eg-huge-pole-lights" },
        hidden = is_setting_hidden("eg-huge-pole-lights")
    },
    {
        type = "bool-setting",
        name = "eg-circuit-pole-lights",
        setting_type = "startup",
        default_value = true,
        order = get_next_order(),
        localised_name = { "mod-setting-name.eg-circuit-pole-lights" },
        localised_description = { "mod-setting-description.eg-circuit-pole-lights" },
        hidden = is_setting_hidden("eg-circuit-pole-lights")
    },
    {
        type = "double-setting",
        name = "eg-max-wire-transformator",
        setting_type = "startup",
        default_value = 16.0,
        minimum_value = 4.0,
        maximum_value = 24.0,
        order = get_next_order(),
        localised_name = { "", "[item=eg-transformator] ", { "mod-setting-name.eg-max-wire-transformator" } },
        localised_description = { "mod-setting-description.eg-max-wire-transformator" }
    },
    {
        type = "double-setting",
        name = "eg-max-wire-small",
        setting_type = "startup",
        default_value = 9.0,
        minimum_value = 4.0,
        maximum_value = 12.0,
        order = get_next_order(),
        localised_name = { "", "[item=small-electric-pole] ", { "mod-setting-name.eg-max-wire-small" } },
        localised_description = { "mod-setting-description.eg-max-wire-small" },
        hidden = is_setting_hidden("eg-max-wire-small")
    },
    {
        type = "double-setting",
        name = "eg-max-supply-small",
        setting_type = "startup",
        default_value = 7.0,
        minimum_value = 4.0,
        maximum_value = 10.0,
        order = get_next_order(),
        localised_name = { "", "[item=small-electric-pole] ", { "mod-setting-name.eg-max-supply-small" } },
        localised_description = { "mod-setting-description.eg-max-supply-small" },
        hidden = is_setting_hidden("eg-max-supply-small")
    },
    {
        type = "double-setting",
        name = "eg-max-wire-small-iron",
        setting_type = "startup",
        default_value = 9.0,
        minimum_value = 4.0,
        maximum_value = 12.0,
        order = get_next_order(),
        localised_name = { "", "[item=small-iron-electric-pole] ", { "mod-setting-name.eg-max-wire-small-iron" } },
        localised_description = { "mod-setting-description.eg-max-wire-small-iron" },
        hidden = is_setting_hidden("eg-max-wire-small-iron")
    },
    {
        type = "double-setting",
        name = "eg-max-supply-small-iron",
        setting_type = "startup",
        default_value = 7.0,
        minimum_value = 4.0,
        maximum_value = 10.0,
        order = get_next_order(),
        localised_name = { "", "[item=small-iron-electric-pole] ", { "mod-setting-name.eg-max-supply-small-iron" } },
        localised_description = { "mod-setting-description.eg-max-supply-small-iron" },
        hidden = is_setting_hidden("eg-max-supply-small-iron")
    },
    {
        type = "double-setting",
        name = "eg-max-wire-medium",
        setting_type = "startup",
        default_value = 9.0,
        minimum_value = 4.0,
        maximum_value = 12.0,
        order = get_next_order(),
        localised_name = { "", "[item=medium-electric-pole] ", { "mod-setting-name.eg-max-wire-medium" } },
        localised_description = { "mod-setting-description.eg-max-wire-medium" },
        hidden = is_setting_hidden("eg-max-wire-medium")
    },
    {
        type = "double-setting",
        name = "eg-max-wire-big",
        setting_type = "startup",
        default_value = 18.0,
        minimum_value = 16.0,
        maximum_value = 24.0,
        order = get_next_order(),
        localised_name = { "", "[item=big-electric-pole] ", { "mod-setting-name.eg-max-wire-big" } },
        localised_description = { "mod-setting-description.eg-max-wire-big" },
        hidden = is_setting_hidden("eg-max-wire-big")
    },
    {
        type = "double-setting",
        name = "eg-max-wire-huge",
        setting_type = "startup",
        default_value = 36.0,
        minimum_value = 24.0,
        maximum_value = 64.0,
        order = get_next_order(),
        localised_name = huge_localised,
        localised_description = { "mod-setting-description.eg-max-wire-huge" },
        hidden = is_setting_hidden("eg-max-wire-huge")
    },
    {
        type = "double-setting",
        name = "eg-max-wire-substation",
        setting_type = "startup",
        default_value = 18.0,
        minimum_value = 16.0,
        maximum_value = 24.0,
        order = get_next_order(),
        localised_name = { "", "[item=substation] ", { "mod-setting-name.eg-max-wire-substation" } },
        localised_description = { "mod-setting-description.eg-max-wire-substation" },
        hidden = is_setting_hidden("eg-max-wire-substation")
    },
    {
        type = "double-setting",
        name = "eg-max-supply-substation",
        setting_type = "startup",
        default_value = 18.0,
        minimum_value = 16.0,
        maximum_value = 24.0,
        order = get_next_order(),
        localised_name = { "", "[item=substation] ", { "mod-setting-name.eg-max-supply-substation" } },
        localised_description = { "mod-setting-description.eg-max-supply-substation" },
        hidden = is_setting_hidden("eg-max-supply-substation")
    },
    {
        type = "double-setting",
        name = "eg-max-wire-wooden-support",
        setting_type = "startup",
        default_value = 9.5,
        minimum_value = 4.0,
        maximum_value = 12.0,
        order = get_next_order(),
        localised_name = { "", "[item=wooden-support] ", { "mod-setting-name.eg-max-wire-wooden-support" } },
        localised_description = { "mod-setting-description.eg-max-wire-wooden-support" },
        hidden = is_setting_hidden("eg-max-wire-wooden-support")
    },
    {
        type = "double-setting",
        name = "eg-max-supply-wooden-support",
        setting_type = "startup",
        default_value = 9.0,
        minimum_value = 4.0,
        maximum_value = 10.0,
        order = get_next_order(),
        localised_name = { "", "[item=wooden-support] ", { "mod-setting-name.eg-max-supply-wooden-support" } },
        localised_description = { "mod-setting-description.eg-max-supply-wooden-support" },
        hidden = is_setting_hidden("eg-max-supply-wooden-support")
    },
    {
        type = "double-setting",
        name = "eg-max-wire-steel-support",
        setting_type = "startup",
        default_value = 9.5,
        minimum_value = 4.0,
        maximum_value = 12.0,
        order = get_next_order(),
        localised_name = { "", "[item=steel-support] ", { "mod-setting-name.eg-max-wire-steel-support" } },
        localised_description = { "mod-setting-description.eg-max-wire-steel-support" },
        hidden = is_setting_hidden("eg-max-wire-steel-support")
    },
})
