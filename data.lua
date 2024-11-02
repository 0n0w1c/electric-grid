constants = require("constants")

require("./prototypes/eg_boiler")
require("./prototypes/eg_infinity_pipe")
require("./prototypes/eg_transformator")

--[[
boiler = {
    boiler = {
        burning_cooldown = 20,
        close_sound = {
            filename = "__base__/sound/open-close/steam-close.ogg",
            scale = 0.11111111111111112,
            volume = 0.5
        },
        collision_box = {
            {
                -0.4,
                -0.4
            },
            {
                0.4,
                0.4
            }
        },
        corpse = "boiler-remnants",
        damaged_trigger_effect = {
            damage_type_filters = "fire",
            entity_name = "spark-explosion",
            offset_deviation = {
                {
                    -0.5,
                    -0.5
                },
                {
                    0.5,
                    0.5
                }
            },
            offsets = {
                {
                    0,
                    1
                }
            },
            type = "create-entity"
        },
        dying_explosion = "boiler-explosion",
        energy_consumption = "1.8MW",

        energy_source = {
            type = "electric",
            buffer_capacity = "1.8MJ",  -- Buffer capacity matching one second of consumption
            input_flow_limit = "1.8MW", -- Maximum input flow
            usage_priority = "secondary-input",
            emissions_per_minute = {
                pollution = 30
            }
        },
        fuel_inventory_size = 1,
        light_flicker = {
            color = {
                0,
                0,
                0
            },
            maximum_intensity = 0.95,
            minimum_intensity = 0.6
        },
        smoke = {
            {
                east_position = {
                    0.625,
                    -2.1875
                },
                frequency = 15,
                name = "smoke",
                north_position = {
                    -1.1875,
                    -1.484375
                },
                south_position = {
                    1.203125,
                    -1
                },
                starting_frame_deviation = 60,
                starting_vertical_speed = 0,
                west_position = {
                    -0.59375,
                    -0.265625
                }
            }
        },
        type = "burner"
    },
    fast_replaceable_group = "boiler",
    fire_flicker_enabled = true,
    fire_glow_flicker_enabled = true,
    flags = {
        "placeable-neutral",
        "player-creation"
    },
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
        pipe_covers = {
            east = {
                layers = {
                    {
                        filename = "__base__/graphics/entity/pipe-covers/pipe-cover-east.png",
                        height = 128,
                        priority = "extra-high",
                        scale = 0.5,
                        width = 128
                    },
                    {
                        draw_as_shadow = true,
                        filename = "__base__/graphics/entity/pipe-covers/pipe-cover-east-shadow.png",
                        height = 128,
                        priority = "extra-high",
                        scale = 0.5,
                        width = 128
                    }
                }
            },
            north = {
                layers = {
                    {
                        filename = "__base__/graphics/entity/pipe-covers/pipe-cover-north.png",
                        height = 128,
                        priority = "extra-high",
                        scale = 0.5,
                        width = 128
                    },
                    {
                        draw_as_shadow = true,
                        filename = "__base__/graphics/entity/pipe-covers/pipe-cover-north-shadow.png",
                        height = 128,
                        priority = "extra-high",
                        scale = 0.5,
                        width = 128
                    }
                }
            },
            south = {
                layers = {
                    {
                        filename = "__base__/graphics/entity/pipe-covers/pipe-cover-south.png",
                        height = 128,
                        priority = "extra-high",
                        scale = 0.5,
                        width = 128
                    },
                    {
                        draw_as_shadow = true,
                        filename = "__base__/graphics/entity/pipe-covers/pipe-cover-south-shadow.png",
                        height = 128,
                        priority = "extra-high",
                        scale = 0.5,
                        width = 128
                    }
                }
            },
            west = {
                layers = {
                    {
                        filename = "__base__/graphics/entity/pipe-covers/pipe-cover-west.png",
                        height = 128,
                        priority = "extra-high",
                        scale = 0.5,
                        width = 128
                    },
                    {
                        draw_as_shadow = true,
                        filename = "__base__/graphics/entity/pipe-covers/pipe-cover-west-shadow.png",
                        height = 128,
                        priority = "extra-high",
                        scale = 0.5,
                        width = 128
                    }
                }
            }
        },
        production_type = "input",
        volume = 200
    },
    icon = "__base__/graphics/icons/boiler.png",
    impact_category = "metal-large",
    max_health = 200,
    minable = {
        mining_time = 0.2,
        result = "boiler"
    },
    mode = "output-to-separate-pipe",
    name = "boiler",
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
                position = {
                    0,
                    -0.4
                }
            }
        },
        pipe_covers = {
            east = {
                layers = {
                    {
                        filename = "__base__/graphics/entity/pipe-covers/pipe-cover-east.png",
                        height = 128,
                        priority = "extra-high",
                        scale = 0.16666666666666665,
                        width = 128
                    },
                    {
                        draw_as_shadow = true,
                        filename = "__base__/graphics/entity/pipe-covers/pipe-cover-east-shadow.png",
                        height = 128,
                        priority = "extra-high",
                        scale = 0.16666666666666665,
                        width = 128
                    }
                }
            },
            north = {
                layers = {
                    {
                        filename = "__base__/graphics/entity/pipe-covers/pipe-cover-north.png",
                        height = 128,
                        priority = "extra-high",
                        scale = 0.16666666666666665,
                        width = 128
                    },
                    {
                        draw_as_shadow = true,
                        filename = "__base__/graphics/entity/pipe-covers/pipe-cover-north-shadow.png",
                        height = 128,
                        priority = "extra-high",
                        scale = 0.16666666666666665,
                        width = 128
                    }
                }
            },
            south = {
                layers = {
                    {
                        filename = "__base__/graphics/entity/pipe-covers/pipe-cover-south.png",
                        height = 128,
                        priority = "extra-high",
                        scale = 0.16666666666666665,
                        width = 128
                    },
                    {
                        draw_as_shadow = true,
                        filename = "__base__/graphics/entity/pipe-covers/pipe-cover-south-shadow.png",
                        height = 128,
                        priority = "extra-high",
                        scale = 0.16666666666666665,
                        width = 128
                    }
                }
            },
            west = {
                layers = {
                    {
                        filename = "__base__/graphics/entity/pipe-covers/pipe-cover-west.png",
                        height = 128,
                        priority = "extra-high",
                        scale = 0.16666666666666665,
                        width = 128
                    },
                    {
                        draw_as_shadow = true,
                        filename = "__base__/graphics/entity/pipe-covers/pipe-cover-west-shadow.png",
                        height = 128,
                        priority = "extra-high",
                        scale = 0.16666666666666665,
                        width = 128
                    }
                }
            }
        },
        production_type = "output",
        volume = 200
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
    resistances = {
        {
            percent = 90,
            type = "fire"
        },
        {
            percent = 30,
            type = "explosion"
        },
        {
            percent = 30,
            type = "impact"
        }
    },
    scale_entity_info_icon = true,
    selection_box = {
        {
            -0.5,
            -0.5
        },
        {
            0.5,
            0.5
        }
    },
    surface_conditions = {
        {
            min = 10,
            property = "pressure"
        }
    },
    target_temperature = 165,
    type = "boiler",
    water_reflection = {
        orientation_to_variation = true,
        pictures = {
            filename = "__base__/graphics/entity/boiler/boiler-reflection.png",
            height = 32,
            priority = "extra-high",
            scale = 1.6666666666666665,
            shift = {
                0.052083333333333321,
                0.3125
            },
            variation_count = 4,
            width = 28
        },
        rotate = false
    },
    working_sound = {
        audible_distance_modifier = 0.3,
        fade_in_ticks = 4,
        fade_out_ticks = 20,
        sound = {
            filename = "__base__/sound/boiler.ogg",
            scale = 0.3333333333333333,
            volume = 0.7
        }
    }
}

