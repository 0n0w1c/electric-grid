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
        localised_description = { "", "Component of a Transformator, heat capcity of ", heat_capacity }
    }
end
