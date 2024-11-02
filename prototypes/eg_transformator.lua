local boiler_prototype = data.raw["boiler"]["boiler"]

local eg_transformator_displayer = {
    type = "simple-entity-with-force",
    name = "eg_transformator-displayer",
    icon = constants.EG_GRAPHICS .. "/entities/trafo-sprites.png",
    icon_size = 64,
    flags = { "placeable-neutral", "player-creation" },
    minable = { mining_time = 0.5, result = "eg_transformator-item" },
    max_health = 200,
    collision_box = { { -0.9, -0.9 }, { 0.9, 0.9 } },
    selection_box = { { -1, -1 }, { 1, 1 } },
    pictures = constants.EG_TRANSFORMATOR_DISPLAYER_PICTURES(),
    direction_count = 4
}

data:extend({ eg_transformator_displayer })

-- Define the eg_transformator item
local eg_transformator_item = {
    type = "item",
    name = "eg_transformator-item",
    icon = boiler_prototype.icon,
    icon_size = boiler_prototype.icon_size,
    subgroup = "energy-pipe-distribution",
    order = "b[pipe]-d[eg_transformator-item]",
    place_result = "eg_transformator-displayer",
    stack_size = 50,
}

-- Add eg_transformator entity and item to the game
data:extend({ eg_transformator_item })

local eg_transformator_recipe = {
    type = "recipe",
    name = "eg_transformator-item",
    ingredients = {
        { type = "item", name = "electric-boiler",        amount = 1 },
        { type = "item", name = "electric-infinity-pipe", amount = 1 }
    },
    results = {
        { type = "item", name = "eg_transformator-item", amount = 1 }
    },
    enabled = true
}

data:extend({ eg_transformator_recipe })
