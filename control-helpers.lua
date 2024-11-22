--- Get the position offset for the boiler based on direction.
-- @param direction defines.direction The direction of the transformator.
-- @return table The position offset as {x, y}.
function get_eg_boiler_offset(direction)
    if direction == defines.direction.north then
        return { x = -1, y = 0 }
    elseif direction == defines.direction.east then
        return { x = -1, y = -1 }
    elseif direction == defines.direction.south then
        return { x = 0, y = -1 }
    elseif direction == defines.direction.west then
        return { x = 0, y = 0 }
    end
    return { x = 0, y = 0 }
end

--- Get the position offset for the pump based on direction.
-- @param direction defines.direction The direction of the transformator.
-- @return table The position offset as {x, y}.
function get_eg_pump_offset(direction)
    if direction == defines.direction.north then
        return { x = 0, y = 0 }
    elseif direction == defines.direction.east then
        return { x = -1, y = 0 }
    elseif direction == defines.direction.south then
        return { x = -1, y = -1 }
    elseif direction == defines.direction.west then
        return { x = 0, y = -1 }
    end
    return { x = 0, y = 0 }
end

--- Get the position offset for the infinity pipe based on direction.
-- @param direction defines.direction The direction of the transformator.
-- @return table The position offset as {x, y}.
function get_eg_infinity_pipe_offset(direction)
    if direction == defines.direction.north then
        return { x = 0, y = -1 }
    elseif direction == defines.direction.east then
        return { x = -0, y = 0 }
    elseif direction == defines.direction.south then
        return { x = -1, y = 0 }
    elseif direction == defines.direction.west then
        return { x = -1, y = -1 }
    end
    return { x = 0, y = 0 }
end

--- Get the position offset for the steam engine based on direction.
-- @param direction defines.direction The direction of the transformator.
-- @return table The position offset as {x, y}.
function get_eg_steam_engine_offset(direction)
    if direction == defines.direction.north then
        return { x = -1, y = -1 }
    elseif direction == defines.direction.east then
        return { x = 0, y = -1 }
    elseif direction == defines.direction.south then
        return { x = 0, y = 0 }
    elseif direction == defines.direction.west then
        return { x = -1, y = 0 }
    end
    return { x = 0, y = 0 }
end

--- Get the position offset for the high-voltage pole based on direction.
-- @param direction defines.direction The direction of the transformator.
-- @return table The position offset as {x, y}.
function get_eg_high_voltage_pole_offset(direction)
    if direction == defines.direction.north then
        return { x = 0, y = 1 }
    elseif direction == defines.direction.east then
        return { x = -1, y = 0 }
    elseif direction == defines.direction.south then
        return { x = 0, y = -1 }
    elseif direction == defines.direction.west then
        return { x = 1, y = 0 }
    end
    return { x = 0, y = 0 }
end

--- Get the position offset for the low-voltage pole based on direction.
-- @param direction defines.direction The direction of the transformator.
-- @return table The position offset as {x, y}.
function get_eg_low_voltage_pole_offset(direction)
    if direction == defines.direction.north then
        return { x = 0, y = -1 }
    elseif direction == defines.direction.east then
        return { x = 1, y = 0 }
    elseif direction == defines.direction.south then
        return { x = 0, y = 1 }
    elseif direction == defines.direction.west then
        return { x = -1, y = 0 }
    end
    return { x = 0, y = 0 }
end

--- Check if the given name corresponds to a transformator.
-- @param name string The name of the entity to check.
-- @return boolean True if the entity is a transformator, false otherwise.
function is_transformator(name)
    if name == constants.EG_DISPLAYER or constants.EG_TRANSFORMATORS[name] then
        return true
    end
    return false
end

--- Find the transformator associated with a given pump.
-- @param pump LuaEntity The pump entity to check.
-- @return table|nil The transformator object if found, nil otherwise.
function find_transformator_by_pump(pump)
    if not (pump and pump.valid) then return nil end
    for _, transformator in pairs(storage.eg_transformators) do
        if transformator.pump and transformator.pump.valid and transformator.pump == pump then
            return transformator
        end
    end
    return nil
