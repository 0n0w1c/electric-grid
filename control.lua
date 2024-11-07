local util = require("util")
constants = require("constants")

local eg_transformators

-- Initialize global memory structures and event handlers
local function initialize_globals()
    storage = storage or {}
    eg_transformators = storage.eg_transformators or {}
    storage.eg_transformators = eg_transformators -- Persist eg_transformators in storage
    storage.eg_selected_transformator = storage.eg_selected_transformator or {}
end

-- Handle loading globals when the game is loaded
local function load_globals()
    eg_transformators = storage.eg_transformators
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

-- Define the position offset for the infinity pipe based on direction
local function get_eg_infinity_pipe_offset(direction)
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

-- Place the electric boiler and infinity pipe with direction handling
local function on_eg_transformator_built(event)
    local entity = event.entity

    if not entity or not entity.name then return end

    if entity.name ~= constants.EG_DISPLAYER and not constants.EG_TRANSFORMATORS[entity.name] then return end

    -- Store surface, force, position and direction
    local surface = entity.surface
    local force = entity.force
    local position = entity.position
    local direction = entity.direction
    local offset = { x = 0, y = 0 }
    local quality = entity.quality or 1

    -- Remove the displayer
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
        name = "eg-boiler-1",
        position = eg_boiler_position,
        force = force,
        direction = direction
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

    -- Place the eg-steam-engine with the same direction as the boiler
    local eg_steam_engine = surface.create_entity {
        name = "eg-steam-engine-1",
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

    -- Track the eg_transformator components by the unit_number
    storage.eg_transformators[eg_unit.unit_number] = {
        unit = eg_unit,
        boiler = eg_boiler,
        infinity_pipe = eg_infinity_pipe,
        generator = eg_steam_engine,
        high_voltage = eg_high_voltage_pole,
        low_voltage = eg_low_voltage_pole
    }

    -- Update storage
    storage.eg_transformators = eg_transformators
end

-- Remove all components of a transformer when the displayer is mined
local function on_eg_transformator_mined(event)
    local entity = event.entity
    local unit_number = entity.unit_number

    if storage.eg_transformators[unit_number] then
        local eg_transformator = storage.eg_transformators[unit_number]

        -- Destroy each component if it still exists
        if eg_transformator.boiler and eg_transformator.boiler.valid then
            eg_transformator.boiler.destroy()
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

-- Register events and load globals
local function register_event_handlers()
    script.on_event(defines.events.on_built_entity, on_eg_transformator_built)
    script.on_event(defines.events.on_robot_built_entity, on_eg_transformator_built)
    script.on_event(defines.events.on_player_mined_entity, on_eg_transformator_mined)
    script.on_event(defines.events.on_robot_mined_entity, on_eg_transformator_mined)
    script.on_event(defines.events.on_entity_died, on_eg_transformator_mined)
end

-- Set up globals and event handlers on initialization
script.on_init(function()
    initialize_globals()
    register_event_handlers()
end)

-- Load globals and re-register event handlers when the game is loaded
script.on_load(function()
    load_globals()
    register_event_handlers()
end)

---BEGIN NEW HERE
---
--- Check if the given transformator rating is researched for the player's force.
-- @param player LuaPlayer The player to check for.
-- @param rating string The transformator rating to check.
-- @return boolean True if the rating is researched, otherwise false.
local function is_rating_researched(player, rating)
    --[[
    if not player or not rating then return end

    local force = player.force
    local rating_num = tonumber(string.sub(rating, 7, 7))

    if rating_num < 4 and force.technologies["trafo-1-tech"] and force.technologies["trafo-1-tech"].researched then
        return true
    elseif rating_num < 7 and force.technologies["trafo-2-tech"] and force.technologies["trafo-2-tech"].researched then
        return true
    elseif force.technologies["trafo-3-tech"] and force.technologies["trafo-3-tech"].researched then
        return true
    end

    return false
]]
    return true
end

local function is_transformator(name)
    if name == constants.EG_DISPLAYER or constants.EG_TRANSFORMATORS[name] then return true end

    return false
end

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
    local current_rating = nil
    for unit, specs in pairs(constants.EG_TRANSFORMATORS) do
        if specs.rating and unit == transformator.name then
            current_rating = specs.rating
            break
        end
    end

    -- Loop through the transformators
    for unit, specs in pairs(constants.EG_TRANSFORMATORS) do
        if specs.rating and is_rating_researched(player, unit) then
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
    --storage.selected_transformator[player.index] = transformator
end

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

--- Event handler for GUI button clicks (e.g., confirming rating selection).
-- Updates the transformator based on the selected rating and closes the GUI.
-- @param event EventData The event data containing the clicked GUI element.
script.on_event(defines.events.on_gui_click, function(event)
    local element = event.element
    if not (element and element.valid) then return end

    local player = game.get_player(event.player_index)
    if not player or not player.valid then return end

    if element.name == "confirm_transformator_rating" then
        local frame = player.gui.screen.transformator_rating_selection_frame
        if frame then
            local selected_rating = nil

            for _, child in pairs(frame.children[1].children) do
                if child.type == "checkbox" and child.state then
                    selected_rating = string.match(child.name, "rating_checkbox_(.+)")
                    break
                end
            end
            --[[
            if selected_rating then
                local transformator = storage.selected_transformator[player.index]
                if transformator and transformator.valid then
                    replace_transformator(transformator, selected_rating)
                end
            end
]]
            close_transformator_gui(player)
        end
    end
end)
