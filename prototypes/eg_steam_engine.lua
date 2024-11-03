local eg_steam_engine = {
    type = "generator",
    name = "eg-steam-engine",
    heating_energy = "100kW",
    maximum_temperature = 165,
    fluid_usage_per_tick = 1,
    icon = "__base__/graphics/icons/steam-engine.png",
    impact_category = "metal-large",
    max_health = 400,
    scale_entity_info_icon = true,
    collision_box = {
        { -0.4, -0.4 },
        { 0.4,  0.4 }
    },
    selection_box = {
        { -0.5, -0.5 },
        { 0.5,  0.5 }
    },
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
        filter = "steam",
        hide_connection_info = true,
        minimum_temperature = 100,
        production_type = "input",
        volume = 200,
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

data:extend({ eg_steam_engine })
