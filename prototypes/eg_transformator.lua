local function get_transformator_picture()
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
            shift = { 1.55, -1.1 },
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
            shift = { 1.55, -1.1 },
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
                    blend_mode = constants.EG_TIER_BLEND_MODE,
                    tint = constants.EG_PUMP_TINT,
                    scale = 0.5,
                },
            },
        },
        east = {
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
                    tint = constants.EG_PUMP_TINT,
                },
            },
        },
        south = {
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
                    scale = 0.5,
                    blend_mode = constants.EG_TIER_BLEND_MODE,
                    tint = constants.EG_PUMP_TINT,
                },
            },
        },
        west = {
            layers = {
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-sprites.png",
                    x = 0,
                    width = 466,
                    height = 310,
                    shift = { 1.55, -1.1 },
                    scale = 0.5,
                },
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-shadows.png",
                    x = 0,
                    width = 466,
                    height = 310,
                    shift = { 1.55, -1.1 },
                    scale = 0.5,
                    draw_as_shadow = true,
                },
                {
                    filename = constants.EG_ENTITIES .. "eg-unit-mask.png",
                    x = 0,
                    width = 466,
                    height = 310,
                    shift = { 1.55, -1.1 },
                    scale = 0.5,
                    blend_mode = constants.EG_TIER_BLEND_MODE,
                    tint = constants.EG_PUMP_TINT,
                },
            },
        },
    }

    if constants.EG_OVERLAY then
        if constants.EG_INVERT_OVERLAY then
            table.insert(template.north.layers, overlay.south)
            table.insert(template.east.layers, overlay.west)
            table.insert(template.south.layers, overlay.north)
            table.insert(template.west.layers, overlay.east)
        else
            table.insert(template.north.layers, overlay.north)
            table.insert(template.east.layers, overlay.east)
            table.insert(template.south.layers, overlay.south)
            table.insert(template.west.layers, overlay.west)
        end
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
        },
        {
            min = 1,
            property = "gravity"
        }
    }
end

for tier = 1, constants.EG_NUM_TIERS do
    data.extend({
        create_transformator_water(tier),
        create_transformator_steam(tier),
        create_transformator_boiler(tier),
        create_transformator_steam_engine("ne", tier),
        create_transformator_steam_engine("sw", tier)
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
    hidden_in_factoriopedia = true,
    picture                 = get_transformator_picture(),
    surface_conditions      = surface_conditions
}

local subgroup
if constants.EG_TRANSFORMATORS_ONLY then
    subgroup = "energy-pipe-distribution"
else
    subgroup = constants.EG_SUBGROUP
end

local order
if mods["bobpower"] then
    order = "a[energy]-d[substation-4]" .. "zz"
else
    order = data.raw["item"]["substation"].order .. "zz"
end

local item_sounds = require("__base__/prototypes/item_sounds")

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
    weight                = 20000,
    inventory_move_sound  = item_sounds.electric_large_inventory_move,
    pick_sound            = item_sounds.electric_large_inventory_pickup,
    drop_sound            = item_sounds.electric_large_inventory_move
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
