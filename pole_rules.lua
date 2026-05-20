local pole_rules = {}

local function tag_set(tags)
    local set = {}
    for _, tag in ipairs(tags or {}) do set[tag] = true end
    return set
end

local function pole(class, tags)
    return { class = class, tags = tag_set(tags) }
end

pole_rules.poles = {
    -- Electric Grid / vanilla
    ["small-electric-pole"] = pole("distribution_small", { "vanilla", "distribution" }),
    ["small-iron-electric-pole"] = pole("distribution_small", { "electric-grid", "aai-industry", "distribution" }),
    ["medium-electric-pole"] = pole("transmission_medium", { "vanilla", "transmission" }),
    ["big-electric-pole"] = pole("transmission_big", { "vanilla", "transmission" }),
    ["substation"] = pole("distribution_substation", { "vanilla", "distribution" }),
    ["eg-ugp-small-electric-pole"] = pole("distribution_small", { "electric-grid", "underground", "distribution" }),
    ["eg-ugp-substation"] = pole("distribution_substation", { "electric-grid", "underground", "distribution" }),
    ["eg-circuit-pole"] = pole("utility_circuit", { "electric-grid", "utility" }),
    ["eg-huge-electric-pole"] = pole("transmission_huge_eg", { "electric-grid", "transmission", "huge" }),

    -- Engineers vs environmentalist redux
    ["medium-electric-pole-2"] = pole("transmission_medium", { "engineersvsenvironmentalist-redux", "transmission" }),
    ["medium-electric-pole-3"] = pole("transmission_medium", { "engineersvsenvironmentalist-redux", "transmission" }),
    ["medium-electric-pole-4"] = pole("transmission_medium", { "engineersvsenvironmentalist-redux", "transmission" }),
    ["big-electric-pole-2"] = pole("transmission_big", { "engineersvsenvironmentalist-redux", "transmission" }),
    ["big-electric-pole-3"] = pole("transmission_big", { "engineersvsenvironmentalist-redux", "transmission" }),
    ["big-electric-pole-4"] = pole("transmission_big", { "engineersvsenvironmentalist-redux", "transmission" }),
    ["substation-2"] = pole("distribution_substation", { "engineersvsenvironmentalist-redux", "distribution" }),
    ["substation-3"] = pole("distribution_substation", { "engineersvsenvironmentalist-redux", "distribution" }),
    ["substation-4"] = pole("distribution_substation", { "engineersvsenvironmentalist-redux", "distribution" }),

    -- Factorio Plus / Fix large electric pole
    ["medium-wooden-electric-pole"] = pole("distribution_small", { "factorioplus", "distribution" }),
    ["electrical-distributor"] = pole("big_endpoint", { "factorioplus", "distribution" }),
    ["huge-electric-pole"] = pole("transmission_huge_factorioplus", { "factorioplus", "transmission", "huge" }),
    ["large-electric-pole"] = pole("transmission_huge_large", { "fixLargeElectricPole", "transmission", "huge" }),

    -- Cargo ships / offshore resources
    ["floating-electric-pole"] = pole("floating_endpoint", { "cargo-ships", "water", "transmission" }),
    ["or_pole"] = pole("distribution_small", { "cargo-ships", "offshore-resources", "distribution" }),

    -- James' electric trains plus / minimalist rails
    ["james-rail-pole"] = pole("rail_power", { "james-electric-trains-plus", "rail" }),
    ["james-track-pole"] = pole("rail_track", { "james-electric-trains-plus", "rail" }),
    ["hidden-rail-pole"] = pole("rail_hidden", { "minimalist-rails", "rail", "transmission" }),
    ["hidden-rail-pole-invisible"] = pole("rail_hidden", { "minimalist-rails", "rail", "transmission" }),

    -- Subsurface
    ["wooden-support"] = pole("subsurface_wooden_support", { "subsurface", "distribution" }),
    ["steel-support"] = pole("subsurface_steel_support", { "subsurface", "transmission" }),
    ["tunnel-entrance-cable"] = pole("subsurface_entrance", { "subsurface", "utility" }),
    ["tunnel-exit-cable"] = pole("subsurface_exit", { "subsurface", "utility" }),

    -- Dredgeworks
    ["wire-buoy"] = pole("water_transmission_tap", { "dredgeworks", "water", "transmission" }),

    -- Energy combinator
    ["power-combinator-meter-network"] = pole("meter_network", { "energy-combinator", "utility" }),

    -- Power Overload
    ["po-interface"] = pole("po_interface", { "PowerOverload", "utility" }),
    ["po-small-electric-fuse"] = pole("po_small_fuse", { "PowerOverload", "fuse" }),
    ["po-medium-electric-fuse"] = pole("po_medium_fuse", { "PowerOverload", "fuse" }),
    ["po-big-electric-fuse"] = pole("po_big_fuse", { "PowerOverload", "fuse" }),
    ["po-substation-fuse"] = pole("po_substation_fuse", { "PowerOverload", "fuse" }),
    ["po-huge-electric-fuse"] = pole("po_huge_fuse", { "PowerOverload", "fuse" }),
    ["po-hidden-electric-pole-in"] = pole("po_hidden_link", { "PowerOverload", "hidden" }),
    ["po-hidden-electric-pole-out"] = pole("po_hidden_link", { "PowerOverload", "hidden" }),
    ["po-huge-electric-pole"] = pole("transmission_huge_po", { "PowerOverload", "transmission", "huge" }),

    -- Krastorio 2
    ["kr-superior-substation"] = pole("distribution_substation", { "Krastorio2", "distribution" }),

    -- Bio Industries
    ["bi-wooden-pole-big"] = pole("transmission_big", { "Bio_Industries_2", "transmission" }),
    ["bi-wooden-pole-huge"] = pole("transmission_huge_bio", { "Bio_Industries_2", "transmission", "huge" }),

    -- Industrial Revolution 3 assets
    ["small-bronze-pole"] = pole("distribution_small", { "IR3_Assets_bronze", "distribution" }),
    ["small-iron-pole"] = pole("distribution_small", { "IR3_Assets_power", "distribution" }),
    ["medium-steel-pole"] = pole("transmission_medium", { "IR3_Assets_power", "transmission" }),
    ["big-wooden-pole"] = pole("transmission_medium", { "IR3_Assets_power", "transmission" }),

    -- Hypercell substation
    ["snouz_better_substation"] = pole("distribution_substation", { "snouz_better_substation", "distribution" }),
}

