--- Runtime control script for Electric Grid.
--
-- This file owns event registration, persistent runtime state initialization,
-- blueprint tier tagging, GUI interactions, and the high-level lifecycle of
-- transformators and related pole wiring rules.
--
-- Helper functions that build, rebuild, replace, validate, and query
-- transformators live in `control_helpers.lua` and are loaded below.

constants = require("constants")
local job_queue = require("job_queue")
require("control_helpers")


-- ---------------------------------------------------------------------------
-- Initialization helpers
-- ---------------------------------------------------------------------------

--- Add Electric Grid entities to the Picker Dollies blacklist when the remote
--- interface is available.
--- @return nil
local function edp_blacklist()
    if not remote.interfaces["PickerDollies"] then return end

    local blacklist_names = {
        "eg-pump",
        "eg-low-voltage-pole-" .. defines.direction.north,
        "eg-low-voltage-pole-" .. defines.direction.east,
        "eg-low-voltage-pole-" .. defines.direction.south,
        "eg-low-voltage-pole-" .. defines.direction.west,
        "eg-high-voltage-pole-" .. defines.direction.north,
        "eg-high-voltage-pole-" .. defines.direction.east,
        "eg-high-voltage-pole-" .. defines.direction.south,
        "eg-high-voltage-pole-" .. defines.direction.west
    }

    for _, name in pairs(blacklist_names) do
        remote.call("PickerDollies", "add_blacklist_name", name)
    end
end

--- Round a target tick up to the next job-queue scheduler bucket.
--- @param tick uint Target tick.
--- @return uint aligned_tick
local function align_to_scheduler_tick(tick)
    local scheduler_interval = constants.EG_TICK_INTERVAL
    return math.ceil(tick / scheduler_interval) * scheduler_interval
end

--- Initialize or migrate persistent global state used by the mod.
---
--- This function is safe to call from `on_init` and
--- `on_configuration_changed`.
--- @return nil
local function initialize_globals()
    storage = storage or {}
    storage.eg_transformators = storage.eg_transformators or {}
    storage.eg_selected_transformator = storage.eg_selected_transformator or {}
    storage.eg_copper_wire_on_cursor = storage.eg_copper_wire_on_cursor or {}
    storage.eg_last_selected_pole = storage.eg_last_selected_pole or {}
    storage.eg_selected_rating = storage.eg_selected_rating or {}
    if type(storage.eg_transformator_to_build) ~= "table" then
        storage.eg_transformator_to_build = {}
    end
    storage.eg_transformator_keys = storage.eg_transformator_keys or {}
    storage.eg_transformator_scan_index = storage.eg_transformator_scan_index or 1
    storage.eg_entity_to_transformator = storage.eg_entity_to_transformator or {}

    storage.eg_transformators_only = false

    local setting = settings.startup["eg-transformators-only"].value
    if setting
        or (script.active_mods["base"] < "2.0.29"
            and not (script.active_mods["no-quality"]
                or script.active_mods["unquality"]
                or script.active_mods["no-more-quality"]))
    then
        storage.eg_transformators_only = true
    end

    if script.active_mods["bobpower"] and settings.startup["bobmods-power-poles"].value then
        storage.eg_transformators_only = true
    end
end


-- ---------------------------------------------------------------------------
-- Transformator monitoring helpers
-- ---------------------------------------------------------------------------

--- React to a pump being disabled through circuit control.
---
--- Only the transition from enabled -> disabled matters. When the pump is
--- disabled, buffered fluid is cleared and the boiler/steam-engine pair is
--- refreshed so their tiered prototypes match the transformator state.
--- @param transformator table Stored transformator state.
--- @return nil
local function check_pump_disabled(transformator)
    local pump = transformator.pump
    if not (pump and pump.valid) then return end

    local cb = pump.get_control_behavior()
    local disabled = cb and cb.disabled or false

    if transformator.pump_was_disabled == nil then
        transformator.pump_was_disabled = disabled
        return
    end

    if not disabled then
        transformator.pump_was_disabled = false
        return
    end

    if transformator.pump_was_disabled then
        return
    end

    transformator.pump_was_disabled = true
    pump.clear_fluid_inside()
    replace_tiered_components(transformator)
