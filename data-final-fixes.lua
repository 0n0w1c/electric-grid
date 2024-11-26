if settings.startup["eg-max-wire-small"] and settings.startup["eg-max-wire-small"].value then
    data.raw["electric-pole"]["small-electric-pole"].maximum_wire_distance =
        tonumber(settings.startup["eg-max-wire-small"].value)
end
if settings.startup["eg-max-wire-medium"] and settings.startup["eg-max-wire-medium"].value then
    data.raw["electric-pole"]["medium-electric-pole"].maximum_wire_distance =
        tonumber(settings.startup["eg-max-wire-medium"].value)
end
if settings.startup["eg-max-wire-big"] and settings.startup["eg-max-wire-big"].value then
    data.raw["electric-pole"]["big-electric-pole"].maximum_wire_distance =
        tonumber(settings.startup["eg-max-wire-big"].value)
end
if settings.startup["eg-max-wire-huge"] and settings.startup["eg-max-wire-huge"].value then
    data.raw["electric-pole"]["eg-huge-electric-pole"].maximum_wire_distance =
        tonumber(settings.startup["eg-max-wire-huge"].value)
end
if settings.startup["eg-max-wire-substation"] and settings.startup["eg-max-wire-substation"].value then
    data.raw["electric-pole"]["substation"].maximum_wire_distance =
        tonumber(settings.startup["eg-max-wire-substation"].value)

    data.raw["electric-pole"]["eg-ugp-substation"].maximum_wire_distance =
        data.raw["electric-pole"]["substation"].maximum_wire_distance
end

if settings.startup["eg-max-wire-transformator"] and settings.startup["eg-max-wire-transformator"].value then
    for _, pole in pairs(data.raw["electric-pole"]) do
        if string.sub(pole.name, 1, 20) == "eg_high_voltage_pole" or string.sub(pole.name, 1, 19) == "eg_low_voltage_pole" then
            pole.maximum_wire_distance = tonumber(settings.startup["eg-max-wire-transformator"].value)
        end
    end
end