local class_allows = {
    distribution_small = {
        distribution_small = true,
        transmission_medium = true,
        rail_power = true,
        po_small_fuse = true,
        meter_network = true,
    },
    transmission_medium = {
        distribution_small = true,
        transmission_medium = true,
        transmission_big = true,
        rail_power = true,
        rail_hidden = true,
        subsurface_wooden_support = true,
        subsurface_entrance = true,
        water_transmission_tap = true,
        po_small_fuse = true,
        po_medium_fuse = true,
        po_hidden_link = true,
        meter_network = true,
    },
    transmission_big = {
        transmission_medium = true,
        transmission_big = true,
        distribution_substation = true,
        utility_circuit = true,
        floating_endpoint = true,
        big_endpoint = true,
        rail_hidden = true,
        subsurface_entrance = true,
        po_medium_fuse = true,
        po_big_fuse = true,
        po_substation_fuse = true,
        po_hidden_link = true,
        meter_network = true,
    },
    distribution_substation = {
        distribution_substation = true,
        transmission_big = true,
        po_substation_fuse = true,
        meter_network = true,
    },
    transmission_huge_eg = {
        transmission_huge_eg = true,
        transmission_huge_bio = true,
        po_hidden_link = true,
        meter_network = true,
    },
    transmission_huge_factorioplus = {
        transmission_huge_factorioplus = true,
        transmission_huge_bio = true,
        po_hidden_link = true,
        meter_network = true,
    },
    transmission_huge_po = {
        transmission_huge_po = true,
        transmission_huge_bio = true,
        po_huge_fuse = true,
        po_hidden_link = true,
        meter_network = true,
    },
    transmission_huge_large = {
        transmission_huge_large = true,
        po_hidden_link = true,
        meter_network = true,
    },
    transmission_huge_bio = {
        transmission_huge_bio = true,
        transmission_huge_eg = true,
        transmission_huge_factorioplus = true,
        transmission_huge_po = true,
        po_hidden_link = true,
        meter_network = true,
    },
    utility_circuit = {
        utility_circuit = true,
        transmission_big = true,
    },
    floating_endpoint = {
        floating_endpoint = true,
        distribution_small = true,
        transmission_big = true,
    },
    big_endpoint = {
        transmission_big = true,
        meter_network = true,
    },
    rail_power = {
        rail_power = true,
        rail_track = true,
        transmission_medium = true,
        distribution_small = true,
    },
    rail_track = {
        rail_power = true,
        rail_track = true,
    },
    rail_hidden = {
        rail_hidden = true,
        transmission_medium = true,
        transmission_big = true,
    },
    subsurface_wooden_support = {
        subsurface_wooden_support = true,
        subsurface_steel_support = true,
        transmission_medium = true,
    },
    subsurface_steel_support = {
        subsurface_wooden_support = true,
        subsurface_steel_support = true,
        subsurface_exit = true,
    },
    subsurface_entrance = {
        transmission_medium = true,
        transmission_big = true,
    },
    subsurface_exit = {
        subsurface_steel_support = true,
    },
    water_transmission_tap = {
        water_transmission_tap = true,
        transmission_medium = true,
    },
    meter_network = {
        distribution_small = true,
        transmission_medium = true,
        transmission_big = true,
        transmission_huge_eg = true,
        transmission_huge_factorioplus = true,
        transmission_huge_po = true,
        transmission_huge_large = true,
        transmission_huge_bio = true,
        distribution_substation = true,
        big_endpoint = true,
    },
    po_interface = {
        po_huge_fuse = true,
    },
    po_small_fuse = {
        distribution_small = true,
        transmission_medium = true,
        po_hidden_link = true,
    },
    po_medium_fuse = {
        transmission_medium = true,
        transmission_big = true,
        po_hidden_link = true,
    },
    po_big_fuse = {
        transmission_big = true,
        distribution_substation = true,
        po_hidden_link = true,
    },
    po_substation_fuse = {
        distribution_substation = true,
        transmission_big = true,
        po_hidden_link = true,
    },
    po_huge_fuse = {
        transmission_huge_po = true,
        po_interface = true,
        po_hidden_link = true,
    },
    po_hidden_link = {
        po_hidden_link = true,
        transmission_medium = true,
        transmission_big = true,
        transmission_huge_eg = true,
        transmission_huge_factorioplus = true,
        transmission_huge_po = true,
        transmission_huge_large = true,
        transmission_huge_bio = true,
        po_small_fuse = true,
        po_medium_fuse = true,
        po_big_fuse = true,
        po_substation_fuse = true,
        po_huge_fuse = true,
    },
}


