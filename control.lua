constants = require("constants")

local job_queue = require("job_queue")

require("control_helpers")

--- Initializes global storage variables for managing transformators and related state.
-- Ensures all required global variables are initialized with default values if not already set.
-- Configures `storage` based on startup settings.
-- @global storage table A global table used to store persistent game state related to transformators.
-- @return nil
local function initialize_globals()
    storage = storage or {}
    storage.eg_transformators = storage.eg_transformators or {}
    storage.eg_selected_transformator = storage.eg_selected_transformator or {}
    storage.eg_copper_wire_on_cursor = storage.eg_copper_wire_on_cursor or {}
    storage.eg_last_selected_pole = storage.eg_last_selected_pole or {}
    storage.eg_check_interval = storage.eg_check_interval or 60
    storage.eg_transformators_only = storage.eg_transformators_only or false
    storage.eg_selected_rating = storage.eg_selected_rating or {}
    storage.eg_transformator_to_build = storage.eg_transformator_to_build or nil

    if settings.startup["eg-on-tick-interval"] and settings.startup["eg-on-tick-interval"].value then
        storage.eg_check_interval = tonumber(settings.startup["eg-on-tick-interval"].value) * 60
    end

    if settings.startup["eg-transformators-only"] then
        storage.eg_transformators_only = settings.startup["eg-transformators-only"].value
            or (script.active_mods["base"] < "2.0.29"
                and not (script.active_mods["no-quality"] or script.active_mods["unquality"] or script.active_mods["no-more-quality"]))
    end
end

--[[
local function get_usage(pole)
    if not (pole and pole.valid and pole.type == "electric-pole" and pole.electric_network_statistics) then
        return 0
    end

    local stats = pole.electric_network_statistics
    local total_usage = 0

    for prototype_name, count in pairs(stats.input_counts) do
        if count > 0 and string.sub(prototype_name, 1, 3) ~= "eg-" then
            for _, quality in ipairs(constants.EG_QUALITIES) do
                local flow = stats.get_flow_count {
                    name = { name = prototype_name, quality = quality },
                    precision_index = defines.flow_precision_index.five_seconds,
                    count = false,
                    category = "input"
                }

                total_usage = total_usage + flow
            end
        end
    end

    return total_usage * 60 -- Convert from per tick to per second
end

local function get_production(pole)
    if not (pole and pole.valid and pole.type == "electric-pole" and pole.electric_network_statistics) then
        return 0
    end

    local stats = pole.electric_network_statistics
    local total_production = 0

    for prototype_name, count in pairs(stats.output_counts) do
        if count > 0 and string.sub(prototype_name, 1, 3) ~= "eg-" then
            for _, quality in ipairs(constants.EG_QUALITIES) do
                local flow = stats.get_flow_count {
                    name = { name = prototype_name, quality = quality },
                    precision_index = defines.flow_precision_index.five_seconds,
                    count = false,
                    category = "output"
                }

                total_production = total_production + flow
            end
        end
    end

    return total_production * 60 -- Convert from per tick to per second
end

local function get_maximum_production(pole)
    if not (pole and pole.valid and pole.type == "electric-pole" and pole.electric_network_statistics) then
        return 0
    end

    local stats = pole.electric_network_statistics
    local total_max_production = 0

    -- Iterate over all prototypes producing power in the network
    for prototype_name, count in pairs(stats.output_counts) do
        if count > 0 then
            local prototype = game.entity_prototypes[prototype_name]
            if prototype and prototype.get_max_energy_production then
                -- Get max energy production per entity in Joules per tick
                local max_production_per_entity = prototype.get_max_energy_production()
                -- Convert to Watts (Joules per second) and multiply by the count
                total_max_production = total_max_production + (max_production_per_entity * count * 60)
            end
        end
    end

    return total_max_production -- Return the maximum power production in Watts
end
]]

