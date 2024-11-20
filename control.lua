constants = require("constants")

-- Initialize global memory structures
local function initialize_globals()
    storage = storage or {}
    storage.eg_transformators = storage.eg_transformators or {}
    storage.eg_selected_transformator = storage.eg_selected_transformator or {}
    storage.eg_copper_wire_on_cursor = storage.eg_copper_wire_on_cursor or {}
    storage.eg_last_selected_pole = storage.eg_last_selected_pole or {}
end

-- Define the position offset for the boiler based on direction
local function get_eg_boiler_offset(direction)
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

-- Define the position offset for the pump based on direction
local function get_eg_pump_offset(direction)
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

-- Define the position offset for the infinity pipe based on direction
local function get_eg_infinity_pipe_offset(direction)
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

-- Define the position offset for the steam generator based on direction
local function get_eg_steam_engine_offset(direction)
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

-- Define the position offset for the eg-high-voltage-pole
local function get_eg_high_voltage_pole_offset(direction)
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

-- Define the position offset for the eg-low-voltage-pole
local function get_eg_low_voltage_pole_offset(direction)
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

local function is_transformator(name)
    --if name == constants.EG_DISPLAYER or constants.EG_TRANSFORMATORS[name] or string.sub(name, 1, 8) == "eg-pump-" then
    if name == constants.EG_DISPLAYER or constants.EG_TRANSFORMATORS[name] then
        return true
    end

    return false
end

local function find_transformator_by_pump(pump)
    if not (pump and pump.valid) then
        return nil -- Ensure the pump is valid
    end

    for _, transformator in pairs(storage.eg_transformators) do
        if transformator.pump and transformator.pump.valid and transformator.pump == pump then
            return transformator -- Found the matching transformator
        end
    end

    return nil -- No matching transformator found
end


local function replace_boiler_steam_engine(transformator)
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

        name = eg_transformator.generator.name
        direction = eg_transformator.generator.direction
        position = eg_transformator.generator.position

        if eg_transformator.generator and eg_transformator.generator.valid then
            eg_transformator.generator.destroy()
        end

        local eg_steam_engine = surface.create_entity {
            name = name,
            position = position,
            force = force,
            direction = direction
        }

        storage.eg_transformators[unit_number].boiler = eg_boiler
        storage.eg_transformators[unit_number].generator = eg_steam_engine
    else
        --game.print("Error: Transformator with unit_number " .. unit_number .. " not found.")
    end
end

--- Replace the old transformator entity with a new one based on the selected rating.
-- Restores wire connections and ensures smooth replacement of the transformator.
-- @param old_transformator LuaEntity The transformator to replace.
-- @param new_rating string The selected new rating for the transformator.
local function replace_transformator(old_transformator, new_rating)
    if not old_transformator then return end
    if not new_rating then return end

    local new_unit = "eg-unit-1"

    for unit, specs in pairs(constants.EG_TRANSFORMATORS) do
        if specs.rating == new_rating then
            new_unit = unit
            break
        end
    end

    --if not new_unit or storage.eg_transformators[old_transformator.unit_number].unit.name == new_unit then return end

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
        if eg_transformator.generator and eg_transformator.generator.valid then
            eg_steam_engine_position = eg_transformator.generator.position
            eg_steam_engine_direction = eg_transformator.generator.direction
            eg_transformator.generator.destroy()
        end
    else
        --game.print("Error: Transformator with unit_number " .. unit_number .. " not found.")
    end

    local tier = string.sub(new_unit, -1)

    -- Replace with the unit, same positon and direction
    local eg_unit = surface.create_entity {
        name = "eg-unit-" .. tier,
        position = eg_unit_position,
        force = force,
        direction = eg_unit_direction
    }

    -- Place the eg-boiler with the same direction as the original unit
    local eg_boiler = surface.create_entity {
        name = "eg-boiler-" .. direction .. "-" .. tier,
        position = eg_boiler_position,
        force = force,
        direction = eg_boiler_direction
    }

    -- Place the eg-pump with the same direction as the boiler
    local eg_pump = surface.create_entity {
        name = "eg-pump-" .. direction,
        position = eg_pump_position,
        force = force,
        direction = eg_pump_direction,
    }

    -- Place the eg-infinity-pipe with the same direction as the boiler
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

    -- Place the eg-steam-engine with the same direction as the boiler
    local eg_steam_engine = surface.create_entity {
        name = "eg-steam-engine-" .. eg_steam_engine_variant .. "-" .. tier,
        position = eg_steam_engine_position,
        force = force,
        direction = eg_steam_engine_direction
    }

    -- Set eg-water to be actively flowing
    eg_infinity_pipe.set_infinity_pipe_filter({
        name = "eg-water-" .. tier,
        percentage = 1,
        temperature = 15,
        mode = "at-least"
    })

    -- Track the eg_transformator components by the unit's unit_number
    storage.eg_transformators[eg_unit.unit_number] = {
        unit = eg_unit,
        boiler = eg_boiler,
        pump = eg_pump,
        infinity_pipe = eg_infinity_pipe,
        generator = eg_steam_engine,
        high_voltage = eg_high_voltage_pole,
        low_voltage = eg_low_voltage_pole
    }

    -- Remove old_transformator from storage
    storage.eg_transformators[unit_number] = nil
