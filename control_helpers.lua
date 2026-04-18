-- Shared runtime helpers for Electric Grid.
--
-- This file exposes the helper API used by `control.lua`. Functions are defined
-- globally because the mod loads this file with `require("control_helpers")` and
-- then calls the helpers directly from the control script.
--
-- Broadly, these helpers cover:
--   * transformator lookup and storage synchronization
--   * transformator build / rebuild / replacement operations
--   * electric pole connection enforcement and short-circuit detection
--   * transformator GUI construction helpers

--- @class EgTransformator
--- @field boiler LuaEntity?
--- @field pump LuaEntity?
--- @field infinity_pipe LuaEntity?
--- @field steam_engine LuaEntity?
--- @field high_voltage LuaEntity?
--- @field low_voltage LuaEntity?
--- @field alert_tick uint
--- @field tier integer?
--- @field pump_was_disabled boolean?

-- ---------------------------------------------------------------------------
-- Transformator lookup and synchronization
-- ---------------------------------------------------------------------------

--- Fetch a stored transformator by its root pump unit number.
--- @param pump_unit_number uint?
--- @return EgTransformator? transformator
function get_transformator_by_pump_unit_number(pump_unit_number)
    if not pump_unit_number then return nil end
    return storage.eg_transformators[pump_unit_number]
end

--- Resolve any tracked transformator component back to the owning transformator.
--- @param entity LuaEntity? Any tracked transformator entity.
--- @return EgTransformator? transformator
function get_transformator_by_entity(entity)
    if not (entity and entity.valid and entity.unit_number) then return nil end

    local pump_unit_number = storage.eg_entity_to_transformator
        and storage.eg_entity_to_transformator[entity.unit_number]

    if not pump_unit_number then return nil end
    return storage.eg_transformators[pump_unit_number]
end

