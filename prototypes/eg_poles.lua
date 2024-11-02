-- High Voltage Pole Entity
local eg_high_voltage_pole = table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
eg_high_voltage_pole.name = "eg-high-voltage-pole"
eg_high_voltage_pole.supply_area_distance = 0.9

-- High Voltage Pole Item
local eg_high_voltage_pole_item = {
    type = "item",
    name = "eg-high-voltage-pole",
    icon = "__base__/graphics/icons/small-electric-pole.png", -- Optionally set a custom icon
    icon_size = 64,
    place_result = "eg-high-voltage-pole",
    subgroup = "energy-pipe-distribution",
    order = "b[electric-pole]-a[eg-high-voltage-pole]",
    stack_size = 50
}

-- High Voltage Pole Recipe
local eg_high_voltage_pole_recipe = {
    type = "recipe",
    name = "eg-high-voltage-pole",
    results = { { type = "item", name = "eg-high-voltage-pole", amount = 1 } },
    enabled = true -- Enable the recipe by default
}

-- Low Voltage Pole Entity
local eg_low_voltage_pole = table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
eg_low_voltage_pole.name = "eg-low-voltage-pole"
eg_low_voltage_pole.supply_area_distance = 0.9

-- Low Voltage Pole Item
local eg_low_voltage_pole_item = {
    type = "item",
    name = "eg-low-voltage-pole",
    icon = "__base__/graphics/icons/small-electric-pole.png", -- Optionally set a custom icon
    icon_size = 64,
    place_result = "eg-low-voltage-pole",
    subgroup = "energy-pipe-distribution",
    order = "b[electric-pole]-b[eg-low-voltage-pole]",
    stack_size = 50
}

-- Low Voltage Pole Recipe
local eg_low_voltage_pole_recipe = {
    type = "recipe",
    name = "eg-low-voltage-pole",
    results = { { type = "item", name = "eg-low-voltage-pole", amount = 1 } },
    enabled = true -- Enable the recipe by default
}

-- Register all entities, items, and recipes
data:extend({
    eg_high_voltage_pole,
    eg_high_voltage_pole_item,
    eg_high_voltage_pole_recipe,
    eg_low_voltage_pole,
    eg_low_voltage_pole_item,
    eg_low_voltage_pole_recipe
})
