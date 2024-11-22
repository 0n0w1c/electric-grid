local function get_transformator_displayer_pictures()
    return {
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
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-arrows-hr.png",
                    x = 466,
                    width = 466,
                    height = 310,
                    shift = { 2.6, -0.45 },
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
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-arrows-hr.png",
                    width = 466,
                    height = 310,
                    shift = { 1.5, -1.15 },
                    scale = 0.5,
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
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-arrows-hr.png",
                    x = 1398,
                    width = 466,
                    height = 310,
                    shift = { 2.6, -0.45 },
                    scale = 0.5,
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
                    filename = constants.EG_GRAPHICS .. "/entities/trafo-arrows-hr.png",
                    x = 932,
                    width = 466,
                    height = 310,
                    shift = { 1.5, -1.15 },
                    scale = 0.5,
                },
            },
        },
    }
end

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
    local rating = constants.EG_TRANSFORMATORS["eg-unit-" .. tier].rating

    return {
        type = "simple-entity-with-force",
        name = "eg-unit-" .. tier,
        icon = constants.EG_GRAPHICS .. "/technologies/tier-" .. tier .. ".png",
        icon_size = 128,
        flags = { "placeable-player", "player-creation", "not-rotatable" },
        minable = { mining_time = 0.5, result = "eg-transformator-item" },
        selectable_in_game = true,
        selection_priority = 1,
        corpse = "big-remnants",
        dying_explosion = "medium-explosion",
        placeable_by = { item = "eg-transformator-item", count = 1 },
        max_health = constants.EG_MAX_HEALTH,
        resistances = data.raw["electric-pole"]["substation"].resistances,
        random_variation_on_create = false,
        collision_box = { { -0.9, -1.9 }, { 0.9, 1.9 } },
        selection_box = { { -1.0, -1.0 }, { 1.0, 0.0 } },
        collision_mask = { layers = { item = true, meltable = true, object = true, player = true, water_tile = true, is_object = true } },
        picture = get_transformator_picture(tier),
        localised_name = { "", "Transformator - ", rating },
        localised_description = { "", "Regulates power distribution." }
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
for tier = 1, constants.EG_NUM_TIERS do
    data:extend({
        create_transformator_unit(tier),
        create_transformator_water(tier),
        create_transformator_steam(tier),
        create_transformator_boiler(defines.direction.north, tier),
        create_transformator_boiler(defines.direction.east, tier),
        create_transformator_boiler(defines.direction.south, tier),
        create_transformator_boiler(defines.direction.west, tier),
        create_transformator_steam_engine("ne", tier),
        create_transformator_steam_engine("sw", tier),
    })
end

data:extend({
    create_transformator_fluid_disable(),
    create_transformator_fluid_enable(),
    create_transformator_pump(defines.direction.north),
    create_transformator_pump(defines.direction.east),
    create_transformator_pump(defines.direction.south),
    create_transformator_pump(defines.direction.west),
})

local eg_transformator_displayer = {
    type = "simple-entity-with-force",
    name = constants.EG_DISPLAYER,
    localised_name = { "", "Transformator displayer" },
    localised_description = { "", "Transformator model used during placement." },
    icon = constants.EG_GRAPHICS .. "/technologies/tier-1.png",
    icon_size = 128,
    flags = { "placeable-player", "player-creation" },
    collision_box = { { -0.9, -1.9 }, { 0.9, 1.9 } },
    collision_mask = { layers = { item = true, meltable = true, object = true, player = true, water_tile = true, is_object = true } },
    hidden_in_factoriopedia = true,
    picture = get_transformator_displayer_pictures(), -- use picture not pictures, rotation works
    direction_count = 4,
}

local eg_transformator_item = {
    type = "item",
    name = "eg-transformator-item",
    localised_name = { "", "Transformator" },
    localised_description = { "", "Regulates power distribution." },
    icon = constants.EG_GRAPHICS .. "/technologies/tier-1.png",
    icon_size = 128,
    subgroup = "energy-pipe-distribution",
    order = "b[pipe]-d[eg-transformator-item]",
    place_result = constants.EG_DISPLAYER,
    stack_size = 50,
    weight = 20000,
    hidden_in_factoriopedia = true
}

local eg_transformator_recipe = {
    type = "recipe",
    name = "eg-transformator-recipe",
    localised_name = { "", "Transformator" },
    localised_description = { "", "Assembles components into a power regulating device." },
    ingredients = {
        { type = "item", name = "copper-plate", amount = 2 },
        { type = "item", name = "steel-plate",  amount = 4 },
        { type = "item", name = "iron-plate",   amount = 10 },
        { type = "item", name = "copper-cable", amount = 200 }
    },
    results = {
        { type = "item", name = "eg-transformator-item", amount = 1 }
    },
    enabled = false,
    allow_quality = false,
}

data:extend({ eg_transformator_displayer, eg_transformator_item, eg_transformator_recipe })
