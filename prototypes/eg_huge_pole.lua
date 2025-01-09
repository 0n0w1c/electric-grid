if constants.EG_TRANSFORMATORS_ONLY then return end
if mods["factorioplus"] then return end

local scale                              = 1.2
local translate                          = -0.4

local huge_pole                          = table.deepcopy(data.raw["electric-pole"]["big-electric-pole"])

huge_pole.type                           = "electric-pole"
huge_pole.name                           = "eg-huge-electric-pole"
huge_pole.localised_name                 = { "entity-name.eg-huge-electric-pole" }
huge_pole.localised_description          = { "entity-description.eg-huge-electric-pole" }
huge_pole.icon                           = constants.EG_ICONS .. "eg-huge-electric-pole.png"
huge_pole.icon_size                      = 32
huge_pole.drawing_box_vertical_extension = 3
huge_pole.minable                        = { mining_time = huge_pole.minable.mining_time, result = "eg-huge-electric-pole" }
huge_pole.light                          = constants.EG_HUGE_POLE_LIGHTS and constants.EG_HUGE_POLE_LIGHT or nil
huge_pole.max_health                     = huge_pole.max_health + 100
huge_pole.maximum_wire_distance          = tonumber(settings.startup["eg-max-wire-huge"].value)
huge_pole.supply_area_distance           = 0
huge_pole.pictures                       =
{
    filename = constants.EG_ENTITIES .. "eg-huge-electric-pole.png",
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

huge_pole.water_reflection               =
{
    pictures =
    {
        filename = "__base__/graphics/entity/big-electric-pole/big-electric-pole-reflection.png",
        priority = "extra-high",
        width = 16,
        height = 32,
        shift = { util.by_pixel(0, 60)[1] * scale, (util.by_pixel(0, 60)[2] + translate) * scale },
        variation_count = 1,
        scale = 5 * scale
    },
    rotate = false,
    orientation_to_variation = false
}


local huge_pole_item                 = table.deepcopy(data.raw["item"]["big-electric-pole"])
huge_pole_item.name                  = "eg-huge-electric-pole"
huge_pole_item.localised_name        = { "item-name.eg-huge-electric-pole" }
huge_pole_item.localised_description = { "item-description.eg-huge-electric-pole" }
huge_pole_item.subgroup              = "eg-electric-distribution"
huge_pole_item.order                 = huge_pole_item.order .. "z"
huge_pole_item.icon                  = constants.EG_ICONS .. "eg-huge-electric-pole.png"
huge_pole_item.icon_size             = 32
huge_pole_item.place_result          = "eg-huge-electric-pole"
huge_pole_item.weight                = 20000


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
