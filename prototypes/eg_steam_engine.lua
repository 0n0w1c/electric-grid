function create_transformator_steam_engine(tier)
    local rating = constants.EG_TRANSFORMATORS["eg-unit-" .. tier].rating

    return {
        type = "generator",
        name = "eg-steam-engine-" .. tier,
        --heating_energy = "100kW",
        energy_production = rating,
        maximum_temperature = 500,
        fluid_usage_per_tick = 1,
        --burns_fluid = false,
        icon = "__base__/graphics/icons/steam-engine.png",
        icon_size = 64,
        impact_category = "metal-large",
        max_health = 400,
        hidden = true,
        hidden_in_factoriopedia = true,
        minable = nil,
        selectable_in_game = false,
        scale_entity_info_icon = true,
        collision_box = {
            { -0.4, -0.4 },
            { 0.4,  0.4 }
        },
        --        selection_box = {
        --            { -0.5, -0.5 },
        --            { 0.5,  0.5 }
        --        },
        effectivity = 1,
        energy_source = {
            type = "electric",
            usage_priority = "secondary-output"
        },
        flags = {
            "placeable-neutral",
            "player-creation"
        },
        fluid_box = {
            filter = "eg-steam-" .. tier,
            hide_connection_info = true,
            minimum_temperature = 100,
            production_type = "input",
            volume = 100,
            pipe_connections = {
                {
                    direction = 8,
                    flow_direction = "input-output",
                    position = { 0, 0.4 }
                },
                {
                    direction = 0,
                    flow_direction = "input-output",
                    position = { 0, -0.4 }
                }
            }
        }
    }
end