end

--- Replace the boiler and steam engine for the given transformator.
-- @param transformator table The transformator to replace components for.
function replace_boiler_steam_engine(transformator)
    if not transformator then return end

    local unit_name = transformator.unit.name
    local tier = string.sub(unit_name, -1)
    if not tier then return end

    local force = transformator.unit.force
    local surface = transformator.unit.surface
    local unit_number = transformator.unit.unit_number

    if storage.eg_transformators[unit_number] then
        local eg_transformator = storage.eg_transformators[unit_number]

        local name = eg_transformator.boiler.name
        local direction = eg_transformator.boiler.direction
        local position = eg_transformator.boiler.position

        if eg_transformator.boiler and eg_transformator.boiler.valid then
            eg_transformator.boiler.destroy()
        end

        local eg_boiler = surface.create_entity {
            name = name,
            position = position,
            force = force,
            direction = direction
        }

        name = eg_transformator.steam_engine.name
        direction = eg_transformator.steam_engine.direction
        position = eg_transformator.steam_engine.position

        if eg_transformator.steam_engine and eg_transformator.steam_engine.valid then
            eg_transformator.steam_engine.destroy()
        end

        local eg_steam_engine = surface.create_entity {
            name = name,
            position = position,
            force = force,
            direction = direction
        }

        storage.eg_transformators[unit_number].boiler = eg_boiler
        storage.eg_transformators[unit_number].steam_engine = eg_steam_engine
    else
        --game.print("Error: Transformator with unit_number " .. unit_number .. " not found.")
    end
end

--- Handle the building of a transformator.
-- Replaces the transformator displayer entity with the full transformator setup.
-- @param entity LuaEntity The entity being built.
function eg_transformator_built(entity)
    if not entity or not entity.name then return end

    if not is_transformator(entity.name) then return end

    local surface = entity.surface
    local force = entity.force
    local position = entity.position
    local direction = entity.direction
    local offset = { x = 0, y = 0 }

    entity.destroy()

    local eg_unit_position = { position.x, position.y }

    local eg_unit = surface.create_entity {
        name = "eg-unit-1",
        position = eg_unit_position,
        force = force,
        direction = direction
    }

    offset = get_eg_boiler_offset(direction)
    local eg_boiler_position = { position.x + offset.x, position.y + offset.y }

    local eg_boiler = surface.create_entity {
        name = "eg-boiler-" .. direction .. "-1",
        position = eg_boiler_position,
        force = force,
        direction = direction
    }

    offset = get_eg_pump_offset(direction)
    local eg_pump_position = { position.x + offset.x, position.y + offset.y }

    local eg_pump = surface.create_entity {
        name = "eg-pump-" .. direction,
        position = eg_pump_position,
        force = force,
        direction = direction,
    }

    offset = get_eg_infinity_pipe_offset(direction)
    local eg_infinity_pipe_position = { position.x + offset.x, position.y + offset.y }

    local eg_infinity_pipe = surface.create_entity {
        name = "eg-infinity-pipe",
        position = eg_infinity_pipe_position,
        force = force,
        direction = direction,
    }

    offset = get_eg_steam_engine_offset(direction)
    local eg_steam_engine_position = { position.x + offset.x, position.y + offset.y }
    local eg_steam_engine_variant = ""

    if direction == defines.direction.north or direction == defines.direction.east then
        eg_steam_engine_variant = "ne"
    elseif direction == defines.direction.south or direction == defines.direction.west then
        eg_steam_engine_variant = "sw"
    end

    local eg_steam_engine = surface.create_entity {
        name = "eg-steam-engine-" .. eg_steam_engine_variant .. "-1",
        position = eg_steam_engine_position,
        force = force,
        direction = direction
    }

    offset = get_eg_high_voltage_pole_offset(direction)
    local eg_high_voltage_pole_position = { position.x + offset.x, position.y + offset.y }

    local eg_high_voltage_pole = surface.create_entity {
        name = "eg-high-voltage-pole-" .. direction,
        position = eg_high_voltage_pole_position, --place on top of eg-boiler
        force = force,
        direction = direction
    }

    offset = get_eg_low_voltage_pole_offset(direction)
    local eg_low_voltage_pole_position = { position.x + offset.x, position.y + offset.y }

    local eg_low_voltage_pole = surface.create_entity {
        name = "eg-low-voltage-pole-" .. direction,
        position = eg_low_voltage_pole_position, --place on top of eg-steam-engine
        force = force,
        direction = direction
    }

    eg_infinity_pipe.set_infinity_pipe_filter({
        name = "eg-water-1",
        percentage = 1,
        temperature = 15,
        mode = "at-least"
    })

    storage.eg_transformators[eg_unit.unit_number] = {
        unit = eg_unit,
        boiler = eg_boiler,
        pump = eg_pump,
        infinity_pipe = eg_infinity_pipe,
        steam_engine = eg_steam_engine,
        high_voltage = eg_high_voltage_pole,
        low_voltage = eg_low_voltage_pole
    }

    --eg_unit.destroy()
    --eg_boiler.destroy()
    --eg_steam_engine.destroy()
    --eg_high_voltage_pole.destroy()
    --eg_low_voltage_pole.destroy()
