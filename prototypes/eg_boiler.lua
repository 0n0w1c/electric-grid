function create_transformator_boiler(tier)
    local heat_capacity = constants.EG_TRANSFORMATORS["eg-unit-" .. tier].heat_capacity
    local rating = constants.EG_TRANSFORMATORS["eg-unit-" .. tier].rating

    return {
        type = "boiler",
        name = "eg-boiler-" .. tier,
        icon = "__base__/graphics/icons/boiler.png",
        icon_size = 64,
        --energy_consumption = heat_capacity,
        energy_consumption = rating,
        target_temperature = 165,
        energy_source = {
            type = "electric",
            buffer_capacity = heat_capacity, -- Buffer capacity matching one second of consumption
            input_flow_limit = rating,       -- Maximum input flow
            usage_priority = "secondary-input",
            emissions = 0
        },
        mode = "output-to-separate-pipe",
        burning_cooldown = 0.1,
        collision_box = {
            { -0.4, -0.4 },
            { 0.4,  0.4 }
        },
        selection_box = {
            { -0.5, -0.5 },
            { 0.5,  0.5 }
        },
        fluid_box = {
            filter = "eg-water-" .. tier,
            hide_connection_info = false,
            pipe_connections = {
                {
                    direction = 12,
                    flow_direction = "input-output",
                    position = { 0.39, 0 }
                },
                {
                    direction = 4,
                    flow_direction = "input-output",
                    position = { -0.39, 0 }
                }
            },
            production_type = "input",
            volume = 100,
        },
        output_fluid_box = {
            filter = "eg-steam-" .. tier,
            hide_connection_info = false,
            pipe_connections = {
                {
                    direction = 0,
                    flow_direction = "output",
                    position = { 0, -0.4 }
                }
            },
            production_type = "output",
            volume = 100
        }
    }
end
