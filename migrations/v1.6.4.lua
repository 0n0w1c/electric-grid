--- Find the transformator associated with a given pump
-- @param pump LuaEntity The pump entity to check
-- @return table|nil The transformator object if found, nil otherwise
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
    local old_pumps = surface.find_entities_filtered { name = "eg-pump" }
    for _, old_pump in pairs(old_pumps) do
        local position = old_pump.position
        local direction = old_pump.direction
        local force = old_pump.force

        local transformator = find_transformator_by_pump(old_pump)
        if transformator then
            local tier = transformator and string.sub(transformator.unit.name, -1) or "1"

            old_pump.destroy()

            local eg_pump = surface.create_entity {
                name = "eg-pump-" .. tier,
                position = position,
                direction = direction,
                force = force
            }

            transformator.pump = eg_pump
        end
    end
end
