if constants.EG_TRANSFORMATORS_ONLY then return end

if mods["quality"] then
    recycling = require("__quality__/prototypes/recycling")
end

local items                       = data.raw["item"]
local recipes                     = data.raw["recipe"]
local technologies                = data.raw["technology"]
local poles                       = data.raw["electric-pole"]

local small_pole                  = poles["small-electric-pole"]
local medium_pole                 = poles["medium-electric-pole"]
local big_pole                    = poles["big-electric-pole"]
local substation                  = poles["substation"]

small_pole.maximum_wire_distance  = constants.EG_MAX_WIRE_SMALL
small_pole.supply_area_distance   = constants.EG_MAX_SUPPLY_SMALL

medium_pole.supply_area_distance  = 0
medium_pole.maximum_wire_distance = constants.EG_MAX_WIRE_MEDIUM
medium_pole.light                 = constants.EG_MEDIUM_POLE_LIGHTS and constants.EG_MEDIUM_POLE_LIGHT or nil

big_pole.supply_area_distance     = 0
big_pole.maximum_wire_distance    = constants.EG_MAX_WIRE_BIG
big_pole.light                    = constants.EG_BIG_POLE_LIGHTS and constants.EG_BIG_POLE_LIGHT or nil
big_pole.subgroup                 = "eg-electric-distribution"

substation.subgroup               = "eg-electric-distribution"
substation.maximum_wire_distance  = constants.EG_MAX_WIRE_SUBSTATION
substation.supply_area_distance   = constants.EG_MAX_SUPPLY_SUBSTATION

if not mods["PowerOverload"] and not mods["Krastorio2"] and not mods["Krastorio2-spaced-out"] then
    substation.next_upgrade = "eg-ugp-substation-displayer"
end

if mods["quality"] and recipes["eg-ugp-substation-displayer-recycling"] then
    recipes["eg-ugp-substation-displayer-recycling"].results = recipes["substation-recycling"].results
end

for _, pole in pairs(poles) do
    pole.rewire_neighbours_when_destroying = false
end

items["small-electric-pole"].subgroup           = "eg-electric-distribution"
items["medium-electric-pole"].subgroup          = "eg-electric-distribution"
items["big-electric-pole"].subgroup             = "eg-electric-distribution"
items["substation"].subgroup                    = "eg-electric-distribution"

data.raw["power-switch"]["power-switch"].hidden = true
items["power-switch"].hidden                    = true
recipes["power-switch"].hidden                  = true

if not mods["aai-industry"] and recipes["small-iron-electric-pole"] then
    table.insert(technologies["electronics"].effects,
        { type = "unlock-recipe", recipe = "small-iron-electric-pole" })
end

if mods["PowerOverload"] then
    local po_huge_pole                                = poles["po-huge-electric-pole"]
    po_huge_pole.light                                = constants.EG_HUGE_POLE_LIGHTS and constants.EG_HUGE_POLE_LIGHT or
        nil
    po_huge_pole.maximum_wire_distance                = tonumber(settings.startup["eg-max-wire-huge"].value)
    po_huge_pole.drawing_box_vertical_extension       = 3

    items["po-huge-electric-pole"].subgroup           = "eg-electric-distribution"
    items["po-interface"].subgroup                    = "eg-electric-distribution"

    data.raw["power-switch"]["po-transformer"].hidden = true
    items["po-transformer"].hidden                    = true
    recipes["po-transformer"].hidden                  = true

    if mods["quality"] then
        recipes["po-transformer-recycling"].hidden = true
    end

    for _, pole in pairs(poles) do
        if string.sub(pole.name, 1, 3) == "po-" and string.find(pole.name, "-fuse") then
            data.raw["electric-pole"][pole.name].hidden = true
            items[pole.name].hidden                     = true
            recipes[pole.name].hidden                   = true
        end
    end

    technologies["po-electric-energy-distribution-3"].hidden = true

    table.insert(technologies["electric-energy-distribution-1"].effects,
        { type = "unlock-recipe", recipe = "po-huge-electric-pole" })

    table.insert(technologies["electric-energy-distribution-2"].effects,
        { type = "unlock-recipe", recipe = "po-interface" })
end

if mods["factorioplus"] then
    local effects = technologies["electric-energy-distribution-3"].effects
    if effects then
        for i, effect in ipairs(effects) do
            if effect.type == "unlock-recipe" and effect.recipe == "huge-electric-pole" then
                table.remove(effects, i)
                break
            end
        end
    end

    local huge_pole = poles["huge-electric-pole"]

    huge_pole.supply_area_distance = 0
    huge_pole.maximum_wire_distance = tonumber(settings.startup["eg-max-wire-huge"].value)

    items["medium-wooden-electric-pole"].subgroup = "eg-electric-distribution"
    items["huge-electric-pole"].subgroup = "eg-electric-distribution"
    items["electrical-distributor"].subgroup = "eg-electric-distribution"

    table.insert(data.raw["technology"]["electric-energy-distribution-1"].effects,
        { type = "unlock-recipe", recipe = "huge-electric-pole" })
end

if mods["aai-industry"] then
    local iron_pole = poles["small-iron-electric-pole"]
    if iron_pole then
        iron_pole.maximum_wire_distance = small_pole.maximum_wire_distance
        iron_pole.supply_area_distance  = small_pole.supply_area_distance

        local iron_pole_item            = items["small-iron-electric-pole"]
        iron_pole_item.subgroup         = "eg-electric-distribution"
    end

    local huge_pole_recipe = recipes["eg-huge-electric-pole"]
    if huge_pole_recipe then
        huge_pole_recipe.ingredients =
        {
            { type = "item", name = "steel-plate",  amount = 8 },
            { type = "item", name = "iron-stick",   amount = 12 },
            { type = "item", name = "copper-cable", amount = 20 },
            { type = "item", name = "concrete",     amount = 2 }
        }

        if mods["quality"] then
            recycling.generate_recycling_recipe(huge_pole_recipe)
        end
    end
end

if mods["cargo-ships"] and items["floating-electric-pole"] then
    items["floating-electric-pole"].subgroup = "eg-electric-distribution"
end

if mods["Krastorio2"] or mods["Krastorio2-spaced-out"] then
    local item = items["kr-superior-substation"]
    if item then
        item.order = items["substation"].order .. "y"
        item.subgroup = "eg-electric-distribution"
    end
end

if mods["energy-combinator"] then
    local pole = poles["power-combinator-meter-network"]
    if pole then pole.auto_connect_up_to_n_wires = 1 end
end
