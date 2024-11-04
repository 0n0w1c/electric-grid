local name = "eg-transformator-displayer"
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
        return { x = 0, y = 0 } -- Opposite side (above) the boiler
    elseif direction == defines.direction.east then
        return { x = 0, y = 0 } -- Opposite side (left) of the boiler
    elseif direction == defines.direction.south then
        return { x = 0, y = 0 } -- Opposite side (below) the boiler
    elseif direction == defines.direction.west then
        return { x = 0, y = 0 }    -- Opposite side (right) of the boiler
    end
    return { x = 0, y = 0 }        -- Default offset in case of unknown direction
    --[[
    if direction == defines.direction.north then
        return { x = 0, y = 0.5 }  -- Opposite side (above) the boiler
    elseif direction == defines.direction.east then
        return { x = -0.5, y = 0 } -- Opposite side (left) of the boiler
    elseif direction == defines.direction.south then
        return { x = 0, y = -0.5 } -- Opposite side (below) the boiler
    elseif direction == defines.direction.west then
        return { x = 0.5, y = 0 }  -- Opposite side (right) of the boiler
    end
    return { x = 0, y = 0 }        -- Default offset in case of unknown direction
]]
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
    if not entity then
        game.print("Error: entity is nil.")
        return
    end

    if entity.name == name then
        -- Capture position, surface, force, and direction information
        local surface = entity.surface
        local position = entity.position
        local force = entity.force
        local direction = entity.direction -- Get the direction of the displayer

        -- Remove the displayer
        entity.destroy()

        local eg_unit = surface.create_entity {
            name = "eg-transformator-1-unit",
            position = position,
            force = force,
            direction = direction
        }

        -- Place the eg-boiler with the same direction as the displayer
        local eg_boiler = surface.create_entity {
            name = "eg-boiler-1",
            position = position,
            force = force,
            direction = direction
        }

        -- Calculate the offset position for the eg-infinity-pipe based on direction
        local offset = get_eg_infinity_pipe_offset(direction)
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
            position = eg_high_voltage_pole_position, --place on top of eg-boiler
            force = force,
            direction = direction
        }

        -- Calculate the offset position for the eg-low-voltage-pole based on direction
        offset = get_eg_low_voltage_pole_offset(direction)
        local eg_low_voltage_pole_position = { position.x + offset.x, position.y + offset.y }

        -- Place the eg-low-voltage-pole with the same direction as the boiler
        local eg_low_voltage_pole = surface.create_entity {
            name = "eg-low-voltage-pole",
            position = eg_low_voltage_pole_position, --place on top of eg-steam-engine
            force = force,
            direction = direction
        }

        -- Let the water flow
        eg_infinity_pipe.set_infinity_pipe_filter({
            name = "eg-water-1",
            percentage = 1,
            temperature = 15,
            mode = "at-least"
        })

        -- Track components together as a eg_transformators
        eg_transformators[#eg_transformators + 1] = {
            unit = eg_unit,
            boiler = eg_boiler,
            infinity_pipe = eg_infinity_pipe,
            generator = eg_steam_engine,
            high_voltage = eg_high_voltage_pole,
            low_voltage = eg_low_voltage_pole
        }
        storage.eg_transformators = eg_transformators -- Update storage after modification
    end
end

-- Remove both the boiler and infinity pipe when the eg_transformator displayer is mined
local function on_eg_transformator_displayer_mined(event)
    local entity = event.entity
    if entity.name == name then
        -- Remove the associated boiler and infinity pipe from storage tracking
        for index, eg_transformator in pairs(eg_transformators) do
            if eg_transformator.boiler.valid then eg_transformator.boiler.destroy() end
            if eg_transformator.infinity_pipe.valid then eg_transformator.infinity_pipe.destroy() end
            if eg_transformator.generator.valid then eg_transformator.generator.destroy() end
            if eg_transformator.high_voltage.valid then eg_transformator.high_voltage.destroy() end
            if eg_transformator.low_voltage.valid then eg_transformator.low_voltage.destroy() end
            table.remove(eg_transformators, index)
            break
        end
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
