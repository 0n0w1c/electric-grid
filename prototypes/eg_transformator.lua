local function get_transformator_picture(tier)
    local altoverlay = {
        north = {
            filename = constants.EG_GRAPHICS .. "/entities/trafo-altoverlay-hr.png",
            x = 466,
            width = 466,
            height = 310,
            shift = { 2.6, -0.45 },
            scale = 0.5,
        },
        east = {
            filename = constants.EG_GRAPHICS .. "/entities/trafo-altoverlay-hr.png",
            width = 466,
            height = 310,
            shift = { 1.5, -1.15 },
            scale = 0.5,
        },
        south = {
            filename = constants.EG_GRAPHICS .. "/entities/trafo-altoverlay-hr.png",
            x = 1398,
            width = 466,
            height = 310,
            shift = { 2.6, -0.45 },
            scale = 0.5,
        },
        west = {
            filename = constants.EG_GRAPHICS .. "/entities/trafo-altoverlay-hr.png",
            x = 932,
            width = 466,
            height = 310,
            shift = { 1.5, -1.15 },
            scale = 0.5,
        },
    }

    local template = {
        north = {
            layers = {
                {
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-sprites-hr.png",
                    x = 466,
                    width = 466,
                    height = 310,
                    shift = { 2.6, -0.45 },
                    scale = 0.5,
                },
                {
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-shadows-hr.png",
                    x = 466,
                    width = 466,
                    height = 310,
                    shift = { 2.6, -0.45 },
                    scale = 0.5,
                    draw_as_shadow = true,
                },
                {
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-mask-hr.png",
                    x = 466,
                    width = 466,
                    height = 310,
                    shift = { 2.6, -0.45 },
                    blend_mode = constants.EG_TIER_BLEND_MODE,
                    tint = constants.EG_TRANSFORMATORS["eg-unit-" .. tier].tint,
                    scale = 0.5,
                },
            },
        },
        east = {
            layers = {
                {
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-sprites-hr.png",
                    width = 466,
                    height = 310,
                    shift = { 1.5, -1.15 },
                    scale = 0.5,
                },
                {
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-shadows-hr.png",
                    width = 466,
                    height = 310,
                    shift = { 1.5, -1.15 },
                    scale = 0.5,
                    draw_as_shadow = true,
                },
                {
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-mask-hr.png",
                    width = 466,
                    height = 310,
                    shift = { 1.5, -1.15 },
                    scale = 0.5,
                    blend_mode = constants.EG_TIER_BLEND_MODE,
                    tint = constants.EG_TRANSFORMATORS["eg-unit-" .. tier].tint,
                },
            },
        },
        south = {
            layers = {
                {
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-sprites-hr.png",
                    x = 1398,
                    width = 466,
                    height = 310,
                    shift = { 2.6, -0.45 },
                    scale = 0.5,
                },
                {
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-shadows-hr.png",
                    x = 1398,
                    width = 466,
                    height = 310,
                    shift = { 2.6, -0.45 },
                    scale = 0.5,
                    draw_as_shadow = true,
                },
                {
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-mask-hr.png",
                    x = 1398,
                    width = 466,
                    height = 310,
                    shift = { 2.6, -0.45 },
                    scale = 0.5,
                    blend_mode = constants.EG_TIER_BLEND_MODE,
                    tint = constants.EG_TRANSFORMATORS["eg-unit-" .. tier].tint,
                },
            },
        },
        west = {
            layers = {
                {
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-sprites-hr.png",
                    x = 932,
                    width = 466,
                    height = 310,
                    shift = { 1.5, -1.15 },
                    scale = 0.5,
                },
                {
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-shadows-hr.png",
                    x = 932,
                    width = 466,
                    height = 310,
                    shift = { 1.5, -1.15 },
                    scale = 0.5,
                    draw_as_shadow = true,
                },
                {
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-mask-hr.png",
                    x = 932,
                    width = 466,
                    height = 310,
                    shift = { 1.5, -1.15 },
                    scale = 0.5,
                    blend_mode = constants.EG_TIER_BLEND_MODE,
                    tint = constants.EG_TRANSFORMATORS["eg-unit-" .. tier].tint,
                },
            },
        },
    }

    if constants.EG_ALTOVERLAY then
        table.insert(template.north.layers, altoverlay.north)
        table.insert(template.east.layers, altoverlay.east)
        table.insert(template.south.layers, altoverlay.south)
        table.insert(template.west.layers, altoverlay.west)
    end

    return template
end

local function create_transformator_unit(tier)
    local power_consumption = constants.EG_TRANSFORMATORS["eg-unit-" .. tier].rating

    return {
        type = "simple-entity-with-force",
        name = "eg-unit-" .. tier,
        icon = constants.EG_GRAPHICS .. "/technologies/tier-" .. tier .. ".png",
        icon_size = 128,
        flags = { "placeable-player", "player-creation" },
        minable = { mining_time = 0.5, result = "eg-transformator-item" },
        corpse = "big-remnants",
        dying_explosion = "medium-explosion",
        placeable_by = { item = "eg-transformator-item", count = 1 },
        max_health = 300,
        resistances = { { type = "fire", percent = 70 } },
        random_variation_on_create = false,
        collision_box = { { -1.0, -2.0 }, { 1.0, 2.0 } },
        selection_box = { { -1.0, -1.5 }, { 1.0, 1.5 } },
        drawing_box = { { -1.0, -2.0 }, { 1.0, 2.0 } },
        picture = get_transformator_picture(tier),
    }
end

local flags = {}

if constants.EG_ALTOVERLAY then
    table.insert(flags, constants.EG_ALTOVERLAY)
end

for _, flag in ipairs(constants.EG_INTERNAL_ENTITY_FLAGS) do
    table.insert(flags, flag)
end

-- Loop to extend data with entities and fluids for each tier
-- Consider incorporating Quality!
for tier = 1, constants.EG_NUM_TIERS do
    data:extend({
        create_transformator_unit(tier),
        create_transformator_water(tier),
        create_transformator_steam(tier),
        create_transformator_boiler(tier),
        create_transformator_steam_engine(tier),
    })
end

local eg_transformator_displayer = {
    type = "simple-entity-with-force",
    name = constants.EG_DISPLAYER,
    icon = constants.EG_GRAPHICS .. "/entities/trafo-sprites.png",
    icon_size = 64,
    flags = { "placeable-player", "player-creation" },
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
    place_result = constants.EG_DISPLAYER,
    stack_size = 50,
}

local eg_transformator_recipe = {
    type = "recipe",
    name = "eg-transformator-recipe",
    ingredients = {
        { type = "item", name = "boiler", amount = 1 },
    },
    results = {
        { type = "item", name = "eg-transformator-item", amount = 1 }
    },
    enabled = true
}

data:extend({ eg_transformator_displayer, eg_transformator_item, eg_transformator_recipe })
