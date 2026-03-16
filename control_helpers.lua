--- Shared runtime helpers for Electric Grid.
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


-- ---------------------------------------------------------------------------
-- Transformator lookup and synchronization
-- ---------------------------------------------------------------------------

--- Fetch a stored transformator by its root pump unit number.
--- @param pump_unit_number uint|nil
--- @return table|nil transformator
function get_transformator_by_pump_unit_number(pump_unit_number)
    if not pump_unit_number then return nil end
    return storage.eg_transformators[pump_unit_number]
end

--- Resolve any tracked transformator component back to the owning transformator.
--- @param entity LuaEntity|nil Any tracked transformator entity.
--- @return table|nil transformator
function get_transformator_by_entity(entity)
    if not (entity and entity.valid and entity.unit_number) then return nil end

    local pump_unit_number = storage.eg_entity_to_transformator
        and storage.eg_entity_to_transformator[entity.unit_number]

    if not pump_unit_number then return nil end
    return storage.eg_transformators[pump_unit_number]
end

--- Rebuild the cached transformator key list and entity-to-transformator index.
---
--- This should be called after any operation that creates, destroys, or
--- replaces tracked transformator components.
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
            transformator.boiler,
            transformator.infinity_pipe,
            transformator.steam_engine,
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
    local eg_transformator = storage.eg_transformators[pump_unit_number]
    if not eg_transformator then return end

    if eg_transformator.boiler and eg_transformator.boiler.valid then eg_transformator.boiler.destroy() end
    if eg_transformator.pump and eg_transformator.pump.valid then eg_transformator.pump.destroy() end
    if eg_transformator.infinity_pipe and eg_transformator.infinity_pipe.valid then
        eg_transformator.infinity_pipe
            .destroy()
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
--- @param transformator table|LuaEntity|nil
--- @return integer|nil tier
function get_transformator_tier(transformator)
    if not transformator then return nil end

    if transformator.tier then
        return tonumber(transformator.tier)
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

function get_steam_engine_direction(direction)
    if direction == defines.direction.east or direction == defines.direction.west then
        return defines.direction.east
    end
    return defines.direction.north
end

--- Return the steam engine variant suffix used for the given direction.
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
--- @param name string|nil
--- @return boolean is_transformator_name
function is_transformator(name)
    return name == "eg-pump"
        or name == "eg-transformator-displayer"
        or constants.EG_TRANSFORMATORS[name] ~= nil
end

--- Fetch a stored transformator directly from a root pump entity.
--- @param pump LuaEntity|nil
--- @return table|nil transformator
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
--- @param transformator table Stored transformator state.
--- @return nil
function replace_tiered_components(transformator)
    if not transformator then return end
    if not (transformator.pump and transformator.pump.valid) then return end

    local tier = get_transformator_tier(transformator)
    if not tier then return end

    local force = transformator.pump.force
    local surface = transformator.pump.surface
    local pump_unit_number = transformator.pump.unit_number

    local eg_transformator = storage.eg_transformators[pump_unit_number]
    if not eg_transformator then
        log("Error: Transformator with pump unit_number " .. pump_unit_number .. " not found.")
        return
    end

    if not (eg_transformator.boiler and eg_transformator.boiler.valid) then return end
    if not (eg_transformator.steam_engine and eg_transformator.steam_engine.valid) then return end

    local boiler_direction = eg_transformator.boiler.direction
    local boiler_position = eg_transformator.boiler.position
    eg_transformator.boiler.destroy()

    local eg_boiler = surface.create_entity {
        name = "eg-boiler-" .. tier,
        position = boiler_position,
        force = force,
        direction = boiler_direction,
        create_build_effect_smoke = false
    }

    local steam_engine_direction = eg_transformator.steam_engine.direction
    local steam_engine_position = eg_transformator.steam_engine.position
    eg_transformator.steam_engine.destroy()

    local eg_steam_engine = surface.create_entity {
        name = "eg-steam-engine-" .. get_steam_engine_variant(steam_engine_direction) .. "-" .. tier,
        position = steam_engine_position,
        force = force,
        direction = steam_engine_direction,
        create_build_effect_smoke = false
    }

    eg_transformator.boiler = eg_boiler
    eg_transformator.steam_engine = eg_steam_engine
