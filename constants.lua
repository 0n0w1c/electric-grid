local constants = {}

constants.EG_MOD = "__electric-grid__"
constants.EG_GRAPHICS = constants.EG_MOD .. "/graphics"
constants.EG_SOUND = constants.EG_MOD .. "/sound"

--[[
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
]]

function constants.EG_TRANSFORMATOR_DISPLAYER_PICTURES()
    return {
        north = {
            layers = {
                {
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-sprites.png",
                    x = 233,
                    width = 233,
                    height = 155,
                    shift = { 2.6, -0.45 },
                    hr_version = {
                        filename = constants.EG_GRAPHICS .. "/entities/trafo-sprites-hr.png",
                        x = 466,
                        width = 466,
                        height = 310,
                        shift = { 2.6, -0.45 },
                        scale = 0.5,
                    },
                },
                {
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-arrows.png",
                    x = 233,
                    width = 233,
                    height = 155,
                    shift = { 2.6, -0.45 },
                    hr_version = {
                        filename = constants.EG_GRAPHICS .. "/entities/trafo-arrows-hr.png",
                        x = 466,
                        width = 466,
                        height = 310,
                        shift = { 2.6, -0.45 },
                        scale = 0.5,
                    },
                },
            },
        },
        east = {
            layers = {
                {
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-sprites.png",
                    width = 233,
                    height = 155,
                    shift = { 1.5, -1.15 },
                    hr_version = {
                        filename = constants.EG_GRAPHICS .. "/entities/trafo-sprites-hr.png",
                        width = 466,
                        height = 310,
                        shift = { 1.5, -1.15 },
                        scale = 0.5,
                    },
                },
                {
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-arrows.png",
                    width = 233,
                    height = 155,
                    shift = { 1.5, -1.15 },
                    hr_version = {
                        filename = constants.EG_GRAPHICS .. "/entities/trafo-arrows-hr.png",
                        width = 466,
                        height = 310,
                        shift = { 1.5, -1.15 },
                        scale = 0.5,
                    },
                },
            },
        },
        south = {
            layers = {
                {
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-sprites.png",
                    x = 699,
                    width = 233,
                    height = 155,
                    shift = { 2.6, -0.45 },
                    hr_version = {
                        filename = constants.EG_GRAPHICS .. "/entities/trafo-sprites-hr.png",
                        x = 1398,
                        width = 466,
                        height = 310,
                        shift = { 2.6, -0.45 },
                        scale = 0.5,
                    },
                },
                {
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-arrows.png",
                    x = 699,
                    width = 233,
                    height = 155,
                    shift = { 2.6, -0.45 },
                    hr_version = {
                        filename = constants.EG_GRAPHICS .. "/entities/trafo-arrows-hr.png",
                        x = 1398,
                        width = 466,
                        height = 310,
                        shift = { 2.6, -0.45 },
                        scale = 0.5,
                    },
                },
            },
        },
        west = {
            layers = {
                {
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-sprites.png",
                    x = 466,
                    width = 233,
                    height = 155,
                    shift = { 1.5, -1.15 },
                    hr_version = {
                        filename = constants.EG_GRAPHICS .. "/entities/trafo-sprites-hr.png",
                        x = 932,
                        width = 466,
                        height = 310,
                        shift = { 1.5, -1.15 },
                        scale = 0.5,
                    },
                },
                {
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-arrows.png",
                    x = 466,
                    width = 233,
                    height = 155,
                    shift = { 1.5, -1.15 },
                    hr_version = {
                        filename = constants.EG_GRAPHICS .. "/entities/trafo-arrows-hr.png",
                        x = 932,
                        width = 466,
                        height = 310,
                        shift = { 1.5, -1.15 },
                        scale = 0.5,
                    },
                },
            },
        },
    }
end

return constants
