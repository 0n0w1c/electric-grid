function create_transformator_fluid_disable()
    return {
        type = "fluid",
        name = "eg-fluid-disable",
        default_temperature = 15,
        max_temperature = 100,
        heat_capacity = "0kJ",
        icon = "__core__/graphics/filter-blacklist.png",
        icon_size = 101,
        base_color = { r = 0.0, g = 0.0, b = 0.0 },
        flow_color = { r = 0.0, g = 0.0, b = 0.0 },
        auto_barrel = false,
        hidden = false,
        order = "a[eg]-a[fluid]-a[disable]",
        subgroup = "fluid",
        localised_name = { "", "Disable" },
        localised_description = { "", "Select to disable a Transformator" }
    }
end

function create_transformator_fluid_enable()
    return {
        type = "fluid",
        name = "eg-fluid-enable",
        default_temperature = 15,
        max_temperature = 100,
        heat_capacity = "0kJ",
        icon = constants.EG_GRAPHICS .. "/icons/flash.png",
        icon_size = 32,
        base_color = { r = 0.0, g = 0.0, b = 0.0 },
        flow_color = { r = 0.0, g = 0.0, b = 0.0 },
        auto_barrel = false,
        hidden = false,
        order = "a[eg]-a[fluid]-a[enable]",
        subgroup = "fluid",
        localised_name = { "", "Enable" },
        localised_description = { "", "Select to enable a Transformator" }
    }
end

function create_transformator_water(tier)
    local heat_capacity = constants.EG_TRANSFORMATORS["eg-unit-" .. tier].heat_capacity

    return {
        type = "fluid",
        name = "eg-water-" .. tier,
        default_temperature = 15,
        max_temperature = 100,
        heat_capacity = heat_capacity,
        icon = constants.EG_GRAPHICS .. "/icons/flash.png",
        icon_size = 32,
        base_color = { r = 0.5, g = 0.5, b = 0.5 },
        flow_color = { r = 1.0, g = 1.0, b = 1.0 },
        order = "a[fluid]-a[water]",
        auto_barrel = false,
        hidden = true,
        localised_name = { "", "Water - Tier ", tostring(tier) },
        localised_description = { "", "Component of a Transformator, heat capcity of ", heat_capacity }
    }
end

function create_transformator_steam(tier)
    local heat_capacity = constants.EG_TRANSFORMATORS["eg-unit-" .. tier].heat_capacity

    return {
        type = "fluid",
        name = "eg-steam-" .. tier,
        default_temperature = 100,
        max_temperature = 165,
        heat_capacity = heat_capacity,
        icon = constants.EG_GRAPHICS .. "/icons/flash.png",
        icon_size = 32,
        base_color = { r = 0.5, g = 0.5, b = 0.5 },
        flow_color = { r = 1.0, g = 1.0, b = 1.0 },
        order = "a[fluid]-b[steam]",
        auto_barrel = false,
        hidden = true,
        localised_name = { "", "Steam - Tier ", tostring(tier) },
        localised_description = { "", "Component of a Transformator, heat capcity ", heat_capacity }
    }
end