pole_rules.explicit_deny = {
    ["power-combinator-meter-network"] = {
        ["power-combinator-meter-network"] = true,
    },
}

local function has_prefix(name, prefix)
    return string.sub(name, 1, string.len(prefix)) == prefix
end

function pole_rules.get_class(name)
    local def = pole_rules.poles[name]
    return def and def.class or nil
end

function pole_rules.is_transmission(name)
    local def = pole_rules.poles[name]
    if not def then return false end
    return (def.tags and def.tags.transmission) or
        def.class == "transmission_medium" or
        def.class == "transmission_big" or
        def.class == "transmission_huge_eg" or
        def.class == "transmission_huge_factorioplus" or
        def.class == "transmission_huge_po" or
        def.class == "transmission_huge_large" or
        def.class == "transmission_huge_bio"
end

function pole_rules.is_huge(name)
    local def = pole_rules.poles[name]
    return def and def.tags and def.tags.huge == true
end

function pole_rules.is_power_overload_fuse(name)
    return has_prefix(name, "po-") and string.find(name, "-fuse", 1, true) ~= nil
end

local function classes_can_connect(class_a, class_b)
    return class_a and class_b and class_allows[class_a] and class_allows[class_a][class_b] == true
end

function pole_rules.can_connect(name_a, name_b, surface_name, is_transformator_a, is_transformator_b)
    if not (name_a and name_b) then return false end

    if pole_rules.explicit_deny[name_a] and pole_rules.explicit_deny[name_a][name_b] then return false end
    if pole_rules.explicit_deny[name_b] and pole_rules.explicit_deny[name_b][name_a] then return false end

    local class_a = pole_rules.get_class(name_a)
    local class_b = pole_rules.get_class(name_b)
    local is_transmission_a = pole_rules.is_transmission(name_a)
    local is_transmission_b = pole_rules.is_transmission(name_b)
    local is_huge_a = pole_rules.is_huge(name_a)
    local is_huge_b = pole_rules.is_huge(name_b)

    if surface_name == "fulgora" then
        if is_transmission_a and is_transmission_b then return true end
        if (is_transmission_a and is_huge_b) or (is_transmission_b and is_huge_a) then return true end
        if is_huge_a and is_huge_b then return true end
    end

    if is_transformator_a and is_transformator_b then return true end
    if (is_transformator_a and is_transmission_b) or (is_transformator_b and is_transmission_a) then return true end
    if (is_transformator_a and is_huge_b) or (is_transformator_b and is_huge_a) then return true end
    if (is_transformator_a and class_b == "po_interface") or (is_transformator_b and class_a == "po_interface") then return true end
    if (is_transformator_a and pole_rules.is_power_overload_fuse(name_b)) or
        (is_transformator_b and pole_rules.is_power_overload_fuse(name_a)) then
        return true
    end

    if classes_can_connect(class_a, class_b) or classes_can_connect(class_b, class_a) then return true end

    local is_proxy_a = has_prefix(name_a, "electric-proxy-")
    local is_proxy_b = has_prefix(name_b, "electric-proxy-")
    local is_f077et_a = has_prefix(name_a, "F077ET-")
    local is_f077et_b = has_prefix(name_b, "F077ET-")

    if is_proxy_a and is_proxy_b then return true end
    if is_f077et_a and is_f077et_b then return true end
    if (is_huge_a and is_proxy_b) or (is_huge_b and is_proxy_a) then return false end
    if (is_huge_a and is_f077et_b) or (is_huge_b and is_f077et_a) then return false end
    if (is_transmission_a and is_proxy_b) or (is_transmission_b and is_proxy_a) then return true end
    if (is_transmission_a and is_f077et_b) or (is_transmission_b and is_f077et_a) then return true end

    return false
end

return pole_rules
