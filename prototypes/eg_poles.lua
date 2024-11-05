local eg_high_voltage_pole = table.deepcopy(data.raw["electric-pole"]["big-electric-pole"])
eg_high_voltage_pole.name = "eg-high-voltage-pole"
eg_high_voltage_pole.supply_area_distance = 0.8
eg_high_voltage_pole.pictures = nil
eg_high_voltage_pole.water_reflection = nil
eg_high_voltage_pole.auto_connect_up_to_n_wires = 0
eg_high_voltage_pole.minable = nil

local eg_low_voltage_pole = table.deepcopy(data.raw["electric-pole"]["big-electric-pole"])
eg_low_voltage_pole.name = "eg-low-voltage-pole"
eg_low_voltage_pole.supply_area_distance = 0.8
eg_low_voltage_pole.pictures = nil
eg_low_voltage_pole.water_reflection = nil
eg_low_voltage_pole.auto_connect_up_to_n_wires = 0
eg_low_voltage_pole.minable = nil

data:extend({ eg_high_voltage_pole, eg_low_voltage_pole })
