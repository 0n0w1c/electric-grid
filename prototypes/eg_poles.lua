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

local function get_eg_high_voltage_pole_selection_box(direction)
    if direction == defines.direction.north then
        return {
            { -1, 0 },
            { 1,  1 }
        }
    elseif direction == defines.direction.east then
        return {
            { -1, -1 },
            { 0,  1 }
        }
    elseif direction == defines.direction.south then
        return {
            { -1, -1 },
            { 1,  0 }
        }
    elseif direction == defines.direction.west then
        return {
            { 0, -1 },
            { 1, 1 }
        }
    end
    return {
        { -1, -1 },
        { 1,  1 }
    }
end

local function get_eg_low_voltage_pole_selection_box(direction)
    if direction == defines.direction.north then
        return {
            { -1, -1 },
            { 1,  0 }
        }
    elseif direction == defines.direction.east then
        return {
            { 0, -1 },
            { 1, 1 }
        }
    elseif direction == defines.direction.south then
        return {
            { -1, 0 },
            { 1,  1 }
        }
    elseif direction == defines.direction.west then
        return {
            { -1, -1 },
            { 0,  1 }
        }
    end
    return {
        { -1, -1 },
        { 1,  1 }
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
    eg_high_voltage_pole.radius_visualisation_picture = nil
    eg_high_voltage_pole.flags = constants.EG_INTERNAL_ENTITY_FLAGS
    eg_high_voltage_pole.max_health = constants.EG_MAX_HEALTH
    eg_high_voltage_pole.connection_points = eg_wireconnections("eg_high_voltage_pole", direction)
    eg_high_voltage_pole.selection_box = get_eg_high_voltage_pole_selection_box(direction)
    eg_high_voltage_pole.localised_name = { "", "High Voltage Pole" }
    eg_high_voltage_pole.localised_description = { "", "Connect to the electrical source" }
    eg_high_voltage_pole.hidden_in_factoriopedia = true

    local eg_low_voltage_pole = table.deepcopy(data.raw["electric-pole"]["big-electric-pole"])

    eg_low_voltage_pole.name = "eg-low-voltage-pole-" .. direction
    eg_low_voltage_pole.supply_area_distance = 0.8
    eg_low_voltage_pole.pictures = nil
    eg_low_voltage_pole.water_reflection = nil
    eg_low_voltage_pole.auto_connect_up_to_n_wires = 0
    eg_low_voltage_pole.minable = nil
    eg_low_voltage_pole.radius_visualisation_picture = nil
    eg_low_voltage_pole.flags = constants.EG_INTERNAL_ENTITY_FLAGS
    eg_low_voltage_pole.max_health = constants.EG_MAX_HEALTH
    eg_low_voltage_pole.connection_points = eg_wireconnections("eg_low_voltage_pole", direction)
    eg_low_voltage_pole.selection_box = get_eg_low_voltage_pole_selection_box(direction)
    eg_low_voltage_pole.localised_name = { "", "Low Voltage Pole" }
    eg_low_voltage_pole.localised_description = { "", "Connect to the electrical load" }
    eg_low_voltage_pole.hidden_in_factoriopedia = true

    data:extend({ eg_high_voltage_pole, eg_low_voltage_pole })
end