--- Checks if the pump in the transformator is disabled, and if so, clears its fluid and triggers a replacement of boiler/steam engine.
-- @param transformator table The transformator entity containing the pump reference.
-- @field pump LuaEntity The pump entity associated with the transformator.
-- @return nil
local function check_pump_disabled(transformator)
    local pump = transformator.pump
    if not (pump and pump.valid) then return end

    local control_behavior = pump.get_control_behavior()
    if control_behavior and control_behavior.disabled and pump.fluidbox[1] ~= nil then
        pump.clear_fluid_inside()
        replace_tiered_components(transformator)
    end
end

--- Periodic checks on all transformers
-- Replaces buffered components if pump is disabled, quick power on/off
local function nth_tick_checks()
    local transformators = storage.eg_transformators
    for _, transformator in pairs(transformators) do
        check_pump_disabled(transformator)
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
        local unit_number = entity.unit_number

        job_queue.schedule(
            game.tick + 180,
            "replace_displayer_with_ugp_substation",
            { unit_number = unit_number }
        )
    elseif entity.type == "electric-pole" then
        if not storage.eg_transformators_only then
            enforce_pole_connections(entity)

            local poles = get_nearby_poles(entity)
            if poles then
                for _, pole in pairs(poles) do
                    enforce_pole_connections(pole)
                end
            end
        end

        short_circuit_check()
    end
end

--- Handles the event triggered when an entity is mined by a player or a robot.
-- If the mined entity is a transformator, it removes it from the mod's internal storage.
-- If the entity is an electric pole, it optionally enforces connection rules for nearby poles.
-- @param event EventData.on_entity_mined The event data containing information about the mined entity.
local function on_entity_mined(event)
    local entity = event.entity
    if not (entity and entity.valid) then return end

    if is_transformator(entity.name) then
        local unit_number = entity.unit_number
        remove_transformator(unit_number)
    elseif entity.type == "electric-pole" then
        short_circuit_check()

        if not storage.eg_transformators_only then
            -- Auto-reconnect seems to preserve the wiring rules, so this may not be necessary.
            local poles = get_nearby_poles(entity)
            if poles then
                for _, pole in pairs(poles) do
                    enforce_pole_connections(pole)
                end
            end
        end
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

    if cursor_stack and not cursor_stack.valid_for_read then
        storage.eg_transformator_to_build = nil
    end
end

--- Handle selection change events to track electric poles and enforce wiring rules.
-- @param event EventData.on_selected_entity_changed The event data contains the player information.
local function on_selected_entity_changed(event)
    local player = game.get_player(event.player_index)
    if not player then return end

    local selected_entity = player.selected
    local player_index = event.player_index

    if storage.eg_last_selected_pole[player_index] and (not selected_entity or selected_entity.type ~= "electric-pole") then
        enforce_pole_connections(storage.eg_last_selected_pole[player_index])
        storage.eg_last_selected_pole[player_index] = nil

        short_circuit_check()
    end

    if storage.eg_copper_wire_on_cursor[player_index] and selected_entity and selected_entity.valid and selected_entity.type == "electric-pole" then
        storage.eg_last_selected_pole[player_index] = selected_entity
    else
        storage.eg_last_selected_pole[player_index] = nil
    end

    if selected_entity and selected_entity.valid and is_transformator(selected_entity.name) and not storage.eg_transformator_to_build then
        storage.eg_transformator_to_build = selected_entity.name
    end

    if player.cursor_stack and not player.cursor_stack.valid_for_read then
        storage.eg_transformator_to_build = nil
    end
end

--- Handle the transformator rating selection event
-- Toggles the GUI for selecting the transformator rating
-- If the GUI is already open, it closes it; otherwise, it initializes and opens the GUI
-- Stores the selected transformator for reference during the GUI interaction
-- @param event EventData.on_selected_entity_changed The event data containing the player's index
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
            add_rating_dropdown(frame, current_rating)

            storage.eg_selected_transformator[player.index] = selected_entity
            player.opened = frame
        end
    end
