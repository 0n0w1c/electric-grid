if storage and storage.eg_transformators then
    local updated_transformators = {}

    for _, transformator in pairs(storage.eg_transformators) do
        if transformator.unit and transformator.unit.valid then
            local unit_number = transformator.unit.unit_number
            if unit_number then
                updated_transformators[unit_number] = transformator
            end
        end
    end

    storage.eg_transformators = updated_transformators
end