end

--- Replace the old transformator entity with a new one based on the selected rating.
-- Preserves existing wire connections during the replacement of the transformator components.
-- @param old_transformator LuaEntity The transformator to replace.
-- @param new_rating string The selected new rating for the transformator.
function replace_transformator(old_transformator, new_rating)
    if not old_transformator then return end
    if not new_rating then return end

    local new_unit = "eg-unit-1"

    for unit, specs in pairs(constants.EG_TRANSFORMATORS) do
        if specs.rating == new_rating then
            new_unit = unit
            break
        end
    end

    local force = old_transformator.force
    local surface = old_transformator.surface
    local direction = old_transformator.direction

    local unit_number = old_transformator.unit_number
    local eg_high_voltage_pole = nil
    local eg_low_voltage_pole = nil

    local eg_unit_position
    local eg_unit_direction
    local eg_boiler_position
    local eg_boiler_direction
    local eg_pump_position
    local eg_pump_direction
    local eg_infinity_pipe_position
    local eg_infinity_pipe_direction
    local eg_steam_engine_position
    local eg_steam_engine_direction

    if storage.eg_transformators[unit_number] then
        local eg_transformator = storage.eg_transformators[unit_number]

        eg_high_voltage_pole = storage.eg_transformators[unit_number].high_voltage
        eg_low_voltage_pole = storage.eg_transformators[unit_number].low_voltage

        -- Destroy all but the poles, perserve existing wire connections
        if eg_transformator.unit and eg_transformator.unit.valid then
            eg_unit_position = eg_transformator.unit.position
            eg_unit_direction = eg_transformator.unit.direction
            eg_transformator.unit.destroy()
        end
        if eg_transformator.boiler and eg_transformator.boiler.valid then
            eg_boiler_position = eg_transformator.boiler.position
            eg_boiler_direction = eg_transformator.boiler.direction
            eg_transformator.boiler.destroy()
        end
        if eg_transformator.pump and eg_transformator.pump.valid then
            eg_pump_position = eg_transformator.pump.position
            eg_pump_direction = eg_transformator.pump.direction
            eg_transformator.pump.destroy()
        end
        if eg_transformator.infinity_pipe and eg_transformator.infinity_pipe.valid then
            eg_infinity_pipe_position = eg_transformator.infinity_pipe.position
            eg_infinity_pipe_direction = eg_transformator.infinity_pipe.direction
            eg_transformator.infinity_pipe.destroy()
        end
        if eg_transformator.steam_engine and eg_transformator.steam_engine.valid then
            eg_steam_engine_position = eg_transformator.steam_engine.position
            eg_steam_engine_direction = eg_transformator.steam_engine.direction
            eg_transformator.steam_engine.destroy()
        end
    else
        --game.print("Error: Transformator with unit_number " .. unit_number .. " not found.")
        return
    end

    local tier = string.sub(new_unit, -1)

    local eg_unit = surface.create_entity {
        name = "eg-unit-" .. tier,
        position = eg_unit_position,
        force = force,
        direction = eg_unit_direction
    }

    local eg_boiler = surface.create_entity {
        name = "eg-boiler-" .. direction .. "-" .. tier,
        position = eg_boiler_position,
        force = force,
        direction = eg_boiler_direction
    }

    local eg_pump = surface.create_entity {
        name = "eg-pump-" .. direction,
        position = eg_pump_position,
        force = force,
        direction = eg_pump_direction,
    }

    local eg_infinity_pipe = surface.create_entity {
        name = "eg-infinity-pipe",
        position = eg_infinity_pipe_position,
        force = force,
        direction = eg_infinity_pipe_direction,
    }

    local eg_steam_engine_variant = ""

    if direction == defines.direction.north or direction == defines.direction.east then
        eg_steam_engine_variant = "ne"
    elseif direction == defines.direction.south or direction == defines.direction.west then
        eg_steam_engine_variant = "sw"
    end

    local eg_steam_engine = surface.create_entity {
        name = "eg-steam-engine-" .. eg_steam_engine_variant .. "-" .. tier,
        position = eg_steam_engine_position,
        force = force,
        direction = eg_steam_engine_direction
    }

    eg_infinity_pipe.set_infinity_pipe_filter({
        name = "eg-water-" .. tier,
        percentage = 1,
        temperature = 15,
        mode = "at-least"
    })

    storage.eg_transformators[eg_unit.unit_number] = {
        unit = eg_unit,
        boiler = eg_boiler,
        pump = eg_pump,
        infinity_pipe = eg_infinity_pipe,
        steam_engine = eg_steam_engine,
        high_voltage = eg_high_voltage_pole,
        low_voltage = eg_low_voltage_pole
    }

    storage.eg_transformators[unit_number] = nil