end

-- Checks for short circuits among all transformers and alerts players if any are found
local function nth_tick_checks()
    local transformators = storage.eg_transformators
    local updated_transformators = {}

    for id, transformator in pairs(transformators) do
        -- Validate the transformator components
        if transformator.pump.valid and transformator.high_voltage.valid and transformator.low_voltage.valid then
            -- Preserve valid transformators in the updated table
            updated_transformators[id] = transformator

            -- Short circuit detection
            local high_network_id = transformator.high_voltage.electric_network_id
            local low_network_id = transformator.low_voltage.electric_network_id

            if high_network_id and low_network_id and high_network_id == low_network_id then
                for _, player in pairs(game.players) do
                    player.add_custom_alert(
                        transformator.unit,
                        { type = "virtual", name = "eg-alert" },
                        { "", "Short circuit detected" },
                        true
                    )
                end
            end

            -- Check if pump is disabled
            local pump = transformator.pump
            local control_behavior = pump.get_control_behavior()
            if control_behavior and control_behavior.disabled and pump.fluidbox[1] ~= nil then
                local tier = string.sub(transformator.unit.name, -1)
                pump.clear_fluid_inside()
                replace_boiler_steam_engine(transformator)
            end
        end
    end

    -- Replace the storage table with the updated one
    storage.eg_transformators = updated_transformators
end

