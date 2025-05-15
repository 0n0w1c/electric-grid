local function get_transformator_picture(tier)
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
            shift = { 1.0, -0.65 },
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
                    shift = { 1.0, -0.65 },
                    scale = 0.5,
                },
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-mask.png",
                    x = 932,
                    width = 466,
                    height = 310,
                    shift = { 1.0, -0.65 },
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

function create_tiered_transformator_pump(tier)
    local collision_box = { { -0.49, -0.49 }, { 0.49, 0.49 } }
    local selection_box = { { -1.49, -0.49 }, { 0.49, 0.49 } }
    --local selection_box = { { -0.49, -0.49 }, { 0.49,  0.49 } }

    return {
        type                      = "pump",
        name                      = "eg-pump-" .. tier,
        icon                      = constants.EG_ICONS .. "eg-transformator.png",
        icon_size                 = 128,
        max_health                = constants.EG_MAX_HEALTH,
        hidden                    = false,
        hidden_in_factoriopedia   = true,
        selectable_in_game        = true,
        flags                     = constants.EG_PUMP_FLAGS,
        alert_icon_scale          = 0,
        minable                   = nil,
        collision_mask            = { layers = {} },
        selection_box             = selection_box,
        collision_box             = collision_box,
        localised_name            = { "entity-name.eg-pump" },
        localised_description     = { "entity-description.eg-pump" },
        quality_indicator_scale   = 0,
        integration_patch         = get_transformator_picture(tier),
        pumping_speed             = 1,
        energy_usage              = "0.001W",
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
        circuit_wire_max_distance = constants.EG_MAX_WIRE_TRANSFORMATOR,
        close_sound               = {
            filename = "__base__/sound/machine-close.ogg",
            volume = 0.5
        },
        circuit_connector         = {
            {
                points = {
                    shadow = {
                        green = {
                            -0.0625,
                            0.421875
                        },
                        red = {
                            0.21875,
                            0.421875
                        }
                    },
                    wire = {
                        green = {
                            -0.625,
                            0.078125
                        },
                        red = {
                            -0.53125,
                            -0.078125
                        }
                    }
                },
                sprites = {
                    blue_led_light_offset = {
                        -0.65625,
                        -0.109375
                    },
                    connector_main = {
                        filename = "__base__/graphics/entity/circuit-connector/ccm-universal-04a-base-sequence.png",
                        height = 50,
                        priority = "low",
                        scale = 0.5,
                        shift = {
                            -0.46875,
                            -0.234375
                        },
                        width = 52,
                        --x = 0,
                        --y = 150
                        x = 104,
                        y = 150
                    },
                    led_blue = {
                        draw_as_glow = true,
                        filename =
                        "__base__/graphics/entity/circuit-connector/ccm-universal-04e-blue-LED-on-sequence.png",
                        height = 60,
                        priority = "low",
                        scale = 0.5,
                        shift = {
                            -0.46875,
                            -0.265625
                        },
                        width = 60,
                        x = 0,
                        y = 180
                    },
                    led_blue_off = {
                        filename =
                        "__base__/graphics/entity/circuit-connector/ccm-universal-04f-blue-LED-off-sequence.png",
                        height = 44,
                        priority = "low",
                        scale = 0.5,
                        shift = {
                            -0.46875,
                            -0.265625
                        },
                        width = 46,
                        x = 0,
                        y = 132
                    },
                    led_green = {
                        draw_as_glow = true,
                        filename = "__base__/graphics/entity/circuit-connector/ccm-universal-04h-green-LED-sequence.png",
                        height = 46,
                        priority = "low",
                        scale = 0.5,
                        shift = {
                            -0.46875,
                            -0.265625
                        },
                        width = 48,
                        x = 0,
                        y = 138
                    },
                    led_light = {
                        intensity = 0,
                        size = 0.9
                    },
                    led_red = {
                        draw_as_glow = true,
                        filename = "__base__/graphics/entity/circuit-connector/ccm-universal-04i-red-LED-sequence.png",
                        height = 46,
                        priority = "low",
                        scale = 0.5,
                        shift = {
                            -0.46875,
                            -0.265625
                        },
                        width = 48,
                        x = 0,
                        y = 138
                    },
                    red_green_led_light_offset = {
                        -0.65625,
                        -0.234375
                    },
                    wire_pins = {
                        filename = "__base__/graphics/entity/circuit-connector/ccm-universal-04c-wire-sequence.png",
                        height = 58,
                        priority = "low",
                        scale = 0.5,
                        shift = {
                            -0.46875,
                            -0.234375
                        },
                        width = 62,
                        x = 0,
                        y = 174
                    }
                }
            },
            {
                points = {
                    shadow = {
                        green = {
                            0,
                            0.734375
                        },
                        red = {
                            0.1875,
                            0.734375
                        }
                    },
                    wire = {
                        green = {
                            -0.1875,
                            0.359375
                        },
                        red = {
                            -0.25,
                            0.140625
                        }
                    }
                },
                sprites = {
                    blue_led_light_offset = {
                        -0.5,
                        0.390625
                    },
                    connector_main = {
                        filename = "__base__/graphics/entity/circuit-connector/ccm-universal-04a-base-sequence.png",
                        height = 50,
                        priority = "low",
                        scale = 0.5,
                        shift = {
                            -0.5,
                            0.140625
                        },
                        width = 52,
                        x = 104,
                        y = 150
                    },
                    connector_shadow = {
                        draw_as_shadow = true,
                        filename =
                        "__base__/graphics/entity/circuit-connector/ccm-universal-04b-base-shadow-sequence.png",
                        height = 46,
                        priority = "low",
                        scale = 0.5,
                        shift = {
                            -0.359375,
                            0.5
                        },
                        width = 60,
                        x = 120,
                        y = 138
                    },
                    led_blue = {
                        draw_as_glow = true,
                        filename =
                        "__base__/graphics/entity/circuit-connector/ccm-universal-04e-blue-LED-on-sequence.png",
                        height = 60,
                        priority = "low",
                        scale = 0.5,
                        shift = {
                            -0.5,
                            0.109375
                        },
                        width = 60,
                        x = 120,
                        y = 180
                    },
                    led_blue_off = {
                        filename =
                        "__base__/graphics/entity/circuit-connector/ccm-universal-04f-blue-LED-off-sequence.png",
                        height = 44,
                        priority = "low",
                        scale = 0.5,
                        shift = {
                            -0.5,
                            0.109375
                        },
                        width = 46,
                        x = 92,
                        y = 132
                    },
                    led_green = {
                        draw_as_glow = true,
                        filename = "__base__/graphics/entity/circuit-connector/ccm-universal-04h-green-LED-sequence.png",
                        height = 46,
                        priority = "low",
                        scale = 0.5,
                        shift = {
                            -0.5,
                            0.109375
                        },
                        width = 48,
                        x = 96,
                        y = 138
                    },
                    led_light = {
                        intensity = 0,
                        size = 0.9
                    },
                    led_red = {
                        draw_as_glow = true,
                        filename = "__base__/graphics/entity/circuit-connector/ccm-universal-04i-red-LED-sequence.png",
                        height = 46,
                        priority = "low",
                        scale = 0.5,
                        shift = {
                            -0.5,
                            0.109375
                        },
                        width = 48,
                        x = 96,
                        y = 138
                    },
                    red_green_led_light_offset = {
                        -0.5,
                        0.296875
                    },
                    wire_pins = {
                        filename = "__base__/graphics/entity/circuit-connector/ccm-universal-04c-wire-sequence.png",
                        height = 58,
                        priority = "low",
                        scale = 0.5,
                        shift = {
                            -0.5,
                            0.140625
                        },
                        width = 62,
                        x = 124,
                        y = 174
                    },
                    wire_pins_shadow = {
                        draw_as_shadow = true,
                        filename =
                        "__base__/graphics/entity/circuit-connector/ccm-universal-04d-wire-shadow-sequence.png",
                        height = 54,
                        priority = "low",
                        scale = 0.5,
                        shift = {
                            -0.28125,
                            0.53125
                        },
                        width = 68,
                        x = 136,
                        y = 162
                    }
                }
            },
            {
                points = {
                    shadow = {
                        green = {
                            -0.453125,
                            0.625
                        },
                        red = {
                            -0.171875,
                            0.625
                        }
                    },
                    wire = {
                        green = {
                            -0.609375,
                            0.078125
                        },
                        red = {
                            -0.515625,
                            -0.078125
                        }
                    }
                },
                sprites = {
                    blue_led_light_offset = {
                        -0.640625,
                        -0.109375
                    },
                    connector_main = {
                        filename = "__base__/graphics/entity/circuit-connector/ccm-universal-04a-base-sequence.png",
                        height = 50,
                        priority = "low",
                        scale = 0.5,
                        shift = {
                            -0.453125,
                            -0.234375
                        },
                        width = 52,
                        x = 0,
                        y = 150
                    },
                    led_blue = {
                        draw_as_glow = true,
                        filename =
                        "__base__/graphics/entity/circuit-connector/ccm-universal-04e-blue-LED-on-sequence.png",
                        height = 60,
                        priority = "low",
                        scale = 0.5,
                        shift = {
                            -0.453125,
                            -0.265625
                        },
                        width = 60,
                        x = 0,
                        y = 180
                    },
                    led_blue_off = {
                        filename =
                        "__base__/graphics/entity/circuit-connector/ccm-universal-04f-blue-LED-off-sequence.png",
                        height = 44,
                        priority = "low",
                        scale = 0.5,
                        shift = {
                            -0.453125,
                            -0.265625
                        },
                        width = 46,
                        x = 0,
                        y = 132
                    },
                    led_green = {
                        draw_as_glow = true,
                        filename = "__base__/graphics/entity/circuit-connector/ccm-universal-04h-green-LED-sequence.png",
                        height = 46,
                        priority = "low",
                        scale = 0.5,
                        shift = {
                            -0.453125,
                            -0.265625
                        },
                        width = 48,
                        x = 0,
                        y = 138
                    },
                    led_light = {
                        intensity = 0,
                        size = 0.9
                    },
                    led_red = {
                        draw_as_glow = true,
                        filename = "__base__/graphics/entity/circuit-connector/ccm-universal-04i-red-LED-sequence.png",
                        height = 46,
                        priority = "low",
                        scale = 0.5,
                        shift = {
                            -0.453125,
                            -0.265625
                        },
                        width = 48,
                        x = 0,
                        y = 138
                    },
                    red_green_led_light_offset = {
                        -0.640625,
                        -0.234375
                    },
                    wire_pins = {
                        filename = "__base__/graphics/entity/circuit-connector/ccm-universal-04c-wire-sequence.png",
                        height = 58,
                        priority = "low",
                        scale = 0.5,
                        shift = {
                            -0.453125,
                            -0.234375
                        },
                        width = 62,
                        x = 0,
                        y = 174
                    }
                }
            },
            {
                points = {
                    shadow = {
                        green = {
                            0.21875,
                            -0.078125
                        },
                        red = {
                            0.40625,
                            -0.078125
                        }
                    },
                    wire = {
                        green = {
                            1.734375,
                            1.190625
                        },
                        red = {
                            1.671875,
                            0.971875
                        }
                    }
                },
                sprites = {
                    blue_led_light_offset = {
                        0.421875,
                        0.421875
                    },
                    connector_main = {
                        filename = "__base__/graphics/entity/circuit-connector/ccm-universal-04a-base-sequence.png",
                        height = 50,
                        priority = "low",
                        scale = 0.5,
                        shift = {
                            1.521875,
                            0.81875
                        },
                        width = 52,
                        x = 208,
                        y = 150
                    },
                    connector_shadow = {
                        draw_as_shadow = true,
                        filename =
                        "__base__/graphics/entity/circuit-connector/ccm-universal-04b-base-shadow-sequence.png",
                        height = 46,
                        priority = "low",
                        scale = 0.5,
                        shift = {
                            1.640625,
                            0.9125
                        },
                        width = 60,
                        x = 120,
                        y = 138
                    },
                    led_blue = {
                        draw_as_glow = true,
                        filename =
                        "__base__/graphics/entity/circuit-connector/ccm-universal-04e-blue-LED-on-sequence.png",
                        height = 60,
                        priority = "low",
                        scale = 0.5,
                        shift = {
                            0.421875,
                            0.140625
                        },
                        width = 60,
                        x = 120,
                        y = 180
                    },
                    led_blue_off = {
                        filename =
                        "__base__/graphics/entity/circuit-connector/ccm-universal-04f-blue-LED-off-sequence.png",
                        height = 44,
                        priority = "low",
                        scale = 0.5,
                        shift = {
                            0.421875,
                            0.140625
                        },
                        width = 46,
                        x = 92,
                        y = 132
                    },
                    led_green = {
                        draw_as_glow = true,
                        filename = "__base__/graphics/entity/circuit-connector/ccm-universal-04h-green-LED-sequence.png",
                        height = 46,
                        priority = "low",
                        scale = 0.5,
                        shift = {
                            0.421875,
                            0.140625
                        },
                        width = 48,
                        x = 96,
                        y = 138
                    },
                    led_light = {
                        intensity = 0,
                        size = 0.9
                    },
                    led_red = {
                        draw_as_glow = true,
                        filename = "__base__/graphics/entity/circuit-connector/ccm-universal-04i-red-LED-sequence.png",
                        height = 46,
                        priority = "low",
                        scale = 0.5,
                        shift = {
                            0.421875,
                            0.140625
                        },
                        width = 48,
                        x = 96,
                        y = 138
                    },
                    red_green_led_light_offset = {
                        0.421875,
                        0.328125
                    },
                    wire_pins = {
                        filename = "__base__/graphics/entity/circuit-connector/ccm-universal-04c-wire-sequence.png",
                        height = 58,
                        priority = "low",
                        scale = 0.5,
                        shift = {
                            1.441875,
                            0.931875
                        },
                        width = 62,
                        x = 124,
                        y = 174
                    },
                    wire_pins_shadow = {
                        draw_as_shadow = true,
                        filename =
                        "__base__/graphics/entity/circuit-connector/ccm-universal-04d-wire-shadow-sequence.png",
                        height = 54,
                        priority = "low",
                        scale = 0.5,
                        shift = {
                            1.441875,
                            0.931875
                        },
                        width = 68,
                        x = 136,
                        y = 162
                    }
                }
            }
        },
    }
