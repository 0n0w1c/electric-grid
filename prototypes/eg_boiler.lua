-- Electric Boiler Definition

local eg_boiler = {
    type = "boiler",
    name = "eg-boiler",
    icon = "__base__/graphics/icons/boiler.png",
    energy_consumption = "1.8MW",

    energy_source = {
        type = "electric",
        buffer_capacity = "1.8MJ",  -- Buffer capacity matching one second of consumption
        input_flow_limit = "1.8MW", -- Maximum input flow
        usage_priority = "secondary-input",
        emissions_per_minute = { pollution = 0 }
    },
    energy_usage = "51.5MW",  -- Energy to heat water from 15°C to 515°C
    target_temperature = 515, -- Target temperature for the heated water
    burning_cooldown = 20,
    fluid_box = {
        filter = "water",
        pipe_connections = {
            {
                direction = 12,
                flow_direction = "input-output",
                position = {
                    0.39000000000000004,
                    0
                }
            },
            {
                direction = 4,
                flow_direction = "input-output",
                position = {
                    -0.39000000000000004,
                    0
                }
            }
        },
        production_type = "input",
        volume = 200,
    },
    mode = "output-to-separate-pipe",
    open_sound = {
        filename = "__base__/sound/open-close/steam-open.ogg",
        scale = 0.11111111111111112,
        volume = 0.56999999999999993
    },
    output_fluid_box = {
        filter = "steam",
        pipe_connections = {
            {
                direction = 0,
                flow_direction = "output",
                position = { 0, -0.4 }
            }
        },
        production_type = "output",
        volume = 200
    },
    minable = { mining_time = 0.3, result = "eg-boiler" },
    collision_box = {
        { -0.4, -0.4 },
        { 0.4,  0.4 }
    },
    pictures = {
        east = {
            fire = {
                animation_speed = 0.5,
                draw_as_glow = true,
                filename = "__base__/graphics/entity/boiler/boiler-E-fire.png",
                frame_count = 64,
                height = 28,
                line_length = 8,
                priority = "extra-high",
                scale = 0.16666666666666665,
                shift = {
                    -0.098958333333333321,
                    -0.22916666666666665
                },
                width = 28
            },
            fire_glow = {
                blend_mode = "additive",
                draw_as_glow = true,
                filename = "__base__/graphics/entity/boiler/boiler-E-light.png",
                height = 244,
                priority = "extra-high",
                scale = 0.16666666666666665,
                shift = {
                    0.0026041666666666661,
                    -0.13541666666666665
                },
                width = 139
            },
            patch = {
                filename = "__base__/graphics/entity/boiler/boiler-E-patch.png",
                height = 36,
                scale = 0.16666666666666665,
                shift = {
                    0.3489583333333333,
                    -0.140625
                },
                width = 6
            },
            structure = {
                layers = {
                    {
                        filename = "__base__/graphics/entity/boiler/boiler-E-idle.png",
                        height = 301,
                        priority = "extra-high",
                        scale = 0.16666666666666665,
                        shift = {
                            -0.03125,
                            0.01302083333333333
                        },
                        width = 216
                    },
                    {
                        draw_as_shadow = true,
                        filename = "__base__/graphics/entity/boiler/boiler-E-shadow.png",
                        height = 194,
                        priority = "extra-high",
                        scale = 0.16666666666666665,
                        shift = {
                            0.3125,
                            0.098958333333333321
                        },
                        width = 184
                    }
                }
            }
        },
        north = {
            fire = {
                animation_speed = 0.5,
                draw_as_glow = true,
                filename = "__base__/graphics/entity/boiler/boiler-N-fire.png",
                frame_count = 64,
                height = 26,
                line_length = 8,
                priority = "extra-high",
                scale = 0.16666666666666665,
                shift = {
                    0,
                    -0.088541666666666643
                },
                width = 26
            },
            fire_glow = {
                blend_mode = "additive",
                draw_as_glow = true,
                filename = "__base__/graphics/entity/boiler/boiler-N-light.png",
                height = 173,
                priority = "extra-high",
                scale = 0.16666666666666665,
                shift = {
                    -0.010416666666666665,
                    -0.0703125
                },
                width = 200
            },
            structure = {
                layers = {
                    {
                        filename = "__base__/graphics/entity/boiler/boiler-N-idle.png",
                        height = 221,
                        priority = "extra-high",
                        scale = 0.16666666666666665,
                        shift = {
                            -0.01302083333333333,
                            0.0546875
                        },
                        width = 269
                    },
                    {
                        draw_as_shadow = true,
                        filename = "__base__/graphics/entity/boiler/boiler-N-shadow.png",
                        height = 164,
                        priority = "extra-high",
                        scale = 0.16666666666666665,
                        shift = {
                            0.21354166666666665,
                            0.09375
                        },
                        width = 274
                    }
                }
            }
        },
        south = {
            fire = {
                animation_speed = 0.5,
                draw_as_glow = true,
                filename = "__base__/graphics/entity/boiler/boiler-S-fire.png",
                frame_count = 64,
                height = 16,
                line_length = 8,
                priority = "extra-high",
                scale = 0.16666666666666665,
                shift = {
                    -0.010416666666666665,
                    -0.27604166666666661
                },
                width = 26
            },
            fire_glow = {
                blend_mode = "additive",
                draw_as_glow = true,
                filename = "__base__/graphics/entity/boiler/boiler-S-light.png",
                height = 162,
                priority = "extra-high",
                scale = 0.16666666666666665,
                shift = {
                    0.010416666666666665,
                    0.057291666666666661
                },
                width = 200
            },
            structure = {
                layers = {
                    {
                        filename = "__base__/graphics/entity/boiler/boiler-S-idle.png",
                        height = 192,
                        priority = "extra-high",
                        scale = 0.16666666666666665,
                        shift = {
                            0.041666666666666661,
                            0.13541666666666665
                        },
                        width = 260
                    },
                    {
                        draw_as_shadow = true,
                        filename = "__base__/graphics/entity/boiler/boiler-S-shadow.png",
                        height = 131,
                        priority = "extra-high",
                        scale = 0.16666666666666665,
                        shift = {
                            0.3098958333333333,
                            0.1640625
                        },
                        width = 311
                    }
                }
            }
        },
        west = {
            fire = {
                animation_speed = 0.5,
                draw_as_glow = true,
                filename = "__base__/graphics/entity/boiler/boiler-W-fire.png",
                frame_count = 64,
                height = 29,
                line_length = 8,
                priority = "extra-high",
                scale = 0.16666666666666665,
                shift = {
                    0.13541666666666665,
                    -0.2421875
                },
                width = 30
            },
            fire_glow = {
                blend_mode = "additive",
                draw_as_glow = true,
                filename = "__base__/graphics/entity/boiler/boiler-W-light.png",
                height = 217,
                priority = "extra-high",
                scale = 0.16666666666666665,
                shift = {
                    0.02083333333333333,
                    -0.065104166666666652
                },
                width = 136
            },
            structure = {
                layers = {
                    {
                        filename = "__base__/graphics/entity/boiler/boiler-W-idle.png",
                        height = 273,
                        priority = "extra-high",
                        scale = 0.16666666666666665,
                        shift = {
                            0.015625,
                            0.080729166666666643
                        },
                        width = 196
                    },
                    {
                        draw_as_shadow = true,
                        filename = "__base__/graphics/entity/boiler/boiler-W-shadow.png",
                        height = 218,
                        priority = "extra-high",
                        scale = 0.16666666666666665,
                        shift = {
                            0.203125,
                            0.067708333333333313
                        },
                        width = 206
                    }
                }
            }
        }
    },
}

local eg_boiler_item = {
    type = "item",
    name = "eg-boiler",
    icon = "__base__/graphics/icons/boiler.png", -- Custom icon if desired
    place_result = "eg-boiler",
    stack_size = 50
}

local eg_boiler_recipe = {
    type = "recipe",
    name = "eg-boiler",
    enabled = true,
    ingredients = {
        { type = "item", name = "boiler",             amount = 1 },
        { type = "item", name = "electronic-circuit", amount = 5 }
    },
    results = {
        { type = "item", name = "eg-boiler", amount = 1 }
    }
}

data:extend({ eg_boiler, eg_boiler_item, eg_boiler_recipe })