end

--- Handle GUI click events
-- Processes button clicks in the transformator rating selection GUI
-- Handles "Save" and "Close" button clicks, updating the transformator rating or closing the GUI
-- @param event EventData.on_gui_click The event data containing the GUI element and player index
local function on_gui_click(event)
    local element = event.element
    if not (element and element.valid) then return end

    local player = game.get_player(event.player_index)
    if not player or not player.valid then return end

    if element.name == "close_transformator_gui" then
        close_transformator_gui(player)
        remove_invalid_transformators()
        return
    end

    if element.name == "confirm_transformator_rating" then
        local transformator = storage.eg_selected_transformator[player.index]
        if transformator and transformator.valid then
            local frame = player.gui.screen.transformator_rating_selection_frame
            if not frame then return end

            local bordered_frame = frame.rating_selection_bordered_frame
            if not bordered_frame then return end

            local dropdown = nil
            for _, child in pairs(bordered_frame.children) do
                if child.name == "dropdown_flow" then
                    for _, inner_child in pairs(child.children) do
                        if inner_child.name == "rating_dropdown" then
                            dropdown = inner_child
                            break
                        end
                    end
                end
            end

            if dropdown and dropdown.items then
                local selected_rating = dropdown.items[dropdown.selected_index]
                local current_rating = get_current_transformator_rating(transformator)

                if selected_rating and selected_rating ~= current_rating then
                    replace_transformator(transformator, selected_rating)
                    storage.eg_selected_transformator[player.index] = nil
                end
            end
        end

        close_transformator_gui(player)
        remove_invalid_transformators()
    end
end

--- Handle GUI or entity closed events
-- Processes when a player closes the transformator rating selection GUI or an entity is closed
-- Handles cleaning up the selected transformator state and updates the transformator's pump fluid filters
-- @param event EventData.on_gui_closed The event data containing the player index and closed GUI element or entity
local function on_gui_closed(event)
    local player = game.get_player(event.player_index)
    if not player or not player.valid then return end

    if event.element and event.element.name == "transformator_rating_selection_frame" then
        storage.eg_selected_transformator[player.index] = nil
        player.opened = nil
        return
    end

    local entity = event.entity
    if entity and entity.valid and entity.type == "pump" then
        local transformator = find_transformator_by_pump(entity)
        if not transformator then return end

        local pump = transformator.pump
        if pump and pump.valid then
            local filter = pump.fluidbox.get_filter(1)
            if filter and filter.name then
                local unit_name = transformator.unit.name
                local tier = string.sub(unit_name, -1)

                if filter.name == "eg-fluid-disable" then
                    pump.clear_fluid_inside()
                    replace_tiered_components(transformator)
                    pump.fluidbox.set_filter(1, { name = "eg-fluid-disable" })
                else
                    pump.clear_fluid_inside()
                    pump.fluidbox.set_filter(1, { name = "eg-water-" .. tier })
                end
            end
        end
    end
end

--- Update the sprite based on the selected dropdown rating
-- This function is called when the dropdown selection changes
-- @param player LuaPlayer The player interacting with the GUI
-- @param selected_rating string The selected rating from the dropdown
local function update_sprite(player, selected_rating)
    if not player or not player.valid then return end

    local frame = player.gui.screen.transformator_rating_selection_frame
    if not frame then return end

    local bordered_frame = frame.rating_selection_bordered_frame
    if not bordered_frame then return end

    local sprite_background_frame = bordered_frame["sprite_background_frame"]
    if not sprite_background_frame then return end

    local sprite_element = sprite_background_frame["current_rating_sprite"]
    if not sprite_element then return end

    sprite_element.sprite = selected_rating
    sprite_element.tooltip = "Rating: " .. selected_rating
end

