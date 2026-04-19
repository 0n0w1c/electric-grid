if mods["quality"] then
    recycling = require("__quality__/prototypes/recycling")
end

local items        = data.raw["item"]
local recipes      = data.raw["recipe"]
local technologies = data.raw["technology"]
local poles        = data.raw["electric-pole"]

local small_pole   = poles["small-electric-pole"]
local medium_pole  = poles["medium-electric-pole"]
local big_pole     = poles["big-electric-pole"]
local substation   = poles["substation"]

local function apply_medium_pole_settings(pole)
    if not pole then return end
    pole.supply_area_distance  = 0
    pole.maximum_wire_distance = constants.EG_MAX_WIRE_MEDIUM
    pole.light                 = constants.EG_MEDIUM_POLE_LIGHTS and constants.EG_MEDIUM_POLE_LIGHT or nil
end

local function apply_big_pole_settings(pole)
    if not pole then return end
    pole.supply_area_distance  = 0
    pole.maximum_wire_distance = constants.EG_MAX_WIRE_BIG
    pole.light                 = constants.EG_BIG_POLE_LIGHTS and constants.EG_BIG_POLE_LIGHT or nil
end

local function apply_substation_settings(pole)
    if not pole then return end
    pole.maximum_wire_distance = constants.EG_MAX_WIRE_SUBSTATION
    pole.supply_area_distance  = constants.EG_MAX_SUPPLY_SUBSTATION
end

local function apply_transmission_pole_only(pole)
    if not pole then return end
    pole.supply_area_distance = 0
    if string.sub(pole.name, 1, 6) == "medium" then
        pole.light = constants.EG_MEDIUM_POLE_LIGHTS and constants.EG_MEDIUM_POLE_LIGHT or nil
    elseif string.sub(pole.name, 1, 3) == "big" then
        pole.light = constants.EG_BIG_POLE_LIGHTS and constants.EG_BIG_POLE_LIGHT or nil
    end
end

local function shift_big_pole_visuals(pole)
    if not (pole and pole.pictures and pole.pictures.layers) then return end

    for _, layer in pairs(pole.pictures.layers) do
        layer.shift = layer.shift or { 0, 0 }
        layer.shift[2] = layer.shift[2] + 0.3
    end

    if pole.connection_points then
        for _, connection in pairs(pole.connection_points) do
            for _, point in ipairs({ "wire", "shadow" }) do
                if connection[point] then
                    for _, color in pairs({ "red", "green", "copper" }) do
                        if connection[point][color] then
                            connection[point][color][2] = connection[point][color][2] + 0.3
                        end
                    end
                end
            end
        end
    end
end

small_pole.maximum_wire_distance = constants.EG_MAX_WIRE_SMALL
small_pole.supply_area_distance  = constants.EG_MAX_SUPPLY_SMALL

apply_medium_pole_settings(medium_pole)
apply_big_pole_settings(big_pole)
apply_substation_settings(substation)

if not substation.next_upgrade and poles["eg-ugp-substation-displayer"] then
    substation.next_upgrade = "eg-ugp-substation-displayer"
end

if recipes["eg-huge-electric-pole"] then
    local technology = technologies["eg-tech-1"]
    table.insert(technology.effects, { type = "unlock-recipe", recipe = "eg-huge-electric-pole" })
end

for _, pole in pairs(poles) do
    pole.rewire_neighbours_when_destroying = false
end

shift_big_pole_visuals(big_pole)

if mods["Engineersvsenvironmentalist-redux"] then
    apply_transmission_pole_only(poles["medium-electric-pole-2"])
    apply_transmission_pole_only(poles["medium-electric-pole-3"])
    apply_transmission_pole_only(poles["medium-electric-pole-4"])

    apply_transmission_pole_only(poles["big-electric-pole-2"])
    apply_transmission_pole_only(poles["big-electric-pole-3"])
    apply_transmission_pole_only(poles["big-electric-pole-4"])

    shift_big_pole_visuals(poles["big-electric-pole-2"])
    shift_big_pole_visuals(poles["big-electric-pole-3"])
    shift_big_pole_visuals(poles["big-electric-pole-4"])
