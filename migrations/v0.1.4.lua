if storage and storage.eg_transformators then
    local updated_transformators = {}

    -- Reindex with key = unit.unit_number
    for _, transformator in pairs(storage.eg_transformators) do
        if transformator.unit and transformator.unit.valid and transformator.unit.unit_number then
            local unit_number = transformator.unit.unit_number
            updated_transformators[unit_number] = transformator
        end
    end

    storage.eg_transformators = updated_transformators
end
