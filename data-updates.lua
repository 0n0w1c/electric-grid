if constants.EG_TRANSFORMATORS_ONLY then return end

local small_pole  = data.raw["electric-pole"]["small-electric-pole"]
local medium_pole = data.raw["electric-pole"]["medium-electric-pole"]
local big_pole    = data.raw["electric-pole"]["big-electric-pole"]
local substation  = data.raw["electric-pole"]["substation"]


small_pole.maximum_wire_distance = medium_pole.maximum_wire_distance
small_pole.supply_area_distance  = medium_pole.supply_area_distance


medium_pole.supply_area_distance = 0.01
medium_pole.light                = constants.EG_MEDIUM_POLE_LIGHTS and constants.EG_MEDIUM_POLE_LIGHT or nil


big_pole.supply_area_distance  = 0.01
big_pole.maximum_wire_distance = substation.maximum_wire_distance
big_pole.light                 = constants.EG_BIG_POLE_LIGHTS and constants.EG_BIG_POLE_LIGHT or nil
big_pole.subgroup              = "eg-electric-distribution"


substation.next_upgrade = "eg-ugp-substation-displayer"
substation.subgroup     = "eg-electric-distribution"


-- Place electric poles in their own subgroup
data.raw["item"]["small-electric-pole"].subgroup  = "eg-electric-distribution"
data.raw["item"]["medium-electric-pole"].subgroup = "eg-electric-distribution"
data.raw["item"]["big-electric-pole"].subgroup    = "eg-electric-distribution"
data.raw["item"]["substation"].subgroup           = "eg-electric-distribution"


-- Hide switch
data.raw["power-switch"]["power-switch"].hidden = true
data.raw["item"]["power-switch"].hidden         = true
data.raw["recipe"]["power-switch"].hidden       = true

-- Conditionally adjust the radar placement alignment
if constants.EG_EVEN_ALIGN_RADAR then
    data.raw["radar"]["radar"].collision_box = { { -1.51, -1.51 }, { 1.51, 1.51 } }
end

-- Technologies
table.insert(data.raw["technology"]["electric-energy-distribution-1"].effects,
    { type = "unlock-recipe", recipe = "eg-huge-electric-pole" })

table.insert(data.raw["technology"]["electric-energy-distribution-2"].effects,
    { type = "unlock-recipe", recipe = "eg-ugp-substation-displayer" })

table.insert(data.raw["technology"]["circuit-network"].effects,
    { type = "unlock-recipe", recipe = "eg-circuit-pole" })

-- Mod support
if mods["aai-industry"] then
    local iron_pole                 = data.raw["electric-pole"]["small-iron-electric-pole"]

    iron_pole.maximum_wire_distance = small_pole.maximum_wire_distance
    iron_pole.supply_area_distance  = small_pole.supply_area_distance

    local iron_pole_item            = data.raw["item"]["small-iron-electric-pole"]
    iron_pole_item.subgroup         = "eg-electric-distribution"

    local huge_pole_recipe          = data.raw["recipe"]["eg-huge-electric-pole"]
    huge_pole_recipe.ingredients    =
    {
        { type = "item", name = "steel-plate",  amount = 8 },
        { type = "item", name = "iron-stick",   amount = 12 },
        { type = "item", name = "copper-cable", amount = 20 },
        { type = "item", name = "concrete",     amount = 2 }
    }
end

if mods["cargo-ships"] and data.raw["item"]["floating-electric-pole"] then
    data.raw["item"]["floating-electric-pole"].subgroup = "eg-electric-distribution"
end