local function on_eg_transformator_built(event)
    local entity = event.entity

    if not entity or not entity.name then return end

    if not is_transformator(entity.name) then return end

    local surface = entity.surface
    local force = entity.force
    local position = entity.position
    local direction = entity.direction
    local offset = { x = 0, y = 0 }

    entity.destroy()

    -- Use the same position, no offset
    local eg_unit_position = { position.x, position.y }

    -- Replace with the unit, same positon and direction
    local eg_unit = surface.create_entity {
        name = "eg-unit-1",
        position = eg_unit_position,
        force = force,
        direction = direction
    }

    -- Calculate the offset position for the eg-infinity-pipe based on direction
    offset = get_eg_boiler_offset(direction)
    local eg_boiler_position = { position.x + offset.x, position.y + offset.y }

    -- Place the eg-boiler with the same direction as the displayer
    local eg_boiler = surface.create_entity {
        name = "eg-boiler-" .. direction .. "-1",
        position = eg_boiler_position,
        force = force,
        direction = direction
    }

    -- Calculate the offset position for the eg-pump
    offset = get_eg_pump_offset(direction)
    local eg_pump_position = { position.x + offset.x, position.y + offset.y }

    -- Place the eg-pump with the same direction as the boiler
    local eg_pump = surface.create_entity {
        name = "eg-pump-" .. direction,
        position = eg_pump_position,
        force = force,
        direction = direction,
    }

    -- Calculate the offset position for the eg-infinity-pipe based on direction
    offset = get_eg_infinity_pipe_offset(direction)
    local eg_infinity_pipe_position = { position.x + offset.x, position.y + offset.y }

    -- Place the eg-infinity-pipe with the same direction as the boiler
    local eg_infinity_pipe = surface.create_entity {
        name = "eg-infinity-pipe",
        position = eg_infinity_pipe_position,
        force = force,
        direction = direction,
    }

    -- Calculate the offset position for the eg-steam-engine based on direction
    offset = get_eg_steam_engine_offset(direction)
    local eg_steam_engine_position = { position.x + offset.x, position.y + offset.y }
    local eg_steam_engine_variant = ""

    if direction == defines.direction.north or direction == defines.direction.east then
        eg_steam_engine_variant = "ne"
    elseif direction == defines.direction.south or direction == defines.direction.west then
        eg_steam_engine_variant = "sw"
    end

    -- Place the eg-steam-engine with the same direction as the boiler
    local eg_steam_engine = surface.create_entity {
        name = "eg-steam-engine-" .. eg_steam_engine_variant .. "-1",
        position = eg_steam_engine_position,
        force = force,
        direction = direction
    }

    -- Calculate the offset position for the eg-low-voltage-pole based on direction
    offset = get_eg_high_voltage_pole_offset(direction)
    local eg_high_voltage_pole_position = { position.x + offset.x, position.y + offset.y }

    -- Place the eg-low-voltage-pole with the same direction as the boiler
    local eg_high_voltage_pole = surface.create_entity {
        name = "eg-high-voltage-pole-" .. direction,
        position = eg_high_voltage_pole_position, --place on top of eg-boiler
        force = force,
        direction = direction
    }

    -- Calculate the offset position for the eg-low-voltage-pole based on direction
    offset = get_eg_low_voltage_pole_offset(direction)
    local eg_low_voltage_pole_position = { position.x + offset.x, position.y + offset.y }

    -- Place the eg-low-voltage-pole with the same direction as the boiler
    local eg_low_voltage_pole = surface.create_entity {
        name = "eg-low-voltage-pole-" .. direction,
        position = eg_low_voltage_pole_position, --place on top of eg-steam-engine
        force = force,
        direction = direction
    }

    -- Set eg-water to be actively flowing
    eg_infinity_pipe.set_infinity_pipe_filter({
        name = "eg-water-1",
        percentage = 1,
        temperature = 15,
        mode = "at-least"
    })

    -- Track the eg_transformator components by the unit's unit_number
    storage.eg_transformators[eg_unit.unit_number] = {
        unit = eg_unit,
        boiler = eg_boiler,
        pump = eg_pump,
        infinity_pipe = eg_infinity_pipe,
        generator = eg_steam_engine,
        high_voltage = eg_high_voltage_pole,
        low_voltage = eg_low_voltage_pole
    }

    --eg_unit.destroy()
    --eg_boiler.destroy()
    --eg_steam_engine.destroy()
    --eg_high_voltage_pole.destroy()
    --eg_low_voltage_pole.destroy()
end

--- Replace the ugp-substation-displayer entity with ugp-substation.
-- Simply destroys the displayer and creates a ugp-substation in the same position.
-- @param displayer LuaEntity The ugp-substation-displayer to replace.
local function replace_displayer_with_ugp_substation(displayer)
    if not displayer or not displayer.valid then return end

    -- Save the position, direction, force, and surface of the displayer
    local position = displayer.position
    local direction = displayer.direction
    local force = displayer.force
    local surface = displayer.surface

    -- Destroy the displayer entity
    displayer.destroy()

    -- Create the ugp-substation at the same location
    local new_entity = surface.create_entity {
        name = "eg-ugp-substation",
        position = position,
        direction = direction,
        force = force
    }

    return new_entity
end

