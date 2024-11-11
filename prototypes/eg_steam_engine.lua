function create_transformator_steam_engine(variant, tier)
    local rating = constants.EG_TRANSFORMATORS["eg-unit-" .. tier].rating

    local selection_box = {
        { -0.49, -0.49 },
        { 0.49,  0.49 }
    }

    if variant == "ne" then
        selection_box = {
            { -0.49, -0.49 },
            { 1.49,  1.49 }
        }
    elseif variant == "sw" then
        selection_box = {
            { -1.49, -1.49 },
            { 0.49,  0.49 }
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
        localised_name = { "", "Steam engine ", variant:upper(), " - Tier ", tostring(tier) },
        localised_description = { "", "Component of a Transformator rated for ", rating, " of power output." },
        collision_mask = {
            layers = {
                ["is_lower_object"] = true
            }
        },
        collision_box = {
            { -0.49, -0.49 },
            { 0.49,  0.49 }
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
            volume = 200,
            pipe_connections = {
                {
                    connection_category = "eg-guts-category",
                    direction = defines.direction.north,
                    flow_direction = "input-output",
                    position = { 0, 0 }
                },
                {
                    connection_category = "eg-guts-category",
                    direction = defines.direction.south,
                    flow_direction = "input-output",
                    position = { 0, 0 }
                }
            }
        },
        working_sound = {
            match_speed_to_activity = true,
            sound = {
                filename = constants.EG_SOUND .. "/MainsBrum50Hz.ogg",
                volume = constants.EG_VOLUME or 0,
            },
        },
    }
end
