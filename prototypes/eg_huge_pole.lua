if constants.EG_TRANSFORMATORS_ONLY then return end
if mods["factorioplus"] or mods["PowerOverload"] then return end

local huge_pole                          = table.deepcopy(data.raw["electric-pole"]["big-electric-pole"])

huge_pole.type                           = "electric-pole"
huge_pole.name                           = "eg-huge-electric-pole"
huge_pole.localised_name                 = { "entity-name.eg-huge-electric-pole" }
huge_pole.localised_description          = { "entity-description.eg-huge-electric-pole" }
huge_pole.icon                           = constants.EG_ICONS .. "eg-huge-electric-pole.png"
huge_pole.icon_size                      = 32
huge_pole.drawing_box_vertical_extension = 5
huge_pole.minable                        =
{
    mining_time = huge_pole.minable.mining_time,
    result = "eg-huge-electric-pole"
}
huge_pole.light                          = constants.EG_HUGE_POLE_LIGHTS and constants.EG_HUGE_POLE_LIGHT or nil
huge_pole.max_health                     = huge_pole.max_health + 100
huge_pole.maximum_wire_distance          = constants.EG_MAX_WIRE_HUGE
huge_pole.supply_area_distance           = 0

huge_pole.collision_box                  = {
    { -1.4, -1.4 },
    { 1.4,  1.4 }
}
huge_pole.selection_box                  = {
    { -1.5, -1.5 },
    { 1.5,  1.5 }
}

huge_pole.pictures                       =
{
    layers =
    {
        {
            filename = constants.EG_ENTITIES .. "eg-huge-electric-pole.png",
            priority = "extra-high",
            width = 1216 / 4,
            height = 512,
            scale = 0.5,
            direction_count = 4,
            shift = util.by_pixel(0, -70),
        },
        {
            filename = constants.EG_ENTITIES .. "eg-huge-electric-pole-shadow.png",
            priority = "extra-high",
            width = 2048 / 4,
            height = 160,
            scale = 0.5,
            direction_count = 4,
            shift = util.by_pixel(76, 3),
            draw_as_shadow = true,
        }
    }
}
huge_pole.connection_points              =
{
    {
        shadow =
        {
            copper = util.by_pixel_hr(330, 3),
            red = util.by_pixel_hr(360, 3),
            green = util.by_pixel_hr(280, 3)
        },
        wire =
        {
            copper = util.by_pixel_hr(0, -340),
            red = util.by_pixel_hr(74, -304),
            green = util.by_pixel_hr(-74, -304)
        }
    },
    {
        shadow =
        {
            copper = util.by_pixel_hr(346, 4),
            red = util.by_pixel_hr(346, 48),
            green = util.by_pixel_hr(280, -28)
        },
        wire =
        {
            copper = util.by_pixel_hr(-0, -340),
            red = util.by_pixel_hr(52, -264),
            green = util.by_pixel_hr(-52, -332)
        }
    },
    {
        shadow =
        {
            copper = util.by_pixel_hr(340, 8),
            red = util.by_pixel_hr(310, 62),
            green = util.by_pixel_hr(310, -50)
        },
        wire =
        {
            copper = util.by_pixel_hr(4, -340),
            red = util.by_pixel_hr(4, -260),
            green = util.by_pixel_hr(4, -354)
        }
    },
    {
        shadow =
        {
            copper = util.by_pixel_hr(346, 8),
            red = util.by_pixel_hr(270, 40),
            green = util.by_pixel_hr(340, -30)
        },
        wire =
        {
            copper = util.by_pixel_hr(0, -340),
            red = util.by_pixel_hr(-52, -264),
            green = util.by_pixel_hr(52, -332)
        }
    },
}
huge_pole.water_reflection               =
{
    pictures =
    {
        filename = "__base__/graphics/entity/big-electric-pole/big-electric-pole-reflection.png",
        priority = "extra-high",
        width = 16,
        height = 32,
        shift = util.by_pixel(0, 70),
        variation_count = 1,
        scale = 8
    },
    rotate = false,
    orientation_to_variation = false
}

local huge_pole_item                     =
{
    type                  = "item",
    name                  = "eg-huge-electric-pole",
    localised_name        = { "item-name.eg-huge-electric-pole" },
    localised_description = { "item-description.eg-huge-electric-pole" },
    subgroup              = "eg-electric-distribution",
    order                 = data.raw["item"]["big-electric-pole"].order .. "z",
    icon                  = constants.EG_ICONS .. "eg-huge-electric-pole.png",
    icon_size             = 64,
    stack_size            = data.raw["item"]["big-electric-pole"].stack_size,
    place_result          = "eg-huge-electric-pole",
    weight                = 20000
}

local huge_pole_recipe                   =
{
    type        = "recipe",
    name        = "eg-huge-electric-pole",
    category    = data.raw["recipe"]["big-electric-pole"].category,
    enabled     = false,
    results     = { { type = "item", name = "eg-huge-electric-pole", amount = 1 } },
    ingredients =
    {
        { type = "item", name = "iron-stick",   amount = 12 },
        { type = "item", name = "steel-plate",  amount = 8 },
        { type = "item", name = "copper-cable", amount = 8 }
    }
}

data.extend { huge_pole, huge_pole_item, huge_pole_recipe }

table.insert(data.raw["technology"]["electric-energy-distribution-1"].effects,
    { type = "unlock-recipe", recipe = "eg-huge-electric-pole" })
