local visibility = {}

visibility.hidden_if_mod_present = {
    ["bobpower"] = {
        ["eg-transformators-only"] = true,
        ["eg-medium-pole-lights"] = true,
        ["eg-big-pole-lights"] = true,
        ["eg-huge-pole-lights"] = true,
        ["eg-circuit-pole-lights"] = true,
        ["eg-max-wire-small"] = true,
        ["eg-max-supply-small"] = true,
        ["eg-max-wire-small-iron"] = true,
        ["eg-max-supply-small-iron"] = true,
        ["eg-max-wire-medium"] = true,
        ["eg-max-wire-big"] = true,
        ["eg-max-wire-huge"] = true,
        ["eg-max-wire-substation"] = true,
        ["eg-max-supply-substation"] = true,
    },

    ["PowerOverload"] = {
        ["eg-max-wire-small-iron"] = true,
        ["eg-max-supply-small-iron"] = true,
    },

    ["Engineersvsenvironmentalist-redux"] = {
        ["eg-max-wire-small"] = true,
        ["eg-max-supply-small"] = true,
        ["eg-max-wire-medium"] = true,
        ["eg-max-wire-big"] = true,
        ["eg-max-wire-substation"] = true,
        ["eg-max-supply-substation"] = true,
    }
}

visibility.hidden_if_mod_missing = {
    ["Subsurface"] = {
        ["eg-max-wire-wooden-support"] = true,
        ["eg-max-supply-wooden-support"] = true,
        ["eg-max-wire-steel-support"] = true,
    }
}

function visibility.is_setting_hidden(setting_name)
    for mod_name, hidden_settings in pairs(visibility.hidden_if_mod_present) do
        if mods[mod_name] and hidden_settings[setting_name] then
            return true
        end
    end

    for mod_name, hidden_settings in pairs(visibility.hidden_if_mod_missing) do
        if not mods[mod_name] and hidden_settings[setting_name] then
            return true
        end
    end

    return false
end

return visibility
