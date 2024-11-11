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
    for _, pole_type in ipairs({ "high", "low" }) do
        local pole_name = "eg-" .. pole_type .. "-voltage-pole-" .. direction
        local connection_name = "eg_" .. pole_type .. "_voltage_pole"
        local selection_box_func =
            pole_type == "high" and get_eg_high_voltage_pole_selection_box or get_eg_low_voltage_pole_selection_box
        local localised_name = pole_type == "high" and "High voltage pole" or "Low voltage pole"
        local localised_description = pole_type == "high" and "Connect to the electrical source" or
            "Connect to the electrical load"

        local pole = table.deepcopy(data.raw["electric-pole"]["big-electric-pole"])

        pole.name = pole_name
        pole.supply_area_distance = constants.EG_SUPPLY_AREA_DISTANCE
        pole.maximum_wire_distance = constants.EG_MAXIMUM_WIRE_DISTANCE
        pole.pictures = nil
        pole.water_reflection = nil
        pole.auto_connect_up_to_n_wires = 0
        pole.minable = nil
        pole.radius_visualisation_picture = nil
        pole.flags = constants.EG_INTERNAL_ENTITY_FLAGS
        pole.max_health = constants.EG_MAX_HEALTH
        pole.connection_points = eg_wireconnections(connection_name, direction)
        pole.selection_box = selection_box_func(direction)
        pole.localised_name = { "", localised_name }
        pole.localised_description = { "", localised_description }
        pole.hidden = true
        pole.hidden_in_factoriopedia = true
        pole.collision_mask = {
            layers = {
                ["is_lower_object"] = true
            }
        }

        data:extend({ pole })
    end
end
