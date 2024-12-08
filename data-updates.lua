local small_pole = data.raw["electric-pole"]["small-electric-pole"]
local medium_pole = data.raw["electric-pole"]["medium-electric-pole"]
local big_pole = data.raw["electric-pole"]["big-electric-pole"]
local substation = data.raw["electric-pole"]["substation"]

small_pole.maximum_wire_distance = medium_pole.maximum_wire_distance
small_pole.supply_area_distance = medium_pole.supply_area_distance

medium_pole.supply_area_distance = 0
medium_pole.light = constants.EG_MEDIUM_POLE_LIGHTS and constants.EG_MEDIUM_POLE_LIGHT or nil

big_pole.supply_area_distance = 0
big_pole.maximum_wire_distance = substation.maximum_wire_distance
big_pole.light = constants.EG_BIG_POLE_LIGHTS and constants.EG_BIG_POLE_LIGHT or nil

substation.next_upgrade = "eg-ugp-substation-displayer"

-- Hide switch
data.raw["power-switch"]["power-switch"].hidden = true
data.raw["item"]["power-switch"].hidden = true
data.raw["recipe"]["power-switch"].hidden = true

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
    local iron_pole = data.raw["electric-pole"]["small-iron-electric-pole"]

    iron_pole.maximum_wire_distance = small_pole.maximum_wire_distance
    iron_pole.supply_area_distance = small_pole.supply_area_distance
end