--- Rebuild cached transformator indexes derived from runtime storage.
---
--- This refreshes:
--- - the transformator pump-unit key list
--- - the entity-to-transformator lookup index
---
--- This should be called after any operation that creates, destroys, rotates,
--- or replaces tracked transformator components.
--- @return nil
function sync_transformator_keys()
    if not storage then return end
    if not storage.eg_transformators then return end
    if storage.eg_transformator_keys == nil then return end

    local keys = {}
    local entity_to_transformator = {}

    for pump_unit_number, transformator in pairs(storage.eg_transformators) do
        keys[#keys + 1] = pump_unit_number

        local entities = {
            transformator.pump,
            transformator.high_voltage,
            transformator.low_voltage
        }

        for _, entity in pairs(entities) do
            if entity and entity.valid and entity.unit_number then
                entity_to_transformator[entity.unit_number] = pump_unit_number
            end
        end
    end

    storage.eg_transformator_keys = keys
    storage.eg_entity_to_transformator = entity_to_transformator

    storage.eg_transformator_scan_index = storage.eg_transformator_scan_index or 1
    storage.eg_transformator_scan_accumulator = storage.eg_transformator_scan_accumulator or 0

    if storage.eg_transformator_scan_index > #storage.eg_transformator_keys then
        storage.eg_transformator_scan_index = 1
    end
end

-- ---------------------------------------------------------------------------
-- Transformator lifecycle helpers
-- ---------------------------------------------------------------------------



--- Destroy an entire transformator, including its root pump, and remove it from
--- persistent storage.
--- @param pump_unit_number uint Root pump unit number.
--- @return nil
function remove_transformator(pump_unit_number)
    --- @type EgTransformator?
    local eg_transformator = storage.eg_transformators[pump_unit_number]
    if not eg_transformator then return end

    if eg_transformator.boiler and eg_transformator.boiler.valid then eg_transformator.boiler.destroy() end
    if eg_transformator.pump and eg_transformator.pump.valid then eg_transformator.pump.destroy() end
    if eg_transformator.infinity_pipe and eg_transformator.infinity_pipe.valid then
        eg_transformator.infinity_pipe.destroy()
    end
    if eg_transformator.steam_engine and eg_transformator.steam_engine.valid then eg_transformator.steam_engine.destroy() end
    if eg_transformator.high_voltage and eg_transformator.high_voltage.valid then eg_transformator.high_voltage.destroy() end
    if eg_transformator.low_voltage and eg_transformator.low_voltage.valid then eg_transformator.low_voltage.destroy() end

    storage.eg_transformators[pump_unit_number] = nil
    sync_transformator_keys()
end

--- Check whether a stored transformator is fully intact.
---
--- All tracked component entities must exist and be valid.
--- @param pump_unit_number uint Root pump unit number.
--- @return boolean is_valid
function is_transformator_valid(pump_unit_number)
    --- @type EgTransformator?
    local eg_transformator = storage.eg_transformators[pump_unit_number]
    if not eg_transformator then return false end

    if not (eg_transformator.pump and eg_transformator.pump.valid) then return false end
    if not (eg_transformator.boiler and eg_transformator.boiler.valid) then return false end
    if not (eg_transformator.infinity_pipe and eg_transformator.infinity_pipe.valid) then return false end
    if not (eg_transformator.steam_engine and eg_transformator.steam_engine.valid) then return false end
    if not (eg_transformator.high_voltage and eg_transformator.high_voltage.valid) then return false end
    if not (eg_transformator.low_voltage and eg_transformator.low_voltage.valid) then return false end

    return true
end

--- Derive a transformator tier from cached state or component prototype names.
--- @param transformator EgTransformator|LuaEntity|nil
--- @return integer? tier
function get_transformator_tier(transformator)
    if not transformator then return nil end

    if transformator.tier then
        return tonumber(transformator.tier)
    end

    if transformator.pump and transformator.pump.valid and transformator.pump.name then
        local tier = transformator.pump.name:match("^eg%-pump%-(%d+)$")
        if tier then return tonumber(tier) end
        if transformator.pump.name == "eg-pump" then return 1 end
    end

    if transformator.boiler and transformator.boiler.valid and transformator.boiler.name then
        local tier = transformator.boiler.name:match("^eg%-boiler%-(%d+)$")
        if tier then return tonumber(tier) end
    end

    if transformator.steam_engine and transformator.steam_engine.valid and transformator.steam_engine.name then
        local tier = transformator.steam_engine.name:match("^eg%-steam%-engine%-%a+%-(%d+)$")
        if tier then return tonumber(tier) end
    end

    return nil
end

--- Check whether an entity or item name is a transformator root pump.
--- @param name string?
--- @return boolean is_pump
function is_transformator_pump(name)
    return type(name) == "string"
        and (name == "eg-pump" or name:match("^eg%-pump%-%d+$") ~= nil)
end

--- Return the canonical transformator pump prototype name for a tier.
--- The legacy `eg-pump` name is still recognized for migration, but all new
--- and replaced transformators use the numbered pump names.
--- @param tier integer|string|nil
--- @return string pump_name
function get_transformator_pump_name(tier)
    local pump_tier = tonumber(tier) or 1
    return "eg-pump-" .. pump_tier
end

--- Normalize the steam-engine facing used by the transformator layout.
--- @param direction defines.direction
--- @return defines.direction steam_engine_direction
function get_steam_engine_direction(direction)
    if direction == defines.direction.east or direction == defines.direction.west then
        return defines.direction.east
    end
    return defines.direction.north
end

--- Return the steam-engine variant suffix used for the given direction.
--- @param direction defines.direction
--- @return string variant Either `"ne"` or `"sw"`.
function get_steam_engine_variant(direction)
    if direction == defines.direction.south or direction == defines.direction.west then
        return "sw"
    end
    return "ne"
end

--- Rotate a local offset around the transformator origin.
---
--- This helper is intentionally limited to the four cardinal directions used by
--- the mod's transformator layout.
--- @param position MapPosition Relative position to rotate.
--- @param direction defines.direction Cardinal direction.
--- @return MapPosition rotated_position
function rotate_position(position, direction)
    local rotation_matrices = {
        [defines.direction.north] = { { 1, 0 }, { 0, 1 } },
        [defines.direction.east]  = { { 0, -1 }, { 1, 0 } },
        [defines.direction.south] = { { -1, 0 }, { 0, -1 } },
        [defines.direction.west]  = { { 0, 1 }, { -1, 0 } }
    }
    local matrix = rotation_matrices[direction]
    local x = position.x * matrix[1][1] + position.y * matrix[1][2]
    local y = position.x * matrix[2][1] + position.y * matrix[2][2]
    return { x = x, y = y }
end

--- Check whether an entity or item name belongs to the transformator family.
--- @param name string?
--- @return boolean is_transformator_name
function is_transformator(name)
    return is_transformator_pump(name)
        or name == "eg-transformator-displayer"
        or (type(name) == "string" and name:match("^eg%-boiler%-%d+$") ~= nil)
        or (type(name) == "string" and name:match("^eg%-steam%-engine%-%a+%-%d+$") ~= nil)
end

--- Fetch a stored transformator directly from a root pump entity.
--- @param pump LuaEntity?
--- @return EgTransformator? transformator
function find_transformator_by_pump(pump)
    if not (pump and pump.valid and pump.unit_number) then return nil end
    return storage.eg_transformators[pump.unit_number]
end

-- ---------------------------------------------------------------------------
-- Transformator component replacement helpers
-- ---------------------------------------------------------------------------

--- Recreate only the tiered boiler and steam-engine components in-place.
---
--- Used when the pump disable state requires refreshing tiered prototypes while
--- preserving the rest of the transformator.
--- @param transformator EgTransformator
--- @return nil
function replace_tiered_components(transformator)
    if not (transformator.pump and transformator.pump.valid) then return end

    local tier = get_transformator_tier(transformator)
    if not tier then return end

    local force = transformator.pump.force
    local surface = transformator.pump.surface
    local pump_unit_number = transformator.pump.unit_number
    if not pump_unit_number then return end

    --- @type EgTransformator?
    local eg_transformator = storage.eg_transformators[pump_unit_number]
    if not eg_transformator then
        log("Error: Transformator with pump unit_number " .. pump_unit_number .. " not found.")
        return
    end

    local old_boiler = eg_transformator.boiler
    local old_steam_engine = eg_transformator.steam_engine
    if not (old_boiler and old_boiler.valid) then return end
    if not (old_steam_engine and old_steam_engine.valid) then return end

    local boiler_direction = old_boiler.direction
    local boiler_position = old_boiler.position
    old_boiler.destroy()

    local eg_boiler = surface.create_entity {
        name = "eg-boiler-" .. tier,
        position = boiler_position,
        force = force,
        direction = boiler_direction,
        create_build_effect_smoke = false
    }

    local steam_engine_direction = old_steam_engine.direction
    local steam_engine_position = old_steam_engine.position
    old_steam_engine.destroy()

    local eg_steam_engine = surface.create_entity {
        name = "eg-steam-engine-" .. get_steam_engine_variant(steam_engine_direction) .. "-" .. tier,
        position = steam_engine_position,
        force = force,
        direction = steam_engine_direction,
        create_build_effect_smoke = false
    }

    eg_transformator.boiler = eg_boiler
    eg_transformator.steam_engine = eg_steam_engine
    sync_transformator_keys()
end

--- Translate a transformator tier into the configured rating string.
--- @param tier integer|string|nil
--- @return string|nil rating
function get_transformator_rating_for_tier(tier)
    if not tier then return nil end
    local spec = constants.EG_TRANSFORMATORS[tonumber(tier)]
    return spec and spec.rating or nil
end

--- Apply a blueprint-stored tier to a transformator after it is built.
---
--- This must be called after `eg_transformator_built(...)`, using the returned
--- root pump entity when available.
---
--- Behavior:
--- - Reads the tier from `tags[constants.EG_BLUEPRINT_TIER_TAG]`
--- - Compares against the current transformator tier
--- - Replaces the transformator if the tiers differ
---
--- Safe to call with nil or invalid entities.
---
--- @param entity LuaEntity|nil Root pump entity (`eg-pump` / `eg-pump-<tier>`)
--- @param tags table|nil Blueprint tags from the build event
--- @return nil
function apply_transformator_blueprint_tier(entity, tags)
    if not (entity and entity.valid and is_transformator_pump(entity.name)) then return end
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

--- Build or rebuild a transformator from a placed entity.
---
--- This function ensures that the full transformator structure is created
--- around the root pump entity and registers it in runtime storage.
---
--- Returns the root transformator pump entity for the transformator. This return value
--- is used by blueprint-tier restoration code to apply stored tier metadata to
--- the correct final entity, even when the original built entity was a
--- displayer or item placeholder.
---
--- @param entity LuaEntity The entity that triggered transformator creation.
--- @param player_index uint|nil Optional acting player index for placement intent.
--- @return LuaEntity? root_pump
function eg_transformator_built(entity, player_index)
    if not entity or not entity.name then return nil end
    if not is_transformator(entity.name) then return nil end

    local surface = entity.surface
    local force = entity.force
    local position = entity.position
    local direction = entity.direction

    local transformator_position = { x = position.x, y = position.y }
    local tier
    --- @type LuaEntity?
    local eg_pump = nil

    if entity.name == "eg-transformator-displayer" then
        tier = "1"
        entity.destroy()
    elseif is_transformator_pump(entity.name) then
        local pump_offset = rotate_position(constants.EG_ENTITY_OFFSETS.pump, direction)
        transformator_position = {
            x = position.x - pump_offset.x,
            y = position.y - pump_offset.y
        }

        local filter = entity.fluidbox and entity.fluidbox.get_filter(1)
        if filter and filter.name then
            tier = filter.name:match("^eg%-water%-(%d+)$")
        end

        eg_pump = entity
    else
        tier = entity.name:match("(%d+)$")
        entity.destroy()
    end

    local transformator_to_build = player_index
        and storage.eg_transformator_to_build
        and storage.eg_transformator_to_build[player_index]
        or nil
    if tonumber(transformator_to_build) then
        tier = tostring(transformator_to_build)
    end

    tier = tier or "1"

    local function position_from_offset(offset)
        local rotated_offset = rotate_position(offset, direction)
        return {
            x = transformator_position.x + rotated_offset.x,
            y = transformator_position.y + rotated_offset.y
        }
    end

    local eg_boiler = surface.create_entity {
        name = "eg-boiler-" .. tier,
        position = position_from_offset(constants.EG_ENTITY_OFFSETS.boiler),
        force = force,
        direction = direction,
        create_build_effect_smoke = false
    }

    if not eg_pump then
        eg_pump = surface.create_entity {
            name = get_transformator_pump_name(tier),
            position = position_from_offset(constants.EG_ENTITY_OFFSETS.pump),
            force = force,
            direction = direction,
            create_build_effect_smoke = false
        }
    end

    local eg_infinity_pipe = surface.create_entity {
        name = "eg-infinity-pipe",
        position = position_from_offset(constants.EG_ENTITY_OFFSETS.infinity_pipe),
        force = force,
        direction = direction,
        create_build_effect_smoke = false
    }
    local steam_engine_direction = get_steam_engine_direction(direction)

    local eg_steam_engine = surface.create_entity {
        name = "eg-steam-engine-" .. get_steam_engine_variant(direction) .. "-" .. tier,
        position = position_from_offset(constants.EG_ENTITY_OFFSETS.steam_engine),
        force = force,
        direction = steam_engine_direction,
        create_build_effect_smoke = false
    }

    local eg_high_voltage_pole = surface.create_entity {
        name = "eg-high-voltage-pole-" .. direction,
        position = position_from_offset(constants.EG_ENTITY_OFFSETS.high_voltage_pole),
        force = force,
        direction = direction,
        create_build_effect_smoke = false
    }

    local eg_low_voltage_pole = surface.create_entity {
        name = "eg-low-voltage-pole-" .. direction,
        position = position_from_offset(constants.EG_ENTITY_OFFSETS.low_voltage_pole),
        force = force,
        direction = direction,
        create_build_effect_smoke = false
    }

    if eg_infinity_pipe then
        eg_infinity_pipe.set_infinity_pipe_filter {
            name = "eg-water-" .. tier,
            percentage = 1,
            temperature = 15,
            mode = "at-least"
        }
    end

    if eg_pump and eg_pump.unit_number then
        --- @type EgTransformator
        local transformator = {
            boiler = eg_boiler,
            pump = eg_pump,
            infinity_pipe = eg_infinity_pipe,
            steam_engine = eg_steam_engine,
            high_voltage = eg_high_voltage_pole,
            low_voltage = eg_low_voltage_pole,
            alert_tick = 0,
            tier = tonumber(tier),
            pump_was_disabled = false
        }
        storage.eg_transformators[eg_pump.unit_number] = transformator
    end

    sync_transformator_keys()
    return eg_pump
end

--- Enforce overload rules after a transformator rating change.
---
--- If the replacement would leave the high-voltage side overloaded, all copper
--- connections on the transformator's HV pole are disconnected.
--- @param transformator EgTransformator
--- @return nil
function enforce_overload_after_rating_change(transformator)
    if is_transformator_overload_allowed() then return end
    if not transformator then return end

    local high_voltage = transformator.high_voltage
    if not (high_voltage and high_voltage.valid) then return end

    if is_high_voltage_connection_overloaded(high_voltage) then
        local connectors = high_voltage.get_wire_connectors(false)
        if not connectors then return end

        for _, connector in pairs(connectors) do
            if connector.wire_type == defines.wire_type.copper then
                for _, connection in pairs(connector.connections) do
                    connector.disconnect_from(connection.target)
                end
            end
        end
    end
end

--- Capture all real circuit-wire connections from a transformator pump.
--- @param pump LuaEntity
--- @return table[] connections
local function snapshot_pump_circuit_connections(pump)
    local snapshots = {}
    local seen = {}
    local connectors = pump.get_wire_connectors(false)
    if not connectors then return snapshots end

    for _, connector in pairs(connectors) do
        if connector.valid and connector.wire_type ~= defines.wire_type.copper then
            for _, connection in pairs(connector.real_connections or {}) do
                local target = connection.target
                if target and target.valid and target.owner and target.owner.valid then
                    local key = table.concat({
                        tostring(connector.wire_connector_id),
                        tostring(target.owner.unit_number or target.owner.name),
                        tostring(target.wire_connector_id),
                        tostring(connector.wire_type)
                    }, ":")

                    if not seen[key] then
                        seen[key] = true
                        snapshots[#snapshots + 1] = {
                            source_id = connector.wire_connector_id,
                            target = target,
                            target_entity = target.owner,
                            target_id = target.wire_connector_id,
                            wire_type = connector.wire_type,
                            origin = connection.origin or defines.wire_origin.player
                        }
                    end
                end
            end
        end
    end

    return snapshots
end

--- Snapshot runtime circuit-control settings from a transformator pump so
--- they can be restored after replacement.
--- @param pump LuaEntity
--- @return table settings
local function snapshot_pump_control_behavior(pump)
    local defaults = {
        circuit_enable_disable = false,
        connect_to_logistic_network = true,
        circuit_condition = nil,
        logistic_condition = nil
    }

    if not (pump and pump.valid) then return defaults end

    local cb = pump.get_control_behavior()
    if not cb then return defaults end

    --- @diagnostic disable-next-line: undefined-field
    defaults.circuit_enable_disable = cb.circuit_enable_disable
    --- @diagnostic disable-next-line: undefined-field
    defaults.connect_to_logistic_network = cb.connect_to_logistic_network
    --- @diagnostic disable-next-line: undefined-field
    defaults.circuit_condition = cb.circuit_condition
    --- @diagnostic disable-next-line: undefined-field
    defaults.logistic_condition = cb.logistic_condition
    return defaults
end

--- Apply previously captured circuit-control settings to a replacement
--- transformator pump.
--- @param target_pump LuaEntity
--- @param settings table
--- @return nil
local function apply_pump_control_behavior(target_pump, settings)
    if not (target_pump and target_pump.valid) then return end
    if not settings then return end

    local target_cb = target_pump.get_control_behavior()
    if not target_cb then return end

    --- @cast target_cb LuaPumpControlBehavior
    target_cb.set_filter = false
    target_cb.circuit_enable_disable = settings.circuit_enable_disable
    target_cb.connect_to_logistic_network = settings.connect_to_logistic_network
    target_cb.circuit_condition = settings.circuit_condition
    target_cb.logistic_condition = settings.logistic_condition
end

--- Restore captured circuit-wire connections onto a replacement transformator
--- pump.
--- @param pump LuaEntity
--- @param snapshots table[]
--- @return nil
local function restore_pump_circuit_connections(pump, snapshots)
    if not (pump and pump.valid) then return end
    if not snapshots then return end

    for _, snapshot in pairs(snapshots) do
        local target_entity = snapshot.target_entity
        if target_entity and target_entity.valid then
            local source_connector = pump.get_wire_connector(snapshot.source_id, true)
            local target_connector = target_entity.get_wire_connector(snapshot.target_id, true)
            if source_connector and source_connector.valid and target_connector and target_connector.valid then
                local origin = snapshot.origin or defines.wire_origin.player
                if not source_connector.is_connected_to(target_connector, origin) then
                    source_connector.connect_to(target_connector, true, origin)
                end
            end
        end
    end
end

--- Update any player-selected transformator references after replacement so
--- open GUIs continue targeting the new record.
--- @param old_transformator EgTransformator
--- @param replacement EgTransformator
--- @return nil
local function update_selected_transformator_references(old_transformator, replacement)
    if not (storage and storage.eg_selected_transformator) then return end

    for player_index, selected in pairs(storage.eg_selected_transformator) do
        if selected == old_transformator then
            storage.eg_selected_transformator[player_index] = replacement
        end
    end
end


--- Replace a transformator's tiered internals while preserving the root pump
--- and voltage poles.
---
--- The transformator's short-circuit alert state is reset because the tracked
--- tiered entities are recreated.
--- @param old_transformator EgTransformator?
--- @param new_rating string Requested rating string.
--- @return EgTransformator? replacement
function replace_transformator(old_transformator, new_rating)
    if not old_transformator then return nil end
    if not new_rating then return nil end

    local new_tier = 1
    for tier, specs in ipairs(constants.EG_TRANSFORMATORS) do
        if specs.rating == new_rating then
            new_tier = tier
            break
        end
    end
    if not new_tier then return nil end

    if not (old_transformator.pump and old_transformator.pump.valid) then return nil end

    local force = old_transformator.pump.force
    local surface = old_transformator.pump.surface
    local old_pump_unit_number = old_transformator.pump.unit_number
    if not old_pump_unit_number then return nil end

    --- @type EgTransformator?
    local eg_transformator = storage.eg_transformators[old_pump_unit_number]
    if not eg_transformator then return nil end

    local eg_high_voltage_pole = eg_transformator.high_voltage
    local eg_low_voltage_pole = eg_transformator.low_voltage
    local old_pump = eg_transformator.pump
    local old_boiler = eg_transformator.boiler
    local old_infinity_pipe = eg_transformator.infinity_pipe
    local old_steam_engine = eg_transformator.steam_engine

    if not (eg_high_voltage_pole and eg_high_voltage_pole.valid) then return nil end
    if not (eg_low_voltage_pole and eg_low_voltage_pole.valid) then return nil end
    if not (old_pump and old_pump.valid) then return nil end
    if not (old_boiler and old_boiler.valid) then return nil end
    if not (old_infinity_pipe and old_infinity_pipe.valid) then return nil end
    if not (old_steam_engine and old_steam_engine.valid) then return nil end

    local prior_pump_was_disabled = eg_transformator.pump_was_disabled
    local previous_alert_tick = eg_transformator.alert_tick or 0
    local old_pump_position = old_pump.position
    local old_pump_direction = old_pump.direction
    local old_pump_health = old_pump.health
    local old_pump_filter = old_pump.fluidbox.get_filter(1)
    local pump_connections = snapshot_pump_circuit_connections(old_pump)
    local pump_cb_settings = snapshot_pump_control_behavior(old_pump)

    local eg_boiler_position = old_boiler.position
    local eg_boiler_direction = old_boiler.direction
    old_boiler.destroy()

    local eg_infinity_pipe_position = old_infinity_pipe.position
    local eg_infinity_pipe_direction = old_infinity_pipe.direction
    old_infinity_pipe.destroy()

    local eg_steam_engine_position = old_steam_engine.position
    local current_engine_name = old_steam_engine.name
    local current_variant = current_engine_name:match("^eg%-steam%-engine%-(%a+)%-%d+$") or "ne"
    local eg_steam_engine_direction = get_steam_engine_direction(eg_boiler_direction)
    old_steam_engine.destroy()

    old_pump.destroy()

    local new_pump = surface.create_entity {
        name = get_transformator_pump_name(new_tier),
        position = old_pump_position,
        direction = old_pump_direction,
        force = force,
        create_build_effect_smoke = false
    }
    if not (new_pump and new_pump.valid) then return nil end

    if old_pump_health then
        new_pump.health = math.min(old_pump_health, new_pump.max_health)
    end

    local eg_boiler = surface.create_entity {
        name = "eg-boiler-" .. new_tier,
        position = eg_boiler_position,
        direction = eg_boiler_direction,
        force = force,
        create_build_effect_smoke = false
    }

    local new_infinity_pipe = surface.create_entity {
        name = "eg-infinity-pipe",
        position = eg_infinity_pipe_position,
        direction = eg_infinity_pipe_direction,
        force = force,
        create_build_effect_smoke = false
    }

    local eg_steam_engine = surface.create_entity {
        name = "eg-steam-engine-" .. current_variant .. "-" .. new_tier,
        position = eg_steam_engine_position,
        direction = eg_steam_engine_direction,
        force = force,
        create_build_effect_smoke = false
    }

    new_pump.clear_fluid_inside()
    if old_pump_filter and old_pump_filter.name then
        if old_pump_filter.name == constants.DISABLED_FLUID then
            new_pump.fluidbox.set_filter(1, { name = constants.DISABLED_FLUID })
        else
            new_pump.fluidbox.set_filter(1, { name = "eg-water-" .. new_tier })
        end
    else
        new_pump.fluidbox.set_filter(1, { name = "eg-water-" .. new_tier })
    end

    if new_infinity_pipe and new_infinity_pipe.valid then
        new_infinity_pipe.set_infinity_pipe_filter {
            name = "eg-water-" .. new_tier,
            percentage = 1,
            temperature = 15,
            mode = "at-least"
        }
    end

    restore_pump_circuit_connections(new_pump, pump_connections)
    apply_pump_control_behavior(new_pump, pump_cb_settings)

    --- @type EgTransformator
    local replacement = {
        boiler = eg_boiler,
        pump = new_pump,
        infinity_pipe = new_infinity_pipe,
        steam_engine = eg_steam_engine,
        high_voltage = eg_high_voltage_pole,
        low_voltage = eg_low_voltage_pole,
        alert_tick = previous_alert_tick,
        tier = new_tier,
        pump_was_disabled = prior_pump_was_disabled
    }

    storage.eg_transformators[old_pump_unit_number] = nil
    storage.eg_transformators[new_pump.unit_number] = replacement
    update_selected_transformator_references(old_transformator, replacement)
    sync_transformator_keys()
    enforce_overload_after_rating_change(replacement)

    return replacement
end

--- Destroy only the non-root transformator components.
---
--- Used by rotation rebuilds that keep the game-rotated pump as the stable
--- owner/root entity.
--- @param transformator EgTransformator
--- @return nil
function destroy_transformator_dependents(transformator)
    if transformator.boiler and transformator.boiler.valid then
        transformator.boiler.destroy()
        transformator.boiler = nil
    end
    if transformator.infinity_pipe and transformator.infinity_pipe.valid then
        transformator.infinity_pipe.destroy()
        transformator.infinity_pipe = nil
    end
    if transformator.steam_engine and transformator.steam_engine.valid then
        transformator.steam_engine.destroy()
        transformator.steam_engine = nil
    end
    if transformator.high_voltage and transformator.high_voltage.valid then
        transformator.high_voltage.destroy()
        transformator.high_voltage = nil
    end
    if transformator.low_voltage and transformator.low_voltage.valid then
        transformator.low_voltage.destroy()
        transformator.low_voltage = nil
    end
end

--- Check whether a rotated transformator can place its new electric poles.
---
--- This validates only the new pole positions needed by a center-axis rotation
--- and ignores the current transformator's own existing entities, because they
--- will be rebuilt as part of the rotation.
--- @param transformator EgTransformator
--- @param center MapPosition
--- @param direction defines.direction
--- @return boolean can_build
function can_rotate_transformator_poles(transformator, center, direction)
    if not (transformator.pump and transformator.pump.valid) then return false end

    local surface = transformator.pump.surface
    local force = transformator.pump.force

    local own_entities = {}
    for _, entity in pairs {
        transformator.pump,
        transformator.boiler,
        transformator.infinity_pipe,
        transformator.steam_engine,
        transformator.high_voltage,
        transformator.low_voltage
    } do
        if entity and entity.valid and entity.unit_number then
            own_entities[entity.unit_number] = true
        end
    end

    local function pos_from_offset(offset)
        local r = rotate_position(offset, direction)
        return {
            x = center.x + r.x,
            y = center.y + r.y
        }
    end

    local function can_place_pole(name, position)
        if surface.can_place_entity {
                name = name,
                position = position,
                direction = direction,
                force = force
            }
        then
            return true
        end

        local blockers = surface.find_entities_filtered {
            area = {
                { position.x - 0.6, position.y - 0.6 },
                { position.x + 0.6, position.y + 0.6 }
            }
        }

        for _, blocker in pairs(blockers) do
            if blocker.valid and blocker.unit_number and not own_entities[blocker.unit_number] then
                return false
            end
        end

        return true
    end

    local high_voltage_position = pos_from_offset(constants.EG_ENTITY_OFFSETS.high_voltage_pole)
    local low_voltage_position = pos_from_offset(constants.EG_ENTITY_OFFSETS.low_voltage_pole)

    if not can_place_pole("eg-high-voltage-pole-" .. direction, high_voltage_position) then
        return false
    end

    if not can_place_pole("eg-low-voltage-pole-" .. direction, low_voltage_position) then
        return false
    end

    return true
end

--- Rotate the full transformator about its geometric center.
---
--- The game rotates the root pump in place before the event fires. For this
--- multi-entity structure, the pump must then be relocated so that all four
--- internal 1x1 entities rotate about the transformator center rather than
--- about the pump's own tile.
---
--- After rebuilding dependents, pole connection rules are re-enforced and a
--- deferred short-circuit scan is scheduled.
--- @param pump LuaEntity Root pump that the game has already rotated.
--- @param previous_direction defines.direction? Direction before the engine rotation.
--- @return boolean success
function rebuild_transformator_dependents_from_pump(pump, previous_direction)
    if not (pump and pump.valid and is_transformator_pump(pump.name) and pump.unit_number) then
        return false
    end

    --- @type EgTransformator?
    local transformator = get_transformator_by_pump_unit_number(pump.unit_number)
    if not transformator then return false end

    local surface = pump.surface
    local force = pump.force
    local direction = pump.direction
    local tier = get_transformator_tier(transformator) or 1

    local old_direction = previous_direction or direction
    local old_pump_offset = rotate_position(constants.EG_ENTITY_OFFSETS.pump, old_direction)
    local transformator_position = {
        x = pump.position.x - old_pump_offset.x,
        y = pump.position.y - old_pump_offset.y
    }

    local function pos_from_offset(offset)
        local r = rotate_position(offset, direction)
        return {
            x = transformator_position.x + r.x,
            y = transformator_position.y + r.y
        }
    end

    local new_pump_position = pos_from_offset(constants.EG_ENTITY_OFFSETS.pump)

    if not can_rotate_transformator_poles(transformator, transformator_position, direction) then
        pump.direction = old_direction
        return false
    end

    if pump.position.x ~= new_pump_position.x or pump.position.y ~= new_pump_position.y then
        local teleported = pump.teleport(new_pump_position)
        if not teleported then
            pump.direction = old_direction
            return false
        end
    end

    destroy_transformator_dependents(transformator)

    local boiler = surface.create_entity {
        name = "eg-boiler-" .. tier,
        position = pos_from_offset(constants.EG_ENTITY_OFFSETS.boiler),
        force = force,
        direction = direction,
        create_build_effect_smoke = false
    }

    local infinity_pipe = surface.create_entity {
        name = "eg-infinity-pipe",
        position = pos_from_offset(constants.EG_ENTITY_OFFSETS.infinity_pipe),
        force = force,
        direction = direction,
        create_build_effect_smoke = false
    }

    local steam_engine_direction = get_steam_engine_direction(direction)
    local steam_engine = surface.create_entity {
        name = "eg-steam-engine-" .. get_steam_engine_variant(direction) .. "-" .. tier,
        position = pos_from_offset(constants.EG_ENTITY_OFFSETS.steam_engine),
        force = force,
        direction = steam_engine_direction,
        create_build_effect_smoke = false
    }

    local high_voltage = surface.create_entity {
        name = "eg-high-voltage-pole-" .. direction,
        position = pos_from_offset(constants.EG_ENTITY_OFFSETS.high_voltage_pole),
        force = force,
        direction = direction,
        create_build_effect_smoke = false
    }

    local low_voltage = surface.create_entity {
        name = "eg-low-voltage-pole-" .. direction,
        position = pos_from_offset(constants.EG_ENTITY_OFFSETS.low_voltage_pole),
        force = force,
        direction = direction,
        create_build_effect_smoke = false
    }

    if infinity_pipe then
        infinity_pipe.set_infinity_pipe_filter {
            name = "eg-water-" .. tier,
            percentage = 1,
            temperature = 15,
            mode = "at-least"
        }
    end

    transformator.pump = pump
    transformator.boiler = boiler
    transformator.infinity_pipe = infinity_pipe
    transformator.steam_engine = steam_engine
    transformator.high_voltage = high_voltage
    transformator.low_voltage = low_voltage
    transformator.tier = tonumber(tier)

    sync_transformator_keys()

    if high_voltage then
        enforce_pole_connections(high_voltage)
    end
    if low_voltage then
        enforce_pole_connections(low_voltage)
    end

    eg_schedule_short_circuit_check()

    return true
end

-- ---------------------------------------------------------------------------
-- Pole / wiring helpers
-- ---------------------------------------------------------------------------

--- Find nearby electric poles within copper wire reach of the given pole.
--- @param entity LuaEntity Pole whose nearby copper-wire neighborhood should be queried.
--- @return LuaEntity[]? poles
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
        type = "electric-pole"
    }