local function is_copper_cable_connection_allowed(pole_a, pole_b)
    if not (pole_a and pole_b and pole_a.valid and pole_b.valid) then
        return false
    end

    local name_a, name_b = pole_a.name, pole_b.name

    -- Rule set 1: Check if the connection is allowed in the standard connection table
    if constants.EG_WIRE_CONNECTIONS[name_a] and constants.EG_WIRE_CONNECTIONS[name_a][name_b] then
        return true
    end

    -- Rule set 2: Transformator poles can connect to each other
    if name_a:match("^eg%-[high%-low]+%-voltage%-pole%-") and name_b:match("^eg%-[high%-low]+%-voltage%-pole%-") then
        return true
    end

    -- Rule set 3: Transformator poles can connect to eg-huge-electric-pole and vice-versa
    if (name_a == "eg-huge-electric-pole" and name_b:match("^eg%-[high%-low]+%-voltage%-pole%-")) or
        (name_b == "eg-huge-electric-pole" and name_a:match("^eg%-[high%-low]+%-voltage%-pole%-")) then
        return true
    end

    -- Rule set 4: Transformator poles can connect to big-electric-pole and medium-electric-pole, and vice-versa
    local standard_poles = { ["big-electric-pole"] = true, ["medium-electric-pole"] = true }
    if (name_a:match("^eg%-[high%-low]+%-voltage%-pole%-") and standard_poles[name_b]) or
        (name_b:match("^eg%-[high%-low]+%-voltage%-pole%-") and standard_poles[name_a]) then
        return true
    end

    -- If no rule matches, the connection is not allowed
    return false
end

local function enforce_pole_connections(pole)
    if not pole or not pole.valid or pole.type ~= "electric-pole" then
        return true
    end

    local allowed = true

    -- Retrieve all wire connectors for the pole
    local connectors = pole.get_wire_connectors()
    if not connectors then
        return true
    end

    -- debug
    -- game.print(serpent.block(connectors))

    -- Iterate over each connector and filter for copper connectors
    for _, connector in pairs(connectors) do
        if connector.wire_type == defines.wire_type.copper then
            -- Iterate over all connections for this copper connector
            for _, connection in pairs(connector.connections) do
                local target_connector = connection.target
                local target_pole = target_connector.owner

                if target_pole and target_pole.valid and target_pole.type == "electric-pole" then
                    -- Check if this connection is allowed based on the constants table
                    if not is_copper_cable_connection_allowed(pole, target_pole) then
                        -- Disconnect the unauthorized target pole
                        connector.disconnect_from(target_connector)
                        allowed = false
                    end
                end
            end
        end
    end

    return allowed
end

--- Handle the addition of a transformator or electric-pole entity.
-- Adds a transformator entity to storage.transformators or enforces wiring rules if it's an electric-pole.
-- @param entity LuaEntity The entity that was added.
local function on_entity_built(event)
    if not event or not event.entity or not event.entity.valid then return end
    local entity = event.entity

    if is_transformator(entity.name) then
        on_eg_transformator_built(event)
    elseif entity.name == "eg-ugp-substation-displayer" then
        local new_entity = replace_displayer_with_ugp_substation(entity)
        enforce_pole_connections(new_entity)
    elseif entity.type == "electric-pole" then
        enforce_pole_connections(entity)
    end
end

-- Remove all components of a transformer when the unit is mined
local function on_eg_transformator_mined(event)
    local entity = event.entity
    if not entity then return end

    local unit_number = entity.unit_number

    if storage.eg_transformators[unit_number] then
        local eg_transformator = storage.eg_transformators[unit_number]

        -- Destroy each component if it still exists
        if eg_transformator.unit and eg_transformator.unit.valid then
            eg_transformator.unit.destroy()
        end
        if eg_transformator.boiler and eg_transformator.boiler.valid then
            eg_transformator.boiler.destroy()
        end
        if eg_transformator.pump and eg_transformator.pump.valid then
            eg_transformator.pump.destroy()
        end
        if eg_transformator.infinity_pipe and eg_transformator.infinity_pipe.valid then
            eg_transformator.infinity_pipe.destroy()
        end
        if eg_transformator.generator and eg_transformator.generator.valid then
            eg_transformator.generator.destroy()
        end
        if eg_transformator.high_voltage and eg_transformator.high_voltage.valid then
            eg_transformator.high_voltage.destroy()
        end
        if eg_transformator.low_voltage and eg_transformator.low_voltage.valid then
            eg_transformator.low_voltage.destroy()
        end

        -- Update storage
        storage.eg_transformators[unit_number] = nil
    end
