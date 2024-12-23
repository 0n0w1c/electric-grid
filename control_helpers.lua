--- Removes a transformator and safely destroys all its associated entities.
-- This function ensures that all components of a transformator are properly destroyed,
-- and the transformator is removed from storage.
-- @param unit_number number The unit number of the transformator to remove.
function remove_transformator(unit_number)
    local eg_transformator = storage.eg_transformators[unit_number]
    if not eg_transformator then return end

    if eg_transformator.boiler then eg_transformator.boiler.destroy() end
    if eg_transformator.pump then eg_transformator.pump.destroy() end
    if eg_transformator.infinity_pipe then eg_transformator.infinity_pipe.destroy() end
    if eg_transformator.steam_engine then eg_transformator.steam_engine.destroy() end
    if eg_transformator.high_voltage then eg_transformator.high_voltage.destroy() end
    if eg_transformator.low_voltage then eg_transformator.low_voltage.destroy() end

    storage.eg_transformators[unit_number] = nil
end

--- Checks if a transformator and all its components are valid.
-- This function verifies the validity of all associated entities in a transformator.
-- If any component is invalid, it returns false. If all components are valid, it returns true.
-- @param unit_number number The unit number of the transformator to check.
-- @return boolean True if the transformator and all components are valid, false otherwise.
function is_transformator_valid(unit_number)
    local eg_transformator = storage.eg_transformators[unit_number]
    if not eg_transformator then return false end

    if eg_transformator.unit and not eg_transformator.unit.valid then return false end
    if eg_transformator.boiler and not eg_transformator.boiler.valid then return false end
    if eg_transformator.pump and not eg_transformator.pump.valid then return false end
    if eg_transformator.infinity_pipe and not eg_transformator.infinity_pipe.valid then return false end
    if eg_transformator.steam_engine and not eg_transformator.steam_engine.valid then return false end
    if eg_transformator.high_voltage and not eg_transformator.high_voltage.valid then return false end
    if eg_transformator.low_voltage and not eg_transformator.low_voltage.valid then return false end

    return true
end

--- Rotates a position vector around the origin based on a given direction.
--- Applies a 90 clockwise rotation matrix for each cardinal direction.
--- @param position table A table containing x and y coordinates of the position to rotate.
--- @param direction defines.direction The cardinal direction for the rotation.
---     defines.direction.north (0 rotation, no change)
---     defines.direction.east (90 clockwise rotation)
---     defines.direction.south (180 rotation)
---     defines.direction.west (270 clockwise rotation)
--- @return table The rotated position as a table with x and y coordinates.
function rotate_position(position, direction)
    local rotation_matrices = {
        [defines.direction.north] = { { 1, 0 }, { 0, 1 } },   -- No rotation
        [defines.direction.east]  = { { 0, -1 }, { 1, 0 } },  -- 90 clockwise
        [defines.direction.south] = { { -1, 0 }, { 0, -1 } }, -- 180 clockwise
        [defines.direction.west]  = { { 0, 1 }, { -1, 0 } }   -- 270 clockwise
    }
    local matrix = rotation_matrices[direction]
    local x = position.x * matrix[1][1] + position.y * matrix[1][2]
    local y = position.x * matrix[2][1] + position.y * matrix[2][2]
    return { x = x, y = y }
end

