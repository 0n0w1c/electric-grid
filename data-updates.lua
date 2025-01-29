if mods["PowerOverload"] then
    local po_huge_pole                          = data.raw["electric-pole"]["po-huge-electric-pole"]

    po_huge_pole.light                          = constants.EG_HUGE_POLE_LIGHTS and constants.EG_HUGE_POLE_LIGHT or nil
    po_huge_pole.maximum_wire_distance          = tonumber(settings.startup["eg-max-wire-huge"].value)
    po_huge_pole.drawing_box_vertical_extension = 3

    if not constants.EG_TRANSFORMATORS_ONLY then
        data.raw["item"]["po-huge-electric-pole"].subgroup = "eg-electric-distribution"
        data.raw["item"]["po-interface"].subgroup          = "eg-electric-distribution"
    end

    data.raw["power-switch"]["po-transformer"].hidden     = true
    data.raw["item"]["po-transformer"].hidden             = true
    data.raw["recipe"]["po-transformer"].hidden           = true
    data.raw["recipe"]["po-transformer-recycling"].hidden = true


    local poles = data.raw["electric-pole"]
    for _, pole in pairs(poles) do
        if string.sub(pole.name, 1, 3) == "po-" and string.find(pole.name, "-fuse") then
            data.raw["electric-pole"][pole.name].hidden = true
            data.raw["item"][pole.name].hidden          = true
            data.raw["recipe"][pole.name].hidden        = true
        end
    end

    data.raw["technology"]["po-electric-energy-distribution-3"].hidden = true

    table.insert(data.raw["technology"]["electric-energy-distribution-1"].effects,
        { type = "unlock-recipe", recipe = "po-huge-electric-pole" })

    table.insert(data.raw["technology"]["electric-energy-distribution-2"].effects,
        { type = "unlock-recipe", recipe = "po-interface" })
end

if constants.EG_TRANSFORMATORS_ONLY then return end

local small_pole                 = data.raw["electric-pole"]["small-electric-pole"]
local medium_pole                = data.raw["electric-pole"]["medium-electric-pole"]
local big_pole                   = data.raw["electric-pole"]["big-electric-pole"]
local substation                 = data.raw["electric-pole"]["substation"]

small_pole.maximum_wire_distance = medium_pole.maximum_wire_distance
small_pole.supply_area_distance  = medium_pole.supply_area_distance

medium_pole.supply_area_distance = 0
medium_pole.light                = constants.EG_MEDIUM_POLE_LIGHTS and constants.EG_MEDIUM_POLE_LIGHT or nil

big_pole.supply_area_distance    = 0
big_pole.maximum_wire_distance   = substation.maximum_wire_distance
big_pole.light                   = constants.EG_BIG_POLE_LIGHTS and constants.EG_BIG_POLE_LIGHT or nil
big_pole.subgroup                = "eg-electric-distribution"

substation.subgroup              = "eg-electric-distribution"
if not mods["PowerOverload"] then
    substation.next_upgrade = "eg-ugp-substation-displayer"
end

data.raw["item"]["small-electric-pole"].subgroup  = "eg-electric-distribution"
data.raw["item"]["medium-electric-pole"].subgroup = "eg-electric-distribution"
data.raw["item"]["big-electric-pole"].subgroup    = "eg-electric-distribution"
data.raw["item"]["substation"].subgroup           = "eg-electric-distribution"

data.raw["power-switch"]["power-switch"].hidden   = true
data.raw["item"]["power-switch"].hidden           = true
data.raw["recipe"]["power-switch"].hidden         = true

if mods["factorioplus"] then
    local effects = data.raw["technology"]["electric-energy-distribution-3"].effects
    for i, effect in ipairs(effects) do
        if effect.type == "unlock-recipe" and effect.recipe == "huge-electric-pole" then
            table.remove(effects, i)
            break
        end
    end

    local huge_pole = data.raw["electric-pole"]["huge-electric-pole"]

    huge_pole.supply_area_distance = 0
    huge_pole.maximum_wire_distance = tonumber(settings.startup["eg-max-wire-huge"].value)

    data.raw["item"]["medium-wooden-electric-pole"].subgroup = "eg-electric-distribution"
    data.raw["item"]["huge-electric-pole"].subgroup = "eg-electric-distribution"
    data.raw["item"]["electrical-distributor"].subgroup = "eg-electric-distribution"

    table.insert(data.raw["technology"]["electric-energy-distribution-1"].effects,
        { type = "unlock-recipe", recipe = "huge-electric-pole" })
end

if mods["aai-industry"] then
    local iron_pole = data.raw["electric-pole"]["small-iron-electric-pole"]

    if iron_pole then
        iron_pole.maximum_wire_distance = small_pole.maximum_wire_distance
        iron_pole.supply_area_distance  = small_pole.supply_area_distance

        local iron_pole_item            = data.raw["item"]["small-iron-electric-pole"]
        iron_pole_item.subgroup         = "eg-electric-distribution"
    end

    local huge_pole_recipe = data.raw["recipe"]["eg-huge-electric-pole"]

    if huge_pole_recipe then
        huge_pole_recipe.ingredients =
        {
            { type = "item", name = "steel-plate",  amount = 8 },
            { type = "item", name = "iron-stick",   amount = 12 },
            { type = "item", name = "copper-cable", amount = 20 },
            { type = "item", name = "concrete",     amount = 2 }
        }

        if mods["quality"] then
            local recycling = require("__quality__/prototypes/recycling")

            recycling.generate_recycling_recipe(huge_pole_recipe)
        end
    end
end

if mods["cargo-ships"] and data.raw["item"]["floating-electric-pole"] then
    data.raw["item"]["floating-electric-pole"].subgroup = "eg-electric-distribution"
end

if mods["quality"] and data.raw["recipe"]["eg-ugp-substation-displayer-recycling"] then
    data.raw["recipe"]["eg-ugp-substation-displayer-recycling"].results =
        data.raw["recipe"]["substation-recycling"].results
end

-- Conditionally adjust the radar placement alignment
if constants.EG_EVEN_ALIGN_RADAR then
    data.raw["radar"]["radar"].collision_box = { { -1.51, -1.51 }, { 1.51, 1.51 } }
end
