if constants.EG_TRANSFORMATORS_ONLY then return end
if mods["factorioplus"] or mods["PowerOverload"] then return end

local huge_pole                 = table.deepcopy(data.raw["electric-pole"]["big-electric-pole"])

huge_pole.type                  = "electric-pole"
huge_pole.name                  = "eg-huge-electric-pole"
huge_pole.localised_name        = { "entity-name.eg-huge-electric-pole" }
huge_pole.localised_description = { "entity-description.eg-huge-electric-pole" }
huge_pole.minable               =
{
    mining_time = huge_pole.minable.mining_time,
    result = "eg-huge-electric-pole"
}
huge_pole.light                 = constants.EG_HUGE_POLE_LIGHTS and constants.EG_HUGE_POLE_LIGHT or nil
huge_pole.max_health            = huge_pole.max_health + 100
huge_pole.maximum_wire_distance = constants.EG_MAX_WIRE_HUGE
huge_pole.supply_area_distance  = 0

if constants.EG_OLD_HUGE_POLE then
    local scale                              = 1.2
    local translate                          = -0.4

    huge_pole.icon                           = constants.EG_ICONS .. "eg-huge-electric-pole-old.png"
    huge_pole.icon_size                      = 32
    huge_pole.drawing_box_vertical_extension = 3

    huge_pole.pictures                       =
    {
        filename = constants.EG_ENTITIES .. "eg-huge-electric-pole-old.png",
        priority = "extra-high",
        width = 168,
        height = 165,
        direction_count = 4,
        shift = { 1.6 * scale, (-1.1 + translate) * scale },
        scale = scale,
    }
    huge_pole.connection_points              =
    {
        {
            shadow =
            {
                copper = { 2.7 * scale, translate },
                green = { 1.8 * scale, translate },
                red = { 3.6 * scale, translate }
            },
            wire =
            {
                copper = { 0, (-3.125 + translate) * scale },
                green = { -0.59375 * scale, (-3.125 + translate) * scale },
                red = { 0.625 * scale, (-3.125 + translate) * scale }
            }
        },
        {
            shadow =
            {
                copper = { 3.1 * scale, (0.2 + translate) * scale },
                green = { 2.3 * scale, (-0.3 + translate) * scale },
                red = { 3.8 * scale, (0.6 + translate) * scale }
            },
            wire =
            {
                copper = { -0.0625 * scale, (-3.125 + translate) * scale },
                green = { -0.5 * scale, (-3.4375 + translate) * scale },
                red = { 0.34375 * scale, (-2.8125 + translate) * scale }
            }
        },
        {
            shadow =
            {
                copper = { 2.9 * scale, (0.06 + translate) * scale },
                green = { 3.0 * scale, (-0.6 + translate) * scale },
                red = { 3.0 * scale, (0.8 + translate) * scale }
            },
            wire =
            {
                copper = { -0.09375 * scale, (-3.09375 + translate) * scale },
                green = { -0.09375 * scale, (-3.53125 + translate) * scale },
                red = { -0.09375 * scale, (-2.65625 + translate) * scale }
            }
        },
        {
            shadow =
            {
                copper = { 3.1 * scale, (0.2 + translate) * scale },
                green = { 3.8 * scale, (-0.3 + translate) * scale },
                red = { 2.35 * scale, (0.6 + translate) * scale }
            },
            wire =
            {
                copper = { -0.0625 * scale, (-3.1875 + translate) * scale },
                green = { 0.375 * scale, (-3.5 + translate) * scale },
                red = { -0.46875 * scale, (-2.90625 + translate) * scale }
            }
        }
    }
else
    huge_pole.icon                           = constants.EG_ICONS .. "eg-huge-electric-pole.png"
    huge_pole.icon_size                      = 64
    huge_pole.drawing_box_vertical_extension = 4

    huge_pole.pictures                       =
    {
        layers =
        {
            {
                filename = constants.EG_ENTITIES .. "eg-huge-electric-pole.png",
                priority = "extra-high",
                width = 592 / 4,
                height = 420,
                scale = 0.5,
                direction_count = 4,
                shift = util.by_pixel(0, -70),
            },
            {
                filename = constants.EG_ENTITIES .. "eg-huge-electric-pole-shadow.png",
                priority = "extra-high",
                width = 1680 / 4,
                height = 148,
                scale = 0.5,
                direction_count = 4,
                shift = util.by_pixel(74, 0),
                draw_as_shadow = true,
            }
        }
    }
    huge_pole.connection_points              =
    {
        {
            shadow =
            {
                copper = util.by_pixel_hr(320, 0),
                red = util.by_pixel_hr(350, 3),
                green = util.by_pixel_hr(280, 3)
            },
            wire =
            {
                copper = util.by_pixel_hr(0, -300),
                red = util.by_pixel_hr(54, -290),
                green = util.by_pixel_hr(-56, -290)
            }
        },
        {
            shadow =
            {
                copper = util.by_pixel_hr(300, 10),
                red = util.by_pixel_hr(258, 46),
                green = util.by_pixel_hr(340, -38)
            },
            wire =
            {
                copper = util.by_pixel_hr(6, -286),
                red = util.by_pixel_hr(42, -252),
                green = util.by_pixel_hr(-40, -330)
            }
        },
        {
            shadow =
            {
                copper = util.by_pixel_hr(306, 0),
                red = util.by_pixel_hr(300, 58),
                green = util.by_pixel_hr(300, -56)
            },
            wire =
            {
                copper = util.by_pixel_hr(8, -290),
                red = util.by_pixel_hr(0, -230),
                green = util.by_pixel_hr(0, -344)
            }
        },
        {
            shadow =
            {
                copper = util.by_pixel_hr(306, 0),
                red = util.by_pixel_hr(330, 38),
                green = util.by_pixel_hr(260, -40)
            },
            wire =
            {
                copper = util.by_pixel_hr(4, -290),
                red = util.by_pixel_hr(-38, -256),
                green = util.by_pixel_hr(42, -328)
            }
        },
    }
end

huge_pole.water_reflection =
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

local icon
local icon_size
if constants.EG_OLD_HUGE_POLE then
    icon = constants.EG_ICONS .. "eg-huge-electric-pole-old.png"
    icon_size = 32
else
    icon = constants.EG_ICONS .. "eg-huge-electric-pole.png"
    icon_size = 64
end

local item_sounds      = require("__base__/prototypes/item_sounds")

local huge_pole_item   =
{
    type                  = "item",
    name                  = "eg-huge-electric-pole",
    localised_name        = { "item-name.eg-huge-electric-pole" },
    localised_description = { "item-description.eg-huge-electric-pole" },
    subgroup              = "eg-electric-distribution",
    order                 = data.raw["item"]["big-electric-pole"].order .. "z",
    icon                  = icon,
    icon_size             = icon_size,
    stack_size            = data.raw["item"]["big-electric-pole"].stack_size,
    place_result          = "eg-huge-electric-pole",
    weight                = 20000,
    inventory_move_sound  = item_sounds.electric_large_inventory_move,
    pick_sound            = item_sounds.electric_large_inventory_pickup,
    drop_sound            = item_sounds.electric_large_inventory_move
}

local huge_pole_recipe =
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