end

--- Replace the ugp-substation-displayer entity with ugp-substation.
-- Simply destroys the displayer and creates a ugp-substation in the same position.
-- @param displayer LuaEntity The ugp-substation-displayer to replace.
function replace_displayer_with_ugp_substation(displayer)
    if not displayer or not displayer.valid then return end

    local position = displayer.position
    local direction = displayer.direction
    local force = displayer.force
    local surface = displayer.surface

    displayer.destroy()

    local new_entity = surface.create_entity {
        name = "eg-ugp-substation",
        position = position,
        direction = direction,
        force = force
    }

    return new_entity
end

--- Check if a copper cable connection is allowed between two poles.
-- The rules for allowed connections include:
-- 1. Checking the standard connection table (`EG_WIRE_CONNECTIONS`).
-- 2. Allowing transformator poles to connect to each other.
-- 3. Allowing transformator poles to connect to `eg-huge-electric-pole` and vice-versa.
-- 4. Allowing transformator poles to connect to `big-electric-pole` and `medium-electric-pole` and vice-versa.
-- @param pole_a LuaEntity The first electric pole.
-- @param pole_b LuaEntity The second electric pole.
-- @return boolean True if the connection is allowed, false otherwise.
function is_copper_cable_connection_allowed(pole_a, pole_b)
    if not (pole_a and pole_b and pole_a.valid and pole_b.valid) then
        return false
    end

    local name_a, name_b = pole_a.name, pole_b.name

    if constants.EG_WIRE_CONNECTIONS[name_a] and constants.EG_WIRE_CONNECTIONS[name_a][name_b] then
        return true
    end

    if name_a:match("^eg%-[high%-low]+%-voltage%-pole%-") and name_b:match("^eg%-[high%-low]+%-voltage%-pole%-") then
        return true
    end

    if (name_a == "eg-huge-electric-pole" and name_b:match("^eg%-[high%-low]+%-voltage%-pole%-")) or
        (name_b == "eg-huge-electric-pole" and name_a:match("^eg%-[high%-low]+%-voltage%-pole%-")) then
        return true
    end

    local standard_poles = { ["big-electric-pole"] = true, ["medium-electric-pole"] = true }
    if (name_a:match("^eg%-[high%-low]+%-voltage%-pole%-") and standard_poles[name_b]) or
        (name_b:match("^eg%-[high%-low]+%-voltage%-pole%-") and standard_poles[name_a]) then
        return true
    end

    -- If no rule matches, the connection is not allowed
    return false