end

--- Build a transformator from a placed transformator root, item, or displayer.
---
--- When the root is already an `eg-pump`, the existing pump is kept and the
--- surrounding internal entities are created around it.
--- @param entity LuaEntity Built entity.
--- @param player_index uint|nil Player index for player-specific build intent.
--- @return nil
function eg_transformator_built(entity, player_index)
    if not entity or not entity.name then return end
    if not is_transformator(entity.name) then return end

    local surface = entity.surface
    local force = entity.force
    local position = entity.position
    local direction = entity.direction

    local transformator_position = { x = position.x, y = position.y }
    local tier
    local eg_pump = nil

    if entity.name == "eg-transformator-displayer" then
        tier = "1"
        entity.destroy()
    elseif entity.name == "eg-pump" then
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
    if type(transformator_to_build) == "string" and string.sub(transformator_to_build, 1, 8) == "eg-unit-" then
        tier = transformator_to_build:match("(%d+)$") or tier
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
            name = "eg-pump",
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

    if eg_pump then
        storage.eg_transformators[eg_pump.unit_number] = {
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
    end

    sync_transformator_keys()
end

--- Replace a transformator's tiered internals while preserving the root pump
--- and voltage poles.
--- @param old_transformator table
--- @param new_rating string Requested rating string.
--- @return nil
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

    local new_tier = tonumber(string.sub(new_unit, -1))
    if not new_tier then return end

    local eg_transformator = old_transformator
    if not (eg_transformator.pump and eg_transformator.pump.valid) then return end

    local force = eg_transformator.pump.force
    local surface = eg_transformator.pump.surface
    local pump_unit_number = eg_transformator.pump.unit_number

    eg_transformator = storage.eg_transformators[pump_unit_number]
    if not eg_transformator then return end

    if not (eg_transformator.high_voltage and eg_transformator.high_voltage.valid) then return end
    if not (eg_transformator.low_voltage and eg_transformator.low_voltage.valid) then return end
    if not (eg_transformator.pump and eg_transformator.pump.valid) then return end
    if not (eg_transformator.boiler and eg_transformator.boiler.valid) then return end
    if not (eg_transformator.infinity_pipe and eg_transformator.infinity_pipe.valid) then return end
    if not (eg_transformator.steam_engine and eg_transformator.steam_engine.valid) then return end

    local eg_high_voltage_pole = eg_transformator.high_voltage
    local eg_low_voltage_pole = eg_transformator.low_voltage
    local eg_pump = eg_transformator.pump
    local prior_pump_was_disabled = eg_transformator.pump_was_disabled

    local eg_boiler_position = eg_transformator.boiler.position
    local eg_boiler_direction = eg_transformator.boiler.direction
    eg_transformator.boiler.destroy()

    local eg_infinity_pipe_position = eg_transformator.infinity_pipe.position
    local eg_infinity_pipe_direction = eg_transformator.infinity_pipe.direction
    eg_transformator.infinity_pipe.destroy()

    local eg_boiler = surface.create_entity {
        name = "eg-boiler-" .. new_tier,
        position = eg_boiler_position,
        direction = eg_boiler_direction,
        force = force,
        create_build_effect_smoke = false
    }

    local eg_infinity_pipe = surface.create_entity {
        name = "eg-infinity-pipe",
        position = eg_infinity_pipe_position,
        direction = eg_infinity_pipe_direction,
        force = force,
        create_build_effect_smoke = false
    }

    local old_steam_engine = eg_transformator.steam_engine
    local eg_steam_engine_position = old_steam_engine.position

    local current_engine_name = old_steam_engine.name
    local current_variant =
        current_engine_name:match("^eg%-steam%-engine%-(%a+)%-%d+$") or "ne"

    local eg_steam_engine_direction = get_steam_engine_direction(eg_boiler_direction)

    old_steam_engine.destroy()

    local eg_steam_engine = surface.create_entity {
        name = "eg-steam-engine-" .. current_variant .. "-" .. new_tier,
        position = eg_steam_engine_position,
        direction = eg_steam_engine_direction,
        force = force,
        create_build_effect_smoke = false
    }

    eg_pump.clear_fluid_inside()
    local filter = eg_pump.fluidbox.get_filter(1)
    if filter and filter.name and filter.name ~= "eg-fluid-disable" then
        eg_pump.fluidbox.set_filter(1, { name = "eg-water-" .. new_tier })
    end

    eg_infinity_pipe.set_infinity_pipe_filter {
        name = "eg-water-" .. new_tier,
        percentage = 1,
        temperature = 15,
        mode = "at-least"
    }

    storage.eg_transformators[pump_unit_number] = {
        boiler = eg_boiler,
        pump = eg_pump,
        infinity_pipe = eg_infinity_pipe,
        steam_engine = eg_steam_engine,
        high_voltage = eg_high_voltage_pole,
        low_voltage = eg_low_voltage_pole,
        alert_tick = 0,
        tier = new_tier,
        pump_was_disabled = prior_pump_was_disabled
    }

    sync_transformator_keys()
end

--- Destroy only the non-root transformator components.
---
--- Used by rotation rebuilds that keep the game-rotated pump as the stable
--- owner/root entity.
--- @param transformator table
--- @return nil
function destroy_transformator_dependents(transformator)
    if not transformator then return end

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

--- Rotate the full transformator about its geometric center.
---
--- The game rotates the root pump in place before the event fires. For this
--- multi-entity structure, the pump must then be relocated so that all four
--- internal 1x1 entities rotate about the transformator center rather than
--- about the pump's own tile.
--- @param pump LuaEntity Root pump that the game has already rotated.
--- @param previous_direction defines.direction|nil Direction before the engine rotation.
--- @return boolean success
function rebuild_transformator_dependents_from_pump(pump, previous_direction)
    if not (pump and pump.valid and pump.name == "eg-pump" and pump.unit_number) then
        return false
    end

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
    if pump.position.x ~= new_pump_position.x or pump.position.y ~= new_pump_position.y then
        local teleported = pump.teleport(new_pump_position)
        if not teleported then
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
    enforce_pole_connections(high_voltage)
    enforce_pole_connections(low_voltage)
    short_circuit_check()

    return true
end

-- ---------------------------------------------------------------------------
-- Pole / wiring helpers
-- ---------------------------------------------------------------------------

--- Find nearby electric poles within copper wire reach of the given pole.
--- @param entity LuaEntity Mined or changed electric pole.
--- @return LuaEntity[]|nil poles
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

--- Check for illegal short-circuit conditions between transformator HV/LV poles.
---
--- When a transformator's high-voltage and low-voltage poles land on the same
--- electric network, a custom alert is added once and later removed when the
--- short is cleared.
--- @return nil


--- Reset cached short-circuit alert state for all stored transformators.
-- This is useful after migrations where the alert entity changed from the old
-- transformator unit to the pump root, because preserved alert_tick values can
-- suppress new alerts for migrated records.
-- @return nil
function reset_short_circuit_alert_state()
    if not (storage and storage.eg_transformators) then return end

    for _, transformator in pairs(storage.eg_transformators) do
        if transformator then
            transformator.alert_tick = 0
        end
    end
end

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

--- Replace the delayed substation displayer with the real substation entity.
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

    short_circuit_check()
end

--- Check whether a copper cable connection is allowed between two poles.
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
    local is_po_fuse_a = string.sub(name_a, 1, 3) == "po-" and string.find(name_a, "-fuse")
    local is_po_fuse_b = string.sub(name_b, 1, 3) == "po-" and string.find(name_b, "-fuse")

    local wire_connections_a = constants.EG_WIRE_CONNECTIONS[name_a]

    if name_a == "power-combinator-meter-network" and name_b == "power-combinator-meter-network" then
        return false
    end

    if is_transformator_a and is_transformator_b then
        for _, transformator in pairs(storage.eg_transformators) do
            local hv = transformator.high_voltage
            local lv = transformator.low_voltage
            if (hv == pole_a and lv == pole_b) or (hv == pole_b and lv == pole_a) then
                return false
            end
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

--- Enforce the custom copper cable rules for a pole by disconnecting invalid
--- copper-wire neighbors.
--- @param pole LuaEntity|nil
--- @return boolean allowed True when no invalid connections were found.
function enforce_pole_connections(pole)
    if not pole or not pole.valid or pole.type ~= "electric-pole" then return true end
    if storage.eg_transformators_only then return true end

    local connectors = pole.get_wire_connectors(false)
    if not connectors then return true end

    local allowed = true
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

-- ---------------------------------------------------------------------------
-- GUI helpers
-- ---------------------------------------------------------------------------

--- Create or recreate the standalone transformator rating selection frame.
--- @param player LuaPlayer
--- @return LuaGuiElement frame
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
        caption = { "entity-name.eg-unit" },
        style = "frame_title"
    }
    title_label.style.horizontally_stretchable = false
    title_label.ignored_by_interaction = true

    local spacer = top_bar.add {
        type = "empty-widget",
        style = "draggable_space_header",
        ignored_by_interaction = false
    }
    spacer.drag_target = frame
    spacer.style.height = 24
    spacer.style.horizontally_stretchable = true
    spacer.ignored_by_interaction = true

    top_bar.add {
        type = "sprite-button",
        name = "close_transformator_gui",
        sprite = "utility/close",
        style = "close_button",
        mouse_button_filter = { "left" }
    }

    player.opened = frame
    return frame
