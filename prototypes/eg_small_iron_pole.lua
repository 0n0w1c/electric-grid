if constants.EG_TRANSFORMATORS_ONLY then return end
if mods["aai-industry"] or mods["PowerOverload"] then return end

local small_iron_pole                      = table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
local medium_pole                          = data.raw["electric-pole"]["medium-electric-pole"]

small_iron_pole.type                       = "electric-pole"
small_iron_pole.name                       = "small-iron-electric-pole"
small_iron_pole.localised_name             = { "entity-name.eg-small-iron-electric-pole" }
small_iron_pole.localised_description      = { "entity-description.eg-small-iron-electric-pole" }
small_iron_pole.icon                       = constants.EG_ICONS .. "eg-small-iron-electric-pole.png"
small_iron_pole.icon_size                  = 64
small_iron_pole.maximum_wire_distance      = medium_pole.maximum_wire_distance
small_iron_pole.supply_area_distance       = medium_pole.supply_area_distance
small_iron_pole.minable                    =
{ mining_time = small_iron_pole.minable.mining_time, result = "small-iron-electric-pole" }
small_iron_pole.surface_conditions         = nil
small_iron_pole.pictures                   = {
    layers = {
        {
            direction_count = 4,
            filename = constants.EG_ENTITIES .. "eg-small-iron-electric-pole.png",
            height = 220,
            priority = "extra-high",
            scale = 0.5,
            shift = {
                0.046875,
                -1.328125
            },
            width = 72
        },
        {
            direction_count = 4,
            draw_as_shadow = true,
            filename = "__base__/graphics/entity/small-electric-pole/small-electric-pole-shadow.png",
            height = 52,
            priority = "extra-high",
            scale = 0.5,
            shift = {
                1.59375,
                0.09375
            },
            width = 256
        }
    }
}

local small_iron_pole_item                 = table.deepcopy(data.raw["item"]["small-electric-pole"])
small_iron_pole_item.name                  = "small-iron-electric-pole"
small_iron_pole_item.localised_name        = { "item-name.eg-small-iron-electric-pole" }
small_iron_pole_item.localised_description = { "item-description.eg-small-iron-electric-pole" }
small_iron_pole_item.subgroup              = "eg-electric-distribution"
small_iron_pole_item.order                 = small_iron_pole_item.order .. "z"
small_iron_pole_item.icon                  = constants.EG_ICONS .. "eg-small-iron-electric-pole.png"
small_iron_pole_item.icon_size             = 64
small_iron_pole_item.place_result          = "small-iron-electric-pole"

local small_iron_pole_recipe               =
{
    type        = "recipe",
    name        = "small-iron-electric-pole",
    category    = data.raw["recipe"]["small-electric-pole"].category,
    enabled     = false,
    results     = { { type = "item", name = "small-iron-electric-pole", amount = 2 } },
    ingredients =
    {
        { type = "item", name = "iron-plate",   amount = 1 },
        { type = "item", name = "copper-cable", amount = 2 }
    }
}

data.extend { small_iron_pole, small_iron_pole_item, small_iron_pole_recipe }