end

--- Enforce copper cable connection rules for a given electric pole.
-- Iterates through all wire connectors for the pole and disconnects unauthorized connections
-- based on the rules defined in `is_copper_cable_connection_allowed`.
-- @param pole LuaEntity The electric pole to enforce connections for.
-- @return boolean True if all connections are valid or no connections exist, false otherwise.
function enforce_pole_connections(pole)
    if not pole or not pole.valid or pole.type ~= "electric-pole" then
        return true
    end

    local allowed = true

    local connectors = pole.get_wire_connectors()
    if not connectors then
        return true
    end

    -- debug
    -- game.print(serpent.block(connectors))

    for _, connector in pairs(connectors) do
        if connector.wire_type == defines.wire_type.copper then
            for _, connection in pairs(connector.connections) do
                local target_connector = connection.target
                local target_pole = target_connector.owner

                if target_pole and target_pole.valid and target_pole.type == "electric-pole" then
                    if not is_copper_cable_connection_allowed(pole, target_pole) then
                        connector.disconnect_from(target_connector)
                        allowed = false
                    end
                end
            end
        end
    end

    return allowed
end

--- Find or create the GUI frame for transformator rating selection.
-- @param player LuaPlayer The player interacting with the GUI.
-- @return LuaGuiElement The created or found frame.
function get_or_create_transformator_frame(player)
    if player.gui.screen.transformator_rating_selection_frame then
        player.gui.screen.transformator_rating_selection_frame.destroy()
    end
    local frame = player.gui.screen.add {
        type = "frame",
        name = "transformator_rating_selection_frame",
        caption = "Rating",
        direction = "vertical"
    }
    frame.auto_center = true
    return frame
end

--- Find the current rating for a transformator.
-- @param transformator LuaEntity The transformator entity.
-- @return string|nil The current rating or nil if not found.
function get_current_transformator_rating(transformator)
    local unit_name = storage.eg_transformators[transformator.unit_number].unit.name
    for name, specs in pairs(constants.EG_TRANSFORMATORS) do
        if specs.rating and name == unit_name then
            return specs.rating
        end
    end
    return nil
end

--- Add rating checkboxes to a transformator frame.
-- @param frame LuaGuiElement The frame to add the checkboxes to.
-- @param current_rating string|nil The current rating of the transformator.
function add_rating_checkboxes(frame, current_rating)
    local table = frame.add { type = "table", column_count = 1 }
    for name, specs in pairs(constants.EG_TRANSFORMATORS) do
        if specs.rating then
            table.add {
                type = "checkbox",
                name = "rating_checkbox_" .. specs.rating,
                caption = specs.rating,
                state = (specs.rating == current_rating)
            }
        end
    end
end

--- Close the transformator GUI for the player.
-- @param player LuaPlayer The player for whom the GUI is closed.
function close_transformator_gui(player)
    if player.gui.screen.transformator_rating_selection_frame then
        player.gui.screen.transformator_rating_selection_frame.destroy()
    end
end
