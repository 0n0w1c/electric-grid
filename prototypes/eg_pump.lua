local function get_pump_animations(tier)
    local overlay = {}
    if constants.EG_INVERT_OVERLAY then
        overlay = {
            south = {
                filename = constants.EG_ENTITIES .. "eg-unit-overlay.png",
                x = 1398,
                width = 466,
                height = 310,
                shift = { 2.1, -0.95 },
                scale = 0.5,
                blend_mode = constants.EG_TIER_BLEND_MODE,
                tint = constants.EG_OVERLAY_TINT
            },
            west = {
                filename = constants.EG_ENTITIES .. "eg-unit-overlay.png",
                x = 932,
                width = 466,
                height = 310,
                shift = { 2, -1.65 },
                scale = 0.5,
                blend_mode = constants.EG_TIER_BLEND_MODE,
                tint = constants.EG_OVERLAY_TINT
            },
            north = {
                filename = constants.EG_ENTITIES .. "eg-unit-overlay.png",
                x = 466,
                width = 466,
                height = 310,
                shift = { 3.1, 0.05 },
                scale = 0.5,
                blend_mode = constants.EG_TIER_BLEND_MODE,
                tint = constants.EG_OVERLAY_TINT
            },
            east = {
                filename = constants.EG_ENTITIES .. "eg-unit-overlay.png",
                x = 0,
                width = 466,
                height = 310,
                shift = { 1.04, -0.6 },
                scale = 0.5,
                blend_mode = constants.EG_TIER_BLEND_MODE,
                tint = constants.EG_OVERLAY_TINT
            },
        }
    else
        overlay = {
            south = {
                filename = constants.EG_ENTITIES .. "eg-unit-overlay.png",
                x = 466,
                width = 466,
                height = 310,
                shift = { 2.1, -0.95 },
                scale = 0.5,
                blend_mode = constants.EG_TIER_BLEND_MODE,
                tint = constants.EG_OVERLAY_TINT
            },
            west = {
                filename = constants.EG_ENTITIES .. "eg-unit-overlay.png",
                x = 0,
                width = 466,
                height = 310,
                shift = { 2.0, -1.65 },
                scale = 0.5,
                blend_mode = constants.EG_TIER_BLEND_MODE,
                tint = constants.EG_OVERLAY_TINT
            },
            north = {
                filename = constants.EG_ENTITIES .. "eg-unit-overlay.png",
                x = 1398,
                width = 466,
                height = 310,
                shift = { 3.1, 0.05 },
                scale = 0.5,
                blend_mode = constants.EG_TIER_BLEND_MODE,
                tint = constants.EG_OVERLAY_TINT
            },
            east = {
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
    end
    local template = {
        north = {
            layers = {
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-sprites.png",
                    x = 1398,
                    width = 466,
                    height = 310,
                    shift = { 2.1, -0.95 },
                    scale = 0.5,
                },
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-mask.png",
                    x = 1398,
                    width = 466,
                    height = 310,
                    shift = { 2.1, -0.95 },
                    blend_mode = constants.EG_TIER_BLEND_MODE,
                    tint = constants.EG_TRANSFORMATORS[tier].tint,
                    scale = 0.5,
                },
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-shadows.png",
                    x = 1398,
                    width = 466,
                    height = 310,
                    shift = { 2.1, -0.95 },
                    scale = 0.5,
                    draw_as_shadow = true,
                },
            },
        },
        east = {
            layers = {
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-sprites.png",
                    x = 932,
                    width = 466,
                    height = 310,
                    shift = { 2.0, -1.65 },
                    scale = 0.5,
                },
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-mask.png",
                    x = 932,
                    width = 466,
                    height = 310,
                    shift = { 2.0, -1.65 },
                    scale = 0.5,
                    blend_mode = constants.EG_TIER_BLEND_MODE,
                    tint = constants.EG_TRANSFORMATORS[tier].tint,
                },
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-shadows.png",
                    x = 932,
                    width = 466,
                    height = 310,
                    shift = { 2.0, -1.65 },
                    scale = 0.5,
                    draw_as_shadow = true,
                },
            },
        },
        south = {
            layers = {
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-sprites.png",
                    x = 466,
                    width = 466,
                    height = 310,
                    shift = { 3.1, 0.05 },
                    scale = 0.5,
                },
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-mask.png",
                    x = 466,
                    width = 466,
                    height = 310,
                    shift = { 3.1, 0.05 },
                    scale = 0.5,
                    blend_mode = constants.EG_TIER_BLEND_MODE,
                    tint = constants.EG_TRANSFORMATORS[tier].tint,
                },
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-shadows.png",
                    x = 466,
                    width = 466,
                    height = 310,
                    shift = { 3.1, 0.05 },
                    scale = 0.5,
                    draw_as_shadow = true,
                },
            },
        },
        west = {
            layers = {
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-sprites.png",
                    x = 0,
                    width = 466,
                    height = 310,
                    shift = { 1.05, -0.6 },
                    scale = 0.5,
                },
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-mask.png",
                    x = 0,
                    width = 466,
                    height = 310,
                    shift = { 1.05, -0.6 },
                    scale = 0.5,
                    blend_mode = constants.EG_TIER_BLEND_MODE,
                    tint = constants.EG_TRANSFORMATORS[tier].tint,
                },
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-shadows.png",
                    x = 0,
                    width = 466,
                    height = 310,
                    shift = { 1.05, -0.6 },
                    scale = 0.5,
                    draw_as_shadow = true,
                },
            },
        },
    }

    if constants.EG_OVERLAY then
        if constants.EG_INVERT_OVERLAY then
            table.insert(template.north.layers, overlay.south)
            table.insert(template.east.layers, overlay.west)
            table.insert(template.south.layers, overlay.north)
            table.insert(template.west.layers, overlay.east)
        else
            table.insert(template.north.layers, overlay.north)
            table.insert(template.east.layers, overlay.east)
            table.insert(template.south.layers, overlay.south)
            table.insert(template.west.layers, overlay.west)
        end
    end

    return template
