-- Electric Infinity Pipe Definition
local eg_infinity_pipe = {
    type = "infinity-pipe",
    name = "electric-infinity-pipe",
    icon = "__base__/graphics/icons/pipe.png", -- Custom icon if desired
    gui_mode = "all",
    minable = { mining_time = 0.5, result = "electric-infinity-pipe" },
    placeable_by = { item = "electric-infinity-pipe", count = 1 },
    max_health = 200,
    corpse = "small-remnants",
    resistances = { { type = "fire", percent = 100 } },
    collision_box = {
        { -0.29, -0.29 },
        { 0.29,  0.29 }
    },
    vertical_window_bounding_box = {
        { -0.28125, -0.5 },
        { 0.03125,  0.125 }
    },

    fluid_box = {
        hide_connection_info = true,
        pipe_connections = {
            {
                connection_category = {
                    "default",
                    "fusion-plasma"
                },
                direction = 0,
                position = { 0, 0 }
            },
            {
                connection_category = {
                    "default",
                    "fusion-plasma"
                },
                direction = 4,
                position = { 0, 0 }
            },
            {
                connection_category = {
                    "default",
                    "fusion-plasma"
                },
                direction = 8,
                position = { 0, 0 }
            },
            {
                connection_category = {
                    "default",
                    "fusion-plasma"
                },
                direction = 12,
                position = { 0, 0 }
            }
        },
        volume = 100
    },
    horizontal_window_bounding_box = {
        { -0.25, -0.28125 },
        { 0.25,  0.15625 }
    },
    icon_draw_specification = {
        scale = 0.5
    },
    icons = {
        {
            icon = "__base__/graphics/icons/pipe.png",
            tint = {
                a = 1,
                b = 1,
                g = 0.5,
                r = 1
            }
        }
    },
}

local eg_infinity_pipe_item = {
    type = "item",
    name = "electric-infinity-pipe",
    icon = "__base__/graphics/icons/pipe.png",
    place_result = "electric-infinity-pipe",
    subgroup = "energy-pipe-distribution",
    order = "b[pipe]-c[electric-infinity-pipe]",
    stack_size = 50
}

local eg_infinity_pipe_recipe = {
    type = "recipe",
    name = "electric-infinity-pipe",
    ingredients = {
        { type = "item", name = "iron-plate",         amount = 10 },
        { type = "item", name = "electronic-circuit", amount = 5 }
    },
    results = {
        { type = "item", name = "electric-infinity-pipe", amount = 1 }
    },
    enabled = true
}

data:extend({ eg_infinity_pipe, eg_infinity_pipe_item, eg_infinity_pipe_recipe })