end

--- Remove any stored transformators whose component set has become invalid.
--- @return nil
function remove_invalid_transformators()
    local transformators = storage.eg_transformators
    local invalid_transformators = {}

    for pump_unit_number in pairs(transformators) do
        if not is_transformator_valid(pump_unit_number) then
            table.insert(invalid_transformators, pump_unit_number)
        end
    end

    for _, pump_unit_number in pairs(invalid_transformators) do
        log("Invalid transformator detected: " .. pump_unit_number)
        remove_transformator(pump_unit_number)
    end

    if #invalid_transformators > 0 then
        sync_transformator_keys()
    end
end

--- Reset cached short-circuit alert state for all stored transformators.
---
--- This is useful after migrations where the alert entity changed from the old
--- transformator unit to the pump root, because preserved `alert_tick` values
--- can suppress new alerts for migrated records.
--- @return nil
function reset_short_circuit_alert_state()
    if not (storage and storage.eg_transformators) then return end

    for _, transformator in pairs(storage.eg_transformators) do
        if transformator then
            transformator.alert_tick = 0
        end
    end
end

--- Ensure each stored transformator uses the tier-matching root pump prototype.
--- This upgrades older saves that only had the legacy `eg-pump` root entity.
--- @return nil
function normalize_transformator_pumps_to_tier()
    if not (storage and storage.eg_transformators) then return end

    local to_upgrade = {}
    for _, transformator in pairs(storage.eg_transformators) do
        if transformator and transformator.pump and transformator.pump.valid then
            local tier = get_transformator_tier(transformator)
            local expected_name = get_transformator_pump_name(tier)
            if tier and transformator.pump.name ~= expected_name then
                to_upgrade[#to_upgrade + 1] = transformator
            end
        end
    end

    for _, transformator in pairs(to_upgrade) do
        local rating = get_current_transformator_rating(transformator)
        if rating then
            replace_transformator(transformator, rating)
        end
    end
end

--- Check whether an entity is a transformator high-voltage pole.
--- @param entity LuaEntity?
--- @return boolean is_high_voltage_pole
function is_transformator_high_voltage_pole(entity)
    if not entity then return false end
    return entity.valid
        and entity.type == "electric-pole"
        and string.sub(entity.name, 1, 21) == "eg-high-voltage-pole-"
end

--- Check whether transformator overloads are allowed.
--- @return boolean
function is_transformator_overload_allowed()
    return settings.startup["eg-enable-transformator-overload"].value == true
end

--- Build a stable storage key for an electric pole using its surface, name,
--- and exact position.
--- @param surface_index uint?
--- @param name string?
--- @param position MapPosition?
--- @return string? key
function get_electric_pole_storage_key(surface_index, name, position)
    if not surface_index or not name or not position then return nil end
    return table.concat({
        tostring(surface_index),
        tostring(name),
        tostring(position.x),
        tostring(position.y)
    }, "|")
end

--- Resolve a transformator's configured rating in watts.
--- @param transformator EgTransformator|LuaEntity|nil
--- @return number rating_watts Zero when the tier cannot be resolved.
function get_transformator_rating_watts(transformator)
    local tier = get_transformator_tier(transformator)
    if not tier then return 0 end

    local specs = constants.EG_TRANSFORMATORS[tier]
    if not specs then return 0 end

    return specs.rating_watts or 0
end

--- Compute total transformator load and supply for a network.
---
--- Load: sum of ratings for transformator high-voltage poles on the network
---
--- Supply: sum of ratings for transformator low-voltage poles on the network
---
--- Used for overload protection logic.
---
--- @param network_id uint?
--- @return {load_watts:number, supply_watts:number, load_count:integer, supply_count:integer} totals
function get_network_transformator_capacity(network_id)
    local totals = {
        load_watts = 0,
        supply_watts = 0,
        load_count = 0,
        supply_count = 0
    }

    if not network_id then return totals end

    for _, transformator in pairs(storage.eg_transformators or {}) do
        if transformator
            and transformator.high_voltage and transformator.high_voltage.valid
            and transformator.low_voltage and transformator.low_voltage.valid
        then
            local rating_watts = get_transformator_rating_watts(transformator)

            if transformator.high_voltage.electric_network_id == network_id then
                totals.load_watts = totals.load_watts + rating_watts
                totals.load_count = totals.load_count + 1
            end

            if transformator.low_voltage.electric_network_id == network_id then
                totals.supply_watts = totals.supply_watts + rating_watts
                totals.supply_count = totals.supply_count + 1
            end
        end
    end

    return totals
end

--- Combine transformator capacity totals from two electric networks as if a new
--- copper-wire connection merged them into one network.
--- @param network_id_a uint?
--- @param network_id_b uint?
--- @return {load_watts:number, supply_watts:number, load_count:integer, supply_count:integer} totals
local function get_merged_network_transformator_capacity(network_id_a, network_id_b)
    local totals = {
        load_watts = 0,
        supply_watts = 0,
        load_count = 0,
        supply_count = 0
    }

    if network_id_a then
        local network_a = get_network_transformator_capacity(network_id_a)
        totals.load_watts = totals.load_watts + network_a.load_watts
        totals.supply_watts = totals.supply_watts + network_a.supply_watts
        totals.load_count = totals.load_count + network_a.load_count
        totals.supply_count = totals.supply_count + network_a.supply_count
    end

    if network_id_b and network_id_b ~= network_id_a then
        local network_b = get_network_transformator_capacity(network_id_b)
        totals.load_watts = totals.load_watts + network_b.load_watts
        totals.supply_watts = totals.supply_watts + network_b.supply_watts
        totals.load_count = totals.load_count + network_b.load_count
        totals.supply_count = totals.supply_count + network_b.supply_count
    end

    return totals
end

--- Check whether a transformator high-voltage pole is overloaded on its
--- current electric network.
---
--- Overload protection is bypassed entirely when:
--- - the feature is disabled
--- - the entity is not a transformator high-voltage pole
--- - the pole is not on an electric network
--- - the network has zero LV-side supply transformators connected
---
--- @param high_voltage_pole LuaEntity?
--- @return boolean is_overloaded
function is_high_voltage_connection_overloaded(high_voltage_pole)
    if not high_voltage_pole then return false end
    if is_transformator_overload_allowed() then return false end
    if not is_transformator_high_voltage_pole(high_voltage_pole) then return false end

    local network_id = high_voltage_pole.electric_network_id
    if not network_id then return false end

    local totals = get_network_transformator_capacity(network_id)

    if totals.supply_count == 0 then
        return false
    end

    return totals.load_watts > totals.supply_watts
end

--- Check whether connecting two poles would overload the merged electric
--- network that results from joining their current networks.
--- @param pole_a LuaEntity?
--- @param pole_b LuaEntity?
--- @return boolean is_overloaded
local function is_connection_overloaded_after_merge(pole_a, pole_b)
    if not pole_a or not pole_b then return false end
    if is_transformator_overload_allowed() then return false end

    local network_id_a = pole_a.electric_network_id
    local network_id_b = pole_b.electric_network_id
    if not network_id_a and not network_id_b then return false end

    local totals = get_merged_network_transformator_capacity(network_id_a, network_id_b)
    if totals.load_count == 0 or totals.supply_count == 0 then
        return false
    end

    return totals.load_watts > totals.supply_watts
end

--- Resolve the placed item name for a pole entity so a delayed rollback can
--- refund the same item the player used to build it.
--- @param entity LuaEntity?
--- @return string? item_name
local function get_pole_place_item_name(entity)
    if not (entity and entity.valid and entity.prototype) then return nil end

    local items_to_place = entity.prototype.items_to_place_this
    if not items_to_place or not items_to_place[1] then return nil end

    return items_to_place[1].name
end

--- Undo a just-built electric pole by refunding its place item to the
--- player cursor or inventory, then removing the pole entity.
---
--- After removal, nearby poles are revalidated and the short-circuit scan is
--- rescheduled so the rollback follows the normal electric-pole removal flow.
--- @param player LuaPlayer?
--- @param pole LuaEntity?
--- @return boolean removed
local function refund_and_remove_built_pole(player, pole)
    if not (player and player.valid and pole and pole.valid) then return false end

    local item_name = get_pole_place_item_name(pole)
    if not item_name then return false end
    local poles = get_nearby_poles(pole)

    local cursor_stack = player.cursor_stack
    if cursor_stack and cursor_stack.valid_for_read and cursor_stack.name == item_name then
        cursor_stack.count = cursor_stack.count + 1
    elseif cursor_stack and not cursor_stack.valid_for_read then
        cursor_stack.set_stack { name = item_name, count = 1 }
    else
        local inserted = player.insert { name = item_name, count = 1 }
        if inserted < 1 then
            pole.surface.spill_item_stack {
                position = pole.position,
                stack = { name = item_name, count = 1 },
                enable_looted = true,
                force = player.force,
                allow_belts = false
            }
        end
    end

    pole.destroy()
    if poles then
        for _, nearby_pole in pairs(poles) do
            enforce_pole_connections(nearby_pole, player, false)
        end
    end
    eg_schedule_short_circuit_check()
    return true
end

--- Validate the settled network of a just-built electric pole after
--- engine auto-connections have been created.
---
--- If the placed pole leaves its electric network overloaded:
--- - player builds are undone and refunded
--- - non-player builds are marked for deconstruction
---
--- The target pole is re-resolved from `{ surface_index, position, name }`
--- because delayed job arguments cannot persist a live `LuaEntity` reference.
---
--- @param args {surface_index:uint, position:MapPosition, name:string, player_index:uint?}
--- @return nil
function validate_built_pole_overload(args)
    if not args or not args.surface_index or not args.position or not args.name then return end
    if storage.eg_transformators_only then return end
    if is_transformator_overload_allowed() then return end

    local surface = game.get_surface(args.surface_index)
    if not surface then return end

    local pole = surface.find_entity(args.name, args.position)
    if not (pole and pole.valid and pole.type == "electric-pole") then return end

    local network_id = pole.electric_network_id
    if not network_id then return end

    local totals = get_network_transformator_capacity(network_id)
    if totals.load_count == 0 or totals.supply_count == 0 then return end
    if totals.load_watts <= totals.supply_watts then return end

    local player = args.player_index and game.get_player(args.player_index) or nil
    if player and player.valid then
        notify_blocked_copper_connection(player, pole, "eg.eg-transformator-overload", true)
        refund_and_remove_built_pole(player, pole)
        return
    end

    storage.eg_skip_pole_cleanup_on_mined = storage.eg_skip_pole_cleanup_on_mined or {}
    local pole_key = get_electric_pole_storage_key(pole.surface.index, pole.name, pole.position)
    if pole_key then
        storage.eg_skip_pole_cleanup_on_mined[pole_key] = true
    end
    pole.order_deconstruction(pole.force)
end

--- Show player feedback for a rejected copper wire connection.
---
--- Only displays when `show_message == true`, which is used for manual wire
--- connections through the custom wire-build flow. Automatic cleanup paths call
--- the same validation helpers with `show_message` omitted or false, which
--- keeps those paths silent.
---
--- Includes:
--- - local flying text
--- - the standard "cannot build" sound
---
--- @param player LuaPlayer|nil
--- @param pole LuaEntity?
--- @param locale_key string
--- @param show_message boolean|nil
--- @return nil
function notify_blocked_copper_connection(player, pole, locale_key, show_message)
    show_message = show_message == true
    if not show_message then return end
    if not (player and player.valid and pole and pole.valid) then return end

    player.play_sound { path = "utility/cannot_build" }
    player.create_local_flying_text {
        text = { locale_key or "eg.eg-connection-not-allowed" },
        position = {
            x = pole.position.x,
            y = pole.position.y - 1
        },
        surface = pole.surface
    }
end

--- Disconnect one specific copper-wire edge between two poles.
---
--- This is used by the manual-wire validation path so the just-attempted wire
--- is removed first, instead of disconnecting some other overloaded neighbor on
--- the same network.
--- @param source_pole LuaEntity?
--- @param target_pole LuaEntity?
--- @return boolean disconnected
function disconnect_specific_copper_connection(source_pole, target_pole)
    if not (source_pole and source_pole.valid and target_pole and target_pole.valid) then return false end

    local connectors = source_pole.get_wire_connectors(false)
    if not connectors then return false end

    for _, connector in pairs(connectors) do
        if connector.wire_type == defines.wire_type.copper then
            for _, connection in pairs(connector.connections) do
                local target_connector = connection.target
                if target_connector and target_connector.valid and target_connector.owner == target_pole then
                    connector.disconnect_from(target_connector)
                    return true
                end
            end
        end
    end

    return false
end

--- Validate a specific attempted copper wire connection between two poles.
---
--- This is used for manual wire placement and ensures:
--- - the exact attempted connection is evaluated first
--- - if invalid, that connection is removed instead of some unrelated neighbor
--- - overload is evaluated against the prospective merged network produced by
---   joining the two poles' current electric networks
---
--- This prevents unrelated transformator connections from being disconnected
--- when overload cleanup is triggered by a newly placed wire.
---
--- @param source_pole LuaEntity
--- @param target_pole LuaEntity
--- @param player LuaPlayer|nil
--- @param show_message boolean|nil
--- @return boolean allowed
function enforce_specific_copper_connection(source_pole, target_pole, player, show_message)
    show_message = show_message == true

    if not (source_pole and source_pole.valid and target_pole and target_pole.valid) then return true end
    if source_pole.type ~= "electric-pole" or target_pole.type ~= "electric-pole" then return true end
    if storage.eg_transformators_only then return true end

    if not is_copper_cable_connection_allowed(source_pole, target_pole) then
        disconnect_specific_copper_connection(source_pole, target_pole)
        notify_blocked_copper_connection(player, source_pole, "eg.eg-connection-not-allowed", show_message)
        return false
    end

    if is_transformator_overload_allowed() then
        return true
    end

    local overload_anchor = source_pole
    if is_transformator_high_voltage_pole(target_pole) then
        overload_anchor = target_pole
    elseif is_transformator_high_voltage_pole(source_pole) then
        overload_anchor = source_pole
    end

    if is_connection_overloaded_after_merge(source_pole, target_pole) then
        disconnect_specific_copper_connection(source_pole, target_pole)
        notify_blocked_copper_connection(player, overload_anchor, "eg.eg-transformator-overload", show_message)
        return false
    end

    return true
end

--- Enforce transformator overload rules on one copper wire connection.
---
--- Behavior:
--- - computes total load vs supply for the electric network that would result
---   from joining the two poles' current networks
--- - allows the connection if:
---   - the merged network has zero LV-side supply transformators, or
---   - load does not exceed supply
--- - otherwise disconnects this connection
---
--- This helper validates only the provided connector pair. Broader pole/network
--- cleanup is handled by the caller.
---
--- @param connector LuaWireConnector
--- @param target_connector LuaWireConnector
--- @param pole LuaEntity
--- @param target_pole LuaEntity
--- @param player LuaPlayer|nil
--- @param show_message boolean|nil
--- @return boolean allowed
function enforce_transformator_overload_connection(connector, target_connector, pole, target_pole, player,
                                                   show_message)
    show_message = show_message == true

    if is_transformator_overload_allowed() then return true end

    local overload_anchor = pole
    if is_transformator_high_voltage_pole(target_pole) then
        overload_anchor = target_pole
    elseif is_transformator_high_voltage_pole(pole) then
        overload_anchor = pole
    end

    if is_connection_overloaded_after_merge(pole, target_pole) then
        connector.disconnect_from(target_connector)
        notify_blocked_copper_connection(
            player,
            overload_anchor,
            "eg.eg-transformator-overload",
            show_message
        )
        return false
    end

    return true
end

--- Check for illegal short-circuit conditions between transformator HV/LV poles.
---
--- When a transformator's high-voltage and low-voltage poles land on the same
--- electric network, a custom alert is added once and later removed when the
--- short is cleared. The pending scheduled-check marker is cleared at the start
--- of the scan.
--- @return nil
function short_circuit_check()
    storage.eg_short_circuit_check_tick = nil

    local transformators = storage.eg_transformators
    if not transformators then return end

    for _, transformator in pairs(transformators) do
        if transformator
            and transformator.pump and transformator.pump.valid
            and transformator.high_voltage and transformator.high_voltage.valid
            and transformator.low_voltage and transformator.low_voltage.valid
        then
            local high_network_id = transformator.high_voltage.electric_network_id
            local low_network_id = transformator.low_voltage.electric_network_id

            if high_network_id and low_network_id then
                if high_network_id == low_network_id then
                    if transformator.alert_tick == 0 then
                        transformator.alert_tick = game.tick
                        for _, player in pairs(game.players) do
                            player.add_custom_alert(
                                transformator.pump,
                                { type = "virtual", name = "eg-alert" },
                                { "", "Short circuit detected" },
                                true
                            )
                        end
                    end
                elseif transformator.alert_tick ~= 0 then
                    transformator.alert_tick = 0
                    for _, player in pairs(game.players) do
                        player.remove_alert({ entity = transformator.pump })
                    end
                end
            end
        end
    end
end

--- Replace the delayed UGP substation displayer proxy with the real substation
--- entity.
--- @param args {unit_number:uint}
--- @return nil
function replace_displayer_with_ugp_substation(args)
    if not args or not args.unit_number then return end

    local displayer = game.get_entity_by_unit_number(args.unit_number)
    if not (displayer and displayer.valid) then return end

    local position = displayer.position
    local direction = displayer.direction
    local force = displayer.force
    local surface = displayer.surface
    local quality = displayer.quality

    displayer.destroy()

    local eg_ugp_substation = surface.create_entity {
        name = "eg-ugp-substation",
        position = position,
        direction = direction,
        force = force,
        quality = quality,
        create_build_effect_smoke = false
    }

    if eg_ugp_substation then
        enforce_pole_connections(eg_ugp_substation)

        local poles = get_nearby_poles(eg_ugp_substation)
        if poles then
            for _, pole in pairs(poles) do
                if pole.valid then
                    enforce_pole_connections(pole)
                end
            end
        end
    end

    eg_schedule_short_circuit_check()
end

--- Check whether a copper cable connection is allowed between two poles.
---
--- Direct copper connections between a transformator's own HV and LV poles are
--- always forbidden. Ownership is resolved through `get_transformator_by_entity()`.
--- @param pole_a LuaEntity
--- @param pole_b LuaEntity
--- @return boolean is_allowed
function is_copper_cable_connection_allowed(pole_a, pole_b)
    if storage.eg_transformators_only then return true end
    if not (pole_a and pole_b and pole_a.valid and pole_b.valid) then
        return false
    end

    local name_a = pole_a.name
    local name_b = pole_b.name

    local is_transformator_a = constants.EG_TRANSFORMATOR_POLE_NAMES[name_a]
    local is_transformator_b = constants.EG_TRANSFORMATOR_POLE_NAMES[name_b]
    local is_transmission_a = constants.EG_TRANSMISSION_POLES[name_a]
    local is_transmission_b = constants.EG_TRANSMISSION_POLES[name_b]
    local is_huge_a = constants.EG_HUGE_POLES[name_a]
    local is_huge_b = constants.EG_HUGE_POLES[name_b]

    local is_proxy_a = string.sub(name_a, 1, 15) == "electric-proxy-"
    local is_proxy_b = string.sub(name_b, 1, 15) == "electric-proxy-"
    local is_f077et_a = string.sub(name_a, 1, 7) == "F077ET-"
    local is_f077et_b = string.sub(name_b, 1, 7) == "F077ET-"
    local is_po_interface_a = string.sub(name_a, 1, 12) == "po-interface"
    local is_po_interface_b = string.sub(name_b, 1, 12) == "po-interface"
    local is_po_fuse_a = string.sub(name_a, 1, 3) == "po-" and string.find(name_a, "-fuse", 1, true)
    local is_po_fuse_b = string.sub(name_b, 1, 3) == "po-" and string.find(name_b, "-fuse", 1, true)

    local wire_connections_a = constants.EG_WIRE_CONNECTIONS[name_a]

    if name_a == "power-combinator-meter-network" and name_b == "power-combinator-meter-network" then
        return false
    end

    if is_transformator_a and is_transformator_b then
        local transformator_a = get_transformator_by_entity(pole_a)
        local transformator_b = get_transformator_by_entity(pole_b)

        if transformator_a and transformator_b and transformator_a == transformator_b then
            return false
        end
    end

    if pole_a.surface.name == "fulgora" then
        if is_transmission_a and is_transmission_b then return true end
        if (is_transmission_a and is_huge_b) or (is_transmission_b and is_huge_a) then return true end
        if is_huge_a and is_huge_b then return true end
    end

    if wire_connections_a and wire_connections_a[name_b] then return true end
    if is_transformator_a and is_transformator_b then return true end
    if (is_transformator_a and is_transmission_b) or (is_transformator_b and is_transmission_a) then return true end
    if (is_transformator_a and is_huge_b) or (is_transformator_b and is_huge_a) then return true end
    if (is_transformator_a and is_po_interface_b) or (is_transformator_b and is_po_interface_a) then return true end
    if (is_transformator_a and is_po_fuse_b) or (is_transformator_b and is_po_fuse_a) then return true end
    if is_proxy_a and is_proxy_b then return true end
    if is_f077et_a and is_f077et_b then return true end
    if (is_huge_a and is_proxy_b) or (is_huge_b and is_proxy_a) then return false end
    if (is_huge_a and is_f077et_b) or (is_huge_b and is_f077et_a) then return false end
    if (is_transmission_a and is_proxy_b) or (is_transmission_b and is_proxy_a) then return true end
    if (is_transmission_a and is_f077et_b) or (is_transmission_b and is_f077et_a) then return true end

    return false
end

--- Validate and enforce all copper wire connections on a pole.
---
--- Behavior:
--- - iterates all copper-wire connections on the pole
--- - removes invalid connections based on:
---   - general pole compatibility rules
---   - transformator overload rules
---
--- Modes:
--- - manual wiring (`show_message == true`):
---   - shows player-local feedback
--- - automatic enforcement (`show_message` omitted or false):
---   - silent cleanup during build, robot placement, rotation, or topology updates
---
--- Overload handling:
--- - `check_overload == nil` or `true`:
---   - runs transformator overload validation
--- - `check_overload == false`:
---   - only enforces general copper-connection legality
---
--- Returns `false` if any connection was removed.
---
--- @param pole LuaEntity
--- @param player LuaPlayer|nil
--- @param show_message boolean|nil
--- @param check_overload boolean|nil
--- @return boolean allowed
function enforce_pole_connections(pole, player, show_message, check_overload)
    show_message = show_message == true
    check_overload = check_overload ~= false

    if not pole or not pole.valid or pole.type ~= "electric-pole" then return true end
    if storage.eg_transformators_only then return true end

    local connectors = pole.get_wire_connectors(false)
    if not connectors then return true end

    local allowed = true
    local notified = false
    local overload_checks_enabled = check_overload and not is_transformator_overload_allowed()
    for _, connector in pairs(connectors) do
        if connector.wire_type == defines.wire_type.copper then
            for _, connection in pairs(connector.connections) do
                local target_connector = connection.target
                local target_pole = target_connector.owner

                if target_pole and target_pole.valid and target_pole.type == "electric-pole" then
                    if not is_copper_cable_connection_allowed(pole, target_pole) then
                        connector.disconnect_from(target_connector)
                        if not notified then
                            notify_blocked_copper_connection(player, pole, "eg.eg-connection-not-allowed", show_message)
                            notified = true
                        end
                        allowed = false
                    elseif overload_checks_enabled and not enforce_transformator_overload_connection(
                            connector,
                            target_connector,
                            pole,
                            target_pole,
                            notified and nil or player,
                            show_message and not notified
                        ) then
                        notified = true
                        allowed = false
                    end
                end
            end
        end
    end

    return allowed
end

-- ---------------------------------------------------------------------------
-- GUI helpers
-- ---------------------------------------------------------------------------

--- Resolve a transformator's configured rating string.
--- @param transformator EgTransformator|LuaEntity|nil Transformator table or transformator entity.
--- @return string? rating
function get_current_transformator_rating(transformator)
    if not transformator then return nil end

    if transformator.valid then
        --- @cast transformator LuaEntity
        local transformator_entity = transformator

        transformator = get_transformator_by_entity(transformator_entity)
        if not transformator then return nil end
    end

    local tier = get_transformator_tier(transformator)
    if not tier then return nil end

    local spec = constants.EG_TRANSFORMATORS[tier]
    return spec and spec.rating or nil
end

--- Return the current fluid filter name set on a transformator pump.
--- @param pump LuaEntity?
--- @return string? filter_name
function get_transformator_pump_filter_name(pump)
    if not (pump and pump.valid and pump.fluidbox) then return nil end

    local filter = pump.fluidbox.get_filter(1)
    if filter and filter.name then
        return filter.name
    end

    return nil
end

--- Check whether a fluid filter is one of the transformator control fluids.
--- @param fluid_name string?
--- @return boolean is_control_fluid
function is_transformator_control_fluid(fluid_name)
    return type(fluid_name) == "string"
        and (fluid_name == constants.DISABLED_FLUID or fluid_name:match("^eg%-water%-%d+$") ~= nil)
end

--- Close the relative transformator GUI for the given player.
--- @param player LuaPlayer
--- @return nil
function close_transformator_gui(player)
    local closed = false

    storage.eg_opened_pump_filter_name[player.index] = nil
    storage.eg_opened_pump_unit_number[player.index] = nil

    if player.gui.relative.eg_transformator_rating_relative_frame then
        player.gui.relative.eg_transformator_rating_relative_frame.destroy()
        storage.eg_selected_transformator[player.index] = nil
        closed = true
    end

    if closed then
        player.play_sound { path = "eg-transformator-gui-close" }
    end
end

--- Create or recreate the pump-relative transformator rating frame.
--- @param player LuaPlayer
--- @return LuaGuiElement frame Newly created relative frame.
function get_or_create_transformator_relative_frame(player)
    if player.gui.relative.eg_transformator_rating_relative_frame then
        player.gui.relative.eg_transformator_rating_relative_frame.destroy()
    end

    local anchor_name = get_transformator_pump_name(1)
    if player.opened and player.opened.valid and is_transformator_pump(player.opened.name) then
        anchor_name = player.opened.name
    end

    local frame = player.gui.relative.add {
        type = "frame",
        name = "eg_transformator_rating_relative_frame",
        direction = "vertical",
        anchor = {
            gui = defines.relative_gui_type.pump_gui,
            position = defines.relative_gui_position.left,
            name = anchor_name
        }
    }

    frame.style.vertically_stretchable = false
    return frame
end

--- Populate the relative transformator GUI with the current rating selector.
--- @param parent_frame LuaGuiElement
--- @param current_rating string
--- @return nil
function add_rating_radio_buttons(parent_frame, current_rating)
    if not (parent_frame and parent_frame.valid) then return end

    local content = parent_frame.add {
        type = "flow",
        name = "eg_transformator_rating_content",
        direction = "vertical"
    }
    content.style.vertical_spacing = 8

    local label = content.add {
        type = "label",
        caption = { "gui.eg-select-rating" },
        style = "heading_2_label"
    }
    label.style.left_margin = 2

    local rating_frame = content.add {
        type = "frame",
        name = "eg_relative_rating_frame",
        style = "inside_shallow_frame_with_padding",
        direction = "vertical"
    }
    rating_frame.style.top_padding = 8
    rating_frame.style.bottom_padding = 8
    rating_frame.style.left_padding = 6
    rating_frame.style.right_padding = 6

    local radio_flow = rating_frame.add {
        type = "flow",
        name = "eg_relative_rating_radio_flow",
        direction = "vertical"
    }
    radio_flow.style.vertical_spacing = 10

    for _, specs in ipairs(constants.EG_TRANSFORMATORS) do
        if specs.rating then
            local radio = radio_flow.add {
                type = "radiobutton",
                name = "eg_relative_rating_radio_" .. specs.rating,
                caption = specs.rating,
                state = (specs.rating == current_rating),
                tags = {
                    eg_relative_rating = specs.rating
                }
            }

            radio.style.margin = 0
            radio.style.top_margin = 0
            radio.style.bottom_margin = 0
        end
    end
end