--- Check if the given name corresponds to a transformator.
-- @param name string The name of the entity to check.
-- @return boolean True if the entity is a transformator, false otherwise.
function is_transformator(name)
    if name == "eg-transformator-displayer" or constants.EG_TRANSFORMATORS[name] then
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
    local rotated_offset = { x = 0, y = 0 }

    local eg_unit_position = { x = position.x, y = position.y }
    local tier
    if entity.name == "eg-transformator-displayer" then
        tier = "1"
    else
        tier = string.sub(entity.name, -1)
    end

    entity.destroy({ raise_destroy = true })

    local eg_unit = surface.create_entity {
        name = "eg-unit-" .. tier,
        position = eg_unit_position,
        force = force,
        direction = direction,
        raise_built = true
    }

    rotated_offset = rotate_position(constants.EG_ENTITY_OFFSETS.boiler, direction)
    local eg_boiler_position = {
        x = eg_unit_position.x + rotated_offset.x,
        y = eg_unit_position.y + rotated_offset.y
    }

    local eg_boiler = surface.create_entity {
        name = "eg-boiler-" .. tier,
        position = eg_boiler_position,
        force = force,
        direction = direction
    }

    rotated_offset = rotate_position(constants.EG_ENTITY_OFFSETS.pump, direction)
    local eg_pump_position = {
        x = eg_unit_position.x + rotated_offset.x,
        y = eg_unit_position.y + rotated_offset.y
    }

    local eg_pump = surface.create_entity {
        name = "eg-pump",
        position = eg_pump_position,
        force = force,
        direction = direction
    }

    rotated_offset = rotate_position(constants.EG_ENTITY_OFFSETS.infinity_pipe, direction)
    local eg_infinity_pipe_position = {
        x = eg_unit_position.x + rotated_offset.x,
        y = eg_unit_position.y + rotated_offset.y
    }

    local eg_infinity_pipe = surface.create_entity {
        name = "eg-infinity-pipe",
        position = eg_infinity_pipe_position,
        force = force,
        direction = direction
    }

    rotated_offset = rotate_position(constants.EG_ENTITY_OFFSETS.steam_engine, direction)
    local eg_steam_engine_position = {
        x = eg_unit_position.x + rotated_offset.x,
        y = eg_unit_position.y + rotated_offset.y
    }

    local eg_steam_engine_variant = "ne"
    if direction == defines.direction.north or direction == defines.direction.east then
        eg_steam_engine_variant = "ne"
    elseif direction == defines.direction.south or direction == defines.direction.west then
        eg_steam_engine_variant = "sw"
    end

    local eg_steam_engine = surface.create_entity {
        name = "eg-steam-engine-" .. eg_steam_engine_variant .. "-" .. tier,
        position = eg_steam_engine_position,
        force = force,
        direction = direction
    }

    rotated_offset = rotate_position(constants.EG_ENTITY_OFFSETS.high_voltage_pole, direction)
    local eg_high_voltage_pole_position = {
        x = eg_unit_position.x + rotated_offset.x,
        y = eg_unit_position.y + rotated_offset.y
    }

    local eg_high_voltage_pole = surface.create_entity {
        name = "eg-high-voltage-pole-" .. direction,
        position = eg_high_voltage_pole_position,
        force = force,
        direction = direction
    }

    rotated_offset = rotate_position(constants.EG_ENTITY_OFFSETS.low_voltage_pole, direction)
    local eg_low_voltage_pole_position = {
        x = eg_unit_position.x + rotated_offset.x,
        y = eg_unit_position.y + rotated_offset.y
    }

    local eg_low_voltage_pole = surface.create_entity {
        name = "eg-low-voltage-pole-" .. direction,
        position = eg_low_voltage_pole_position,
        force = force,
        direction = direction
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
        low_voltage = eg_low_voltage_pole,
        alert_tick = 0
    }

    --eg_unit.destroy()
    --eg_boiler.destroy()
    --eg_steam_engine.destroy()
    --eg_high_voltage_pole.destroy()
    --eg_low_voltage_pole.destroy()
end

--- Replace the old_transformator components with a new ones based on the selected rating.
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

    if not storage.eg_transformators[unit_number] then return end
    local eg_transformator = storage.eg_transformators[unit_number]

    if not (eg_transformator.high_voltage and eg_transformator.high_voltage.valid) then return end
    local eg_high_voltage_pole = eg_transformator.high_voltage

    if not (eg_transformator.low_voltage and eg_transformator.low_voltage.valid) then return end
    local eg_low_voltage_pole = eg_transformator.low_voltage

    if not (eg_transformator.pump and eg_transformator.pump.valid) then return end
    local eg_pump = eg_transformator.pump

    if not (eg_transformator.unit and eg_transformator.unit.valid) then return end
    local eg_unit_position = eg_transformator.unit.position
    local eg_unit_direction = eg_transformator.unit.direction
    eg_transformator.unit.destroy({ raise_destroy = true })

    if not (eg_transformator.boiler and eg_transformator.boiler.valid) then return end
    local eg_boiler_position = eg_transformator.boiler.position
    local eg_boiler_direction = eg_transformator.boiler.direction
    eg_transformator.boiler.destroy()

    if not (eg_transformator.infinity_pipe and eg_transformator.infinity_pipe.valid) then return end
    local eg_infinity_pipe_position = eg_transformator.infinity_pipe.position
    local eg_infinity_pipe_direction = eg_transformator.infinity_pipe.direction
    eg_transformator.infinity_pipe.destroy()

    if not (eg_transformator.steam_engine and eg_transformator.steam_engine.valid) then return end
    local eg_steam_engine_position = eg_transformator.steam_engine.position
    local eg_steam_engine_direction = eg_transformator.steam_engine.direction
    eg_transformator.steam_engine.destroy()

    local tier = string.sub(new_unit, -1)

    local eg_unit = surface.create_entity {
        name = "eg-unit-" .. tier,
        position = eg_unit_position,
        force = force,
        direction = eg_unit_direction,
        raise_built = true
    }

    local eg_boiler = surface.create_entity {
        name = "eg-boiler-" .. tier,
        position = eg_boiler_position,
        force = force,
        direction = eg_boiler_direction
    }

    local eg_infinity_pipe = surface.create_entity {
        name = "eg-infinity-pipe",
        position = eg_infinity_pipe_position,
        force = force,
        direction = eg_infinity_pipe_direction,
    }

    local eg_steam_engine_variant
    if direction == defines.direction.south or direction == defines.direction.west then
        eg_steam_engine_variant = "sw"
    else
        eg_steam_engine_variant = "ne"
    end

    local eg_steam_engine = surface.create_entity {
        name = "eg-steam-engine-" .. eg_steam_engine_variant .. "-" .. tier,
        position = eg_steam_engine_position,
        force = force,
        direction = eg_steam_engine_direction
    }

    eg_pump.clear_fluid_inside()
    local filter = eg_pump.fluidbox.get_filter(1)
    if filter and filter.name and filter.name ~= "eg-fluid-disable" then
        eg_pump.fluidbox.set_filter(1, { name = "eg-water-" .. tier })
    end

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
        low_voltage = eg_low_voltage_pole,
        alert_tick = 0
    }

    storage.eg_transformators[unit_number] = nil