end

--- Perform the per-tick sliced transformator maintenance scan.
---
--- Work is intentionally bounded by `constants.EG_PROCESS_PER_TICK` to avoid
--- scanning all transformators every tick.
--- @return nil
local function on_tick_pump_checks()
    local keys = storage.eg_transformator_keys
    local count = #keys
    if count == 0 then
        storage.eg_transformator_scan_index = 1
        return
    end

    local per_tick = constants.EG_PROCESS_PER_TICK
    local index = storage.eg_transformator_scan_index

    for _ = 1, math.min(per_tick, count) do
        if index > count then
            index = 1
        end

        local pump_unit_number = keys[index]
        local transformator = storage.eg_transformators[pump_unit_number]
        if transformator then
            check_pump_disabled(transformator)
        end

        index = index + 1
    end

    storage.eg_transformator_scan_index = index
end


-- ---------------------------------------------------------------------------
-- Blueprint helpers
-- ---------------------------------------------------------------------------

--- Translate a transformator tier into the configured rating string.
--- @param tier integer|string|nil
--- @return string|nil rating
local function get_transformator_rating_for_tier(tier)
    if not tier then return nil end
    local spec = constants.EG_TRANSFORMATORS["eg-unit-" .. tostring(tier)]
    return spec and spec.rating or nil
end

--- Apply a blueprint-stored tier tag after a pump-rooted transformator has
--- been created.
--- @param entity LuaEntity Built root pump.
--- @param tags table|nil Blueprint placement tags.
--- @return nil
local function apply_transformator_blueprint_tier(entity, tags)
    if not (entity and entity.valid and entity.name == "eg-pump") then return end
    if not tags then return end

    local tier = tonumber(tags[constants.EG_BLUEPRINT_TIER_TAG])
    if not tier then return end

    local transformator = get_transformator_by_pump_unit_number(entity.unit_number)
    if not transformator then return end

    local current_tier = get_transformator_tier(transformator)
    if current_tier == tier then return end

    local rating = get_transformator_rating_for_tier(tier)
    if not rating then return end

    replace_transformator(transformator, rating)
end

--- Write transformator tier data into blueprint entity tags.
---
--- Only `eg-pump` entities are tagged. The tier is later restored when the
--- blueprint is placed and the transformator is rebuilt around the placed pump.
--- @param event EventData.on_player_setup_blueprint
--- @return nil
local function on_player_setup_blueprint(event)
    local blueprint = event.stack or event.record
    if not blueprint then return end

    local mapping = event.mapping
    if mapping and mapping.get then
        mapping = mapping.get()
    end
    if not mapping then return end

    for blueprint_entity_index, source_entity in pairs(mapping) do
        if source_entity and source_entity.valid and source_entity.name == "eg-pump" then
            local transformator = get_transformator_by_entity(source_entity)
            local tier = get_transformator_tier(transformator)
            if tier then
                local tags = blueprint.get_blueprint_entity_tags(blueprint_entity_index) or {}
                tags[constants.EG_BLUEPRINT_TIER_TAG] = tier
                blueprint.set_blueprint_entity_tags(blueprint_entity_index, tags)
            end
        end
    end
end


-- ---------------------------------------------------------------------------
-- Build / mine / rotate handlers
-- ---------------------------------------------------------------------------

