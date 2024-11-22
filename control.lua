constants = require("constants")

require("control-helpers")

--- Initialize global memory structures.
-- Ensures that all necessary global tables and variables exist, creating them if they do not.
local function initialize_globals()
    storage = storage or {}
    storage.eg_transformators = storage.eg_transformators or {}
    storage.eg_selected_transformator = storage.eg_selected_transformator or {}
    storage.eg_copper_wire_on_cursor = storage.eg_copper_wire_on_cursor or {}
    storage.eg_last_selected_pole = storage.eg_last_selected_pole or {}
    storage.eg_check_interval = storage.eg_check_interval or 60
end

--- Periodic checks on all transformers
-- Detects short circuits and alerts players if any short circuits are found,
-- Replaces buffered components if pump is disabled, quick power on/off switch.
local function nth_tick_checks()
    local transformators = storage.eg_transformators

    for _, transformator in pairs(transformators) do
        if transformator.pump.valid and transformator.high_voltage.valid and transformator.low_voltage.valid then
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

            local pump = transformator.pump
            local control_behavior = pump.get_control_behavior()
            if control_behavior and control_behavior.disabled and pump.fluidbox[1] ~= nil then
                pump.clear_fluid_inside()
                replace_boiler_steam_engine(transformator)
            end
        end
    end
end

-- Places transformator or ugp_substation entities
-- or enforces wiring rules if it's an electric-pole.
-- @param entity LuaEntity The entity that was added.
local function on_entity_built(event)
    if not event or not event.entity or not event.entity.valid then return end
    local entity = event.entity

    if is_transformator(entity.name) then
        eg_transformator_built(entity)
    elseif entity.name == "eg-ugp-substation-displayer" then
        local new_entity = replace_displayer_with_ugp_substation(entity)
        enforce_pole_connections(new_entity)
    elseif entity.type == "electric-pole" then
        enforce_pole_connections(entity)
    end
end

-- This function cleans up all components associated with the mined transformator.
-- Each component of the transformator (unit, boiler, pump, infinity pipe, steam engine, high voltage pole, low voltage pole)
-- is destroyed, and the transformator is removed from the global storage.
-- @param event EventData The event data containing the entity that was mined.
local function on_eg_transformator_mined(event)
    local entity = event.entity
    if not entity then return end

    local unit_number = entity.unit_number

    if storage.eg_transformators[unit_number] then
        local eg_transformator = storage.eg_transformators[unit_number]

        if eg_transformator.unit then eg_transformator.unit.destroy() end
        if eg_transformator.boiler then eg_transformator.boiler.destroy() end
        if eg_transformator.pump then eg_transformator.pump.destroy() end
        if eg_transformator.infinity_pipe then eg_transformator.infinity_pipe.destroy() end
        if eg_transformator.steam_engine then eg_transformator.steam_engine.destroy() end
        if eg_transformator.high_voltage then eg_transformator.high_voltage.destroy() end
        if eg_transformator.low_voltage then eg_transformator.low_voltage.destroy() end

        storage.eg_transformators[unit_number] = nil
    end
end

--- Handle cursor stack change events to set or clear the copper wire flag.
-- @param event EventData The event data containing the player information.
local function on_cursor_stack_changed(event)
    local player = game.players[event.player_index]
    local cursor_stack = player.cursor_stack

    if cursor_stack and cursor_stack.valid_for_read and cursor_stack.name == "copper-wire" then
        storage.eg_copper_wire_on_cursor[player.index] = true
    else
        storage.eg_copper_wire_on_cursor[player.index] = nil
    end
end

--- Handle selection change events to track electric poles and enforce wiring rules.
-- @param event EventData.on_selected_entity_changed The event data contains the player information.
local function on_selected_entity_changed(event)
    local player = game.get_player(event.player_index)
    if not player then return end

    local selected_entity = player.selected
    local player_index = event.player_index

    -- Check if the player was holding copper wire and previously had an electric pole selected
    if storage.eg_last_selected_pole[player_index] and (not selected_entity or selected_entity.type ~= "electric-pole") then
        enforce_pole_connections(storage.eg_last_selected_pole[player_index])
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

