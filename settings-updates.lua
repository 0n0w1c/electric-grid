if mods["PowerOverload"] then
    if data.raw["double-setting"]["power-overload-transformer-efficiency"] then
        data.raw["double-setting"]["power-overload-transformer-efficiency"].hidden = true
    end

    local string_settings = data.raw["string-setting"]
    for _, setting in pairs(string_settings) do
        if string.sub(setting.name, 1, 25) == "power-overload-max-power-" and string.sub(setting.name, -5) == "-fuse" then
            setting.hidden = true
        end
    end
end
