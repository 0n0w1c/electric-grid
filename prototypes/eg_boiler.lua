function create_transformator_boiler(variant, tier)
    local rating = constants.EG_TRANSFORMATORS["eg-unit-" .. tier].rating

    local alert_icon_shift = { x = 0.0, y = 0.0 }

    if variant == "n" then
        alert_icon_shift = { x = 0.5, y = -0.5 }
    elseif variant == "e" then
        alert_icon_shift = { x = 0.5, y = 0.5 }
    elseif variant == "s" then
        alert_icon_shift = { x = -0.5, y = 0.5 }
    elseif variant == "w" then
        alert_icon_shift = { x = -0.5, y = -0.5 }
    end

    return {
        type = "boiler",
        name = "eg-boiler-" .. variant .. "-" .. tier,
        icon = "__base__/graphics/icons/boiler.png",
        icon_size = 64,
        energy_consumption = rating,
        target_temperature = 165,
        max_health = constants.EG_MAX_HEALTH,
        hidden = true,
        minable = nil,
        selectable_in_game = false,
        flags = constants.EG_INTERNAL_ENTITY_FLAGS,
        localised_name = { "", "Boiler - Tier ", tostring(tier) },
        localised_description = { "", "Component of a Transformator rated for ", rating, " of power output." },
        alert_icon_shift = alert_icon_shift,
        energy_source = {
            type = "electric",
            buffer_capacity = "0kJ",
            input_flow_limit = rating,
            usage_priority = "secondary-input",
            emissions = 0
        },
        mode = "output-to-separate-pipe",
        burning_cooldown = 0,
        collision_mask = {
            layers = {
                ["is_lower_object"] = true
            }
        },
        collision_box = {
            { -0.49, -0.49 },
            { 0.49,  0.49 }
        },
        --selection_box = {
        --    { -0.49, -0.49 },
        --    { 0.49,  0.49 }
        --},
        selection_box = {
            { -0.49, -1.49 },
            { 1.49,  0.49 }
        },
        fluid_box = {
            filter = "eg-water-" .. tier,
            hide_connection_info = true,
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
            hide_connection_info = true,
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
