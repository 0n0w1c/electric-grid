data.raw["electric-pole"]["small-electric-pole"].maximum_wire_distance = 8.5
data.raw["electric-pole"]["small-electric-pole"].supply_area_distance = 3

data.raw["electric-pole"]["medium-electric-pole"].maximum_wire_distance = 10
data.raw["electric-pole"]["medium-electric-pole"].supply_area_distance = 0

data.raw["electric-pole"]["big-electric-pole"].maximum_wire_distance = 18
data.raw["electric-pole"]["big-electric-pole"].supply_area_distance = 0

data.raw["power-switch"]["power-switch"].hidden = true
data.raw["item"]["power-switch"].hidden = true
data.raw["recipe"]["power-switch"].hidden = true

table.insert(data.raw["technology"]["electric-energy-distribution-1"].effects,
    { type = "unlock-recipe", recipe = "eg-huge-electric-pole" })

table.insert(data.raw["technology"]["electric-energy-distribution-2"].effects,
    { type = "unlock-recipe", recipe = "eg-ugp-substation-displayer" })
