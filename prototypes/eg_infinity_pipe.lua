-- Electric Infinity Pipe Definition
local eg_infinity_pipe = {
    type = "infinity-pipe",
    name = "eg-infinity-pipe",
    icon = "__base__/graphics/icons/pipe.png", -- Custom icon if desired
    gui_mode = "all",
    minable = { mining_time = 0.5, result = "eg-infinity-pipe" },
    placeable_by = { item = "eg-infinity-pipe", count = 1 },
    max_health = 200,
    corpse = "small-remnants",
    resistances = { { type = "fire", percent = 100 } },
    collision_box = {
        { -0.29, -0.29 },
        { 0.29,  0.29 }
    },
    selection_box = {
        { -0.29, -0.29 },
        { 0.29,  0.29 }
    },
    vertical_window_bounding_box = {
        { -0.28125, -0.5 },
        { 0.03125,  0.125 }
    },

    -- Fluid box with water set as default output fluid
    fluid_box = {
        hide_connection_info = true,
        base_area = 1,    -- Determines how much fluid is in the pipe (adjust as needed)
        filter = "water", -- Ensures only water flows through this pipe
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
        production_type = "output", -- Sets this pipe to output mode by default
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
    name = "eg-infinity-pipe",
    icon = "__base__/graphics/icons/pipe.png",
    place_result = "eg-infinity-pipe",
    subgroup = "energy-pipe-distribution",
    order = "b[pipe]-c[eg-infinity-pipe]",
    stack_size = 50
}

local eg_infinity_pipe_recipe = {
    type = "recipe",
    name = "eg-infinity-pipe",
    ingredients = {
        { type = "item", name = "iron-plate",         amount = 10 },
        { type = "item", name = "electronic-circuit", amount = 5 }
    },
    results = {
        { type = "item", name = "eg-infinity-pipe", amount = 1 }
    },
    enabled = true
}

data:extend({ eg_infinity_pipe, eg_infinity_pipe_item, eg_infinity_pipe_recipe })
