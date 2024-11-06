-- Calculates wire connection points with specified offset for visual separation.
-- Determines positions for copper, red, and green wires around an electric pole.
-- @param pole string The type of the pole ("eg-high-voltage-pole" or "eg-low-voltage-pole").
-- @param direction 0, 4, 8, 12
-- @return table An array of connection points with positions for each wire type.
local function eg_wireconnections(pole, direction)
    if not pole then return end
    if not direction then return end

    local base_position = constants.EG_POLE_CONNECTIONS[pole][constants.EG_DIRECTION_TO_CARDINAL[direction]]
    local offset = constants.EG_WIRE_CONNECTION_OFFSET

    return {
        {
            wire = {
                copper = { base_position.wire[1], base_position.wire[2] },
                red = { base_position.wire[1] + offset, base_position.wire[2] + offset },
                green = { base_position.wire[1] - offset, base_position.wire[2] + offset }
            },
            shadow = {
                copper = { base_position.shadow[1], base_position.shadow[2] },
                red = { base_position.shadow[1] + offset, base_position.shadow[2] + offset },
                green = { base_position.shadow[1] - offset, base_position.shadow[2] + offset }
            }
        }
    }
end

-- Loop to define high and low voltage poles for each direction
for direction, _ in pairs(constants.EG_DIRECTION_TO_CARDINAL) do
    local eg_high_voltage_pole = table.deepcopy(data.raw["electric-pole"]["big-electric-pole"])

    eg_high_voltage_pole.name = "eg-high-voltage-pole-" .. direction
    eg_high_voltage_pole.supply_area_distance = 0.8
    eg_high_voltage_pole.pictures = nil
    eg_high_voltage_pole.water_reflection = nil
    eg_high_voltage_pole.auto_connect_up_to_n_wires = 0
    eg_high_voltage_pole.minable = nil
    eg_high_voltage_pole.connection_points = eg_wireconnections("eg_high_voltage_pole", direction)

    local eg_low_voltage_pole = table.deepcopy(data.raw["electric-pole"]["big-electric-pole"])

    eg_low_voltage_pole.name = "eg-low-voltage-pole-" .. direction
    eg_low_voltage_pole.supply_area_distance = 0.8
    eg_low_voltage_pole.pictures = nil
    eg_low_voltage_pole.water_reflection = nil
    eg_low_voltage_pole.auto_connect_up_to_n_wires = 0
    eg_low_voltage_pole.minable = nil
    eg_low_voltage_pole.connection_points = eg_wireconnections("eg_low_voltage_pole", direction)

    data:extend({ eg_high_voltage_pole, eg_low_voltage_pole })
end
