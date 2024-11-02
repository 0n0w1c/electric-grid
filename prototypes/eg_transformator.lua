local boiler_prototype = data.raw["boiler"]["boiler"]

local eg_transformator_displayer = {
    type = "simple-entity-with-force",
    name = "eg-transformator-displayer",
    icon = constants.EG_GRAPHICS .. "/entities/trafo-sprites.png",
    icon_size = 64,
    flags = { "placeable-neutral", "player-creation" },
    minable = { mining_time = 0.5, result = "eg-transformator-item" },
    max_health = 200,
    collision_box = { { -0.9, -0.9 }, { 0.9, 0.9 } },
    selection_box = { { -1, -1 }, { 1, 1 } },
    pictures = constants.EG_TRANSFORMATOR_DISPLAYER_PICTURES(),
    direction_count = 4
}

local eg_transformator_item = {
    type = "item",
    name = "eg-transformator-item",
    icon = boiler_prototype.icon,
    icon_size = boiler_prototype.icon_size,
    subgroup = "energy-pipe-distribution",
    order = "b[pipe]-d[eg-transformator-item]",
    place_result = "eg-transformator-displayer",
    stack_size = 50,
}

local eg_transformator_recipe = {
    type = "recipe",
    name = "eg-transformator-item",
    ingredients = {
        { type = "item", name = "eg-boiler",        amount = 1 },
        { type = "item", name = "eg-infinity-pipe", amount = 1 }
    },
    results = {
        { type = "item", name = "eg-transformator-item", amount = 1 }
    },
    enabled = true
}

data:extend({ eg_transformator_displayer, eg_transformator_item, eg_transformator_recipe })
