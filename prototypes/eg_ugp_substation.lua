if constants.EG_TRANSFORMATORS_ONLY then return end
if mods["PowerOverload"] then return end

local ugp_substation                          = table.deepcopy(data.raw["electric-pole"]["substation"])
ugp_substation.name                           = "eg-ugp-substation"
ugp_substation.localised_name                 = { "entity-name.eg-ugp-substation" }
ugp_substation.localised_description          = { "entity-description.eg-ugp-substation" }
ugp_substation.icon                           = constants.EG_ICONS .. "eg-ugp-substation.png"
ugp_substation.icon_size                      = 64
ugp_substation.hidden                         = false
ugp_substation.hidden_in_factoriopedia        = true
ugp_substation.maximum_wire_distance          = constants.EG_MAX_WIRE_SUBSTATION
ugp_substation.supply_area_distance           = constants.EG_MAX_SUPPLY_SUBSTATION
ugp_substation.flags                          =
{
    "placeable-neutral",
    "placeable-player",
    "player-creation",
    "not-rotatable"
}
ugp_substation.placeable_by                   = { item = "eg-ugp-substation-displayer", count = 1 }
ugp_substation.draw_copper_wires              = false
ugp_substation.draw_circuit_wires             = false
ugp_substation.drawing_box_vertical_extension = 0
ugp_substation.minable                        = { mining_time = 0.5, result = "substation" }
ugp_substation.next_upgrade                   = nil
ugp_substation.selection_priority             = 1
ugp_substation.collision_mask                 = { colliding_with_tiles_only = true, layers = {} }
ugp_substation.integration_patch_render_layer = "ground-patch"
ugp_substation.integration_patch              = {
    layers = {
        {
            filename = constants.EG_GRAPHICS .. "/entities/eg-ugp-substation.png",
            priority = "extra-high",
            width = 256,
            height = 256,
            scale = 0.25
        }
    }
}
ugp_substation.pictures                       = {
    layers = {
        {
            filename = constants.EG_GRAPHICS .. "/entities/eg-empty.png",
            priority = "extra-high",
            width = 256,
            height = 256,
            scale = 0.25,
            direction_count = 1
        }
    }
}
ugp_substation.connection_points              = {
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

data.extend({ ugp_substation })


local ugp_substation_displayer                   = table.deepcopy(ugp_substation)
local name                                       = "eg-ugp-substation-displayer"

ugp_substation_displayer.name                    = name
ugp_substation_displayer.hidden                  = false
ugp_substation_displayer.hidden_in_factoriopedia = false
ugp_substation_displayer.draw_copper_wires       = true
ugp_substation_displayer.collision_mask          = data.raw["electric-pole"]["substation"].collision_mask
ugp_substation_displayer.flags                   =
{
    "placeable-player",
    "player-creation",
    "not-rotatable",
    "get-by-unit-number"
}

local ugp_substation_displayer_item              =
{
    type                    = "item",
    name                    = name,
    localised_name          = { "item-name.eg-ugp-substation" },
    localised_description   = { "item-description.eg-ugp-substation" },
    subgroup                = "eg-electric-distribution",
    order                   = data.raw["item"]["substation"].order .. "z",
    icon                    = constants.EG_ICONS .. "eg-ugp-substation.png",
    icon_size               = 64,
    stack_size              = data.raw["item"]["substation"].stack_size,
    hidden                  = false,
    hidden_in_factoriopedia = false,
    place_result            = name
}

local ugp_substation_displayer_recipe            =
{
    type        = "recipe",
    name        = name,
    category    = data.raw["recipe"]["substation"].category,
    enabled     = false,
    ingredients = { { type = "item", name = "substation", amount = 1 } },
    results     = { { type = "item", name = name, amount = 1 } }
}

data.extend({ ugp_substation_displayer, ugp_substation_displayer_item, ugp_substation_displayer_recipe })

table.insert(data.raw["technology"]["electric-energy-distribution-2"].effects,
    { type = "unlock-recipe", recipe = "eg-ugp-substation-displayer" })
