local function get_pump_picture(tier)
    local overlay = {
        north = {
            filename = constants.EG_ENTITIES .. "eg-unit-overlay.png",
            x = 466,
            width = 466,
            height = 310,
            shift = { 2.1, -0.95 },
            scale = 0.5,
            blend_mode = constants.EG_TIER_BLEND_MODE,
            tint = constants.EG_OVERLAY_TINT
        },
        east = {
            filename = constants.EG_ENTITIES .. "eg-unit-overlay.png",
            x = 0,
            width = 466,
            height = 310,
            shift = { 2.0, -1.65 },
            scale = 0.5,
            blend_mode = constants.EG_TIER_BLEND_MODE,
            tint = constants.EG_OVERLAY_TINT
        },
        south = {
            filename = constants.EG_ENTITIES .. "eg-unit-overlay.png",
            x = 1398,
            width = 466,
            height = 310,
            shift = { 3.1, 0.05 },
            scale = 0.5,
            blend_mode = constants.EG_TIER_BLEND_MODE,
            tint = constants.EG_OVERLAY_TINT
        },
        west = {
            filename = constants.EG_ENTITIES .. "eg-unit-overlay.png",
            x = 932,
            width = 466,
            height = 310,
            shift = { 0.94, -0.7 },
            scale = 0.5,
            blend_mode = constants.EG_TIER_BLEND_MODE,
            tint = constants.EG_OVERLAY_TINT
        },
    }

    local template = {
        north = {
            layers = {
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-sprites.png",
                    x = 466,
                    width = 466,
                    height = 310,
                    shift = { 2.1, -0.95 },
                    scale = 0.5,
                },
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-mask.png",
                    x = 466,
                    width = 466,
                    height = 310,
                    shift = { 2.1, -0.95 },
                    blend_mode = constants.EG_TIER_BLEND_MODE,
                    tint = constants.EG_TRANSFORMATORS["eg-unit-" .. tier].tint,
                    scale = 0.5,
                },
            },
        },
        east = {
            layers = {
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-sprites.png",
                    x = 0,
                    width = 466,
                    height = 310,
                    shift = { 2.0, -1.65 },
                    scale = 0.5,
                },
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-mask.png",
                    x = 0,
                    width = 466,
                    height = 310,
                    shift = { 2.0, -1.65 },
                    scale = 0.5,
                    blend_mode = constants.EG_TIER_BLEND_MODE,
                    tint = constants.EG_TRANSFORMATORS["eg-unit-" .. tier].tint,
                },
            },
        },
        south = {
            layers = {
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-sprites.png",
                    x = 1398,
                    width = 466,
                    height = 310,
                    shift = { 3.1, 0.05 },
                    scale = 0.5,
                },
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-mask.png",
                    x = 1398,
                    width = 466,
                    height = 310,
                    shift = { 3.1, 0.05 },
                    scale = 0.5,
                    blend_mode = constants.EG_TIER_BLEND_MODE,
                    tint = constants.EG_TRANSFORMATORS["eg-unit-" .. tier].tint,
                },
            },
        },
        west = {
            layers = {
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-sprites.png",
                    x = 932,
                    width = 466,
                    height = 310,
                    shift = { 0.94, -0.7 },
                    scale = 0.5,
                },
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-mask.png",
                    x = 932,
                    width = 466,
                    height = 310,
                    shift = { 0.94, -0.7 },
                    scale = 0.5,
                    blend_mode = constants.EG_TIER_BLEND_MODE,
                    tint = constants.EG_TRANSFORMATORS["eg-unit-" .. tier].tint,
                },
            },
        },
    }

    if constants.EG_OVERLAY then
        table.insert(template.north.layers, overlay.north)
        table.insert(template.east.layers, overlay.east)
        table.insert(template.south.layers, overlay.south)
        table.insert(template.west.layers, overlay.west)
    end

    return template
end

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
        integration_patch         = get_pump_picture(1),
        pumping_speed             = 100,
        energy_usage              = "1kW",
        energy_source             = { type = "void" },
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
