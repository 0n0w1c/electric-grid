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
    flags = constants.EG_INTERNAL_ENTITY_FLAGS,
    localised_name = {"", "Infinity Pipe"},
    localised_description = {"", "Component of a Transformator"},
    collision_box = {
        { -0.5, -0.5 },
        { 0.5,  0.5 }
    },
    --    selection_box = {
    --        { -0.5, -0.5 },
    --        { 0.5,  0.5 }
    --    },
    horizontal_window_bounding_box = {
        { 0, 0 },
        { 0, 0 }
    },
    vertical_window_bounding_box = {
        { 0, 0 },
        { 0, 0 }
    },
    fluid_box = {
        hide_connection_info = true,
        max_pipeline_extent = 2,
        pipe_connections = {
            {
                direction = defines.direction.north,
                position = { 0, 0 }
            },
            {
                direction = defines.direction.east,
                position = { 0, 0 }
            },
            {
                direction = defines.direction.south,
                position = { 0, 0 }
            },
            {
                direction = defines.direction.west,
                position = { 0, 0 }
            }
        },
        production_type = "output",
        volume = 100
    }
}

data:extend({ eg_infinity_pipe })
