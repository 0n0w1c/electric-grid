data.raw["electric-pole"]["small-electric-pole"].maximum_wire_distance =
    data.raw["electric-pole"]["medium-electric-pole"].maximum_wire_distance
data.raw["electric-pole"]["small-electric-pole"].supply_area_distance =
    data.raw["electric-pole"]["medium-electric-pole"].supply_area_distance

if mods["aai-industry"] then
    data.raw["electric-pole"]["small-iron-electric-pole"].maximum_wire_distance =
        data.raw["electric-pole"]["medium-electric-pole"].maximum_wire_distance
    data.raw["electric-pole"]["small-iron-electric-pole"].supply_area_distance =
        data.raw["electric-pole"]["medium-electric-pole"].supply_area_distance
end

data.raw["electric-pole"]["medium-electric-pole"].supply_area_distance = 0
data.raw["electric-pole"]["medium-electric-pole"].light = constants.EG_POLE_LIGHT

data.raw["electric-pole"]["big-electric-pole"].supply_area_distance = 0
data.raw["electric-pole"]["big-electric-pole"].maximum_wire_distance =
    data.raw["electric-pole"]["substation"].maximum_wire_distance
data.raw["electric-pole"]["big-electric-pole"].light = constants.EG_POLE_LIGHT

data.raw["electric-pole"]["substation"].next_upgrade = "eg-ugp-substation-displayer"

-- Hide switch
data.raw["power-switch"]["power-switch"].hidden = true
data.raw["item"]["power-switch"].hidden = true
data.raw["recipe"]["power-switch"].hidden = true

-- Technology
table.insert(data.raw["technology"]["electric-energy-distribution-1"].effects,
    { type = "unlock-recipe", recipe = "eg-huge-electric-pole" })

table.insert(data.raw["technology"]["electric-energy-distribution-2"].effects,
    { type = "unlock-recipe", recipe = "eg-ugp-substation-displayer" })

if mods["ConnectionBox"] then
    data.raw["electric-pole"]["connection-box"].supply_area_distance = 0
    data.raw["electric-pole"]["connection-box"].maximum_wire_distance =
        data.raw["electric-pole"]["medium-electric-pole"].maximum_wire_distance
    data.raw["electric-pole"]["connection-box"].minable.mining_time =
        data.raw["electric-pole"]["medium-electric-pole"].minable.mining_time

    data.raw["item"]["connection-box"].icon = constants.EG_GRAPHICS .. "/icons/eg-connection-box.png"
    data.raw["item"]["connection-box"].icon_size = 256

    data.raw["recipe"]["connection-box"].results[1].amount = 1
end
