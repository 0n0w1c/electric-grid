CONSTANTS                   = require("constants")

local big_pole              = data.raw["electric-pole"]["big-electric-pole"]

local scale                 = 1.2
local translate             = -0.4

local huge_pole             = {
    type                         = "electric-pole",
    name                         = "eg-huge-electric-pole",
    localised_name               = "Huge electric pole",
    localised_description        = "Huge electric pole",
    icon                         = constants.EG_GRAPHICS .. "/icons/huge-electric-pole.png",
    icon_size                    = 32,
    icon_mipmaps                 = 1,
    flags                        = big_pole.flags,
    minable                      = { mining_time = big_pole.minable.mining_time, result = "eg-huge-electric-pole" },
    max_health                   = 250,
    corpse                       = big_pole.corpse,
    dying_explosion              = big_pole.dying_explosion,
    resistances                  = big_pole.resistances,
    collision_box                = big_pole.collision_box,
    selection_box                = big_pole.selection_box,
    damaged_trigger_effect       = big_pole.damaged_trigger_effect,
    drawing_box                  = { { -1 * scale, -3 * scale }, { 1 * scale, 0.5 * scale } },
    maximum_wire_distance        = 50,
    supply_area_distance         = 0,
    vehicle_impact_sound         = big_pole.vehicle_impact_sound,
    open_sound                   = big_pole.open_sound,
    close_sound                  = big_pole.close_sound,
    pictures                     =
    {
        filename = constants.EG_GRAPHICS .. "/entities/huge-electric-pole.png",
        priority = "extra-high",
        width = 168,
        height = 165,
        direction_count = 4,
        shift = { 1.6 * scale, (-1.1 + translate) * scale }, -- {1.6, -1.1},
        scale = scale,
    },
    connection_points            =
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
    },
    water_reflection             =
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
}

local huge_pole_item        = table.deepcopy(data.raw["item"]["big-electric-pole"])
huge_pole_item.name         = "eg-huge-electric-pole"
huge_pole_item.place_result = "eg-huge-electric-pole"
huge_pole_item.icon         = constants.EG_GRAPHICS .. "/icons/huge-electric-pole.png"
huge_pole_item.icon_size    = 32
huge_pole_item.icon_mipmaps = 1

local huge_pole_recipe      = {
    type = "recipe",
    name = "eg-huge-electric-pole",
    results = { { type = "item", name = "eg-huge-electric-pole", amount = 1 } },
    ingredients =
    {
        { type = "item", name = "iron-stick",   amount = 20 },
        { type = "item", name = "steel-plate",  amount = 15 },
        { type = "item", name = "copper-plate", amount = 15 }
    },
    energy_required = 1,
    enabled = true
}

data:extend { huge_pole, huge_pole_item, huge_pole_recipe }
