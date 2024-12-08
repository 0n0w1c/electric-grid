constants = require("constants")

require("control-helpers")

local function initialize_globals()
    storage = storage or {}
    storage.eg_transformators = storage.eg_transformators or {}
    storage.eg_selected_transformator = storage.eg_selected_transformator or {}
    storage.eg_copper_wire_on_cursor = storage.eg_copper_wire_on_cursor or {}
    storage.eg_last_selected_pole = storage.eg_last_selected_pole or {}
    storage.eg_check_interval = storage.eg_check_interval or 60
    storage.eg_transformators_only = storage.eg_transformators_only or false

    if settings.startup["eg-on-tick-interval"] and settings.startup["eg-on-tick-interval"].value then
        storage.eg_check_interval = tonumber(settings.startup["eg-on-tick-interval"].value) * 60
    end

    if settings.startup["eg-transformators-only"] then
        storage.eg_transformators_only = settings.startup["eg-transformators-only"].value
    end
end

local function remove_invalid_transformators()
    local transformators = storage.eg_transformators
    local invalid_transformators = {}

    for unit_number, _ in pairs(transformators) do
        if not is_transformator_valid(unit_number) then
            table.insert(invalid_transformators, unit_number)
        end
    end

    for _, unit_number in pairs(invalid_transformators) do
        game.print("Invalid transformator detected: " .. unit_number)
        remove_transformator(unit_number)
    end
end

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

local function check_short_circuit(transformator)
    if not (transformator.high_voltage.valid and transformator.low_voltage.valid and transformator.unit.valid) then return end

    local high_network_id = transformator.high_voltage.electric_network_id
    local low_network_id = transformator.low_voltage.electric_network_id

    if not (high_network_id and low_network_id) then return end

    if high_network_id == low_network_id then
        if transformator.alert_tick == 0 then
            for _, player in pairs(game.players) do
                transformator.alert_tick = game.tick
                player.add_custom_alert(
                    transformator.unit,
                    { type = "virtual", name = "eg-alert" },
                    { "", "Short circuit detected" },
                    true
                )
            end
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

local function check_pump_disabled(transformator)
    local pump = transformator.pump
    if not (pump and pump.valid) then return end

    local control_behavior = pump.get_control_behavior()

    if control_behavior and control_behavior.disabled and pump.fluidbox[1] ~= nil then
        pump.clear_fluid_inside()
        replace_boiler_steam_engine(transformator)
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

--- Find all electric poles within a radius around a mined entity's position.
-- @param entity LuaEntity The mined electric pole entity.
-- @param radius number The radius to search (default: 64).
-- @return table A list of electric poles within the radius.
local function get_nearby_poles(entity)
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
        if not storage.eg_transformators_only then
            enforce_pole_connections(new_entity)

            local poles = get_nearby_poles(new_entity)
            if poles then
                for _, pole in pairs(poles) do
                    enforce_pole_connections(pole)
                end
            end
        end

        local transformators = storage.eg_transformators
        for _, transformator in pairs(transformators) do
            check_short_circuit(transformator)
        end
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

        local transformators = storage.eg_transformators
        for _, transformator in pairs(transformators) do
            check_short_circuit(transformator)
        end
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
        local transformators = storage.eg_transformators
        for _, transformator in pairs(transformators) do
            check_short_circuit(transformator)
        end

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

        local transformators = storage.eg_transformators
        for _, transformator in pairs(transformators) do
            check_short_circuit(transformator)
        end
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

    script.on_event(defines.events.on_player_mined_entity, on_entity_mined)
    script.on_event(defines.events.on_robot_mined_entity, on_entity_mined)
    script.on_event(defines.events.on_space_platform_mined_entity, on_entity_mined)
    script.on_event(defines.events.on_entity_died, on_entity_mined)

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
    initialize_globals()
    remove_invalid_transformators()
    register_event_handlers()
end)
