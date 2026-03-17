local function get_boiler_picture(tier)
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
        south = {
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
                    tint = constants.EG_TRANSFORMATORS["eg-unit-" .. tier].tint,
                    scale = 0.5,
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
                    tint = constants.EG_TRANSFORMATORS["eg-unit-" .. tier].tint,
                },
            },
        },
        north = {
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
                    tint = constants.EG_TRANSFORMATORS["eg-unit-" .. tier].tint,
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
                    shift = { 1.05, -0.6 },
                    scale = 0.5,
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
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-mask.png",
                    x = 0,
                    width = 466,
                    height = 310,
                    shift = { 1.05, -0.6 },
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

local function get_boiler_picture_pump(tier)
    local pump_picture = get_boiler_picture(tier)

    local source_dir = {
        north = "south",
        east  = "west",
        south = "north",
        west  = "east",
    }

    local offset = {
        north = { 1, 0 },
        east  = { 0, 1 },
        south = { -1, -0 },
        west  = { 0, -1 },
    }

    local result = {}

    for gen_dir, pump_dir in pairs(source_dir) do
        local pic = table.deepcopy(pump_picture[pump_dir])

        local dx = offset[gen_dir][1]
        local dy = offset[gen_dir][2]

        for _, layer in ipairs(pic.layers) do
            layer.shift = {
                layer.shift[1] + dx,
                layer.shift[2] + dy,
            }
        end

        result[gen_dir] = pic
    end

    return result
end

function create_transformator_boiler(tier)
    local rating = constants.EG_TRANSFORMATORS["eg-unit-" .. tier].rating

    local collision_box = { { -0.5, -0.5 }, { 0.5, 0.5 } }
    --local selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } }
    local selection_box = { { -0.5, -1.5 }, { 1.5, 0.5 } }

    return {
        type                           = "boiler",
        name                           = "eg-boiler-" .. tier,
        icon                           = constants.EG_ICONS .. "eg-transformator.png",
        icon_size                      = 128,
        energy_consumption             = rating,
        target_temperature             = 165,
        max_health                     = constants.EG_MAX_HEALTH,
        alert_icon_scale               = 0,
        hidden                         = false,
        minable                        = nil,
        selectable_in_game             = false,
        flags                          = constants.EG_INTERNAL_ENTITY_FLAGS,
        localised_name                 = { "entity-name.eg-boiler" },
        localised_description          = { "entity-description.eg-boiler" },
        quality_indicator_scale        = 0,
        integration_patch              = get_boiler_picture_pump(tier),
        integration_patch_render_layer = "object-under",
        energy_source                  = {
            type = "electric",
            input_flow_limit = rating,
            usage_priority = "secondary-input",
            emissions = 0
        },
        mode                           = "output-to-separate-pipe",
        burning_cooldown               = 0,
        collision_mask                 = constants.EG_COLLISION_MASK,
        selection_box                  = selection_box,
        collision_box                  = collision_box,

        fluid_box                      = {
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
        output_fluid_box               = {
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
