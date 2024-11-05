local eg_transformators

-- Initialize global memory structures and event handlers
local function initialize_globals()
    storage = storage or {}
    eg_transformators = storage.eg_transformators or {}
    storage.eg_transformators = eg_transformators -- Persist eg_transformators in storage
end

-- Handle loading globals when the game is loaded
local function load_globals()
    eg_transformators = storage.eg_transformators
end

-- Define the position offset for the infinity pipe based on direction with 90-degree rotation
local function get_eg_boiler_offset(direction)
    if direction == defines.direction.north then
        return { x = 0, y = 0 } -- Previously was (0, -1), now rotated to right of boiler
    elseif direction == defines.direction.east then
        return { x = 0, y = 0 } -- Previously was (1, 0), now rotated to above the boiler
    elseif direction == defines.direction.south then
        return { x = 0, y = 0 } -- Previously was (0, 1), now rotated to left of the boiler
    elseif direction == defines.direction.west then
        return { x = 0, y = 0 } -- Previously was (-1, 0), now rotated to below the boiler
    end
    return { x = 0, y = 0 }     -- Default offset in case of unknown direction
end

-- Define the position offset for the infinity pipe based on direction with 90-degree rotation
local function get_eg_infinity_pipe_offset(direction)
    if direction == defines.direction.north then
        return { x = 1, y = 0 }  -- Previously was (0, -1), now rotated to right of boiler
    elseif direction == defines.direction.east then
        return { x = 0, y = 1 }  -- Previously was (1, 0), now rotated to above the boiler
    elseif direction == defines.direction.south then
        return { x = -1, y = 0 } -- Previously was (0, 1), now rotated to left of the boiler
    elseif direction == defines.direction.west then
        return { x = 0, y = -1 } -- Previously was (-1, 0), now rotated to below the boiler
    end
    return { x = 0, y = 0 }      -- Default offset in case of unknown direction
end

-- Define the position offset for the steam generator based on direction for a 1x1 boiler
local function get_eg_steam_engine_offset(direction)
    if direction == defines.direction.north then
        return { x = 0, y = -1 } -- Position below the boiler
    elseif direction == defines.direction.east then
        return { x = 1, y = 0 }  -- Position to the right of the boiler
    elseif direction == defines.direction.south then
        return { x = 0, y = 1 }  -- Position above the boiler
    elseif direction == defines.direction.west then
        return { x = -1, y = 0 } -- Position to the left of the boiler
    end
    return { x = 0, y = 0 }      -- Default offset in case of unknown direction
end

-- Define the position offset for the eg-high-voltage-pole on the opposite side of a 1x1 boiler
local function get_eg_high_voltage_pole_offset(direction)
    if direction == defines.direction.north then
        return { x = 0, y = 1 }  -- Opposite side (above) the boiler
    elseif direction == defines.direction.east then
        return { x = -1, y = 0 } -- Opposite side (left) of the boiler
    elseif direction == defines.direction.south then
        return { x = 0, y = -1 } -- Opposite side (below) the boiler
    elseif direction == defines.direction.west then
        return { x = 1, y = 0 }  -- Opposite side (right) of the boiler
    end
    return { x = 0, y = 0 }      -- Default offset in case of unknown direction
end

-- Define the position offset for the eg-low-voltage-pole based on direction for a 1x1 boiler
local function get_eg_low_voltage_pole_offset(direction)
    if direction == defines.direction.north then
        return { x = 0, y = -1 } -- Position below the boiler
    elseif direction == defines.direction.east then
        return { x = 1, y = 0 }  -- Position to the right of the boiler
    elseif direction == defines.direction.south then
        return { x = 0, y = 1 }  -- Position above the boiler
    elseif direction == defines.direction.west then
        return { x = -1, y = 0 } -- Position to the left of the boiler
    end
    return { x = 0, y = 0 }      -- Default offset in case of unknown direction
end

-- Place the electric boiler and infinity pipe with direction handling
local function on_eg_transformator_displayer_built(event)
    local entity = event.entity

    if not entity or entity.name ~= constants.EG_DISPLAYER then return end

    -- Store surface, force, position and direction
    local surface = entity.surface
    local force = entity.force
    local position = entity.position
    local direction = entity.direction
    local offset = { x = 0, y = 0 }

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
        name = "eg-high-voltage-pole",
        position = eg_high_voltage_pole_position,     --place on top of eg-boiler
        force = force,
        direction = direction
    }

    -- Calculate the offset position for the eg-low-voltage-pole based on direction
    offset = get_eg_low_voltage_pole_offset(direction)
    local eg_low_voltage_pole_position = { position.x + offset.x, position.y + offset.y }

    -- Place the eg-low-voltage-pole with the same direction as the boiler
    local eg_low_voltage_pole = surface.create_entity {
        name = "eg-low-voltage-pole",
        position = eg_low_voltage_pole_position,     --place on top of eg-steam-engine
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

    -- Track the eg_transformator components by unit_number
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
local function on_eg_transformator_displayer_mined(event)
    local entity = event.entity
    local unit_number = entity.unit_number

    if storage.eg_transformators[unit_number] then
        local eg_transformator = storage.eg_transformators[unit_number]

        -- Destroy each component if it still exists
        if eg_transformator.boiler and eg_transformator.boiler.valid then eg_transformator.boiler.destroy() end
        if eg_transformator.infinity_pipe and eg_transformator.infinity_pipe.valid then
            eg_transformator.infinity_pipe.destroy()
        end
        if eg_transformator.generator and eg_transformator.generator.valid then eg_transformator.generator.destroy() end
        if eg_transformator.high_voltage and eg_transformator.high_voltage.valid then
            eg_transformator.high_voltage.destroy()
        end
        if eg_transformator.low_voltage and eg_transformator.low_voltage.valid then eg_transformator.low_voltage.destroy() end

        -- Update storage
        storage.eg_transformators[unit_number] = nil
    end
end

-- Register events and load globals
local function register_event_handlers()
    script.on_event(defines.events.on_built_entity, on_eg_transformator_displayer_built)
    script.on_event(defines.events.on_player_mined_entity, on_eg_transformator_displayer_mined)
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