--- Common build handler for player, robot, script, and clone build events.
---
--- This function builds transformator internals, applies blueprint tier tags,
--- schedules delayed substation replacement jobs, and enforces pole wiring
--- rules for newly built electric poles.
--- @param event table Build-like event containing `entity`.
--- @return nil
local function on_entity_built(event)
    if not event or not event.entity or not event.entity.valid then return end
    local entity = event.entity

    if is_transformator(entity.name) then
        eg_transformator_built(entity, event.player_index)
        apply_transformator_blueprint_tier(entity, event.tags)
        return
    end

    if entity.name == "eg-ugp-substation-displayer" then
        local aligned_tick = align_to_scheduler_tick(game.tick + 180)
        job_queue.schedule(aligned_tick, "replace_displayer_with_ugp_substation", {
            unit_number = entity.unit_number
        })
        return
    end

    if entity.name == "power-combinator" or entity.name == "power-combinator-MK2" then
        if not storage.eg_transformators_only then
            local pole = entity.surface.find_entity("power-combinator-meter-network", entity.position)
            if pole then
                enforce_pole_connections(pole)
            end
        end
        return
    end

    if entity.type == "electric-pole" then
        if not storage.eg_transformators_only then
            local poles = get_nearby_poles(entity)
            if poles then
                for _, pole in pairs(poles) do
                    enforce_pole_connections(pole)
                end
            end
        end

        if string.sub(entity.name, 1, 7) == "F077ET-" or string.sub(entity.name, 1, 14) == "electric-proxy" then
            local aligned_tick = align_to_scheduler_tick(game.tick + 1)
            job_queue.schedule(aligned_tick, "short_circuit_check")
        else
            short_circuit_check()
        end
    end
end

--- Common mine / destroy handler.
--- @param event table Mine-like event containing `entity`.
--- @return nil
local function on_entity_mined(event)
    local entity = event.entity
    if not (entity and entity.valid) then return end

    if is_transformator(entity.name) then
        local transformator = get_transformator_by_entity(entity)
        if transformator and transformator.pump and transformator.pump.unit_number then
            remove_transformator(transformator.pump.unit_number)
        end
        return
    end

    if entity.type == "electric-pole" then
        if not storage.eg_transformators_only then
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

--- Rebuild transformator dependents after a player rotates the root pump.
--- @param event EventData.on_player_rotated_entity
--- @return nil
local function on_player_rotated_entity(event)
    local entity = event.entity
    if not (entity and entity.valid and entity.name == "eg-pump") then return end
    rebuild_transformator_dependents_from_pump(entity)
end

--- Restrict special script-raised build handling to proxy pole entities that
--- need the normal build path.
--- @param event EventData.script_raised_built
--- @return nil
local function on_script_raised_built(event)
    local entity = event.entity
    if not (entity and entity.valid) then return end
    if entity.type ~= "electric-pole" then return end
    if not (string.sub(entity.name, 1, 7) == "F077ET-" or string.sub(entity.name, 1, 14) == "electric-proxy") then
        return
    end

    on_entity_built(event)
end


-- ---------------------------------------------------------------------------
-- Cursor / selection helpers
-- ---------------------------------------------------------------------------

--- Track whether the player currently holds copper wire on the cursor.
---
--- This state is used to defer pole-connection enforcement until the player
--- finishes dragging copper wire.
--- @param event EventData.on_player_cursor_stack_changed
--- @return nil
local function on_cursor_stack_changed(event)
    local player = game.players[event.player_index]
    local cursor_stack = player.cursor_stack

    if cursor_stack and cursor_stack.valid_for_read and cursor_stack.name == "copper-wire" then
        storage.eg_copper_wire_on_cursor[player.index] = true
    else
        storage.eg_copper_wire_on_cursor[player.index] = nil
    end

    if not (cursor_stack and cursor_stack.valid_for_read) then
        storage.eg_transformator_to_build[player.index] = nil
    end
end

--- Track the player selection needed for wire enforcement and transformator
--- placement intent.
--- @param event EventData.on_selected_entity_changed
--- @return nil
local function on_selected_entity_changed(event)
    local player_index = event.player_index
    local player = game.get_player(player_index)
    if not player then return end
    if storage.eg_transformators_only then return end

    local selected_entity = player.selected

    if not selected_entity and storage.eg_last_selected_pole[player_index] then
        local poles = get_nearby_poles(storage.eg_last_selected_pole[player_index])
        if poles then
            for _, pole in pairs(poles) do
                enforce_pole_connections(pole)
            end
            short_circuit_check()
        end

        storage.eg_last_selected_pole[player_index] = nil
        return
    end

    if storage.eg_copper_wire_on_cursor[player_index]
        and selected_entity
        and selected_entity.type == "electric-pole"
    then
        storage.eg_last_selected_pole[player_index] = selected_entity
    end

    if selected_entity and is_transformator(selected_entity.name) and not storage.eg_transformator_to_build[player.index] then
        storage.eg_transformator_to_build[player.index] = selected_entity.name
    end

    if not (player.cursor_stack and player.cursor_stack.valid_for_read) then
        storage.eg_transformator_to_build[player.index] = nil
    end
