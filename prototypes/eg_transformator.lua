local function get_transformator_picture(tier)
    local overlay = {
        north = {
            filename = constants.EG_ENTITIES .. "eg-unit-overlay.png",
            x = 466,
            width = 466,
            height = 310,
            shift = { 2.6, -0.45 },
            scale = 0.5,
            blend_mode = constants.EG_TIER_BLEND_MODE,
            tint = constants.EG_OVERLAY_TINT
        },
        east = {
            filename = constants.EG_ENTITIES .. "eg-unit-overlay.png",
            x = 0,
            width = 466,
            height = 310,
            shift = { 1.5, -1.15 },
            scale = 0.5,
            blend_mode = constants.EG_TIER_BLEND_MODE,
            tint = constants.EG_OVERLAY_TINT
        },
        south = {
            filename = constants.EG_ENTITIES .. "eg-unit-overlay.png",
            x = 1398,
            width = 466,
            height = 310,
            shift = { 2.6, -0.45 },
            scale = 0.5,
            blend_mode = constants.EG_TIER_BLEND_MODE,
            tint = constants.EG_OVERLAY_TINT
        },
        west = {
            filename = constants.EG_ENTITIES .. "eg-unit-overlay.png",
            x = 932,
            width = 466,
            height = 310,
            shift = { 1.5, -1.15 },
            scale = 0.5,
            blend_mode = constants.EG_TIER_BLEND_MODE,
            tint = constants.EG_OVERLAY_TINT
        },
    }

    local template = {
        north = {
            layers = {
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-sprites.png",
                    x = 466,
                    width = 466,
                    height = 310,
                    shift = { 2.6, -0.45 },
                    scale = 0.5,
                },
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-shadows.png",
                    x = 466,
                    width = 466,
                    height = 310,
                    shift = { 2.6, -0.45 },
                    scale = 0.5,
                    draw_as_shadow = true,
                },
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-mask.png",
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
                    filename = constants.EG_ENTITIES .. "eg-unit-sprites.png",
                    x = 0,
                    width = 466,
                    height = 310,
                    shift = { 1.5, -1.15 },
                    scale = 0.5,
                },
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-shadows.png",
                    x = 0,
                    width = 466,
                    height = 310,
                    shift = { 1.5, -1.15 },
                    scale = 0.5,
                    draw_as_shadow = true,
                },
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-mask.png",
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
                    filename = constants.EG_ENTITIES .. "eg-unit-sprites.png",
                    x = 1398,
                    width = 466,
                    height = 310,
                    shift = { 2.6, -0.45 },
                    scale = 0.5,
                },
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-shadows.png",
                    x = 1398,
                    width = 466,
                    height = 310,
                    shift = { 2.6, -0.45 },
                    scale = 0.5,
                    draw_as_shadow = true,
                },
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-mask.png",
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
                    filename = constants.EG_ENTITIES .. "eg-unit-sprites.png",
                    x = 932,
                    width = 466,
                    height = 310,
                    shift = { 1.5, -1.15 },
                    scale = 0.5,
                },
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-shadows.png",
                    x = 932,
                    width = 466,
                    height = 310,
                    shift = { 1.5, -1.15 },
                    scale = 0.5,
                    draw_as_shadow = true,
                },
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-mask.png",
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

    if constants.EG_OVERLAY then
        table.insert(template.north.layers, overlay.north)
        table.insert(template.east.layers, overlay.east)
        table.insert(template.south.layers, overlay.south)
        table.insert(template.west.layers, overlay.west)
    end

    return template
end

local surface_conditions = nil
if mods["space-age"] then
    surface_conditions = {
        {
            max = 90,
            min = 10,
            property = "magnetic-field"
        }
    }
end

