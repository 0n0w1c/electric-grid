local big_pole               = data.raw["electric-pole"]["big-electric-pole"]
local substation             = data.raw["electric-pole"]["substation"]

local eg_circuit_pole        =
{
    type                       = "electric-pole",
    name                       = "eg-circuit-pole",
    icon                       = constants.EG_GRAPHICS .. "/icons/hr-circuit-pole.png",
    icon_size                  = 32,
    localised_name             = "Circuit pole",
    localised_description      = "Specialized for circuit networks",
    flags                      = { "placeable-neutral", "player-creation" },
    minable                    = { mining_time = big_pole.minable.mining_time, result = "eg-circuit-pole" },
    max_health                 = big_pole.max_health + 100,
    corpse                     = big_pole.corpse,
    dying_explosion            = big_pole.dying_explosion,
    resistances                = big_pole.resistances,
    collision_box              = big_pole.collision_box,
    selection_box              = big_pole.selection_box,
    damaged_trigger_effect     = big_pole.damaged_trigger_effect,
    open_sound                 = big_pole.open_sound,
    close_sound                = big_pole.close_sound,
    auto_connect_up_to_n_wires = 5,
    draw_copper_wires          = false,
    draw_circuit_wires         = true,
    supply_area_distance       = 0,
    maximum_wire_distance      = substation.maximum_wire_distance / 2,
    light                      = constants.EG_CIRCUIT_POLE_LIGHTS and constants.EG_MINI_POLE_LIGHT or nil,
    pictures                   =
    {
        filename = constants.EG_GRAPHICS .. "/entities/hr-circuit-pole.png",
        priority = "extra-high",
        width = 256,
        height = 256,
        direction_count = 1,
        scale = 0.5,
    },
    connection_points          =
    {
        {
            wire =
            {
                copper = { 0, -212 / 256 },
                red = { -142 / 256, 32 / 256 },
                green = { 140 / 256, 32 / 256 }
            },
            shadow =
            {
                copper = { 114 / 256, 168 / 256 },
                red = { -24 / 256, 240 / 256 },
                green = { 250 / 256, 198 / 256 }
            },
        }
    }
}

local eg_circuit_pole_item   =
{
    type                  = "item",
    name                  = "eg-circuit-pole",
    localised_name        = "Circuit pole",
    localised_description = "Specialized for circuit networks",
    icon                  = constants.EG_GRAPHICS .. "/icons/hr-circuit-pole.png",
    icon_size             = 256,
    subgroup              = "circuit-network",
    order                 = "b[wires]-c[circuit-pole]",
    place_result          = "eg-circuit-pole",
    stack_size            = 50
}

local eg_circuit_pole_recipe =
{
    type        = "recipe",
    name        = "eg-circuit-pole",
    category    = data.raw["recipe"]["big-electric-pole"].category,
    enabled     = false,
    ingredients =
    {
        { type = "item", name = "iron-stick",   amount = 3 },
        { type = "item", name = "copper-cable", amount = 3 }
    },
    results     = {
        { type = "item", name = "eg-circuit-pole", amount = 2 },
    },
}

data:extend({ eg_circuit_pole, eg_circuit_pole_item, eg_circuit_pole_recipe })
