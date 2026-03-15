-- migrations/1.22.0.lua
-- Convert Electric Grid transformators from unit-keyed storage to pump-keyed storage.
local function get_tier_from_record(transformator)
    if not transformator then return nil end

    if transformator.unit and transformator.unit.valid and transformator.unit.name then
        local tier = transformator.unit.name:match("^eg%-unit%-(%d+)$")
        if tier then return tonumber(tier) end
    end

    if transformator.boiler and transformator.boiler.valid and transformator.boiler.name then
        local tier = transformator.boiler.name:match("^eg%-boiler%-(%d+)$")
        if tier then return tonumber(tier) end
    end

    if transformator.steam_engine and transformator.steam_engine.valid and transformator.steam_engine.name then
        local tier = transformator.steam_engine.name:match("^eg%-steam%-engine%-%a+%-(%d+)$")
        if tier then return tonumber(tier) end
    end

    return 1
end

local function rebuild_transformator_indexes()
    storage.eg_transformator_keys = {}
    storage.eg_entity_to_transformator = {}

    for pump_unit_number, transformator in pairs(storage.eg_transformators) do
        storage.eg_transformator_keys[#storage.eg_transformator_keys + 1] = pump_unit_number

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
                storage.eg_entity_to_transformator[entity.unit_number] = pump_unit_number
            end
        end
    end

    storage.eg_transformator_scan_index = storage.eg_transformator_scan_index or 1
    if storage.eg_transformator_scan_index > #storage.eg_transformator_keys then
        storage.eg_transformator_scan_index = 1
    end
end

storage = storage or {}
storage.eg_transformators = storage.eg_transformators or {}
storage.eg_transformator_keys = storage.eg_transformator_keys or {}
storage.eg_entity_to_transformator = storage.eg_entity_to_transformator or {}

local migrated = {}
local migrated_count = 0
local skipped_count = 0

for old_key, transformator in pairs(storage.eg_transformators) do
    if transformator and transformator.pump and transformator.pump.valid and transformator.pump.unit_number then
        local pump_unit_number = transformator.pump.unit_number
        local tier = get_tier_from_record(transformator)

        migrated[pump_unit_number] = {
            pump = transformator.pump,
            boiler = (transformator.boiler and transformator.boiler.valid) and transformator.boiler or nil,
            infinity_pipe = (transformator.infinity_pipe and transformator.infinity_pipe.valid) and
                transformator.infinity_pipe or nil,
            steam_engine = (transformator.steam_engine and transformator.steam_engine.valid) and
                transformator.steam_engine or nil,
            high_voltage = (transformator.high_voltage and transformator.high_voltage.valid) and
                transformator.high_voltage or nil,
            low_voltage = (transformator.low_voltage and transformator.low_voltage.valid) and transformator.low_voltage or
                nil,
            tier = tier,
            alert_tick = transformator.alert_tick or 0,
            pump_was_disabled = transformator.pump_was_disabled or false
        }

        migrated_count = migrated_count + 1
    else
        skipped_count = skipped_count + 1
    end
end

storage.eg_transformators = migrated
rebuild_transformator_indexes()