generator = {
    ["steam-engine"] = {
        close_sound = {
            filename = "__base__/sound/machine-close.ogg",
            scale = 0.0046296296296296289,
            volume = 0.5
        },
        collision_box = {
            {
                -0.4,
                -0.4
            },
            {
                0.4,
                0.4
            }
        },
        corpse = "steam-engine-remnants",
        damaged_trigger_effect = {
            damage_type_filters = "fire",
            entity_name = "spark-explosion",
            offset_deviation = {
                {
                    -0.5,
                    -0.5
                },
                {
                    0.5,
                    0.5
                }
            },
            offsets = {
                {
                    0,
                    1
                }
            },
            type = "create-entity"
        },
        dying_explosion = "steam-engine-explosion",
        effectivity = 1,
        energy_source = {
            type = "electric",
            usage_priority = "secondary-output"
        },
        fast_replaceable_group = "steam-engine",
        flags = {
            "placeable-neutral",
            "player-creation"
        },
        fluid_box = {
            filter = "steam",
            minimum_temperature = 100,
            pipe_connections = {
                {
                    direction = 8,
                    flow_direction = "input-output",
                    position = {
                        0,
                        0.4
                    }
                },
                {
                    direction = 0,
                    flow_direction = "input-output",
                    position = {
                        0,
                        -0.4
                    }
                }
            },
            pipe_covers = {
                east = {
                    layers = {
                        {
                            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-east.png",
                            height = 128,
                            priority = "extra-high",
                            scale = 0.5,
                            width = 128
                        },
                        {
                            draw_as_shadow = true,
                            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-east-shadow.png",
                            height = 128,
                            priority = "extra-high",
                            scale = 0.5,
                            width = 128
                        }
                    }
                },
                north = {
                    layers = {
                        {
                            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-north.png",
                            height = 128,
                            priority = "extra-high",
                            scale = 0.5,
                            width = 128
                        },
                        {
                            draw_as_shadow = true,
                            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-north-shadow.png",
                            height = 128,
                            priority = "extra-high",
                            scale = 0.5,
                            width = 128
                        }
                    }
                },
                south = {
                    layers = {
                        {
                            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-south.png",
                            height = 128,
                            priority = "extra-high",
                            scale = 0.5,
                            width = 128
                        },
                        {
                            draw_as_shadow = true,
                            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-south-shadow.png",
                            height = 128,
                            priority = "extra-high",
                            scale = 0.5,
                            width = 128
                        }
                    }
                },
                west = {
                    layers = {
                        {
                            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-west.png",
                            height = 128,
                            priority = "extra-high",
                            scale = 0.5,
                            width = 128
                        },
                        {
                            draw_as_shadow = true,
                            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-west-shadow.png",
                            height = 128,
                            priority = "extra-high",
                            scale = 0.5,
                            width = 128
                        }
                    }
                }
            },
            pipe_covers_frozen = {
                east = {
                    filename = "__space-age__/graphics/entity/frozen/pipe-covers/pipe-cover-east.png",
                    height = 128,
                    priority = "extra-high",
                    scale = 0.5,
                    width = 128
                },
                north = {
                    filename = "__space-age__/graphics/entity/frozen/pipe-covers/pipe-cover-north.png",
                    height = 128,
                    priority = "extra-high",
                    scale = 0.5,
                    width = 128
                },
                south = {
                    filename = "__space-age__/graphics/entity/frozen/pipe-covers/pipe-cover-south.png",
                    height = 128,
                    priority = "extra-high",
                    scale = 0.5,
                    width = 128
                },
                west = {
                    filename = "__space-age__/graphics/entity/frozen/pipe-covers/pipe-cover-west.png",
                    height = 128,
                    priority = "extra-high",
                    scale = 0.5,
                    width = 128
                }
            },
            production_type = "input",
            volume = 200
        },
        fluid_usage_per_tick = 0.5,
        heating_energy = "50kW",
        horizontal_animation = {
            layers = {
                {
                    filename = "__base__/graphics/entity/steam-engine/steam-engine-H.png",
                    frame_count = 32,
                    height = 257,
                    line_length = 8,
                    scale = 0.16666666666666665,
                    shift = {
                        0.010416666666666665,
                        -0.049479166666666661
                    },
                    width = 352
                },
                {
                    draw_as_shadow = true,
                    filename = "__base__/graphics/entity/steam-engine/steam-engine-H-shadow.png",
                    frame_count = 32,
                    height = 160,
                    line_length = 8,
                    scale = 0.16666666666666665,
                    shift = {
                        0.5,
                        0.25
                    },
                    width = 508
                }
            }
        },
        icon = "__base__/graphics/icons/steam-engine.png",
        impact_category = "metal-large",
        max_health = 400,
        maximum_temperature = 165,
        minable = {
            mining_time = 0.3,
            result = "steam-engine"
        },
        name = "steam-engine",
        open_sound = {
            filename = "__base__/sound/machine-open.ogg",
            scale = 0.0046296296296296289,
            volume = 0.5
        },
        perceived_performance = {
            minimum = 0.25,
            performance_to_activity_rate = 2
        },
        resistances = {
            {
                percent = 70,
                type = "fire"
            },
            {
                percent = 30,
                type = "impact"
            }
        },
        scale_entity_info_icon = true,
        selection_box = {
            {
                -0.5,
                -0.5
            },
            {
                0.5,
                0.5
            }
        },
        smoke = {
            {
                east_position = {
                    -0.66666666666666661,
                    -0.66666666666666661
                },
                frequency = 0.3125,
                name = "light-smoke",
                north_position = {
                    0.3,
                    0
                },
                starting_frame_deviation = 60,
                starting_vertical_speed = 0.08
            }
        },
        type = "generator",
        vertical_animation = {
            layers = {
                {
                    filename = "__base__/graphics/entity/steam-engine/steam-engine-V.png",
                    frame_count = 32,
                    height = 391,
                    line_length = 8,
                    scale = 0.16666666666666665,
                    shift = {
                        0.049479166666666661,
                        -0.065104166666666652
                    },
                    width = 225
                },
                {
                    draw_as_shadow = true,
                    filename = "__base__/graphics/entity/steam-engine/steam-engine-V-shadow.png",
                    frame_count = 32,
                    height = 307,
                    line_length = 8,
                    scale = 0.16666666666666665,
                    shift = {
                        0.421875,
                        0.096354166666666643
                    },
                    width = 330
                }
            }
        },
        water_reflection = {
            orientation_to_variation = true,
            pictures = {
                filename = "__base__/graphics/entity/steam-engine/steam-engine-reflection.png",
                height = 44,
                priority = "extra-high",
                repeat_count = 2,
                scale = 5,
                shift = {
                    0,
                    1.71875
                },
                variation_count = 2,
                width = 40
            },
            rotate = false
        },
        working_sound = {
            audible_distance_modifier = 0.8,
            fade_in_ticks = 4,
            fade_out_ticks = 20,
            match_speed_to_activity = true,
            max_sounds_per_type = 3,
            sound = {
                filename = "__base__/sound/steam-engine-90bpm.ogg",
                modifiers = {
                    type = "tips-and-tricks",
                    volume_multiplier = 1.1000000000000001
                },
                speed_smoothing_window_size = 60,
                volume = 0.55
            }
        }
    }
}
]]
