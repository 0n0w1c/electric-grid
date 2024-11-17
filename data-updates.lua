-- Modify electric poles
data.raw["electric-pole"]["small-electric-pole"].maximum_wire_distance =
    data.raw["electric-pole"]["medium-electric-pole"].maximum_wire_distance
data.raw["electric-pole"]["small-electric-pole"].supply_area_distance =
    data.raw["electric-pole"]["medium-electric-pole"].supply_area_distance

data.raw["electric-pole"]["medium-electric-pole"].supply_area_distance = 0
data.raw["electric-pole"]["medium-electric-pole"].light =
{
    intensity = 0.8,
    size = 12,
    color = constants.EG_POLE_LIGHT
}

data.raw["electric-pole"]["big-electric-pole"].supply_area_distance = 0
data.raw["electric-pole"]["big-electric-pole"].maximum_wire_distance =
    data.raw["electric-pole"]["substation"].maximum_wire_distance
data.raw["electric-pole"]["big-electric-pole"].light =
{
    intensity = 0.8,
    size = 12,
    color = constants.EG_POLE_LIGHT
}

-- Hide the power switch
data.raw["power-switch"]["power-switch"].hidden = true
data.raw["item"]["power-switch"].hidden = true
data.raw["recipe"]["power-switch"].hidden = true

-- Update technology research effects
table.insert(data.raw["technology"]["electric-energy-distribution-1"].effects,
    { type = "unlock-recipe", recipe = "eg-huge-electric-pole" })

table.insert(data.raw["technology"]["electric-energy-distribution-2"].effects,
    { type = "unlock-recipe", recipe = "eg-ugp-substation-displayer" })