end

--- Handle cursor stack change events to set or clear the copper wire flag.
-- @param event EventData The event data containing the player information.
local function on_cursor_stack_changed(event)
    local player = game.players[event.player_index]
    local cursor_stack = player.cursor_stack

    -- Check if the player is holding copper wire
    if cursor_stack and cursor_stack.valid_for_read and cursor_stack.name == "copper-wire" then
        storage.eg_copper_wire_on_cursor[player.index] = true
    else
        storage.eg_copper_wire_on_cursor[player.index] = nil -- Clear the flag when not holding copper wire
    end
end

--- Handle selection change events to track electric poles and enforce wiring rules.
-- @param event EventData.on_selected_entity_changed The event data containing the player information.
local function on_selected_entity_changed(event)
    local player = game.get_player(event.player_index)
    if not player then return end -- Guard clause for player existence

    local selected_entity = player.selected
    local player_index = event.player_index

    -- Check if the player was holding copper wire and previously had an electric pole selected
    if storage.eg_last_selected_pole[player_index] and (not selected_entity or selected_entity.type ~= "electric-pole") then
        -- Enforce wiring rules for the last selected pole
        enforce_pole_connections(storage.eg_last_selected_pole[player_index])
        -- Clear the last selected pole tracking
        storage.eg_last_selected_pole[player_index] = nil
    end

    -- Update storage.eg_last_selected_pole if the player selects a new electric pole while holding copper wire
    if storage.eg_copper_wire_on_cursor[player_index] and selected_entity and selected_entity.valid and selected_entity.type == "electric-pole" then
        storage.eg_last_selected_pole[player_index] = selected_entity
    else
        -- Clear storage.eg_last_selected_pole if they are no longer holding copper wire
        storage.eg_last_selected_pole[player_index] = nil
    end
end

-- Register events and load globals
local function register_event_handlers()
    script.on_event(defines.events.on_built_entity, on_entity_built)
    script.on_event(defines.events.on_robot_built_entity, on_entity_built)
    script.on_event(defines.events.on_space_platform_built_entity, on_entity_built)
    script.on_event(defines.events.on_entity_cloned, on_entity_built)
    script.on_event(defines.events.script_raised_built, on_entity_built)
    script.on_event(defines.events.script_raised_revive, on_entity_built)

    script.on_event(defines.events.on_player_mined_entity, on_eg_transformator_mined)
    script.on_event(defines.events.on_robot_mined_entity, on_eg_transformator_mined)
    script.on_event(defines.events.on_space_platform_mined_entity, on_eg_transformator_mined)
    script.on_event(defines.events.on_entity_died, on_eg_transformator_mined)

    script.on_event(defines.events.on_player_cursor_stack_changed, on_cursor_stack_changed)
    script.on_event(defines.events.on_selected_entity_changed, on_selected_entity_changed)

    script.on_nth_tick(constants.EG_ON_TICK_INTERVAL, nth_tick_checks)
end

-- Set up globals and event handlers on initialization
script.on_init(function()
    initialize_globals()
    register_event_handlers()
end)

-- Load globals and re-register event handlers when the game is loaded
script.on_load(function()
    initialize_globals()
    register_event_handlers()
end)

--------------
-- GUI Code --
--------------

--- Closes the transformator GUI if open.
-- @param player LuaPlayer The player for whom the GUI is closed.
local function close_transformator_gui(player)
    if player.gui.screen.transformator_rating_selection_frame then
        player.gui.screen.transformator_rating_selection_frame.destroy()
    end
end

