local eg_transformator_displayer = {
    type = "simple-entity-with-force",
    name = "eg-transformator-displayer",
    icon = constants.EG_GRAPHICS .. "/entities/trafo-sprites.png",
    icon_size = 64,
    flags = { "placeable-player", "player-creation" },
    minable = { mining_time = 0.5, result = "eg-transformator-item" },
    max_health = 200,
    collision_box = { { -0.7, -1.7 }, { 0.7, 1.7 } },
    selection_box = { { -0.9, -1.9 }, { 0.9, 1.9 } },
    drawing_box = { { -1.0, -3.0 }, { 1.0, 2.0 } },
    picture = constants.EG_TRANSFORMATOR_DISPLAYER_PICTURES(), -- use picture not pictures, rotation works
    direction_count = 4
}

local eg_transformator_item = {
    type = "item",
    name = "eg-transformator-item",
    icon = constants.EG_GRAPHICS .. "/icons/trafo.png",
    icon_size = 32,
    subgroup = "energy-pipe-distribution",
    order = "b[pipe]-d[eg-transformator-item]",
    place_result = "eg-transformator-displayer",
    stack_size = 50,
}

local eg_transformator_recipe = {
    type = "recipe",
    name = "eg-transformator-item",
    ingredients = {
        { type = "item", name = "boiler", amount = 1 },
    },
    results = {
        { type = "item", name = "eg-transformator-item", amount = 1 }
    },
    enabled = true
}

data:extend({ eg_transformator_displayer, eg_transformator_item, eg_transformator_recipe })