end

--- Remember the currently selected transformator-ish entity when the player uses
--- pipette, so later placement can inherit the intended transformator tier.
--- @param event EventData.on_player_pipette
--- @return nil
local function on_entity_pipetted(event)
    local player = game.get_player(event.player_index)
    if not player then return end

    local selected = player.selected
    if not (selected and selected.valid and is_transformator(selected.name)) then return end

    storage.eg_transformator_to_build[player.index] = selected.name
end


-- ---------------------------------------------------------------------------
-- GUI helpers
-- ---------------------------------------------------------------------------

--- Update the rating preview sprite inside the full-screen transformator GUI.
--- @param player LuaPlayer
--- @param selected_rating string
--- @return nil
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

--- Open the relative transformator rating GUI when the player opens the pump.
--- @param event EventData.on_gui_opened
--- @return nil
local function on_gui_opened(event)
    local player = game.get_player(event.player_index)
    if not player or not player.valid then return end

    local entity = event.entity
    if entity and entity.valid and entity.name == "eg-pump" then
        local transformator = find_transformator_by_pump(entity)
        if not transformator then
            close_transformator_gui(player)
            return
        end

        local current_rating = get_current_transformator_rating(transformator)
        if not current_rating then
            close_transformator_gui(player)
            return
        end

        local frame = get_or_create_transformator_relative_frame(player)
        if not (frame and frame.valid) then return end

        add_relative_rating_dropdown(frame, current_rating)
        storage.eg_selected_transformator[player.index] = transformator
        return
    end

    if player.gui.relative.eg_transformator_rating_relative_frame then
        close_transformator_gui(player)
    end
end

--- Handle the transformator rating GUIs being closed.
---
--- Also restores the pump's expected fluid filter state after the pump GUI
--- closes.
--- @param event EventData.on_gui_closed
--- @return nil
local function on_gui_closed(event)
    local player = game.get_player(event.player_index)
    if not player or not player.valid then return end

    if event.element and event.element.name == "transformator_rating_selection_frame" then
        storage.eg_selected_transformator[player.index] = nil
        player.opened = nil
        close_transformator_gui(player)
        return
    end

    if event.element and event.element.name == "eg_transformator_rating_relative_frame" then
        storage.eg_selected_transformator[player.index] = nil
        close_transformator_gui(player)
        return
    end

    local entity = event.entity
    if entity and entity.valid and entity.name == "eg-pump" then
        local transformator = find_transformator_by_pump(entity)
        if transformator then
            local pump = transformator.pump
            if pump and pump.valid then
                local filter = pump.fluidbox.get_filter(1)
                if filter and filter.name then
                    local tier = transformator.tier
                    if tier then
                        if filter.name == "eg-fluid-disable" then
                            transformator.pump_was_disabled = true
                            pump.clear_fluid_inside()
                            replace_tiered_components(transformator)
                            pump.fluidbox.set_filter(1, { name = "eg-fluid-disable" })
                        else
                            transformator.pump_was_disabled = false
                            pump.clear_fluid_inside()
                            pump.fluidbox.set_filter(1, { name = "eg-water-" .. tier })
                        end
                    end
                end
            end
        end
    end

    if player.gui.relative.eg_transformator_rating_relative_frame then
        close_transformator_gui(player)
    end
end

--- Handle button clicks in the transformator rating GUI.
--- @param event EventData.on_gui_click
--- @return nil
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
        if transformator and transformator.pump and transformator.pump.valid then
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