end

--- Resolve a transformator's configured rating string.
--- @param transformator table|LuaEntity|nil Transformator table or transformator entity.
--- @return string|nil rating
function get_current_transformator_rating(transformator)
    if not transformator then return nil end

    if transformator.valid then
        transformator = get_transformator_by_entity(transformator)
        if not transformator then return nil end
    end

    local tier = get_transformator_tier(transformator)
    if not tier then return nil end

    local unit_name = "eg-unit-" .. tier
    local spec = constants.EG_TRANSFORMATORS[unit_name]
    return spec and spec.rating or nil
end

--- Close either transformator GUI variant for the given player.
--- @param player LuaPlayer
--- @return nil
function close_transformator_gui(player)
    local closed = false

    if player.gui.screen.transformator_rating_selection_frame then
        player.gui.screen.transformator_rating_selection_frame.destroy()
        player.opened = nil
        storage.eg_selected_transformator[player.index] = nil
        closed = true
    end

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
--- @return LuaGuiElement frame
function get_or_create_transformator_relative_frame(player)
    if player.gui.relative.eg_transformator_rating_relative_frame then
        player.gui.relative.eg_transformator_rating_relative_frame.destroy()
    end

    local frame = player.gui.relative.add {
        type = "frame",
        name = "eg_transformator_rating_relative_frame",
        direction = "vertical",
        anchor = {
            gui = defines.relative_gui_type.pump_gui,
            position = defines.relative_gui_position.right,
            name = "eg-pump"
        }
    }

    frame.style.vertically_stretchable = false
    return frame
