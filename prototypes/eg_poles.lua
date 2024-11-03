local eg_high_voltage_pole = table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
eg_high_voltage_pole.name = "eg-high-voltage-pole"
eg_high_voltage_pole.supply_area_distance = 0.4

local eg_low_voltage_pole = table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
eg_low_voltage_pole.name = "eg-low-voltage-pole"
eg_low_voltage_pole.supply_area_distance = 0.4

data:extend({ eg_high_voltage_pole, eg_low_voltage_pole })
