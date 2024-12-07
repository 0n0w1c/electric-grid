function create_transformator_boiler(tier)
    local rating = constants.EG_TRANSFORMATORS["eg-unit-" .. tier].rating

    local collision_box = {
        { -0.49, -0.49 },
        { 0.49,  0.49 }
    }

    --local selection_box = {
    --    { -0.49, -0.49 },
    --    { 0.49,  0.49 }
    --}

    local selection_box = {
        { -0.49, -0.49 },
        { 1.49,  0.49 }
    }

    return {
        type = "boiler",
        name = "eg-boiler-" .. tier,
        icon = constants.EG_GRAPHICS .. "/technologies/tier-" .. tier .. ".png",
        icon_size = 128,
        energy_consumption = rating,
        target_temperature = 165,
        max_health = constants.EG_MAX_HEALTH,
        alert_icon_scale = 0,
        hidden = true,
        minable = nil,
        selectable_in_game = false,
        flags = constants.EG_INTERNAL_ENTITY_FLAGS,
        localised_name = { "", "Transformator ", tostring(rating) },
        localised_description = { "", "Transformator rated for ", rating, " of power output." },
        energy_source = {
            type = "electric",
            effectivity = constants.EG_EFFICIENCY,
            input_flow_limit = rating,
            usage_priority = "secondary-input",
            emissions = 0
        },
        mode = "output-to-separate-pipe",
        burning_cooldown = 0,
        collision_mask = { layers = {} },
        selection_box = selection_box,
        collision_box = collision_box,

        fluid_box = {
            filter = "eg-water-" .. tier,
            hide_connection_info = not constants.EG_DEBUG_TRANSFORMATOR,
            pipe_connections = {
                {
                    connection_category = "eg-guts-category",
                    direction = defines.direction.west,
                    flow_direction = "input-output",
                    position = { 0, 0 }
                },
                {
                    connection_category = "eg-guts-category",
                    direction = defines.direction.east,
                    flow_direction = "input-output",
                    position = { 0, 0 }
                }
            },
            production_type = "input",
            volume = constants.EG_FLUID_VOLUME,
        },
        output_fluid_box = {
            filter = "eg-steam-" .. tier,
            hide_connection_info = not constants.EG_DEBUG_TRANSFORMATOR,
            pipe_connections = {
                {
                    connection_category = "eg-guts-category",
                    direction = defines.direction.north,
                    flow_direction = "output",
                    position = { 0, 0 }
                }
            },
            production_type = "output",
            volume = constants.EG_FLUID_VOLUME
        }
    }
end