local function create_transformator_unit(tier)
    local rating = constants.EG_TRANSFORMATORS["eg-unit-" .. tier].rating

    return {
        type                       = "simple-entity-with-force",
        name                       = "eg-unit-" .. tier,
        icon                       = constants.EG_ICONS .. "eg-transformator.png",
        icon_size                  = 128,
        hidden_in_factoriopedia    = true,
        flags                      = { "placeable-neutral", "placeable-player", "player-creation", "get-by-unit-number" },
        minable                    = { mining_time = 0.5, result = "eg-transformator" },
        selectable_in_game         = true,
        corpse                     = "big-remnants",
        dying_explosion            = "medium-explosion",
        placeable_by               = { item = "eg-transformator", count = 1 },
        max_health                 = constants.EG_MAX_HEALTH,
        resistances                = data.raw["electric-pole"]["substation"].resistances,
        random_variation_on_create = false,
        collision_box              = { { -0.9, -1.9 }, { 0.9, 1.9 } },
        selection_box              = { { -1.0, -1.0 }, { 1.0, 0.0 } },
        collision_mask             = { layers = { item = true, meltable = true, object = true, player = true, water_tile = true, is_object = true } },
        picture                    = get_transformator_picture(tier),
        render_layer               = "object-under",
        localised_name             = { "entity-name.eg-unit" },
        localised_description      = { "entity-description.eg-unit" },
        quality_indicator_scale    = 0,
        surface_conditions         = surface_conditions
    }
end

for tier = 1, constants.EG_NUM_TIERS do
    data.extend({
        create_transformator_unit(tier),
        create_transformator_water(tier),
        create_transformator_steam(tier),
        create_transformator_boiler(tier),
        create_transformator_steam_engine("ne", tier),
        create_transformator_steam_engine("sw", tier),
        create_tiered_transformator_pump(tier),
    })
end

data.extend({
    create_transformator_fluid_disable(),
    create_transformator_fluid_enable(),
    create_transformator_pump(),
})

local eg_transformator_displayer = {
    type                    = "simple-entity-with-force",
    name                    = "eg-transformator-displayer",
    localised_name          = { "entity-name.eg-transformator-displayer" },
    localised_description   = { "entity-description.eg-transformator-displayer" },
    quality_indicator_scale = 0,
    icon                    = constants.EG_ICONS .. "eg-transformator.png",
    icon_size               = 128,
    flags                   = { "placeable-neutral", "placeable-player", "player-creation" },
    max_health              = constants.EG_MAX_HEALTH,
    collision_box           = { { -0.9, -1.9 }, { 0.9, 1.9 } },
    collision_mask          = { layers = { item = true, meltable = true, object = true, player = true, water_tile = true, is_object = true } },
    hidden_in_factoriopedia = true,
    picture                 = get_transformator_picture(1),
    surface_conditions      = surface_conditions
}

local subgroup
if constants.EG_TRANSFORMATORS_ONLY then
    subgroup = "energy-pipe-distribution"
else
    subgroup = "eg-electric-distribution"
end

local order
if mods["bobpower"] then
    order = "a[energy]-d[substation-4]" .. "zz"
else
    order = data.raw["item"]["substation"].order .. "zz"
end

local eg_transformator_item = {
    type                  = "item",
    name                  = "eg-transformator",
    localised_name        = { "item-name.eg-transformator" },
    localised_description = { "item-description.eg-transformator" },
    icon                  = constants.EG_ICONS .. "eg-transformator.png",
    icon_size             = 128,
    subgroup              = subgroup,
    flags                 = { "hide-from-bonus-gui" },
    order                 = order,
    place_result          = "eg-transformator-displayer",
    stack_size            = 50,
    weight                = 20000
}

local eg_transformator_recipe = {
    type               = "recipe",
    name               = "eg-transformator",
    category           = data.raw["recipe"]["substation"].category,
    ingredients        = {
        { type = "item", name = "copper-plate", amount = 2 },
        { type = "item", name = "steel-plate",  amount = 4 },
        { type = "item", name = "iron-plate",   amount = 10 },
        { type = "item", name = "copper-cable", amount = 200 }
    },
    results            = {
        { type = "item", name = "eg-transformator", amount = 1 }
    },
    allow_quality      = false,
    allow_productivity = false,
    enabled            = false
}

data.extend({ eg_transformator_displayer, eg_transformator_item, eg_transformator_recipe })