end

function create_transformator_pump(tier, name_override)
    local collision_box = { { -0.5, -0.5 }, { 0.5, 0.5 } }
    local selection_box = { { -1.5, -1.5 }, { 0.5, 0.5 } }
    --local selection_box = { { -0.49, -0.49 }, { 0.49,  0.49 } }

    tier = tonumber(tier) or 1
    local name = name_override or ("eg-pump-" .. tier)

    return {
        type                           = "pump",
        name                           = name,
        icon                           = constants.EG_ICONS .. "eg-transformator.png",
        icon_size                      = 128,
        max_health                     = constants.EG_MAX_HEALTH,
        hidden                         = false,
        selectable_in_game             = true,
        minable                        = { mining_time = 0.5, result = "eg-transformator" },
        flags                          = { "placeable-player", "player-creation", "get-by-unit-number" },
        alert_icon_scale               = 0,
        placeable_by                   = { item = "eg-transformator", count = 1 },
        selection_box                  = selection_box,
        collision_box                  = collision_box,
        drawing_box_vertical_extension = 1.5,
        localised_name                 = { "entity-name.eg-pump", constants.EG_TRANSFORMATORS[tier].rating },
        localised_description          = { "entity-description.eg-pump" },
        icon_draw_specification        = { shift = { 0, 0 }, scale = 0, render_layer = "entity-info-icon" },
        animations                     = get_pump_animations(tier),
        pumping_speed                  = 100,
        energy_usage                   = "1kW",
        energy_source                  = { type = "void" },
        fluid_box                      = {
            volume = constants.EG_FLUID_VOLUME,
            hide_connection_info = not constants.EG_DEBUG_TRANSFORMATOR,
            pipe_connections = {
                {
                    connection_category = "eg-guts-category",
                    direction = defines.direction.north,
                    flow_direction = "input",
                    position = { 0, -0.1 }
                },
                {
                    connection_category = "eg-guts-category",
                    direction = defines.direction.west,
                    flow_direction = "output",
                    position = { -0.1, 0 }
                }
            }
        },
        control_behavior               = {
            circuit_enable_disable = true,
            connect_to_logistic_network = true,
        },
        open_sound                     = data.raw["sound"]["eg-transformator-gui-open"],
        close_sound                    = data.raw["sound"]["eg-transformator-gui-close"],
        circuit_wire_max_distance      = constants.EG_MAX_WIRE_TRANSFORMATOR,
        circuit_connector              = circuit_connector_definitions.create_vector
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
