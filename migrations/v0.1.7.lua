if storage and storage.eg_transformators then
    local updated_transformators = {}

    for _, transformator in pairs(storage.eg_transformators) do
        if transformator.generator and transformator.generator.valid
            and transformator.unit and transformator.unit.valid then
            local unit_number = transformator.unit.unit_number
            local steam_engine = transformator.generator
            if steam_engine then
                transformator.steam_engine = steam_engine
                transformator.generator = nil
                updated_transformators[unit_number] = transformator
            end
        end
    end

    storage.eg_transformators = updated_transformators
end
