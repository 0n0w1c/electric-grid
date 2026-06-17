local base_pole_name = data.raw["electric-pole"]["eg-small-iron-electric-pole"] and "eg-small-iron-electric-pole" or
    (data.raw["electric-pole"]["small-iron-electric-pole"] and "small-iron-electric-pole" or "small-electric-pole")
local base_pole = data.raw["electric-pole"][base_pole_name]
if not base_pole then return end

local base_item = data.raw["item"][base_pole_name] or data.raw["item"]["small-electric-pole"]
local base_recipe = data.raw["recipe"][base_pole_name] or data.raw["recipe"]["small-electric-pole"]

local ugp_small_pole_name = "eg-ugp-small-electric-pole"
local ugp_small_pole_displayer_name = ugp_small_pole_name .. "-displayer"

local ugp_small_pole = table.deepcopy(base_pole)
ugp_small_pole.name = ugp_small_pole_name
ugp_small_pole.localised_name = { "entity-name.eg-ugp-small-electric-pole" }
ugp_small_pole.localised_description = { "entity-description.eg-ugp-small-electric-pole" }
ugp_small_pole.icons = { { icon = constants.EG_ICONS .. "eg-ugp-small-electric-pole.png", icon_size = 64, scale = 0.5 } }
ugp_small_pole.hidden = false
ugp_small_pole.hidden_in_factoriopedia = true
ugp_small_pole.maximum_wire_distance = constants.EG_MAX_WIRE_SMALL_IRON
ugp_small_pole.supply_area_distance = constants.EG_MAX_SUPPLY_SMALL_IRON
ugp_small_pole.flags =
{
    "placeable-player",
    "player-creation",
    "not-rotatable"
}
ugp_small_pole.placeable_by = { item = ugp_small_pole_displayer_name, count = 1 }
ugp_small_pole.draw_copper_wires = false
ugp_small_pole.draw_circuit_wires = false
ugp_small_pole.drawing_box_vertical_extension = 0
ugp_small_pole.minable = { mining_time = 0.5, result = ugp_small_pole_displayer_name }
ugp_small_pole.next_upgrade = nil
ugp_small_pole.fast_replaceable_group = base_pole.fast_replaceable_group
ugp_small_pole.selection_priority = 1
ugp_small_pole.collision_mask = { colliding_with_tiles_only = true, layers = { is_object = true }
}
ugp_small_pole.integration_patch_render_layer = "ground-patch"
ugp_small_pole.integration_patch = {
    layers = {
        {
            filename = constants.EG_GRAPHICS .. "/entities/eg-ugp-substation.png",
            priority = "extra-high",
            width = 256,
            height = 256,
            scale = 0.125
        }
    }
}
ugp_small_pole.pictures = {
    layers = {
        {
            filename = constants.EG_GRAPHICS .. "/entities/eg-empty.png",
            priority = "extra-high",
            width = 256,
            height = 256,
            scale = 0.125,
            direction_count = 1
        }
    }
}
ugp_small_pole.connection_points = {
    {
        shadow = {
            copper = { 0, 0 },
            red = { 0, 0 },
            green = { 0, 0 }
        },
        wire = {
            copper = { 0, 0 },
            red = { 0, 0 },
            green = { 0, 0 }
        }
    }
}

data.extend({ ugp_small_pole })

local ugp_small_pole_displayer = table.deepcopy(ugp_small_pole)
ugp_small_pole_displayer.name = ugp_small_pole_displayer_name
ugp_small_pole_displayer.hidden = false
ugp_small_pole_displayer.hidden_in_factoriopedia = false
ugp_small_pole_displayer.draw_copper_wires = true
ugp_small_pole_displayer.collision_mask = base_pole.collision_mask
ugp_small_pole_displayer.next_upgrade = nil
ugp_small_pole_displayer.fast_replaceable_group = base_pole.fast_replaceable_group
ugp_small_pole_displayer.flags =
{
    "placeable-player",
    "player-creation",
    "not-rotatable",
    "get-by-unit-number"
}

local item_sounds = require("__base__/prototypes/item_sounds")

local ugp_small_pole_displayer_item =
{
    type = "item",
    name = ugp_small_pole_displayer_name,
    localised_name = { "item-name.eg-ugp-small-electric-pole" },
    localised_description = { "item-description.eg-ugp-small-electric-pole" },
    subgroup = constants.EG_SUBGROUP,
    order = (base_item and base_item.order or "a[energy]-a[small-electric-pole]") .. "z",
    icons = { { icon = constants.EG_ICONS .. "eg-ugp-small-electric-pole.png", icon_size = 64, scale = 0.5 } },
    stack_size = base_item and base_item.stack_size or 50,
    hidden = false,
    hidden_in_factoriopedia = false,
    place_result = ugp_small_pole_displayer_name,
    inventory_move_sound = item_sounds.electric_small_inventory_move,
    pick_sound = item_sounds.electric_small_inventory_pickup,
    drop_sound = item_sounds.electric_small_inventory_move
}

local ugp_small_pole_displayer_recipe =
{
    type = "recipe",
    name = ugp_small_pole_displayer_name,
    category = base_recipe and base_recipe.category or "crafting",
    enabled = false,
    ingredients = base_recipe and table.deepcopy(base_recipe.ingredients) or
        {
            { type = "item", name = "iron-plate",   amount = 1 },
            { type = "item", name = "copper-cable", amount = 2 }
        },
    results = { { type = "item", name = ugp_small_pole_displayer_name, amount = 1 } }
}

data.extend({ ugp_small_pole_displayer, ugp_small_pole_displayer_item, ugp_small_pole_displayer_recipe })

local unlock_technology = data.raw["technology"]["electronics"] or
    data.raw["technology"]["electric-energy-distribution-1"]
if unlock_technology then
    unlock_technology.effects = unlock_technology.effects or {}
    table.insert(unlock_technology.effects,
        { type = "unlock-recipe", recipe = ugp_small_pole_displayer_name })
end