end

--- Find all electric poles within a radius around a mined entity's position.
-- @param entity LuaEntity The mined electric pole entity.
-- @param radius number The radius to search (default: 64).
-- @return table A list of electric poles within the radius.
function get_nearby_poles(entity)
    if not (entity and entity.valid and entity.type == "electric-pole") then return end

    local position = entity.position
    local surface = entity.surface
    local distance = prototypes.entity[entity.name].get_max_wire_distance(entity.quality)

    local area = {
        { position.x - distance, position.y - distance },
        { position.x + distance, position.y + distance }
    }

    return surface.find_entities_filtered {
        area = area,
        type = "electric-pole",
    }
end

--- Checks for short circuits and issues alerts to players if detected
-- Clears the alert if the short circuit condition resolves
-- @return nil
function short_circuit_check()
    local transformators = storage.eg_transformators

    for _, transformator in pairs(transformators) do
        local high_network_id = transformator.high_voltage.electric_network_id
        local low_network_id = transformator.low_voltage.electric_network_id

        if not (high_network_id and low_network_id) then return end

        if high_network_id == low_network_id then
            for _, player in pairs(game.players) do
                transformator.alert_tick = game.tick
                player.add_custom_alert(
                    transformator.unit,
                    { type = "virtual", name = "eg-alert" },
                    { "", "Short circuit detected" },
                    true
                )
            end
        else
            if transformator.alert_tick ~= 0 then
                transformator.alert_tick = 0
                for _, player in pairs(game.players) do
                    player.remove_alert({ entity = transformator.unit })
                end
            end
        end
    end
end

--- Replace the ugp-substation-displayer entity with ugp-substation.
-- Simply destroys the displayer and creates a ugp-substation in the same position.
-- @param args table A table containing the unit_number.
function replace_displayer_with_ugp_substation(args)
    if not args or not args.unit_number then return end

    local unit_number = args.unit_number
    local displayer = game.get_entity_by_unit_number(unit_number)

    if not (displayer and displayer.valid) then return end

    local position = displayer.position
    local direction = displayer.direction
    local force = displayer.force
    local surface = displayer.surface
    local quality = displayer.quality

    displayer.destroy({ raise_destroy = true })

    local eg_ugp_substation = surface.create_entity {
        name = "eg-ugp-substation",
        position = position,
        direction = direction,
        force = force,
        raise_built = true,
        quality = quality
    }

    enforce_pole_connections(eg_ugp_substation)

    local poles = get_nearby_poles(new_entity)
    if poles then
        for _, pole in pairs(poles) do
            if pole.valid then
                enforce_pole_connections(pole)
            end
        end
    end

    short_circuit_check()
end

--- Check if a copper cable connection is allowed between two poles.
-- @param pole_a LuaEntity The first electric pole.
-- @param pole_b LuaEntity The second electric pole.
-- @return boolean True if the connection is allowed, false otherwise.
function is_copper_cable_connection_allowed(pole_a, pole_b)
    if not (pole_a and pole_b and pole_a.valid and pole_b.valid) then
        return false
    end

    local name_a, name_b = pole_a.name, pole_b.name

    -- Check if one of the poles is a high_voltage pole and execute get_maximum_production
    --    for _, name in ipairs({ name_a, name_b }) do
    --        if name:match("^eg%-high%-voltage%-pole%-") then
    --            local max_power = get_maximum_production(name)
    --            game.print("Max = " .. max_power)
    --        end
    --    end

    if constants.EG_WIRE_CONNECTIONS[name_a] and constants.EG_WIRE_CONNECTIONS[name_a][name_b] then
        return true
    end

    if name_a:match(constants.EG_TRANSFORMATOR_POLES) and name_b:match(constants.EG_TRANSFORMATOR_POLES) then
        return true
    end

    if (name_a:match(constants.EG_TRANSFORMATOR_POLES) and constants.EG_TRANSMISSION_POLES[name_b]) or
        (name_b:match(constants.EG_TRANSFORMATOR_POLES) and constants.EG_TRANSMISSION_POLES[name_a]) then
        return true
    end

    return false