end

local function make_circuit_connector_sprites(template, index, main_offset, shadow_offset, show_shadow)
    local function get_frame(animation, extra_shift, frame)
        return
        {
            filename = animation.filename,
            priority = animation.priority,
            flags = animation.flags,
            draw_as_shadow = animation.draw_as_shadow,
            draw_as_light = animation.draw_as_light,
            draw_as_glow = animation.draw_as_glow,
            width = animation.width,
            height = animation.height,
            scale = animation.scale,
            x = animation.width * (frame % (animation.line_length or animation.frame_count)),
            y = animation.height * (math.floor(frame / (animation.line_length or animation.frame_count))),
            shift = util.add_shift(animation.shift, extra_shift)
        }
    end

    local result = {}
    for k, t in pairs(template) do
        if t.filename then
            result[k] = get_frame(t, main_offset, index)
        end
    end

    if show_shadow and shadow_offset and template.connector_shadow then
        result.connector_shadow = get_frame(template.connector_shadow, shadow_offset, index)
    else
        result.connector_shadow = nil
    end

    if show_shadow and shadow_offset and template.wire_pins_shadow then
        result.wire_pins_shadow = get_frame(template.wire_pins_shadow, shadow_offset, index)
    else
        result.wire_pins_shadow = nil
    end

    result.led_light =
    {
        intensity = 0,
        size = 0.9
    }

    local light_offset = util.add_shift(main_offset, template.light_offset_hotfix)
    result.blue_led_light_offset = template.light_offsets[index + 1] and
        util.add_shift(light_offset, template.light_offsets[index + 1].b)
    result.red_green_led_light_offset = template.light_offsets[index + 1] and
        util.add_shift(light_offset, template.light_offsets[index + 1].rg)

    return result
