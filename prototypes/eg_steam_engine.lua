local eg_steam_engine = {
    collision_box = {
        { -0.4, -0.4 },
        { 0.4,  0.4 }
    },
    corpse = "steam-engine-remnants",
    damaged_trigger_effect = {
        damage_type_filters = "fire",
        entity_name = "spark-explosion",
        offset_deviation = {
            { -0.5, -0.5 },
            { 0.5,  0.5 }
        },
        offsets = {
            { 0, 1 }
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
                position = { 0, 0.4 }
            },
            {
                direction = 0,
                flow_direction = "input-output",
                position = { 0, -0.4 }
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
        result = "eg-steam-engine"
    },
    name = "eg-steam-engine",
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
        { -0.5, -0.5 },
        { 0.5,  0.5 }
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

local steam_engine_prototype = data.raw["item"]["steam-engine"]

local eg_steam_engine_item = {
    type = "item",
    name = "eg-steam-engine",
    icon = steam_engine_prototype.icon,
    icon_size = steam_engine_prototype.icon_size,
    subgroup = "energy-pipe-distribution",
    order = "b[pipe]-d[eg-steam-engine-item]",
    place_result = "eg-steam-engine",
    stack_size = 50,
}

local eg_steam_engine_recipe = {
    type = "recipe",
    name = "eg-steam-engine",
    ingredients = {
        { type = "item", name = "eg-boiler",        amount = 1 },
        { type = "item", name = "eg-infinity-pipe", amount = 1 }
    },
    results = {
        { type = "item", name = "eg-steam-engine", amount = 1 }
    },
    enabled = true
}

data:extend({ eg_steam_engine, eg_steam_engine_item, eg_steam_engine_recipe })
