local function find_transformator_by_pump(pump)
    if not (pump and pump.valid) then return nil end
    for _, transformator in pairs(storage.eg_transformators) do
        if transformator.pump and transformator.pump.valid and transformator.pump == pump then
            return transformator
        end
    end
    return nil
end

for _, surface in pairs(game.surfaces) do
    local old_pumps = surface.find_entities_filtered { name = { "eg-pump-1", "eg-pump-2", "eg-pump-3", "eg-pump-4", "eg-pump-5", "eg-pump-6", "eg-pump-7", "eg-pump-8", "eg-pump-9" } }
    for _, old_pump in pairs(old_pumps) do
        local position = old_pump.position
        local direction = old_pump.direction
        local force = old_pump.force
        local filter = old_pump.fluidbox.get_filter(1)

        local transformator = find_transformator_by_pump(old_pump)
        if transformator then
            local tier = string.sub(transformator.unit.name, -1)
            old_pump.destroy()

            local eg_pump = surface.create_entity {
                name = "eg-pump",
                position = position,
                direction = direction,
                force = force
            }

            if filter and filter.name and filter.name ~= "eg-fluid-disable" then
                eg_pump.fluidbox.set_filter(1, { name = "eg-water-" .. tier })
            end

            transformator.pump = eg_pump
        end
    end
end
