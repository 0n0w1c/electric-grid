function create_transformator_boiler(tier)
    local rating = constants.EG_TRANSFORMATORS["eg-unit-" .. tier].rating

    return {
        type = "boiler",
        name = "eg-boiler-" .. tier,
        icon = "__base__/graphics/icons/boiler.png",
        icon_size = 64,
        energy_consumption = rating,
        target_temperature = 165,
        max_health = constants.EG_MAX_HEALTH,
        hidden = true,
        minable = nil,
        selectable_in_game = false,
        flags = constants.EG_INTERNAL_ENTITY_FLAGS,
        localised_name = { "", "Boiler - Tier ", tostring(tier) },
        localised_description = { "", "Component of a Transformator rated for ", rating, " of power output." },
        --It is worth making four boiler variants to adjust the position of the alert icons?
        --alert_icon_shift = { x = 0.5, y = 0.0 },
        energy_source = {
            type = "electric",
            buffer_capacity = "0kJ",
            input_flow_limit = rating, -- Maximum input flow
            usage_priority = "secondary-input",
            emissions = 0
        },
        mode = "output-to-separate-pipe",
        burning_cooldown = 0,
        collision_box = {
            { -0.5, -0.5 },
            { 0.5,  0.5 }
        },
        --selection_box = {
        --    { -0.4, -0.4 },
        --    { 0.4,  0.4 }
        --},
        selection_box = {
            { -0.5, -1.5 },
            { 1.5,  0.5 }
        },
        fluid_box = {
            filter = "eg-water-" .. tier,
            hide_connection_info = true,
            pipe_connections = {
                {
                    direction = defines.direction.west,
                    flow_direction = "input-output",
                    position = { 0, 0 }
                },
                {
                    direction = defines.direction.east,
                    flow_direction = "input-output",
                    position = { 0, 0 }
                }
            },
            production_type = "input",
            volume = 100,
        },
        output_fluid_box = {
            filter = "eg-steam-" .. tier,
            hide_connection_info = true,
            pipe_connections = {
                {
                    direction = defines.direction.north,
                    flow_direction = "output",
                    position = { 0, 0 }
                }
            },
            production_type = "output",
            volume = 200
        }
    }
end