end

local function make_circuit_connector_points(template, index, main_offset, shadow_offset)
    local result = {}

    index = index + 1

    local offset = util.add_shift(main_offset, template.wire_offset_hotfix)
    result.wire =
    {
        red = util.add_shift(offset, template.wire_offsets[index].red),
        green = util.add_shift(offset, template.wire_offsets[index].green)
    }

    if shadow_offset then
        offset = util.add_shift(shadow_offset, template.wire_shadow_offset_hotfix)
        result.shadow =
        {
            red = util.add_shift(offset, template.wire_shadow_offsets[index].red),
            green = util.add_shift(offset, template.wire_shadow_offsets[index].green)
        }
    end

    return result
end

local function make_single_circuit_connector_definition(template, definition)
    return
    {
        sprites = make_circuit_connector_sprites(template, definition.variation, definition.main_offset,
            definition.shadow_offset, definition.show_shadow),
        points = make_circuit_connector_points(template, definition.variation, definition.main_offset,
            definition.shadow_offset)
    }
end

local function make_multiple_circuit_connector_definitions(template, definitions)
    local result = {}
    for k, d in pairs(definitions) do
        if d.variation then
            table.insert(result, make_single_circuit_connector_definition(template, d))
        end
    end
    return result
end

local circuit_connector_definitions =
{
    create_single = make_single_circuit_connector_definition,
    create_vector = make_multiple_circuit_connector_definitions
}

