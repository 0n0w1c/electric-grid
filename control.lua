--- Runtime control script for Electric Grid.
--
-- This file owns event registration, persistent runtime state initialization,
-- blueprint tier tagging, GUI interactions, and the high-level lifecycle of
-- transformators and related pole wiring rules.
--
-- Helper functions that build, rebuild, replace, validate, and query
-- transformators live in `control_helpers.lua` and are loaded below.
---

--- @class EgStorage
--- @field eg_transformators table<uint, EgTransformator>
--- @field eg_transformator_keys uint[]
--- @field eg_transformator_scan_index uint
--- @field eg_transformator_scan_accumulator number
--- @field eg_entity_to_transformator table<uint, uint>
--- @field eg_selected_transformator table<uint, EgTransformator>
--- @field eg_copper_wire_on_cursor table<uint, boolean>
--- @field eg_wire_click_source table<uint, LuaEntity>
--- @field eg_pending_wire_cleanup table<uint, {source: LuaEntity, target: LuaEntity, tick: uint}>
--- @field eg_transformator_to_build table<uint, string|integer>
--- @field eg_opened_pump_filter_name table<uint, string|nil>
--- @field eg_opened_pump_unit_number table<uint, uint|nil>
--- @field eg_short_circuit_check_tick uint|nil
--- @field eg_skip_pole_cleanup_on_mined table<string, boolean>

constants = require("constants")
local job_queue = require("job_queue")
require("control_helpers")

--- @type EgStorage
storage = storage

-- ---------------------------------------------------------------------------
-- Initialization helpers
-- ---------------------------------------------------------------------------

