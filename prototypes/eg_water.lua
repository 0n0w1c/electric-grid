function create_transformator_water(tier)
    local heat_capacity = constants.EG_TRANSFORMATORS["eg-unit-" .. tier].heat_capacity

    return {
        type = "fluid",
        name = "eg-water-" .. tier,
        default_temperature = 15,
        max_temperature = 100,
        heat_capacity = heat_capacity,
        base_color = { r = 0, g = 0.34, b = 0.6 },
        flow_color = { r = 0.7, g = 0.7, b = 0.7 },
        icon = constants.EG_GRAPHICS .. "/icons/flash.png",
        icon_size = 32,
        order = "a[fluid]-a[water]",
        auto_barrel = false,
        --hidden = true,
    }
end
