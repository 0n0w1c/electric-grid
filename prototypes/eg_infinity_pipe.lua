local eg_infinity_pipe = {
    type                           = "infinity-pipe",
    name                           = "eg-infinity-pipe",
    icon                           = constants.EG_ICONS .. "eg-transformator.png",
    icon_size                      = 128,
    gui_mode                       = "all",
    max_health                     = constants.EG_MAX_HEALTH,
    corpse                         = "small-remnants",
    hidden                         = true,
    minable                        = nil,
    selectable_in_game             = false,
    flags                          = constants.EG_INTERNAL_ENTITY_FLAGS,
    localised_name                 = { "entity-name.eg-infinity-pipe" },
    localised_description          = { "entity-description.eg-infinity-pipe" },
    quality_indicator_scale        = 0,
    collision_mask                 = { layers = {} },
    collision_box                  = { { -0.49, -0.49 }, { 0.49, 0.49 } },
    --selection_box = { { -0.49, -0.49 }, { 0.49,  0.49 } },
    horizontal_window_bounding_box = { { 0, 0 }, { 0, 0 } },
    vertical_window_bounding_box   = { { 0, 0 }, { 0, 0 } },
    fluid_box                      = {
        hide_connection_info = not constants.EG_DEBUG_TRANSFORMATOR,
        production_type = "output",
        volume = constants.EG_FLUID_VOLUME,
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

data.extend({ eg_infinity_pipe })
