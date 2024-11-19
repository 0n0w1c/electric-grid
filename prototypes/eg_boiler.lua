function create_transformator_boiler(variant, tier)
    local rating = constants.EG_TRANSFORMATORS["eg-unit-" .. tier].rating

    local alert_icon_shift = { x = 0.0, y = 0.0 }

    local selection_box
    if variant == defines.direction.north then
        alert_icon_shift = { x = 0.5, y = -0.5 }
        selection_box = {
            { -0.49, -1.49 },
            { 1.49,  0.49 }
        }
    elseif variant == defines.direction.east then
        alert_icon_shift = { x = 0.5, y = 0.5 }
        selection_box = {
            { -0.49, -1.49 },
            { 1.49,  0.49 }
        }
    elseif variant == defines.direction.south then
        alert_icon_shift = { x = -0.5, y = 0.5 }
        selection_box = {
            { -0.49, -1.49 },
            { 1.49,  0.49 }
        }
    elseif variant == defines.direction.west then
        alert_icon_shift = { x = -0.5, y = -0.5 }
        selection_box = {
            { -0.49, -1.49 },
            { 1.49,  0.49 }
        }
    end

    local collision_box = {
        { -0.49, -0.49 },
        { 0.49,  0.49 }
    }

    return {
        type = "boiler",
        name = "eg-boiler-" .. variant .. "-" .. tier,
        icon = "__base__/graphics/icons/boiler.png",
        icon_size = 64,
        energy_consumption = rating,
        target_temperature = 165,
        max_health = constants.EG_MAX_HEALTH,
        hidden = not constants.EG_DEBUG_TRANSFORMATOR,
        minable = nil,
        selectable_in_game = constants.EG_DEBUG_TRANSFORMATOR,
        flags = constants.EG_INTERNAL_ENTITY_FLAGS,
        localised_name = { "", "Boiler - Tier ", tostring(tier) },
        localised_description = { "", "Component of a Transformator rated for ", rating, " of power output." },
        alert_icon_shift = alert_icon_shift,
        energy_source = {
            type = "electric",
            effectivity = constants.EG_EFFICIENCY,
            input_flow_limit = rating,
            usage_priority = "secondary-input",
            emissions = 0
        },
        mode = "output-to-separate-pipe",
        burning_cooldown = 0,
        collision_mask = { layers = {} },
        --collision_mask = {
        --    layers = {
        --        ["is_lower_object"] = true
        --    }
        --},
        selection_box = selection_box,
        collision_box = collision_box,
        fluid_box = {
            filter = "eg-water-" .. tier,
            hide_connection_info = not constants.EG_DEBUG_TRANSFORMATOR,
            pipe_connections = {
                {
                    connection_category = "eg-guts-category",
                    direction = defines.direction.west,
                    flow_direction = "input-output",
                    position = { 0, 0 }
                },
                {
                    connection_category = "eg-guts-category",
                    direction = defines.direction.east,
                    flow_direction = "input-output",
                    position = { 0, 0 }
                }
            },
            production_type = "input",
            volume = 200,
        },
        output_fluid_box = {
            filter = "eg-steam-" .. tier,
            hide_connection_info = not constants.EG_DEBUG_TRANSFORMATOR,
            pipe_connections = {
                {
                    connection_category = "eg-guts-category",
                    direction = defines.direction.north,
                    flow_direction = "output",
                    position = { 0, 0 }
                }
            },
            production_type = "output",
            volume = 200
        }
    }
end