--- Add Electric Grid entities to the Picker Dollies blacklist when the remote
--- interface is available.
--- @return nil
local function edp_blacklist()
    if not remote.interfaces["PickerDollies"] then return end

    local blacklist_names = {
        get_transformator_pump_name(1),
        "eg-low-voltage-pole-" .. defines.direction.north,
        "eg-low-voltage-pole-" .. defines.direction.east,
        "eg-low-voltage-pole-" .. defines.direction.south,
        "eg-low-voltage-pole-" .. defines.direction.west,
        "eg-high-voltage-pole-" .. defines.direction.north,
        "eg-high-voltage-pole-" .. defines.direction.east,
        "eg-high-voltage-pole-" .. defines.direction.south,
        "eg-high-voltage-pole-" .. defines.direction.west
    }

    for tier = 2, constants.EG_NUM_TIERS do
        blacklist_names[#blacklist_names + 1] = get_transformator_pump_name(tier)
    end

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

--- Schedule a coalesced short-circuit scan for the next aligned scheduler tick.
---
--- Multiple requests for the same aligned tick collapse into a single queued
--- job. The pending marker is cleared when `short_circuit_check()` runs.
---
--- @return nil
function eg_schedule_short_circuit_check()
    local scheduled_tick = align_to_scheduler_tick(game.tick + 1)

    if storage.eg_short_circuit_check_tick == scheduled_tick then
        return
    end

    storage.eg_short_circuit_check_tick = scheduled_tick
    job_queue.schedule(scheduled_tick, "short_circuit_check")
end

--- Schedule a delayed overload validation for a newly built electric pole
--- after engine-created copper connections have settled.
---
--- The scheduled job stores a re-findable entity identity rather than the
--- runtime `LuaEntity` itself, because job arguments are persisted in storage.
--- @param entity LuaEntity?
--- @param player_index uint?
--- @return nil
local function schedule_built_pole_overload_check(entity, player_index)
    if not (entity and entity.valid and entity.type == "electric-pole" and entity.surface) then return end

    local scheduled_tick = align_to_scheduler_tick(game.tick + 1)
    job_queue.schedule(scheduled_tick, "validate_built_pole_overload", {
        surface_index = entity.surface.index,
        position = entity.position,
        name = entity.name,
        player_index = player_index
    })
end

--- Initialize or migrate persistent global state used by the mod.
---
--- This function is safe to call from `on_init` and on_configuration_changed`.
--- @return nil
local function initialize_globals()
    storage = storage or {}
    storage.eg_transformators = storage.eg_transformators or {}
    storage.eg_selected_transformator = storage.eg_selected_transformator or {}
    storage.eg_copper_wire_on_cursor = storage.eg_copper_wire_on_cursor or {}
    storage.eg_wire_click_source = storage.eg_wire_click_source or {}
    storage.eg_opened_pump_filter_name = storage.eg_opened_pump_filter_name or {}
    storage.eg_opened_pump_unit_number = storage.eg_opened_pump_unit_number or {}
    storage.eg_pending_wire_cleanup = storage.eg_pending_wire_cleanup or {}
    if type(storage.eg_transformator_to_build) ~= "table" then
        storage.eg_transformator_to_build = {}
    end
    storage.eg_transformator_keys = storage.eg_transformator_keys or {}
    storage.eg_transformator_scan_index = storage.eg_transformator_scan_index or 1
    storage.eg_entity_to_transformator = storage.eg_entity_to_transformator or {}
    storage.eg_skip_pole_cleanup_on_mined = storage.eg_skip_pole_cleanup_on_mined or {}

    storage.eg_transformator_scan_accumulator = storage.eg_transformator_scan_accumulator or 0
end


-- ---------------------------------------------------------------------------
-- Transformator monitoring helpers
-- ---------------------------------------------------------------------------

--- Ensure transformator pumps never use circuit-driven "Set filter".
---
--- This mod owns the pump fluid filter as part of transformator state, so the
--- pump's circuit "Set filter" option must stay disabled. If a player enables
--- it, the setting is reverted and the expected managed filter is restored.
--- @param transformator EgTransformator Stored transformator state.
--- @return nil
local function enforce_transformator_pump_filter_mode(transformator)
    local pump = transformator.pump
    if not (pump and pump.valid) then
        return
    end

    local cb = pump.get_control_behavior()
    if not cb then
        return
    end

    --- @cast cb LuaPumpControlBehavior
    if cb.set_filter then
        cb.set_filter = false

        local tier = get_transformator_tier(transformator)
        if tier then
            local expected_filter = transformator.pump_was_disabled
                and constants.DISABLED_FLUID
                or ("eg-water-" .. tier)

            pump.clear_fluid_inside()
            pump.fluidbox.set_filter(1, { name = expected_filter })
        end
    end
end

--- React to a pump being disabled through circuit control.
---
--- Only the transition from enabled -> disabled matters. When the pump is
--- disabled, buffered fluid is cleared and the boiler/steam-engine pair is
--- refreshed so their tiered prototypes match the transformator state.
---
--- @param transformator EgTransformator Stored transformator state.
--- @return nil
local function check_pump_disabled(transformator)
    local pump = transformator.pump
    if not (pump and pump.valid) then
        return
    end

    enforce_transformator_pump_filter_mode(transformator)

    local cb = pump.get_control_behavior()

    -- LuaLS sees `get_control_behavior()` as a broad union type, so these
    -- pump-specific fields need explicit diagnostic suppression.
    --- @diagnostic disable-next-line: undefined-field
    if not (cb and cb.circuit_enable_disable) then
        transformator.pump_was_disabled = false
        return
    end

    --- @diagnostic disable-next-line: undefined-field
    local disabled = cb.disabled
    local prev = transformator.pump_was_disabled

    if prev == nil then
        transformator.pump_was_disabled = disabled
        return
    end

    if not prev and disabled then
        transformator.pump_was_disabled = true
        pump.clear_fluid_inside()
        replace_tiered_components(transformator)
        return
    end

    transformator.pump_was_disabled = disabled
end

--- Resolve deferred manual copper-wire actions after vanilla wiring has settled.
---
--- The exact attempted `source <-> target` connection is validated first so an
--- overload or illegal pairing disconnects the newly created wire rather than a
--- nearby pre-existing one. After that, nearby poles are re-enforced silently
--- to restore network invariants without showing extra player feedback.
---
--- @return nil
local function process_pending_wire_cleanup()
    local pending = storage.eg_pending_wire_cleanup
    if not pending then return end

    for player_index, job in pairs(pending) do
        if job.tick and job.tick <= game.tick then
            local player = game.get_player(player_index)
            local source = job.source
            local target = job.target

            local allowed = true

            if source and source.valid and target and target.valid then
                allowed = enforce_specific_copper_connection(source, target, player, true) and allowed
            end

            if source and source.valid then
                allowed = enforce_pole_connections(source, player, false) and allowed
            end

            if target and target.valid then
                allowed = enforce_pole_connections(target, player, false) and allowed
            end

            local poles_to_check = {}

            if source and source.valid then
                local nearby_source_poles = get_nearby_poles(source)
                if nearby_source_poles then
                    for _, pole in pairs(nearby_source_poles) do
                        poles_to_check[pole.unit_number] = pole
                    end
                end
            end

            if target and target.valid then
                local nearby_target_poles = get_nearby_poles(target)
                if nearby_target_poles then
                    for _, pole in pairs(nearby_target_poles) do
                        poles_to_check[pole.unit_number] = pole
                    end
                end
            end

            for _, pole in pairs(poles_to_check) do
                enforce_pole_connections(pole, player, false)
            end

            if next(poles_to_check) then
                eg_schedule_short_circuit_check()
            end

            if not allowed and player and player.valid then
                player.clear_cursor()
                storage.eg_copper_wire_on_cursor[player_index] = nil
                storage.eg_wire_click_source[player_index] = nil
            end

            pending[player_index] = nil
        end
    end
end

--- Track changes to open transformator pump GUIs and close them when
--- circuit-control fluid transitions require the vanilla pump window to be
--- dismissed.
---
--- While a transformator pump GUI is open, this watches the current fluid
--- filter against the last observed value for each player. When the pump
--- leaves the disabled state or enters any managed control fluid, the tracked
--- GUI state is cleared and the player's opened entity is closed so the mod can
--- reassert the intended transformator UI flow.
--- @return nil
local function process_open_pump_gui_changes()
    local opened_filter_names = storage.eg_opened_pump_filter_name
    local opened_pump_unit_numbers = storage.eg_opened_pump_unit_number
    if not (opened_filter_names and opened_pump_unit_numbers) then return end

    for player_index, tracked_unit_number in pairs(opened_pump_unit_numbers) do
        if tracked_unit_number ~= nil then
            local player = game.get_player(player_index)

            if not (player and player.valid) then
                opened_filter_names[player_index] = nil
                opened_pump_unit_numbers[player_index] = nil
            else
                local opened_object = player.opened

                if not (opened_object and opened_object.valid and opened_object.object_name == "LuaEntity") then
                    opened_filter_names[player_index] = nil
                    opened_pump_unit_numbers[player_index] = nil
                else
                    --- @cast opened_object LuaEntity
                    local opened = opened_object

                    if not (is_transformator_pump(opened.name) and opened.unit_number == tracked_unit_number) then
                        opened_filter_names[player_index] = nil
                        opened_pump_unit_numbers[player_index] = nil
                    else
                        local current_filter_name = get_transformator_pump_filter_name(opened)
                        local previous_filter_name = opened_filter_names[player_index]

                        if current_filter_name ~= previous_filter_name then
                            local leaving_disabled = (previous_filter_name == constants.DISABLED_FLUID)
                            local entering_control_fluid = is_transformator_control_fluid(current_filter_name)

                            opened_filter_names[player_index] = current_filter_name

                            if leaving_disabled or entering_control_fluid then
                                opened_filter_names[player_index] = nil
                                opened_pump_unit_numbers[player_index] = nil
                                player.opened = nil
                            end
                        end
                    end
                end
            end
        end
    end
end

--- Run per-tick transformator maintenance.
---
--- This processes deferred copper-wire cleanup, watches open pump GUIs for
--- filter-state transitions, and incrementally scans tracked transformators so
--- pump disable transitions are handled over time without spiking work in a
--- single tick.
--- @return nil
local function on_tick_pump_checks()
    process_pending_wire_cleanup()
    process_open_pump_gui_changes()

    local keys = storage.eg_transformator_keys
    local count = keys and #keys or 0

    if count == 0 then
        storage.eg_transformator_scan_index = 1
        storage.eg_transformator_scan_accumulator = 0
        return
    end

    local index = storage.eg_transformator_scan_index or 1
    local accumulator = storage.eg_transformator_scan_accumulator or 0

    accumulator = accumulator + (count / 60)

    local budget = math.floor(accumulator)
    if budget < 1 then
        storage.eg_transformator_scan_accumulator = accumulator
        storage.eg_transformator_scan_index = index
        return
    end

    accumulator = accumulator - budget

    for _ = 1, budget do
        if count == 0 then break end

        if index > count then
            index = 1
        end

        local pump_unit_number = keys[index]
        local transformator = pump_unit_number and storage.eg_transformators[pump_unit_number] or nil

        if transformator then
            check_pump_disabled(transformator)
        end

        index = index + 1
    end

    if index > count then
        index = 1
    end

    storage.eg_transformator_scan_index = index
    storage.eg_transformator_scan_accumulator = accumulator
end

-- ---------------------------------------------------------------------------
-- Blueprint helpers
-- ---------------------------------------------------------------------------

--- Write transformator tier data into blueprint entity tags.
---
--- Only transformator root pump entities are tagged. This preserves the configured tier for
--- blueprint placement, copy, and cut/copy style flows without assuming the
--- mapping contains ghost entities.
--- @param event EventData.on_player_setup_blueprint
--- @return nil
local function on_player_setup_blueprint(event)
    local blueprint = event.stack or event.record
    if not blueprint then return end

    local lazy_mapping = event.mapping
    if not lazy_mapping then return end

    --- @diagnostic disable-next-line: assign-type-mismatch
    local mapping = lazy_mapping.get()
    if not mapping then return end

    --- @cast mapping table<uint, LuaEntity>

    for blueprint_entity_index, source_entity in pairs(mapping) do
        --- @cast blueprint_entity_index uint
        --- @cast source_entity LuaEntity

        if source_entity.valid and is_transformator_pump(source_entity.name) then
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
-- Entity lifecycle handlers
-- ---------------------------------------------------------------------------

--- Handle all build-like events that can create Electric Grid entities.
---
--- Transformator builds may originate from a placed pump, a transformator item,
--- or a displayer proxy. `eg_transformator_built()` returns the root pump when
--- one exists so any blueprint-stored tier tag can be restored onto the final
--- transformator after reconstruction.
--- @param event EventData.on_built_entity
--- | EventData.on_robot_built_entity
--- | EventData.on_space_platform_built_entity
--- | EventData.on_entity_cloned
--- | EventData.script_raised_revive
--- | EventData.script_raised_built
--- @return nil
local function on_entity_built(event)
    local entity = event.entity or event.destination
    if not (entity and entity.valid) then return end

    local player = event.player_index and game.get_player(event.player_index) or nil

    if entity.name == "eg-ugp-substation-displayer" then
        job_queue.schedule(game.tick + 1, "replace_displayer_with_ugp_substation", {
            unit_number = entity.unit_number
        })
        return
    end

    if is_transformator(entity.name) then
        local built_root = eg_transformator_built(entity, event.player_index)
        apply_transformator_blueprint_tier(built_root or entity, event.tags)
        return
    end

    if entity.type == "electric-pole" then
        local poles = get_nearby_poles(entity)
        if poles then
            for _, pole in pairs(poles) do
                enforce_pole_connections(pole, player, false, false)
            end
        end

        if not is_transformator_overload_allowed() then
            schedule_built_pole_overload_check(entity, event.player_index)
        end
        eg_schedule_short_circuit_check()
    end
end

--- Handle removal/destruction of transformator pieces and electric poles.
--- @param event EventData.on_player_mined_entity|EventData.on_robot_mined_entity|EventData.on_space_platform_mined_entity|EventData.on_entity_died|EventData.script_raised_destroy
--- @return nil
local function on_entity_mined(event)
    local entity = event.entity
    if not (entity and entity.valid) then return end

    local player = event.player_index and game.get_player(event.player_index) or nil

    if is_transformator(entity.name) then
        local transformator = get_transformator_by_entity(entity)
        if transformator and transformator.pump and transformator.pump.unit_number then
            remove_transformator(transformator.pump.unit_number)
        end
        return
    end

    if entity.type == "electric-pole" then
        local pole_key = get_electric_pole_storage_key(entity.surface.index, entity.name, entity.position)
        local skip_cleanup = false
        if pole_key
            and storage.eg_skip_pole_cleanup_on_mined
            and storage.eg_skip_pole_cleanup_on_mined[pole_key]
        then
            storage.eg_skip_pole_cleanup_on_mined[pole_key] = nil
            skip_cleanup = true
        end

        if not skip_cleanup then
            local poles = get_nearby_poles(entity)
            if poles then
                for _, pole in pairs(poles) do
                    enforce_pole_connections(pole, player, false)
                end
            end
        end
        eg_schedule_short_circuit_check()
    end
end

--- Rebuild transformator dependents after a player rotates the root pump.
---
--- The root pump is first rotated by the engine in place, then relocated so the
--- whole transformator rotates about its center.
--- @param event EventData.on_player_rotated_entity
--- @return nil
local function on_player_rotated_entity(event)
    local entity = event.entity
    if not (entity and entity.valid and is_transformator_pump(entity.name)) then return end

    local success = rebuild_transformator_dependents_from_pump(entity, event.previous_direction)
    if success then return end

    local previous_direction = event.previous_direction or entity.direction
    local old_pump_offset = rotate_position(constants.EG_ENTITY_OFFSETS.pump, previous_direction)
    local transformator_position = {
        x = entity.position.x - old_pump_offset.x,
        y = entity.position.y - old_pump_offset.y
    }

    local player = game.get_player(event.player_index)

    if player and player.valid then
        player.play_sound { path = "utility/cannot_build", position = player.position, volume = 1 }
        player.create_local_flying_text {
            text = { "eg.eg-rotation-blocked" },
            position = transformator_position,
            surface = entity.surface
        }
    end
end

--- Restrict special script-raised build handling to proxy pole entities that
--- need the normal build path.
--- @param event EventData.script_raised_built|EventData.script_raised_revive
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

    storage.eg_wire_click_source = storage.eg_wire_click_source or {}

    if cursor_stack and cursor_stack.valid_for_read and cursor_stack.name == "copper-wire" then
        storage.eg_copper_wire_on_cursor[player.index] = true
    else
        storage.eg_copper_wire_on_cursor[player.index] = nil
        storage.eg_wire_click_source[event.player_index] = nil
    end

    if not (cursor_stack and cursor_stack.valid_for_read) then
        storage.eg_transformator_to_build[player.index] = nil
    end
end

--- Remember the currently selected transformator entity or displayer when the
--- player uses pipette, so later placement can inherit the intended
--- transformator tier or prototype choice.
--- @param event EventData.on_player_pipette
--- @return nil
local function on_entity_pipetted(event)
    local player = game.get_player(event.player_index)
    if not player then return end

    local selected = player.selected
    if not (selected and selected.valid and is_transformator(selected.name)) then return end

    if is_transformator_pump(selected.name) then
        local transformator = get_transformator_by_entity(selected)
        local tier = get_transformator_tier(transformator)
        if tier then
            storage.eg_transformator_to_build[player.index] = tier
            return
        end
    end

    storage.eg_transformator_to_build[player.index] = selected.name
end


-- ---------------------------------------------------------------------------
-- GUI helpers
-- ---------------------------------------------------------------------------


--- Open or refresh the relative transformator rating GUI when the player opens
--- a transformator pump.
--- @param event EventData.on_gui_opened
--- @return nil
local function on_gui_opened(event)
    local player = game.get_player(event.player_index)
    if not player or not player.valid then return end

    storage.eg_opened_pump_filter_name = storage.eg_opened_pump_filter_name or {}
    storage.eg_opened_pump_unit_number = storage.eg_opened_pump_unit_number or {}

    local entity = event.entity
    if entity and entity.valid and is_transformator_pump(entity.name) then
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

        add_rating_radio_buttons(frame, current_rating)
        storage.eg_selected_transformator[player.index] = transformator
        storage.eg_opened_pump_filter_name[player.index] = get_transformator_pump_filter_name(entity)
        storage.eg_opened_pump_unit_number[player.index] = entity.unit_number
        return
    end

    if player.gui.relative.eg_transformator_rating_relative_frame then
        storage.eg_opened_pump_filter_name[player.index] = nil
        storage.eg_opened_pump_unit_number[player.index] = nil
        close_transformator_gui(player)
    end
end

--- Handle the relative transformator rating GUI being closed.
---
--- When a pump GUI closes, this also restores the pump's expected filter state
--- and refreshes tiered components if the disabled control fluid was selected.
--- @param event EventData.on_gui_closed
--- @return nil
local function on_gui_closed(event)
    local player = game.get_player(event.player_index)
    if not player or not player.valid then return end

    if event.element and event.element.name == "eg_transformator_rating_relative_frame" then
        storage.eg_selected_transformator[player.index] = nil
        storage.eg_opened_pump_filter_name[player.index] = nil
        storage.eg_opened_pump_unit_number[player.index] = nil
        close_transformator_gui(player)
        return
    end

    local entity = event.entity
    if entity and entity.valid and is_transformator_pump(entity.name) then
        local transformator = find_transformator_by_pump(entity)
        if transformator then
            enforce_transformator_pump_filter_mode(transformator)

            local pump = transformator.pump
            if pump and pump.valid then
                local filter = pump.fluidbox.get_filter(1)
                if filter and filter.name then
                    local tier = transformator.tier
                    if tier then
                        if filter.name == constants.DISABLED_FLUID then
                            transformator.pump_was_disabled = true
                            pump.clear_fluid_inside()
                            replace_tiered_components(transformator)
                            pump.fluidbox.set_filter(1, { name = constants.DISABLED_FLUID })
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
        storage.eg_opened_pump_filter_name[player.index] = nil
        storage.eg_opened_pump_unit_number[player.index] = nil
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
end

--- Handle rating radio button changes for the relative GUI.
--- @param event EventData.on_gui_checked_state_changed
--- @return nil
local function on_rating_radio_checked_state_changed(event)
    local element = event.element
    if not (element and element.valid) then return end
    if element.type ~= "radiobutton" then return end
    if not string.find(element.name, "^eg_relative_rating_radio_") then return end

    local player = game.get_player(event.player_index)
    if not player or not player.valid then return end

    if not element.state then return end

    local parent = element.parent
    if parent and parent.valid then
        for _, child in pairs(parent.children) do
            if child.valid and child.type == "radiobutton" and child ~= element and child.state then
                child.state = false
            end
        end
    end

    local transformator = storage.eg_selected_transformator[player.index]
    if not transformator then return end
    if not (transformator.pump and transformator.pump.valid) then
        close_transformator_gui(player)
        return
    end

    local selected_rating = element.tags and element.tags.eg_relative_rating
    if type(selected_rating) ~= "string" then return end

    local current_rating = get_current_transformator_rating(transformator)
    if not current_rating then return end
    if selected_rating == current_rating then return end

    local replacement = replace_transformator(transformator, selected_rating)
    if not replacement then
        close_transformator_gui(player)
        return
    end

    storage.eg_selected_transformator[player.index] = replacement
    storage.eg_opened_pump_filter_name[player.index] = get_transformator_pump_filter_name(replacement.pump)
    storage.eg_opened_pump_unit_number[player.index] = replacement.pump and replacement.pump.unit_number or nil
end


-- ---------------------------------------------------------------------------
-- Scheduled job helpers
-- ---------------------------------------------------------------------------

--- Process queued delayed jobs due on the current scheduler bucket tick.
--- @param event { tick: uint }
--- @return nil
local function on_periodic_tick(event)
    job_queue.process(event.tick)
end

--- Register nth-tick handlers used by the job queue.
--- @return nil
local function register_nth_tick_handlers()
    script.on_nth_tick(constants.EG_TICK_INTERVAL, on_periodic_tick)
end

--- Handle custom copper-wire build input.
---
--- Implements a two-click state machine:
--- 1. First click stores the source pole
--- 2. Second click queues a deferred validation job
---
--- Validation and disconnection occur on the next tick via
--- `process_pending_wire_cleanup()` to ensure vanilla wiring has completed.
--- Player-facing flying text is only shown for this manual-wire path; build,
--- mining, and topology cleanup rechecks remain silent.
---
--- @param event { player_index: uint }
--- @return nil
local function on_wire_build(event)
    local player = game.get_player(event.player_index)
    if not player then return end

    if player:is_cursor_empty()
        or not player.cursor_stack
        or not player.cursor_stack.valid_for_read
        or player.cursor_stack.name ~= "copper-wire"
        or not player.selected
        or not player.selected.valid
        or player.selected.type ~= "electric-pole"
    then
        return
    end

    storage.eg_wire_click_source = storage.eg_wire_click_source or {}
    storage.eg_pending_wire_cleanup = storage.eg_pending_wire_cleanup or {}

    local player_index = event.player_index

    --- @type LuaEntity
    local selected = player.selected

    --- @type LuaEntity?
    local previous = storage.eg_wire_click_source[player_index]

    if previous and not previous.valid then
        previous = nil
        storage.eg_wire_click_source[player_index] = nil
    end

    if not previous then
        storage.eg_wire_click_source[player_index] = selected
        return
    end

    storage.eg_pending_wire_cleanup[player_index] = {
        source = previous,
        target = selected,
        tick = game.tick + 1
    }

    storage.eg_wire_click_source[player_index] = nil
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
    script.on_event("eg-wire-build", on_wire_build)


    script.on_event(defines.events.on_gui_opened, on_gui_opened)
    script.on_event(defines.events.on_gui_checked_state_changed, on_rating_radio_checked_state_changed)
    script.on_event(defines.events.on_gui_click, on_gui_click)
    script.on_event(defines.events.on_gui_closed, on_gui_closed)
end

script.on_init(function()
    initialize_globals()
    job_queue.init()
    job_queue.register_function("replace_displayer_with_ugp_substation", replace_displayer_with_ugp_substation)
    job_queue.register_function("short_circuit_check", short_circuit_check)
    job_queue.register_function("validate_built_pole_overload", validate_built_pole_overload)
    sync_transformator_keys()
    register_nth_tick_handlers()
    edp_blacklist()
    register_event_handlers()
end)

script.on_load(function()
    job_queue.register_function("replace_displayer_with_ugp_substation", replace_displayer_with_ugp_substation)
    job_queue.register_function("short_circuit_check", short_circuit_check)
    job_queue.register_function("validate_built_pole_overload", validate_built_pole_overload)
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
    job_queue.register_function("validate_built_pole_overload", validate_built_pole_overload)
    normalize_transformator_pumps_to_tier()
    sync_transformator_keys()
    reset_short_circuit_alert_state()
    short_circuit_check()
    register_nth_tick_handlers()
    register_event_handlers()
end)