end

if mods["Subsurface"] then
    local wooden_support                 = poles["wooden-support"]
    wooden_support.maximum_wire_distance = constants.EG_MAX_WIRE_WOODEN_SUPPORT
    wooden_support.supply_area_distance  = constants.EG_MAX_SUPPLY_WOODEN_SUPPORT

    local steel_support                  = poles["steel-support"]
    steel_support.maximum_wire_distance  = constants.EG_MAX_WIRE_STEEL_SUPPORT
    steel_support.supply_area_distance   = 0
end

items["small-electric-pole"].subgroup           = constants.EG_SUBGROUP
items["medium-electric-pole"].subgroup          = constants.EG_SUBGROUP
items["big-electric-pole"].subgroup             = constants.EG_SUBGROUP
items["substation"].subgroup                    = constants.EG_SUBGROUP

data.raw["power-switch"]["power-switch"].hidden = true
items["power-switch"].hidden                    = true
recipes["power-switch"].hidden                  = true

if not mods["aai-industry"] and recipes["small-iron-electric-pole"] then
    table.insert(technologies["electronics"].effects,
        { type = "unlock-recipe", recipe = "small-iron-electric-pole" })
end

if mods["PowerOverload"] then
    local po_huge_pole                          = poles["po-huge-electric-pole"]
    po_huge_pole.light                          = constants.EG_HUGE_POLE_LIGHTS and
        constants.EG_HUGE_POLE_LIGHT or nil
    po_huge_pole.maximum_wire_distance          = tonumber(settings.startup["eg-max-wire-huge"].value)
    po_huge_pole.drawing_box_vertical_extension = 3

    items["po-huge-electric-pole"].subgroup     = constants.EG_SUBGROUP
    items["po-interface"].subgroup              = constants.EG_SUBGROUP

    items["po-transformer"].subgroup            = constants.EG_SUBGROUP
    items["po-transformer-high"].subgroup       = constants.EG_SUBGROUP
    items["po-transformer-low"].subgroup        = constants.EG_SUBGROUP

    if mods["quality"] then
        recipes["po-transformer-recycling"].hidden = true
    end

    for _, pole in pairs(poles) do
        if string.sub(pole.name, 1, 3) == "po-" and string.find(pole.name, "-fuse") then
            items[pole.name].subgroup = constants.EG_SUBGROUP
        end
    end

    technologies["po-electric-energy-distribution-3"].hidden = true

    table.insert(technologies["eg-tech-1"].effects, { type = "unlock-recipe", recipe = "po-huge-electric-pole" })

    table.insert(technologies["electric-energy-distribution-2"].effects,
        { type = "unlock-recipe", recipe = "po-interface" })
end

if mods["factorioplus"] then
    local effects = technologies["electric-energy-distribution-3"].effects
    if effects then
        for i, effect in ipairs(effects) do
            if effect.type == "unlock-recipe" and effect.recipe == "huge-electric-pole" then
                table.remove(effects, i)
                break
            end
        end
    end

    local huge_pole = poles["huge-electric-pole"]

    huge_pole.supply_area_distance = 0
    huge_pole.maximum_wire_distance = tonumber(settings.startup["eg-max-wire-huge"].value)

    items["medium-wooden-electric-pole"].subgroup = constants.EG_SUBGROUP
    items["huge-electric-pole"].subgroup = constants.EG_SUBGROUP
    items["electrical-distributor"].subgroup = constants.EG_SUBGROUP

    table.insert(data.raw["technology"]["electric-energy-distribution-1"].effects,
        { type = "unlock-recipe", recipe = "huge-electric-pole" })
end

