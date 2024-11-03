-- Electric Infinity Pipe Definition
local eg_infinity_pipe = {
    type = "infinity-pipe",
    name = "eg-infinity-pipe",
    icon = "__base__/graphics/icons/pipe.png", -- Custom icon if desired
    gui_mode = "all",
    max_health = 200,
    corpse = "small-remnants",
    collision_box = {
        { -0.29, -0.29 },
        { 0.29,  0.29 }
    },
    horizontal_window_bounding_box = {
        { -0.25, -0.28125 },
        { 0.25,  0.15625 }
    },
    vertical_window_bounding_box = {
        { -0.28125, -0.5 },
        { 0.03125,  0.125 }
    },
    fluid_box = {
        hide_connection_info = true,
        filter = "water",
        pipe_connections = {
            {
                direction = 0,
                position = { 0, 0 }
            },
            {
                direction = 4,
                position = { 0, 0 }
            },
            {
                direction = 8,
                position = { 0, 0 }
            },
            {
                direction = 12,
                position = { 0, 0 }
            }
        },
        production_type = "output",
        volume = 100
    }
}

data:extend({ eg_infinity_pipe })
