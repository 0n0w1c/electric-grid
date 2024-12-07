function create_transformator_pump()
    local collision_box = { { -0.49, -0.49 }, { 0.49, 0.49 } }
    local selection_box = { { -1.49, -0.49 }, { 0.49, 0.49 } }
    --local selection_box = { { -0.49, -0.49 }, { 0.49,  0.49 } }

    return {
        type                      = "pump",
        name                      = "eg-pump",
        icon                      = constants.EG_GRAPHICS .. "/technologies/tier-1.png",
        icon_size                 = 128,
        max_health                = constants.EG_MAX_HEALTH,
        hidden                    = false,
        hidden_in_factoriopedia   = true,
        selectable_in_game        = true,
        flags                     = constants.EG_INTERNAL_ENTITY_FLAGS,
        alert_icon_scale          = 0,
        minable                   = nil,
        collision_mask            = { layers = {} },
        selection_box             = selection_box,
        collision_box             = collision_box,
        localised_name            = { "", "Transformator" },
        localised_description     = { "", "Transformator" },
        pumping_speed             = 1,
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
        circuit_wire_max_distance = 9,
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
