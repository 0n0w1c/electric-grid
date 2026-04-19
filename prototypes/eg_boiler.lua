function create_transformator_boiler(tier)
    local rating = constants.EG_TRANSFORMATORS[tier].rating

    local collision_box = { { -0.5, -0.5 }, { 0.5, 0.5 } }
    --local selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } }
    local selection_box = { { -0.5, -1.5 }, { 1.5, 0.5 } }

    return {
        type                    = "boiler",
        name                    = "eg-boiler-" .. tier,
        icon                    = constants.EG_ICONS .. "eg-transformator.png",
        icon_size               = 128,
        energy_consumption      = rating,
        target_temperature      = 165,
        max_health              = constants.EG_MAX_HEALTH,
        alert_icon_scale        = 0,
        hidden                  = false,
        hidden_in_factoriopedia = true,
        minable                 = nil,
        selectable_in_game      = false,
        flags                   = constants.EG_INTERNAL_ENTITY_FLAGS,
        localised_name          = { "entity-name.eg-boiler" },
        localised_description   = { "entity-description.eg-boiler" },
        quality_indicator_scale = 0,
        energy_source           = {
            type = "electric",
            input_flow_limit = rating,
            usage_priority = "secondary-input",
            emissions = 0
        },
        mode                    = "output-to-separate-pipe",
        burning_cooldown        = 0,
        selection_box           = selection_box,
        collision_box           = collision_box,

        fluid_box               = {
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
        output_fluid_box        = {
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
