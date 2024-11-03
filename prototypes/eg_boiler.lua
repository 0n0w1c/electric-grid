-- Electric Boiler Definition

local eg_boiler = {
    type = "boiler",
    name = "eg-boiler",
    icon = "__base__/graphics/icons/boiler.png",
    energy_consumption = "1.8MW",
    energy_source = {
        type = "electric",
        buffer_capacity = "1.8MJ",  -- Buffer capacity matching one second of consumption
        input_flow_limit = "1.8MW", -- Maximum input flow
        usage_priority = "secondary-input",
        emissions_per_minute = { pollution = 0 }
    },
    energy_usage = "51.5MW",  -- Energy to heat water from 15°C to 515°C
    target_temperature = 515, -- Target temperature for the heated water
    burning_cooldown = 20,
    fluid_box = {
        filter = "water",
        hide_connection_info = true,
        pipe_connections = {
            {
                direction = 12,
                flow_direction = "input-output",
                position = {
                    0.39000000000000004,
                    0
                }
            },
            {
                direction = 4,
                flow_direction = "input-output",
                position = {
                    -0.39000000000000004,
                    0
                }
            }
        },
        production_type = "input",
        volume = 200,
    },
    mode = "output-to-separate-pipe",
    output_fluid_box = {
        filter = "steam",
        hide_connection_info = true,
        pipe_connections = {
            {
                direction = 0,
                flow_direction = "output",
                position = { 0, -0.4 }
            }
        },
        production_type = "output",
        volume = 200
    },
    minable = { mining_time = 0.3, result = "eg-boiler" },
    collision_box = {
        { -0.4, -0.4 },
        { 0.4,  0.4 }
    }
}

local eg_boiler_item = {
    type = "item",
    name = "eg-boiler",
    icon = "__base__/graphics/icons/boiler.png", -- Custom icon if desired
    place_result = "eg-boiler",
    stack_size = 50
}

local eg_boiler_recipe = {
    type = "recipe",
    name = "eg-boiler",
    enabled = true,
    ingredients = {
        { type = "item", name = "boiler",             amount = 1 },
        { type = "item", name = "electronic-circuit", amount = 5 }
    },
    results = {
        { type = "item", name = "eg-boiler", amount = 1 }
    }
}

data:extend({ eg_boiler, eg_boiler_item, eg_boiler_recipe })
