local name = "transformer-displayer"
local transformers

-- Initialize global memory structures and event handlers
local function initialize_globals()
    storage = storage or {}
    transformers = storage.transformers or {}
    storage.transformers = transformers -- Persist transformers in storage
end

-- Handle loading globals when the game is loaded
local function load_globals()
    transformers = storage.transformers
end

-- Define the position offset for the infinity pipe based on direction with 90-degree rotation
local function get_infinity_pipe_offset(direction)
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
local function get_steam_generator_offset(direction)
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
local function on_transformer_displayer_built(event)
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
        game.print("Displayer destroyed.") -- Debugging confirmation

        -- Place the electric boiler with the same direction as the displayer
        local boiler = surface.create_entity {
            name = "electric-boiler",
            position = position,
            force = force,
            direction = direction
        }

        -- Calculate the offset position for the infinity pipe based on direction
        local offset = get_infinity_pipe_offset(direction)
        local infinity_pipe_position = { position.x + offset.x, position.y + offset.y }

        -- Place the electric infinity pipe with the same direction as the boiler
        local infinity_pipe = surface.create_entity {
            name = "electric-infinity-pipe",
            position = infinity_pipe_position,
            force = force,
            direction = direction
        }

        -- Track the boiler and infinity pipe together as a transformer
        transformers[#transformers + 1] = { boiler = boiler, infinity_pipe = infinity_pipe }
        storage.transformers = transformers -- Update storage after modification
    end
end

-- Remove both the boiler and infinity pipe when the transformer displayer is mined
local function on_transformer_displayer_mined(event)
    local entity = event.entity
    if entity.name == name then
        -- Remove the associated boiler and infinity pipe from storage tracking
        for i, transformer in pairs(transformers) do
            if transformer.boiler.valid then transformer.boiler.destroy() end
            if transformer.infinity_pipe.valid then transformer.infinity_pipe.destroy() end
            table.remove(transformers, i)
            break
        end
    end
end

-- Register events and load globals
local function register_event_handlers()
    script.on_event(defines.events.on_built_entity, on_transformer_displayer_built)
    script.on_event(defines.events.on_player_mined_entity, on_transformer_displayer_mined)
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
