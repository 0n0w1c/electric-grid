local constants = {}

constants.EG_MOD = "__electric-grid__"
constants.EG_GRAPHICS = constants.EG_MOD .. "/graphics"
constants.EG_SOUND = constants.EG_MOD .. "/sound"

function constants.EG_TRANSFORMATOR_DISPLAYER_PICTURES()
    return {
        layers = {
            {
                filename = constants.EG_GRAPHICS .. "/entities/trafo-sprites.png",
                width = 233,
                height = 155,
                shift = { 2.6, -0.45 },
                scale = 0.5,
                variation_count = 4, -- 4 variations for the 4 directions
                apply_runtime_tint = false,
                draw_as_sprite = true
            },
            {
                filename = constants.EG_GRAPHICS .. "/entities/trafo-arrows.png",
                width = 233,
                height = 155,
                shift = { 2.6, -0.45 },
                scale = 0.5,
                variation_count = 4, -- 4 variations for the 4 directions
                apply_runtime_tint = false,
                draw_as_sprite = true,
                blend_mode = "additive"
            }
        }
    }
end

return constants
