local function eg_wireconnections(pole, direction)
    if not pole then return {} end
    if not direction then return {} end

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

local function hv_selection_box(direction)
    local selection_box = {}

    if direction == defines.direction.north then
        selection_box = {
            { -1, 0 },
            { 1,  1 }
        }
    elseif direction == defines.direction.east then
        selection_box = {
            { -1, -1 },
            { 0,  1 }
        }
    elseif direction == defines.direction.south then
        selection_box = {
            { -1, -1 },
            { 1,  0 }
        }
    elseif direction == defines.direction.west then
        selection_box = {
            { 0, -1 },
            { 1, 1 }
        }
    end

    return selection_box
end

local function lv_selection_box(direction)
    local selection_box = {}

    if direction == defines.direction.north then
        selection_box = {
            { -1, -1 },
            { 1,  0 }
        }
    elseif direction == defines.direction.east then
        selection_box = {
            { 0, -1 },
            { 1, 1 }
        }
    elseif direction == defines.direction.south then
        selection_box = {
            { -1, 0 },
            { 1,  1 }
        }
    elseif direction == defines.direction.west then
        selection_box = {
            { -1, -1 },
            { 0,  1 }
        }
    end

    return selection_box
end

for direction, _ in pairs(constants.EG_DIRECTION_TO_CARDINAL) do
    for _, pole_type in ipairs({ "high", "low" }) do
        local pole_name = "eg-" .. pole_type .. "-voltage-pole-" .. direction
        local connection_name = "eg_" .. pole_type .. "_voltage_pole"
        local selection_box = pole_type == "high" and hv_selection_box(direction) or lv_selection_box(direction)
        local localised_name = pole_type == "high" and "High voltage pole" or "Low voltage pole"
        local localised_description = pole_type == "high" and "Connect to the electrical source" or
            "Connect to the electrical load"

        local pole = table.deepcopy(data.raw["electric-pole"]["big-electric-pole"])

        pole.name = pole_name
        pole.supply_area_distance = constants.EG_SUPPLY_AREA_DISTANCE
        pole.maximum_wire_distance = constants.EG_MAXIMUM_WIRE_DISTANCE
        pole.pictures = nil
        pole.water_reflection = nil
        pole.radius_visualisation_picture = nil
        pole.drawing_box_vertical_extension = 0
        pole.auto_connect_up_to_n_wires = 0
        pole.minable = nil
        pole.selectable_in_game = true
        pole.flags = constants.EG_INTERNAL_ENTITY_FLAGS
        pole.max_health = constants.EG_MAX_HEALTH
        pole.connection_points = eg_wireconnections(connection_name, direction)
        pole.collision_box = { { -0.9, -0.9 }, { 0.9, 0.9 } }
        --pole.collision_box = { { -0.49, -0.49 }, { 0.49, 0.49 } }
        --pole.selection_box = { { -0.49, -0.49 }, { 0.49, 0.49 } }
        pole.selection_box = selection_box
        pole.localised_name = { "", localised_name }
        pole.localised_description = { "", localised_description }
        pole.hidden = true
        pole.hidden_in_factoriopedia = true
        pole.collision_mask = { layers = {} }

        data:extend({ pole })
    end
end