--- Handle dropdown selection state change event
-- Updates the sprite when the dropdown selection changes
-- @param event EventData The event data for the selection state change
local function on_dropdown_selection_changed(event)
    local element = event.element
    if not (element and element.valid) then return end

    if element.name == "rating_dropdown" then
        local player = game.get_player(event.player_index)
        if not player or not player.valid then return end

        local selected_rating = element.items[element.selected_index]
        update_sprite(player, selected_rating)
    end
end

--- Handle transformator rotation event
-- Replaces a transformator upon rotation by removing and re-adding it, preserving its new orientation
-- @param event EventData The event data containing the rotated entity
local function on_entity_rotated(event)
    local entity = event.entity
    if not entity or not entity.valid then return end

    if is_transformator(entity.name) and entity.unit_number then
        remove_transformator(entity.unit_number)
        eg_transformator_built(entity)
    end
end

local function handle_close_transformator_gui(event)
    local player = game.get_player(event.player_index)
    if not player then return end

    if player.gui.screen.transformator_rating_selection_frame then
        close_transformator_gui(player)
    end
end

local function on_entity_pipetted(event)
    local player = game.get_player(event.player_index)
    if not player then return end

    if player.selected and player.selected.valid then
        storage.eg_transformator_to_build = player.selected.name
    end
end

local function register_event_handlers()
    script.on_event(defines.events.on_player_pipette, on_entity_pipetted)
    script.on_event(defines.events.on_player_rotated_entity, on_entity_rotated)

    script.on_event(defines.events.on_built_entity, on_entity_built)
    script.on_event(defines.events.on_robot_built_entity, on_entity_built)
    script.on_event(defines.events.on_space_platform_built_entity, on_entity_built)
    script.on_event(defines.events.on_entity_cloned, on_entity_built)

    script.on_event(defines.events.on_player_mined_entity, on_entity_mined)
    script.on_event(defines.events.on_robot_mined_entity, on_entity_mined)
    script.on_event(defines.events.on_space_platform_mined_entity, on_entity_mined)
    script.on_event(defines.events.on_entity_died, on_entity_mined)

    script.on_event(defines.events.on_player_cursor_stack_changed, on_cursor_stack_changed)
    script.on_event(defines.events.on_selected_entity_changed, on_selected_entity_changed)

    script.on_event("transformator-rating-selection", on_transformator_rating_selection)
    script.on_event(defines.events.on_gui_selection_state_changed, on_dropdown_selection_changed)
    script.on_event(defines.events.on_gui_click, on_gui_click)
    script.on_event(defines.events.on_gui_closed, on_gui_closed)
    script.on_event({ "close-transformator-rating-selection-e", "close-transformator-rating-selection-esc" },
        handle_close_transformator_gui)

    if game and storage.eg_check_interval and storage.eg_check_interval > 0 then
        job_queue.schedule(game.tick + storage.eg_check_interval, "nth_tick_checks", {}, storage.eg_check_interval)
    end
end

script.on_init(function()
    initialize_globals()
    job_queue.init()
    job_queue.register_function("replace_displayer_with_ugp_substation", replace_displayer_with_ugp_substation)
    job_queue.register_function("nth_tick_checks", nth_tick_checks)
    job_queue.update_registration()
    register_event_handlers()
end)

script.on_load(function()
    if storage.jobs then
        job_queue.register_function("replace_displayer_with_ugp_substation", replace_displayer_with_ugp_substation)
        job_queue.register_function("nth_tick_checks", nth_tick_checks)
        job_queue.update_registration()
    end
    register_event_handlers()
end)

script.on_configuration_changed(function()
    initialize_globals()
    remove_invalid_transformators()
    job_queue.init()
    job_queue.register_function("replace_displayer_with_ugp_substation", replace_displayer_with_ugp_substation)
    job_queue.register_function("nth_tick_checks", nth_tick_checks)
    job_queue.update_registration()
    register_event_handlers()
end)