if mods["Bio_Industries_2"] then
    poles["bi-wooden-pole-big"].supply_area_distance = 0
    items["bi-wooden-pole-big"].subgroup = constants.EG_SUBGROUP

    poles["bi-wooden-pole-huge"].supply_area_distance = 0
    items["bi-wooden-pole-huge"].subgroup = constants.EG_SUBGROUP
end

if mods["aai-industry"] then
    local small_iron_pole = poles["small-iron-electric-pole"]
    if small_iron_pole then
        local small_iron_pole_item            = items["small-iron-electric-pole"]
        small_iron_pole_item.subgroup         = constants.EG_SUBGROUP

        small_iron_pole.maximum_wire_distance = constants.EG_MAX_WIRE_SMALL_IRON
        small_iron_pole.supply_area_distance  = constants.EG_MAX_SUPPLY_SMALL_IRON
    end

    local huge_pole_recipe = recipes["eg-huge-electric-pole"]
    if huge_pole_recipe then
        huge_pole_recipe.ingredients =
        {
            { type = "item", name = "steel-plate",  amount = 8 },
            { type = "item", name = "iron-stick",   amount = 12 },
            { type = "item", name = "copper-cable", amount = 20 },
            { type = "item", name = "concrete",     amount = 2 }
        }

        if mods["quality"] then
            recycling.generate_recycling_recipe(huge_pole_recipe)
        end
    end
end

if mods["cargo-ships"] and items["floating-electric-pole"] then
    items["floating-electric-pole"].subgroup = constants.EG_SUBGROUP
end

if mods["Krastorio2"] or mods["Krastorio2-spaced-out"] then
    local item = items["kr-superior-substation"]
    if item then
        item.order = items["substation"].order .. "y"
        item.subgroup = constants.EG_SUBGROUP
    end
end

if mods["energy-combinator"] then
    local pole = poles["power-combinator-meter-network"]
    if pole then pole.auto_connect_up_to_n_wires = 1 end
end

if mods["Foundations"] and items["F077ET-esp-foundation"] then
    items["F077ET-esp-foundation"].subgroup = constants.EG_SUBGROUP
end

if mods["fixLargeElectricPole"] then
    local item = data.raw["item-with-entity-data"]["large-electric-pole"]
    if item then
        item.subgroup = constants.EG_SUBGROUP
    end

    local recipe = recipes["large-electric-pole"]
    if recipe then
        recipe.subgroup = constants.EG_SUBGROUP
    end
end

if mods["IR3_Assets_bronze"] then
    local item = data.raw["item"]["small-bronze-pole"]
    if item then
        item.subgroup = constants.EG_SUBGROUP
    end

    local recipe = recipes["small-bronze-pole"]
    if recipe then
        recipe.subgroup = constants.EG_SUBGROUP
    end
end

if mods["IR3_Assets_power"] and settings.startup["IR3-enable-electric-poles"].value then
    local item = data.raw["item"]["small-iron-pole"]
    if item then
        item.subgroup = constants.EG_SUBGROUP
    end

    local recipe = recipes["small-iron-pole"]
    if recipe then
        recipe.subgroup = constants.EG_SUBGROUP
    end

    local medium_steel_pole                = poles["medium-steel-pole"]
    medium_steel_pole.supply_area_distance = 0

    item                                   = items["medium-steel-pole"]
    if item then
        item.subgroup = constants.EG_SUBGROUP
    end

    recipe = recipes["medium-steel-pole"]
    if recipe then
        recipe.subgroup = constants.EG_SUBGROUP
    end

    local big_wooden_pole                = poles["big-wooden-pole"]
    big_wooden_pole.supply_area_distance = 0

    item                                 = items["big-wooden-pole"]
    if item then
        item.subgroup = constants.EG_SUBGROUP
    end

    recipe = recipes["big-wooden-pole"]
    if recipe then
        recipe.subgroup = constants.EG_SUBGROUP
    end
end
