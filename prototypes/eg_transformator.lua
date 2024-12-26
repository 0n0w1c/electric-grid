local function get_transformator_picture(tier)
    local altoverlay = {
        north = {
            filename = constants.EG_ENTITIES .. "eg-unit-altoverlay-hr.png",
            x = 466,
            width = 466,
            height = 310,
            shift = { 2.6, -0.45 },
            scale = 0.5,
        },
        east = {
            filename = constants.EG_ENTITIES .. "eg-unit-altoverlay-hr.png",
            x = 0,
            width = 466,
            height = 310,
            shift = { 1.5, -1.15 },
            scale = 0.5,
        },
        south = {
            filename = constants.EG_ENTITIES .. "eg-unit-altoverlay-hr.png",
            x = 1398,
            width = 466,
            height = 310,
            shift = { 2.6, -0.45 },
            scale = 0.5,
        },
        west = {
            filename = constants.EG_ENTITIES .. "eg-unit-altoverlay-hr.png",
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
                    filename = constants.EG_ENTITIES .. "eg-unit-sprites-hr.png",
                    x = 466,
                    width = 466,
                    height = 310,
                    shift = { 2.6, -0.45 },
                    scale = 0.5,
                },
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-shadows-hr.png",
                    x = 466,
                    width = 466,
                    height = 310,
                    shift = { 2.6, -0.45 },
                    scale = 0.5,
                    draw_as_shadow = true,
                },
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-mask-hr.png",
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
                    filename = constants.EG_ENTITIES .. "eg-unit-sprites-hr.png",
                    x = 0,
                    width = 466,
                    height = 310,
                    shift = { 1.5, -1.15 },
                    scale = 0.5,
                },
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-shadows-hr.png",
                    x = 0,
                    width = 466,
                    height = 310,
                    shift = { 1.5, -1.15 },
                    scale = 0.5,
                    draw_as_shadow = true,
                },
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-mask-hr.png",
                    x = 0,
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
                    filename = constants.EG_ENTITIES .. "eg-unit-sprites-hr.png",
                    x = 1398,
                    width = 466,
                    height = 310,
                    shift = { 2.6, -0.45 },
                    scale = 0.5,
                },
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-shadows-hr.png",
                    x = 1398,
                    width = 466,
                    height = 310,
                    shift = { 2.6, -0.45 },
                    scale = 0.5,
                    draw_as_shadow = true,
                },
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-mask-hr.png",
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
                    filename = constants.EG_ENTITIES .. "eg-unit-sprites-hr.png",
                    x = 932,
                    width = 466,
                    height = 310,
                    shift = { 1.5, -1.15 },
                    scale = 0.5,
                },
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-shadows-hr.png",
                    x = 932,
                    width = 466,
                    height = 310,
                    shift = { 1.5, -1.15 },
                    scale = 0.5,
                    draw_as_shadow = true,
                },
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-mask-hr.png",
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
        icon = constants.EG_ICONS .. "eg-transformator.png",
        icon_size = 128,
        hidden_in_factoriopedia = true,
        flags = { "placeable-player", "player-creation", "get-by-unit-number" },
        minable = { mining_time = 0.5, result = "eg-transformator" },
        selectable_in_game = true,
        corpse = "big-remnants",
        dying_explosion = "medium-explosion",
        placeable_by = { item = "eg-transformator", count = 1 },
        max_health = constants.EG_MAX_HEALTH,
        resistances = data.raw["electric-pole"]["substation"].resistances,
        random_variation_on_create = false,
        collision_box = { { -0.9, -1.9 }, { 0.9, 1.9 } },
        selection_box = { { -1.0, -1.0 }, { 1.0, 0.0 } },
        collision_mask = { layers = { item = true, meltable = true, object = true, player = true, water_tile = true, is_object = true } },
        picture = get_transformator_picture(tier),
        localised_name = { "entity-name.eg-unit" },
        localised_description = { "", { "entity-description.eg-unit" }, " ", rating }
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
        create_transformator_boiler(tier),
        create_transformator_steam_engine("ne", tier),
        create_transformator_steam_engine("sw", tier),
    })
end

data:extend({
    create_transformator_fluid_disable(),
    create_transformator_fluid_enable(),
    create_transformator_pump(),
})

local eg_transformator_displayer = {
    type = "simple-entity-with-force",
    name = "eg-transformator-displayer",
    localised_name = { "entity-name.eg-transformator-displayer" },
    localised_description = { "entity-description.eg-transformator-displayer" },
    icon = constants.EG_ICONS .. "eg-transformator.png",
    icon_size = 128,
    flags = { "placeable-player", "player-creation" },
    max_health = constants.EG_MAX_HEALTH,
    collision_box = { { -0.9, -1.9 }, { 0.9, 1.9 } },
    collision_mask = { layers = { item = true, meltable = true, object = true, player = true, water_tile = true, is_object = true } },
    hidden_in_factoriopedia = true,
    picture = get_transformator_picture(1)
}

local subgroup
if constants.EG_TRANSFORMATORS_ONLY then
    subgroup = "energy-pipe-distribution"
else
    subgroup = "eg-electric-distribution"
end

local eg_transformator_item = {
    type = "item",
    name = "eg-transformator",
    localised_name = { "item-name.eg-transformator" },
    localised_description = { "item-description.eg-transformator" },
    icon = constants.EG_ICONS .. "eg-transformator.png",
    icon_size = 128,
    subgroup = subgroup,
    order = data.raw["item"]["substation"].order .. "zz",
    place_result = "eg-transformator-displayer",
    stack_size = 50,
    weight = 20000
}

local eg_transformator_recipe = {
    type          = "recipe",
    name          = "eg-transformator",
    category      = data.raw["recipe"]["substation"].category,

    ingredients   = {
        { type = "item", name = "copper-plate", amount = 2 },
        { type = "item", name = "steel-plate",  amount = 4 },
        { type = "item", name = "iron-plate",   amount = 10 },
        { type = "item", name = "copper-cable", amount = 200 }
    },
    results       = {
        { type = "item", name = "eg-transformator", amount = 1 }
    },
    enabled       = false,
    allow_quality = false
}

data:extend({ eg_transformator_displayer, eg_transformator_item, eg_transformator_recipe })
