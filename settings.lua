local function is_hidden()
    if mods["bobpower"] then return true end
    return false
end

local order = 0
local function get_next_order()
    order = order + 1
    return string.format("a-%03d", order)
end

local huge_localised = { "", "[item=eg-huge-electric-pole] ", { "setting-name.eg-max-wire-huge" } }
if mods["PowerOverload"] then
    huge_localised = { "", "[item=po-huge-electric-pole] ", { "setting-name.eg-max-wire-huge" } }
end

data.extend({
    {
        type = "double-setting",
        name = "eg-max-wire-transformator",
        setting_type = "startup",
        default_value = 16.0,
        minimum_value = 4.0,
        maximum_value = 24.0,
        order = get_next_order(),
        localised_name = { "", "[item=eg-transformator] ", { "setting-name.eg-max-wire-transformator" } },
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
        localised_description = { "setting-description.eg-transformators-only" },
        hidden = is_hidden()
    },
    {
        type = "bool-setting",
        name = "eg-medium-pole-lights",
        setting_type = "startup",
        default_value = true,
        order = get_next_order(),
        localised_name = { "setting-name.eg-medium-pole-lights" },
        localised_description = { "setting-description.eg-medium-pole-lights" },
        hidden = is_hidden()
    },
    {
        type = "bool-setting",
        name = "eg-big-pole-lights",
        setting_type = "startup",
        default_value = true,
        order = get_next_order(),
        localised_name = { "setting-name.eg-big-pole-lights" },
        localised_description = { "setting-description.eg-big-pole-lights" },
        hidden = is_hidden()
    },
    {
        type = "bool-setting",
        name = "eg-huge-pole-lights",
        setting_type = "startup",
        default_value = true,
        order = get_next_order(),
        localised_name = { "setting-name.eg-huge-pole-lights" },
        localised_description = { "setting-description.eg-huge-pole-lights" },
        hidden = is_hidden()
    },
    {
        type = "bool-setting",
        name = "eg-circuit-pole-lights",
        setting_type = "startup",
        default_value = true,
        order = get_next_order(),
        localised_name = { "setting-name.eg-circuit-pole-lights" },
        localised_description = { "setting-description.eg-circuit-pole-lights" },
        hidden = is_hidden()
    },
    {
        type = "double-setting",
        name = "eg-max-wire-small",
        setting_type = "startup",
        default_value = 9.0,
        minimum_value = 4.0,
        maximum_value = 12.0,
        order = get_next_order(),
        localised_name = { "", "[item=small-electric-pole] ", { "setting-name.eg-max-wire-small" } },
        localised_description = { "setting-description.eg-max-wire-small" },
        hidden = is_hidden()
    },
    {
        type = "double-setting",
        name = "eg-max-supply-small",
        setting_type = "startup",
        default_value = 7.0,
        minimum_value = 4.0,
        maximum_value = 10.0,
        order = get_next_order(),
        localised_name = { "", "[item=small-electric-pole] ", { "setting-name.eg-max-supply-small" } },
        localised_description = { "setting-description.eg-max-supply-small" },
        hidden = is_hidden()
    },
    {
        type = "double-setting",
        name = "eg-max-wire-small-iron",
        setting_type = "startup",
        default_value = 9.0,
        minimum_value = 4.0,
        maximum_value = 12.0,
        order = get_next_order(),
        localised_name = { "", "[item=small-iron-electric-pole] ", { "setting-name.eg-max-wire-small-iron" } },
        localised_description = { "setting-description.eg-max-wire-small-iron" },
        hidden = (is_hidden() or mods["PowerOverload"] ~= nil)
    },
    {
        type = "double-setting",
        name = "eg-max-supply-small-iron",
        setting_type = "startup",
        default_value = 7.0,
        minimum_value = 4.0,
        maximum_value = 10.0,
        order = get_next_order(),
        localised_name = { "", "[item=small-iron-electric-pole] ", { "setting-name.eg-max-supply-small-iron" } },
        localised_description = { "setting-description.eg-max-supply-small-iron" },
        hidden = (is_hidden() or mods["PowerOverload"] ~= nil)
    },
    {
        type = "double-setting",
        name = "eg-max-wire-medium",
        setting_type = "startup",
        default_value = 9.0,
        minimum_value = 4.0,
        maximum_value = 12.0,
        order = get_next_order(),
        localised_name = { "", "[item=medium-electric-pole] ", { "setting-name.eg-max-wire-medium" } },
        localised_description = { "setting-description.eg-max-wire-medium" },
        hidden = is_hidden()
    },
    {
        type = "double-setting",
        name = "eg-max-wire-big",
        setting_type = "startup",
        default_value = 18.0,
        minimum_value = 16.0,
        maximum_value = 24.0,
        order = get_next_order(),
        localised_name = { "", "[item=big-electric-pole] ", { "setting-name.eg-max-wire-big" } },
        localised_description = { "setting-description.eg-max-wire-big" },
        hidden = is_hidden()
    },
    {
        type = "double-setting",
        name = "eg-max-wire-huge",
        setting_type = "startup",
        default_value = 36.0,
        minimum_value = 24.0,
        maximum_value = 50.0,
        order = get_next_order(),
        localised_name = huge_localised,
        localised_description = { "setting-description.eg-max-wire-huge" },
        hidden = is_hidden()
    },
    {
        type = "double-setting",
        name = "eg-max-wire-substation",
        setting_type = "startup",
        default_value = 18.0,
        minimum_value = 16.0,
        maximum_value = 24.0,
        order = get_next_order(),
        localised_name = { "", "[item=substation] ", { "setting-name.eg-max-wire-substation" } },
        localised_description = { "setting-description.eg-max-wire-substation" },
        hidden = is_hidden()
    },
    {
        type = "double-setting",
        name = "eg-max-supply-substation",
        setting_type = "startup",
        default_value = 18.0,
        minimum_value = 16.0,
        maximum_value = 24.0,
        order = get_next_order(),
        localised_name = { "", "[item=substation] ", { "setting-name.eg-max-supply-substation" } },
        localised_description = { "setting-description.eg-max-supply-substation" },
        hidden = is_hidden()
    },
    {
        type = "double-setting",
        name = "eg-max-wire-wooden-support",
        setting_type = "startup",
        default_value = 9.5,
        minimum_value = 4.0,
        maximum_value = 12.0,
        order = get_next_order(),
        localised_name = { "", "[item=wooden-support] ", { "setting-name.eg-max-wire-wooden-support" } },
        localised_description = { "setting-description.eg-max-wire-wooden-support" },
        hidden = not mods["Subsurface"]
    },
    {
        type = "double-setting",
        name = "eg-max-supply-wooden-support",
        setting_type = "startup",
        default_value = 9.0,
        minimum_value = 4.0,
        maximum_value = 10.0,
        order = get_next_order(),
        localised_name = { "", "[item=wooden-support] ", { "setting-name.eg-max-supply-wooden-support" } },
        localised_description = { "setting-description.eg-max-supply-wooden-supoprt" },
        hidden = not mods["Subsurface"]
    },
    {
        type = "double-setting",
        name = "eg-max-wire-steel-support",
        setting_type = "startup",
        default_value = 9.5,
        minimum_value = 4.0,
        maximum_value = 12.0,
        order = get_next_order(),
        localised_name = { "", "[item=steel-support] ", { "setting-name.eg-max-wire-steel-support" } },
        localised_description = { "setting-description.eg-max-wire-steel-support" },
        hidden = not mods["Subsurface"]
    },
})