--- Show the transformator GUI with rating selection checkboxes.
-- @param player LuaPlayer The player for whom the GUI is shown.
-- @param transformator LuaEntity The selected transformator entity.
local function show_transformator_gui(player, transformator)
    -- Ensure any existing GUI is cleared
    close_transformator_gui(player)

    -- Create the GUI frame
    local frame = player.gui.screen.add {
        type = "frame",
        name = "transformator_rating_selection_frame",
        caption = "Rating",
        direction = "vertical"
    }
    frame.auto_center = true

    -- Table for layout
    local table = frame.add {
        type = "table",
        column_count = 1
    }

    -- Determine the current rating of the selected transformator
    local unit_name = storage.eg_transformators[transformator.unit_number].unit.name
    local current_rating = nil
    for name, specs in pairs(constants.EG_TRANSFORMATORS) do
        if specs.rating and name == unit_name then
            current_rating = specs.rating
            break
        end
    end

    -- Loop through each transformer unit in CONSTANTS.TRAFO_TRANSFORMATORS
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

    -- Add confirm button below checkboxes
    frame.add {
        type = "button",
        name = "confirm_transformator_rating",
        caption = "Save"
    }

    -- Store the selected transformator in global for reference
    storage.eg_selected_transformator[player.index] = transformator
end

--- Event handler for transformator interaction (e.g., GUI toggle).
-- Opens or closes the transformator rating selection GUI.
-- @param event EventData The event data containing the player and entity information.
script.on_event("transformator_rating_selection", function(event)
    local player = game.get_player(event.player_index)
    if not player or not player.valid then return end

    local selected_entity = player.selected
    if selected_entity and selected_entity.valid and is_transformator(selected_entity.name) then
        if player.gui.screen.transformator_rating_selection_frame then
            close_transformator_gui(player)                 -- Close the GUI if it's already open
        else
            show_transformator_gui(player, selected_entity) -- Open the GUI if it’s not already open
        end
    end
end)

--- Event handler to update checkboxes and simulate radio button behavior.
-- Ensures only one checkbox is selected at a time.
-- @param event EventData The event data containing the GUI element information.
script.on_event(defines.events.on_gui_checked_state_changed, function(event)
    local element = event.element
    if not (element and element.valid) then return end

    if element.name:find("rating_checkbox_") then
        local player = game.players[event.player_index]

        local frame = player.gui.screen.transformator_rating_selection_frame
        if frame then
            for _, child in pairs(frame.children[1].children) do
                if child.type == "checkbox" and child.name ~= element.name then
                    child.state = false
                end
            end
        end
    end
end)

--- Event handler for GUI button clicks (e.g., confirming rating selection).
-- Updates the transformator based on the selected rating and closes the GUI.
-- @param event EventData The event data containing the clicked GUI element.
script.on_event(defines.events.on_gui_click, function(event)
    local element = event.element
    if not (element and element.valid) then return end

    local player = game.get_player(event.player_index)
    if not (player and player.valid) then return end

    if element.name == "confirm_transformator_rating" then
        local frame = player.gui.screen.transformator_rating_selection_frame
        if frame and frame.children[1] then
            local selected_rating = nil

            for _, child in pairs(frame.children[1].children) do
                if child.type == "checkbox" and child.state then
                    selected_rating = string.match(child.name, "rating_checkbox_(.+)")
                    break
                end
            end

            if selected_rating then
                local transformator = storage.eg_selected_transformator and storage.eg_selected_transformator[player.index]
                if transformator and transformator.valid then
                    replace_transformator(transformator, selected_rating)
                end
            end

            close_transformator_gui(player)
        end
    end
end)

script.on_event(defines.events.on_gui_closed, function(event)
    local entity = event.entity
    if not entity or not entity.valid then return end

    local player = game.get_player(event.player_index)
    if not player or not player.valid then return end

    local transformator = find_transformator_by_pump(entity)
    if not transformator then return end

    local pump = transformator.pump

    local filter = pump.fluidbox.get_filter(1)
    if filter and filter.name then
        local unit_name = transformator.unit.name
        local tier = string.sub(unit_name, -1)

        if filter.name == "eg-null-disable" then
            -- on nth_tick can check cicuit/logistc conditions, clear guts?
            pump.clear_fluid_inside()
            pump.fluidbox.set_filter(1, { name = "eg-null-disable" })
            replace_boiler_steam_engine(transformator)
        else
            pump.clear_fluid_inside()
            pump.fluidbox.set_filter(1, { name = "eg-water-" .. tier })
        end
    end
end)