--- Handle transformator rating selection event.
-- Toggles the rating selection GUI for the player when a transformator is selected.
-- Opens the GUI and initializes it with the current rating.
-- @param event EventData The event data containing the player index.
local function on_transformator_rating_selection(event)
    local player = game.get_player(event.player_index)
    if not player or not player.valid then return end

    local selected_entity = player.selected
    if selected_entity and selected_entity.valid and is_transformator(selected_entity.name) then
        if player.gui.screen.transformator_rating_selection_frame then
            close_transformator_gui(player)
        else
            local frame = get_or_create_transformator_frame(player)
            local current_rating = get_current_transformator_rating(selected_entity)
            add_rating_checkboxes(frame, current_rating)
            frame.add { type = "button", name = "confirm_transformator_rating", caption = "Save" }

            storage.eg_selected_transformator[player.index] = selected_entity
        end
    end
end

--- Handle GUI checkbox state change event.
-- Ensures that only one checkbox in the transformator rating selection GUI is active at a time.
-- When a checkbox is selected, all others in the same frame are deselected.
-- @param event EventData The event data containing the GUI element information.
local function on_gui_checked_state_changed(event)
    local element = event.element
    if not (element and element.valid) then return end

    if element.name:find("rating_checkbox_") then
        local player = game.get_player(event.player_index)
        if not player then return end
        local frame = player.gui.screen.transformator_rating_selection_frame
        if frame then
            for _, child in pairs(frame.children[1].children) do
                if child.type == "checkbox" and child.name ~= element.name then
                    child.state = false
                end
            end
        end
    end
end

--- Handle GUI click event.
-- Processes the "Save" button click in the transformator rating selection GUI.
-- Updates the transformator's rating if a different rating is selected and closes the GUI.
-- @param event EventData The event data containing the GUI element information.
local function on_gui_click(event)
    local element = event.element
    if not (element and element.valid) then return end

    local player = game.get_player(event.player_index)
    if not player or not player.valid then return end

    if element.name == "confirm_transformator_rating" then
        local transformator = storage.eg_selected_transformator[player.index]
        if transformator and transformator.valid then
            local frame = player.gui.screen.transformator_rating_selection_frame
            local current_rating = get_current_transformator_rating(transformator)
            local selected_rating = nil
            for _, child in pairs(frame.children[1].children) do
                if child.type == "checkbox" and child.state then
                    selected_rating = string.match(child.name, "rating_checkbox_(.+)")
                    break
                end
            end

            if selected_rating and selected_rating ~= current_rating then
                replace_transformator(transformator, selected_rating)
                storage.eg_selected_transformator[player.index] = nil
            end
        end

        close_transformator_gui(player)
    end
end

--- Handle GUI closed event.
-- Replace the copmponents with a buffer when disabled via the filter.
-- Appropriate fluid filter is set on the pump based on the current transformator tier.
-- @param event EventData The event data containing the player and entity information.
local function on_gui_closed(event)
    local player = game.get_player(event.player_index)
    if not player or not player.valid then return end

    local entity = event.entity
    if not entity or not entity.valid then return end

    local transformator = find_transformator_by_pump(entity)
    if not transformator then return end

    local pump = transformator.pump
    if not pump or not pump.valid then return end

    local filter = pump.fluidbox.get_filter(1)
    if filter and filter.name then
        local unit_name = transformator.unit.name
        local tier = string.sub(unit_name, -1)

        if filter.name == "eg-fluid-disable" then
            pump.clear_fluid_inside()
            pump.fluidbox.set_filter(1, { name = "eg-fluid-disable" })
            replace_boiler_steam_engine(transformator)
        else
            pump.clear_fluid_inside()
            pump.fluidbox.set_filter(1, { name = "eg-water-" .. tier })
        end
    end
end

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

    if storage.eg_check_interval and storage.eg_check_interval > 0 then
        script.on_nth_tick(storage.eg_check_interval, nth_tick_checks)
    end

    script.on_event("transformator_rating_selection", on_transformator_rating_selection)
    script.on_event(defines.events.on_gui_checked_state_changed, on_gui_checked_state_changed)
    script.on_event(defines.events.on_gui_click, on_gui_click)
    script.on_event(defines.events.on_gui_closed, on_gui_closed)
end

script.on_init(function()
    initialize_globals()
    register_event_handlers()
end)

script.on_load(function()
    register_event_handlers()
end)

script.on_configuration_changed(function()
    if settings.startup["eg-on-tick-interval"] then
        storage.eg_check_interval = tonumber(settings.startup["eg-on-tick-interval"].value) * 60
    end

    initialize_globals()
    register_event_handlers()
end)
