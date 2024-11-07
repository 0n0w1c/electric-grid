-- Electric Infinity Pipe Definition
local eg_infinity_pipe = {
    type = "infinity-pipe",
    name = "eg-infinity-pipe",
    icon = "__base__/graphics/icons/pipe.png",
    gui_mode = "all",
    max_health = constants.EG_MAX_HEALTH,
    corpse = "small-remnants",
    hidden = true,
    minable = nil,
    selectable_in_game = false,
    hidden_in_factoriopedia = true,
    flags = constants.EG_INTERNAL_ENTITY_FLAGS,
    collision_box = {
        { -0.29, -0.29 },
        { 0.29,  0.29 }
    },
    --    selection_box = {
    --        { -0.29, -0.29 },
    --        { 0.29,  0.29 }
    --    },
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
        max_pipeline_extent = 2,
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