end

--- Enforce copper cable connection rules for a given electric pole.
-- Iterates through all wire connectors for the pole and disconnects unauthorized connections
-- based on the rules defined in is_copper_cable_connection_allowed.
-- @param pole LuaEntity The electric pole to enforce connections for.
-- @return boolean True if all connections are valid or no connections exist, false otherwise.
function enforce_pole_connections(pole)
    if not pole or not pole.valid or pole.type ~= "electric-pole" then
        return true
    end

    if storage.eg_transformators_only then
        return true
    end

    local allowed = true

    local connectors = pole.get_wire_connectors()
    if not connectors then
        return true
    end

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

    player.play_sound { path = "eg-transformator-gui-open" }

    local frame = player.gui.screen.add {
        type = "frame",
        name = "transformator_rating_selection_frame",
        direction = "vertical"
    }
    frame.auto_center = true

    local top_bar = frame.add {
        type = "flow",
        name = "transformator_top_bar",
        direction = "horizontal"
    }
    top_bar.style.horizontal_align = "right"
    top_bar.drag_target = frame

    local title_label = top_bar.add {
        type = "label",
        caption = "Transformator",
        style = "frame_title"
    }
    title_label.style.horizontally_stretchable = false
    title_label.ignored_by_interaction = true

    local spacer = top_bar.add {
        type = "empty-widget",
        style = "flib_titlebar_drag_handle"
    }
    spacer.style.horizontally_stretchable = true
    spacer.ignored_by_interaction = true

    local close_button = top_bar.add {
        type = "sprite-button",
        name = "close_transformator_gui",
        sprite = "utility/close",
        style = "close_button",
        mouse_button_filter = { "left" }
    }

    player.opened = frame

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

--- Close the transformator GUI for the player.
-- @param player LuaPlayer The player for whom the GUI is closed.
function close_transformator_gui(player)
    if player.gui.screen.transformator_rating_selection_frame then
        player.gui.screen.transformator_rating_selection_frame.destroy()
        player.opened = nil
        player.play_sound { path = "eg-transformator-gui-close" }
    end
end

--- Add a dropdown menu with a sprite and a save button to a GUI frame
-- This function creates a bordered frame containing a sprite, a dropdown menu for selecting ratings
-- and a save button. The sprite reflects the currently selected rating
-- @param parent_frame LuaGuiElement The parent frame to which the dropdown and other elements are added
-- @param current_rating string The current rating to display in the dropdown and as the sprite
function add_rating_dropdown(parent_frame, current_rating)
    local bordered_frame = parent_frame.add {
        type = "frame",
        name = "rating_selection_bordered_frame",
        direction = "vertical"
    }

    local sprite_frame = bordered_frame.add {
        type = "frame",
        name = "sprite_background_frame",
        style = "deep_frame_in_shallow_frame",
        direction = "vertical",
    }
    sprite_frame.style.minimal_width = 233
    sprite_frame.style.minimal_height = 155
    sprite_frame.style.horizontal_align = "center"
    sprite_frame.style.vertical_align = "center"

    sprite_frame.add {
        type = "sprite",
        name = "current_rating_sprite",
        sprite = current_rating
    }

    local label_flow = bordered_frame.add {
        type = "flow",
        name = "label_flow",
        direction = "horizontal"
    }
    label_flow.style.horizontally_stretchable = true
    label_flow.style.horizontal_align = "center"

    label_flow.add {
        type = "label",
        caption = { "gui.eg-select-rating" },
        style = "heading_2_label"
    }

    local dropdown_flow = bordered_frame.add {
        type = "flow",
        name = "dropdown_flow",
        direction = "horizontal"
    }
    dropdown_flow.style.horizontally_stretchable = true
    dropdown_flow.style.horizontal_align = "center"

    local dropdown_items = {}
    local selected_index = 1
    local idx = 1
    for _, specs in pairs(constants.EG_TRANSFORMATORS) do
        if specs.rating then
            table.insert(dropdown_items, specs.rating)

            if specs.rating == current_rating then
                selected_index = idx
            end
            idx = idx + 1
        end
    end

    dropdown_flow.add {
        type = "drop-down",
        name = "rating_dropdown",
        items = dropdown_items,
        selected_index = selected_index
    }

    local save_button_flow = bordered_frame.add {
        type = "flow",
        name = "save_button_flow",
        direction = "horizontal"
    }
    save_button_flow.style.horizontally_stretchable = true
    save_button_flow.style.horizontal_align = "center"

    save_button_flow.add {
        type = "button",
        name = "confirm_transformator_rating",
        caption = "Save"
    }
end
