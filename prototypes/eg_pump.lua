function create_transformator_pump()
    local collision_box = { { -0.49, -0.49 }, { 0.49, 0.49 } }
    local selection_box = { { -1.49, -0.49 }, { 0.49, 0.49 } }
    --local selection_box = { { -0.49, -0.49 }, { 0.49,  0.49 } }

    return {
        type                      = "pump",
        name                      = "eg-pump",
        icon                      = constants.EG_ICONS .. "eg-transformator.png",
        icon_size                 = 128,
        max_health                = constants.EG_MAX_HEALTH,
        hidden                    = true,
        hidden_in_factoriopedia   = true,
        factoriopedia_alternative = "eg-transformator-displayer",
        selectable_in_game        = true,
        flags                     = constants.EG_PUMP_FLAGS,
        alert_icon_scale          = 0,
        minable                   = nil,
        collision_mask            = { layers = {} },
        selection_box             = selection_box,
        collision_box             = collision_box,
        localised_name            = { "entity-name.eg-pump" },
        localised_description     = { "entity-description.eg-pump" },
        pumping_speed             = 100,
        energy_usage              = "0.001W",
        energy_source             = {
            type = "electric",
            usage_priority = "secondary-input"
        },
        fluid_box                 = {
            volume = constants.EG_FLUID_VOLUME,
            hide_connection_info = not constants.EG_DEBUG_TRANSFORMATOR,
            pipe_connections = {
                {
                    connection_category = "eg-guts-category",
                    direction = defines.direction.north,
                    flow_direction = "input",
                    position = { 0, 0 }
                },
                {
                    connection_category = "eg-guts-category",
                    direction = defines.direction.west,
                    flow_direction = "output",
                    position = { 0, 0 }
                }
            }
        },
        control_behavior          = {
            circuit_enable_disable = true,
            connect_to_logistic_network = true,
        },
        open_sound                = data.raw["sound"]["eg-transformator-gui-open"],
        close_sound               = data.raw["sound"]["eg-transformator-gui-close"],
        circuit_wire_max_distance = constants.EG_MAX_WIRE_TRANSFORMATOR,
        circuit_connector         = circuit_connector_definitions.create_vector
            (
                universal_connector_template,
                {
                    { variation = 2,  main_offset = util.by_pixel(-16.875, -6.5),    shadow_offset = util.by_pixel(-16.875, -6.5),    show_shadow = true },
                    { variation = 16, main_offset = util.by_pixel(-37.625, -43.625), shadow_offset = util.by_pixel(-37.625, -43.625), show_shadow = true },
                    { variation = 14, main_offset = util.by_pixel(19.125, 23.5),     shadow_offset = util.by_pixel(19.125, 23.5),     show_shadow = true },
                    { variation = 20, main_offset = util.by_pixel(34.75, -8.625),    shadow_offset = util.by_pixel(34.75, -8.625),    show_shadow = true },
                }
            )
    }
end
