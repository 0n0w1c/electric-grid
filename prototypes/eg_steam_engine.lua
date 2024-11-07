function create_transformator_steam_engine(variant, tier)
    local rating = constants.EG_TRANSFORMATORS["eg-unit-" .. tier].rating

    local selection_box

    -- Set selection box based on direction
    if variant == "ne" then
        selection_box = {
            { -0.5, -0.5 },
            { 1.5,  1.5 }
        }
    elseif variant == "sw" then
        selection_box = {
            { -1.5, -1.5 },
            { 0.5,  0.5 }
        }
    else
        selection_box = {
            { -0.5, -0.5 },
            { 0.5,  0.5 }
        }
    end

    return {
        type = "generator",
        name = "eg-steam-engine-" .. variant .. "-" .. tier,
        energy_production = rating,
        maximum_temperature = 500,
        fluid_usage_per_tick = 1,
        icon = "__base__/graphics/icons/steam-engine.png",
        icon_size = 64,
        impact_category = "metal-large",
        max_health = constants.EG_MAX_HEALTH,
        hidden = true,
        minable = nil,
        selectable_in_game = false,
        flags = constants.EG_INTERNAL_ENTITY_FLAGS,
        collision_box = {
            { -0.5, -0.5 },
            { 0.5,  0.5 }
        },
        selection_box = selection_box,

        effectivity = 1,
        energy_source = {
            type = "electric",
            usage_priority = "secondary-output"
        },
        fluid_box = {
            filter = "eg-steam-" .. tier,
            hide_connection_info = true,
            minimum_temperature = 100,
            production_type = "input",
            volume = 100,
            pipe_connections = {
                {
                    direction = defines.direction.north,
                    flow_direction = "input-output",
                    position = { 0, 0 }
                },
                {
                    direction = defines.direction.south,
                    flow_direction = "input-output",
                    position = { 0, 0 }
                }
            }
        }
    }
end