function create_transformator_pump()
    local collision_box = { { -0.49, -0.49 }, { 0.49, 0.49 } }
    local selection_box = { { -1.49, -0.49 }, { 0.49, 0.49 } }
    --local selection_box = { { -0.49, -0.49 }, { 0.49,  0.49 } }

    local universal_connector_template =
    {
        connector_main =
        {
            filename = "__base__/graphics/entity/circuit-connector/ccm-universal-04a-base-sequence.png",
            frame_count = 40,
            height = 50,
            line_length = 8,
            priority = "low",
            scale = 0.5,
            shift = util.by_pixel(0, 1),
            width = 52
        },

        connector_shadow =
        {
            draw_as_shadow = true,
            filename = "__base__/graphics/entity/circuit-connector/ccm-universal-04b-base-shadow-sequence.png",
            frame_count = 40,
            priority = "low",
            scale = 0.5,
            width = 60,
            height = 46,
            shift = util.by_pixel(2.5, 2.5),
            line_length = 8,
        },

        wire_pins =
        {
            filename = "__base__/graphics/entity/circuit-connector/ccm-universal-04c-wire-sequence.png",
            frame_count = 40,
            height = 58,
            line_length = 8,
            priority = "low",
            scale = 0.5,
            shift = util.by_pixel(0, 1),
            width = 62
        },

        wire_pins_shadow =
        {
            draw_as_shadow = true,
            filename = "__base__/graphics/entity/circuit-connector/ccm-universal-04d-wire-shadow-sequence.png",
            frame_count = 40,
            height = 54,
            width = 68,
            line_length = 8,
            priority = "low",
            scale = 0.5,
            shift = util.by_pixel(5.0, 3.5),
        },

        led_blue =
        {
            filename = "__base__/graphics/entity/circuit-connector/ccm-universal-04e-blue-LED-on-sequence.png",
            frame_count = 40,
            height = 60,
            line_length = 8,
            priority = "low",
            draw_as_glow = true,
            scale = 0.5,
            shift = util.by_pixel(0, 0),
            width = 60
        },

        led_blue_off =
        {
            filename = "__base__/graphics/entity/circuit-connector/ccm-universal-04f-blue-LED-off-sequence.png",
            frame_count = 40,
            height = 44,
            line_length = 8,
            priority = "low",
            scale = 0.5,
            shift = util.by_pixel(0, 0),
            width = 46
        },

        led_green =
        {
            filename = "__base__/graphics/entity/circuit-connector/ccm-universal-04h-green-LED-sequence.png",
            frame_count = 40,
            height = 46,
            line_length = 8,
            priority = "low",
            draw_as_glow = true,
            scale = 0.5,
            shift = util.by_pixel(0, 0),
            width = 48
        },

        led_red =
        {
            filename = "__base__/graphics/entity/circuit-connector/ccm-universal-04i-red-LED-sequence.png",
            frame_count = 40,
            height = 46,
            line_length = 8,
            priority = "low",
            draw_as_glow = true,
            scale = 0.5,
            shift = util.by_pixel(0, 0),
            width = 48
        },

        wire_offsets =
        {
            { red = util.by_pixel(-1, 5),   green = util.by_pixel(-8, 5) },
            { red = util.by_pixel(4, 2),    green = util.by_pixel(-1, 5) },
            { red = util.by_pixel(8, -3),   green = util.by_pixel(10, 2) },
            { red = util.by_pixel(6, -8),   green = util.by_pixel(12, -4) },
            { red = util.by_pixel(1, -10),  green = util.by_pixel(8, -10) },
            { red = util.by_pixel(-5, -9),  green = util.by_pixel(1, -12) },
            { red = util.by_pixel(-10, -3), green = util.by_pixel(-8, -10) },
            { red = util.by_pixel(-7, 1),   green = util.by_pixel(-13, -1) },
            { red = util.by_pixel(-3, 5),   green = util.by_pixel(-9, 7) },
            { red = util.by_pixel(4, 4),    green = util.by_pixel(0, 10) },
            { red = util.by_pixel(9, 0),    green = util.by_pixel(10, 7) },
            { red = util.by_pixel(9, -5),   green = util.by_pixel(13, 0) },
            { red = util.by_pixel(2, -9),   green = util.by_pixel(9, -6) },
            { red = util.by_pixel(-3, -9),  green = util.by_pixel(-9, -6) },
            { red = util.by_pixel(-9, 0),   green = util.by_pixel(-10, 6) },
            { red = util.by_pixel(2, 5),    green = util.by_pixel(9, 7) },
            { red = util.by_pixel(-3, 6),   green = util.by_pixel(-7, 9) },
            { red = util.by_pixel(5, 5),    green = util.by_pixel(1, 11) },
            { red = util.by_pixel(8, 1),    green = util.by_pixel(10, 8) },
            { red = util.by_pixel(9, -4),   green = util.by_pixel(12, 2) },
            { red = util.by_pixel(2, -8),   green = util.by_pixel(8, -3) },
            { red = util.by_pixel(-3, -8),  green = util.by_pixel(-8, -3) },
            { red = util.by_pixel(-8, 2),   green = util.by_pixel(-10, 8) },
            { red = util.by_pixel(2, 5),    green = util.by_pixel(8, 9) },
            { red = util.by_pixel(-2, 6),   green = util.by_pixel(-5, 11) },
            { red = util.by_pixel(4, 6),    green = util.by_pixel(2, 12) },
            { red = util.by_pixel(8, 1),    green = util.by_pixel(10, 8) },
            { red = util.by_pixel(8, -3),   green = util.by_pixel(10, 3) },
            { red = util.by_pixel(3, -8),   green = util.by_pixel(5, -1) },
            { red = util.by_pixel(-3, -8),  green = util.by_pixel(-5, -3) },
            { red = util.by_pixel(-8, 2),   green = util.by_pixel(-9, 9) },
            { red = util.by_pixel(3, 6),    green = util.by_pixel(5, 11) },
            { red = util.by_pixel(-5, 4),   green = util.by_pixel(-12, 1) },
            { red = util.by_pixel(2, 4),    green = util.by_pixel(-4, 6) },
            { red = util.by_pixel(7, 0),    green = util.by_pixel(2, 5) },
            { red = util.by_pixel(8, -5),   green = util.by_pixel(12, -1) },
            { red = util.by_pixel(4, -9),   green = util.by_pixel(11, -7) },
            { red = util.by_pixel(-2, -10), green = util.by_pixel(3, -12) },
            { red = util.by_pixel(-8, -7),  green = util.by_pixel(-4, -11) },
            { red = util.by_pixel(-8, 0),   green = util.by_pixel(-12, -4) },
        },
        wire_shadow_offsets =
        {
            { red = util.by_pixel(1, 7),   green = util.by_pixel(-5, 7) },
            { red = util.by_pixel(10, 5),  green = util.by_pixel(5, 9) },
            { red = util.by_pixel(12, 0),  green = util.by_pixel(15, 6) },
            { red = util.by_pixel(12, -3), green = util.by_pixel(18, 0) },
            { red = util.by_pixel(5, -6),  green = util.by_pixel(14, -6) },
            { red = util.by_pixel(-1, -5), green = util.by_pixel(4, -8) },
            { red = util.by_pixel(-7, -1), green = util.by_pixel(-3, -6) },
            { red = util.by_pixel(-4, 4),  green = util.by_pixel(-10, 0) },
            { red = util.by_pixel(4, 10),  green = util.by_pixel(-5, 11) },
            { red = util.by_pixel(12, 10), green = util.by_pixel(4, 13) },
            { red = util.by_pixel(17, 5),  green = util.by_pixel(15, 10) },
            { red = util.by_pixel(17, 0),  green = util.by_pixel(19, 3) },
            { red = util.by_pixel(10, -3), green = util.by_pixel(14, -3) },
            { red = util.by_pixel(4, -3),  green = util.by_pixel(-5, -3) },
            { red = util.by_pixel(-2, 5),  green = util.by_pixel(-5, 10) },
            { red = util.by_pixel(10, 11), green = util.by_pixel(14, 10) },
            { red = util.by_pixel(6, 14),  green = util.by_pixel(-4, 13) },
            { red = util.by_pixel(15, 13), green = util.by_pixel(5, 15) },
            { red = util.by_pixel(19, 9),  green = util.by_pixel(15, 11) },
            { red = util.by_pixel(19, 2),  green = util.by_pixel(17, 5) },
            { red = util.by_pixel(12, 0),  green = util.by_pixel(13, -1) },
            { red = util.by_pixel(6, -1),  green = util.by_pixel(-3, 0) },
            { red = util.by_pixel(-1, 9),  green = util.by_pixel(-6, 12) },
            { red = util.by_pixel(13, 13), green = util.by_pixel(12, 14) },
            { red = util.by_pixel(7, 14),  green = util.by_pixel(-2, 14) },
            { red = util.by_pixel(14, 14), green = util.by_pixel(6, 15) },
            { red = util.by_pixel(20, 10), green = util.by_pixel(14, 10) },
            { red = util.by_pixel(19, 4),  green = util.by_pixel(15, 6) },
            { red = util.by_pixel(14, 0),  green = util.by_pixel(9, 0) },
            { red = util.by_pixel(7, 0),   green = util.by_pixel(-1, 0) },
            { red = util.by_pixel(2, 11),  green = util.by_pixel(-6, 11) },
            { red = util.by_pixel(13, 14), green = util.by_pixel(9, 14) },
            { red = util.by_pixel(-1, 6),  green = util.by_pixel(-8, 5) },
            { red = util.by_pixel(6, 7),   green = util.by_pixel(-1, 9) },
            { red = util.by_pixel(13, 3),  green = util.by_pixel(10, 9) },
            { red = util.by_pixel(14, -2), green = util.by_pixel(18, 2) },
            { red = util.by_pixel(9, -6),  green = util.by_pixel(16, -4) },
            { red = util.by_pixel(2, -6),  green = util.by_pixel(9, -8) },
            { red = util.by_pixel(-4, -4), green = util.by_pixel(0, -7) },
            { red = util.by_pixel(-6, 3),  green = util.by_pixel(-8, -1) },
        },
        light_offsets =
        {
            { rg = util.by_pixel(-2, -4), b = util.by_pixel(-7, -3) },
            { rg = util.by_pixel(-1, -3), b = util.by_pixel(-5, 0) },
            { rg = util.by_pixel(0, -3),  b = util.by_pixel(0, 0) },
            { rg = util.by_pixel(2, -4),  b = util.by_pixel(5, -1) },
            { rg = util.by_pixel(2, -5),  b = util.by_pixel(7, -4) },
            { rg = util.by_pixel(1, -5),  b = util.by_pixel(5, -7) },
            { rg = util.by_pixel(0, -6),  b = util.by_pixel(0, -9) },
            { rg = util.by_pixel(-2, -5), b = util.by_pixel(-5, -7) },
            { rg = util.by_pixel(-5, -2), b = util.by_pixel(-9, 0) },
            { rg = util.by_pixel(-3, 0),  b = util.by_pixel(-6, 3) },
            { rg = util.by_pixel(0, 0),   b = util.by_pixel(0, 5) },
            { rg = util.by_pixel(4, -1),  b = util.by_pixel(7, 3) },
            { rg = util.by_pixel(5, -3),  b = util.by_pixel(9, -1) },
            { rg = util.by_pixel(-5, -3), b = util.by_pixel(-9, -1) },
            { rg = util.by_pixel(0, 0),   b = util.by_pixel(0, 5) },
            { rg = util.by_pixel(5, -2),  b = util.by_pixel(9, 0) },
            { rg = util.by_pixel(-6, 0),  b = util.by_pixel(-8, 2) },
            { rg = util.by_pixel(-4, 2),  b = util.by_pixel(-5, 7) },
            { rg = util.by_pixel(0, 3),   b = util.by_pixel(0, 8) },
            { rg = util.by_pixel(5, 2),   b = util.by_pixel(6, 6) },
            { rg = util.by_pixel(6, -1),  b = util.by_pixel(8, 1) },
            { rg = util.by_pixel(-6, -1), b = util.by_pixel(-8, 1) },
            { rg = util.by_pixel(0, 3),   b = util.by_pixel(0, 8) },
            { rg = util.by_pixel(6, 0),   b = util.by_pixel(8, 2) },
            { rg = util.by_pixel(-6, 1),  b = util.by_pixel(-6, 5) },
            { rg = util.by_pixel(-4, 5),  b = util.by_pixel(-3, 8) },
            { rg = util.by_pixel(0, 6),   b = util.by_pixel(0, 9) },
            { rg = util.by_pixel(5, 4),   b = util.by_pixel(4, 7) },
            { rg = util.by_pixel(6, 1),   b = util.by_pixel(6, 4) },
            { rg = util.by_pixel(-6, 1),  b = util.by_pixel(-6, 5) },
            { rg = util.by_pixel(0, 6),   b = util.by_pixel(0, 9) },
            { rg = util.by_pixel(6, 1),   b = util.by_pixel(6, 4) },
            { rg = util.by_pixel(-2, -4), b = util.by_pixel(-6, -5) },
            { rg = util.by_pixel(-1, -3), b = util.by_pixel(-6, -2) },
            { rg = util.by_pixel(0, -3),  b = util.by_pixel(-3, 0) },
            { rg = util.by_pixel(1, -3),  b = util.by_pixel(4, 0) },
            { rg = util.by_pixel(2, -4),  b = util.by_pixel(6, -2) },
            { rg = util.by_pixel(1, -5),  b = util.by_pixel(6, -6) },
            { rg = util.by_pixel(0, -6),  b = util.by_pixel(2, -8) },
            { rg = util.by_pixel(-1, -5), b = util.by_pixel(-4, -8) },
        }
    }

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
        integration_patch         = get_transformator_picture(1),
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
        close_sound               = {
            filename = "__base__/sound/machine-close.ogg",
            volume = 0.5
        },
        circuit_wire_max_distance = constants.EG_MAX_WIRE_TRANSFORMATOR,
        circuit_connector         = circuit_connector_definitions.create_vector(
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