--- Handle transformator rating dropdown changes for both GUI variants.
--- @param event EventData.on_gui_selection_state_changed
--- @return nil
local function on_dropdown_selection_changed(event)
    local element = event.element
    if not (element and element.valid) then return end

    local player = game.get_player(event.player_index)
    if not player or not player.valid then return end

    if element.name == "rating_dropdown" then
        local selected_rating = element.items[element.selected_index]
        update_sprite(player, selected_rating)
        return
    end

    if element.name == "eg_relative_rating_dropdown" then
        local transformator = storage.eg_selected_transformator[player.index]
        if not transformator then return end
        if not (transformator.pump and transformator.pump.valid) then
            close_transformator_gui(player)
            return
        end

        local selected_rating = element.items[element.selected_index]
        local current_rating = get_current_transformator_rating(transformator)
        if not selected_rating or not current_rating then return end

        if selected_rating ~= current_rating then
            local pump_unit_number = transformator.pump.unit_number
            replace_transformator(transformator, selected_rating)
            storage.eg_selected_transformator[player.index] = storage.eg_transformators[pump_unit_number]
        end
    end
end


-- ---------------------------------------------------------------------------
-- Scheduled job helpers
-- ---------------------------------------------------------------------------

--- Process any queued delayed jobs due on the current bucket tick.
--- @param event EventData.on_nth_tick
--- @return nil
local function on_periodic_tick(event)
    job_queue.process(event.tick)
end

--- Register nth-tick handlers used by the job queue.
--- @return nil
local function register_nth_tick_handlers()
    script.on_nth_tick(constants.EG_TICK_INTERVAL, on_periodic_tick)
end


-- ---------------------------------------------------------------------------
-- Event registration and script lifecycle
-- ---------------------------------------------------------------------------

--- Register all event handlers used by the mod.
--- @return nil
local function register_event_handlers()
    script.on_event(defines.events.on_tick, on_tick_pump_checks)

    script.on_event(defines.events.on_player_pipette, on_entity_pipetted)
    script.on_event(defines.events.on_player_setup_blueprint, on_player_setup_blueprint)
    script.on_event(defines.events.on_player_rotated_entity, on_player_rotated_entity)

    script.on_event(defines.events.on_built_entity, on_entity_built)
    script.on_event(defines.events.on_robot_built_entity, on_entity_built)
    script.on_event(defines.events.on_space_platform_built_entity, on_entity_built)
    script.on_event(defines.events.on_entity_cloned, on_entity_built)
    script.on_event(defines.events.script_raised_revive, on_entity_built)
    script.on_event(defines.events.script_raised_built, on_script_raised_built)

    script.on_event(defines.events.on_player_mined_entity, on_entity_mined)
    script.on_event(defines.events.on_robot_mined_entity, on_entity_mined)
    script.on_event(defines.events.on_space_platform_mined_entity, on_entity_mined)
    script.on_event(defines.events.on_entity_died, on_entity_mined)
    script.on_event(defines.events.script_raised_destroy, on_entity_mined)

    script.on_event(defines.events.on_player_cursor_stack_changed, on_cursor_stack_changed)
    script.on_event(defines.events.on_selected_entity_changed, on_selected_entity_changed)

    script.on_event(defines.events.on_gui_opened, on_gui_opened)
    script.on_event(defines.events.on_gui_selection_state_changed, on_dropdown_selection_changed)
    script.on_event(defines.events.on_gui_click, on_gui_click)
    script.on_event(defines.events.on_gui_closed, on_gui_closed)
end

script.on_init(function()
    initialize_globals()
    job_queue.init()
    job_queue.register_function("replace_displayer_with_ugp_substation", replace_displayer_with_ugp_substation)
    job_queue.register_function("short_circuit_check", short_circuit_check)
    sync_transformator_keys()
    register_nth_tick_handlers()
    edp_blacklist()
    register_event_handlers()
end)

script.on_load(function()
    job_queue.register_function("replace_displayer_with_ugp_substation", replace_displayer_with_ugp_substation)
    job_queue.register_function("short_circuit_check", short_circuit_check)
    register_nth_tick_handlers()
    edp_blacklist()
    register_event_handlers()
end)

script.on_configuration_changed(function()
    initialize_globals()
    remove_invalid_transformators()
    job_queue.init()
    job_queue.register_function("replace_displayer_with_ugp_substation", replace_displayer_with_ugp_substation)
    job_queue.register_function("short_circuit_check", short_circuit_check)
    sync_transformator_keys()
    reset_short_circuit_alert_state()
    short_circuit_check()
    register_nth_tick_handlers()
    register_event_handlers()
end)
