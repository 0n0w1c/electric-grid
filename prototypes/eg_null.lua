function create_transformator_null_disable()
    return {
        type = "fluid",
        name = "eg-null-disable",
        default_temperature = 15,
        max_temperature = 100,
        heat_capacity = "0kJ",
        icon = "__core__/graphics/filter-blacklist.png",
        icon_size = 101,
        base_color = { r = 0.0, g = 0.0, b = 0.0 },
        flow_color = { r = 0.0, g = 0.0, b = 0.0 },
        auto_barrel = false,
        hidden = false,
        order = "a[eg]-a[null]-a[disable]",
        subgroup = "fluid",
        localised_name = { "", "Disable" },
        localised_description = { "", "Select to disable a Transformator" }
    }
end

function create_transformator_null_enable()
    return {
        type = "fluid",
        name = "eg-null-enable",
        default_temperature = 15,
        max_temperature = 100,
        heat_capacity = "0kJ",
        icon = constants.EG_GRAPHICS .. "/icons/flash.png",
        icon_size = 32,
        base_color = { r = 0.0, g = 0.0, b = 0.0 },
        flow_color = { r = 0.0, g = 0.0, b = 0.0 },
        auto_barrel = false,
        hidden = false,
        order = "a[eg]-a[null]-a[enable]",
        subgroup = "fluid",
        localised_name = { "", "Enable" },
        localised_description = { "", "Select to enable a Transformator" }
    }
end