end

--- Populate the relative transformator GUI with the rating dropdown.
--- @param parent_frame LuaGuiElement
--- @param current_rating string
--- @return nil
function add_relative_rating_dropdown(parent_frame, current_rating)
    if not (parent_frame and parent_frame.valid) then return end

    local content = parent_frame.add {
        type = "flow",
        name = "eg_transformator_rating_content",
        direction = "vertical"
    }
    content.style.vertical_spacing = 4

    content.add {
        type = "label",
        caption = { "gui.eg-select-rating" },
        style = "caption_label"
    }

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

    content.add {
        type = "drop-down",
        name = "eg_relative_rating_dropdown",
        items = dropdown_items,
        selected_index = selected_index
    }
end

--- Populate the full-screen transformator GUI with rating controls.
--- @param parent_frame LuaGuiElement
--- @param current_rating string
--- @return nil
function add_rating_dropdown(parent_frame, current_rating)
    if not (parent_frame and parent_frame.valid) then return end

    local bordered_frame = parent_frame.add {
        type = "frame",
        name = "rating_selection_bordered_frame",
        direction = "vertical"
    }

    local sprite_frame = bordered_frame.add {
        type = "frame",
        name = "sprite_background_frame",
        style = "deep_frame_in_shallow_frame",
        direction = "vertical"
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
