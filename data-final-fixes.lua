local small = data.raw["electric-pole"]["small-electric-pole"]
local medium = data.raw["electric-pole"]["medium-electric-pole"]
local big = data.raw["electric-pole"]["big-electric-pole"]
local huge = data.raw["electric-pole"]["eg-huge-electric-pole"]

-- Hide the power switch
data.raw["recipe"]["power-switch"].hidden = true
data.raw["item"]["power-switch"].hidden = true
data.raw["power-switch"]["power-switch"].hidden = true

-- Transmission pole modifications
medium.maximum_wire_distance = 10
medium.supply_area_distance = 0

big.maximum_wire_distance = 25
big.supply_area_distance = 0

huge.maximum_wire_distance = 50
huge.supply_area_distance = 0

-- Distribution pole modifications
small.maximum_wire_distance = 8.5
small.supply_area_distance = 3

-- No love for the substation (and ugp substation)

-- Adjust recipes for technology research completed
table.insert(data.raw.technology["electric-energy-distribution-1"].effects,
    { type = "unlock-recipe", recipe = "eg-huge-electric-pole" })

if constants.EG_UGP_SUBSTATION then
    table.insert(data.raw.technology["electric-energy-distribution-2"].effects,
        { type = "unlock-recipe", recipe = "eg-ugp-substation-displayer" })
end
