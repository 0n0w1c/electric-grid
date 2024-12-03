local small_pole = data.raw["electric-pole"]["small-electric-pole"]
local medium_pole = data.raw["electric-pole"]["medium-electric-pole"]
local big_pole = data.raw["electric-pole"]["big-electric-pole"]
local substation = data.raw["electric-pole"]["substation"]

small_pole.maximum_wire_distance = medium_pole.maximum_wire_distance
small_pole.supply_area_distance = medium_pole.supply_area_distance

medium_pole.supply_area_distance = 0
medium_pole.light = constants.EG_MEDIUM_POLE_LIGHT

big_pole.supply_area_distance = 0
big_pole.maximum_wire_distance = substation.maximum_wire_distance
big_pole.light = constants.EG_BIG_POLE_LIGHT

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

-- Mod the mods
if mods["aai-industry"] then
    local iron_pole = data.raw["electric-pole"]["small-iron-electric-pole"]

    iron_pole.maximum_wire_distance = medium_pole.maximum_wire_distance
    iron_pole.supply_area_distance = medium_pole.supply_area_distance
end

if mods["ConnectionBox"] then
    local connection_box = data.raw["electric-pole"]["connection-box"]

    connection_box.supply_area_distance = 0
    connection_box.maximum_wire_distance = substation.maximum_wire_distance / 2
    connection_box.minable.mining_time = substation.minable.mining_time
    connection_box.light = constants.EG_MINI_POLE_LIGHT

    data.raw["item"]["connection-box"].icon = constants.EG_GRAPHICS .. "/icons/eg-connection-box.png"
    data.raw["item"]["connection-box"].icon_size = 256

    data.raw["recipe"]["connection-box"].ingredients =
    {
        { type = "item", name = "iron-stick",   amount = 3 },
        { type = "item", name = "copper-cable", amount = 3 }
    }

    if mods["quality"] and data.raw["recipe"]["connection-box-recycling"] then
        data.raw["recipe"]["connection-box-recycling"].results =
        {
            { type = "item", name = "iron-stick",   amount = 0.125, extra_count_fraction = 0.125 },
            { type = "item", name = "copper-cable", amount = 0.125, extra_count_fraction = 0.125 },
        }
    end

    -- Lock recipe due to iron stick ingredient
    data.raw["recipe"]["connection-box"].enabled = false
    table.insert(data.raw["technology"]["circuit-network"].effects, { recipe = "connection-box", type = "unlock-recipe" })
end
