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
    localised_name = { "", "Infinity pipe" },
    localised_description = { "", "Component of a Transformator" },
    collision_mask = { layers = {} },
    --collision_mask = {
    --    layers = {
    --        ["is_lower_object"] = true
    --    }
    --},
    collision_box = {
        { -0.49, -0.49 },
        { 0.49,  0.49 }
    },
    selection_box = {
        { -0.49, -0.49 },
        { 0.49,  0.49 }
    },
    horizontal_window_bounding_box = {
        { 0, 0 },
        { 0, 0 }
    },
    vertical_window_bounding_box = {
        { 0, 0 },
        { 0, 0 }
    },
    fluid_box = {
        hide_connection_info = not constants.EG_DEBUG_TRANSFORMATOR,
        production_type = "output",
        volume = 200,
        pipe_connections = {
            {
                connection_category = "eg-guts-category",
                direction = defines.direction.north,
                position = { 0, 0 }
            },
            {
                connection_category = "eg-guts-category",
                direction = defines.direction.east,
                position = { 0, 0 }
            },
            {
                connection_category = "eg-guts-category",
                direction = defines.direction.south,
                position = { 0, 0 }
            },
            {
                connection_category = "eg-guts-category",
                direction = defines.direction.west,
                position = { 0, 0 }
            }
        }
    }
}

data:extend({ eg_infinity_pipe })
