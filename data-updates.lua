local recycling
if mods["quality"] then
    recycling = require("__quality__/prototypes/recycling")
end

local items        = data.raw["item"]
local recipes      = data.raw["recipe"]
local technologies = data.raw["technology"]
local poles        = data.raw["electric-pole"]

local base_to_eg   = table.deepcopy(constants.EG_BASE_TO_EG_POLES)

local function clone_base_pole(base_name, eg_name)
    local base_pole = poles[base_name]
    local base_item = items[base_name]
    local base_recipe = recipes[base_name]
    if not (base_pole and base_item and base_recipe) then return end

    local pole = table.deepcopy(base_pole)
    pole.name = eg_name
    pole.localised_name = { "entity-name." .. base_name }
    if pole.minable and pole.minable.result == base_name then
        pole.minable.result = eg_name
    end
    if pole.placeable_by and pole.placeable_by.item == base_name then
        pole.placeable_by.item = eg_name
    end

    local item = table.deepcopy(base_item)
    item.name = eg_name
    item.place_result = eg_name

    local recipe = table.deepcopy(base_recipe)
    recipe.name = eg_name
    if recipe.main_product == base_name then
        recipe.main_product = eg_name
    end

    for _, result in pairs(recipe.results or {}) do
        if result.name == base_name then
            result.name = eg_name
        elseif result[1] == base_name then
            result[1] = eg_name
        end
    end

    data:extend({ pole, item, recipe })
    if recycling then
        recycling.generate_recycling_recipe(recipe)
    end
end

for base_name, eg_name in pairs(base_to_eg) do
    clone_base_pole(base_name, eg_name)
end

local small_pole  = poles["eg-small-electric-pole"]
local medium_pole = poles["eg-medium-electric-pole"]
local big_pole    = poles["eg-big-electric-pole"]
local substation  = poles["eg-substation"]

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
if poles["eg-ugp-small-electric-pole"] then
    poles["eg-ugp-small-electric-pole"].maximum_wire_distance = constants.EG_MAX_WIRE_SMALL_IRON
    poles["eg-ugp-small-electric-pole"].supply_area_distance = constants.EG_MAX_SUPPLY_SMALL_IRON
end

if items["eg-ugp-small-electric-pole-displayer"] then
    items["eg-ugp-small-electric-pole-displayer"].subgroup = constants.EG_SUBGROUP
end

if poles["eg-small-iron-electric-pole"] and not poles["eg-small-iron-electric-pole"].next_upgrade and poles["eg-ugp-small-electric-pole-displayer"] then
    poles["eg-small-iron-electric-pole"].next_upgrade = "eg-ugp-small-electric-pole-displayer"
end


local huge_pole_recipe = recipes["eg-huge-electric-pole"]
local eg_technology = technologies["eg-tech-1"]
if huge_pole_recipe and eg_technology then
    table.insert(eg_technology.effects, { type = "unlock-recipe", recipe = "eg-huge-electric-pole" })
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

items["eg-small-electric-pole"].subgroup        = constants.EG_SUBGROUP
items["eg-medium-electric-pole"].subgroup       = constants.EG_SUBGROUP
items["eg-big-electric-pole"].subgroup          = constants.EG_SUBGROUP
items["eg-substation"].subgroup                 = constants.EG_SUBGROUP

data.raw["power-switch"]["power-switch"].hidden = true
items["power-switch"].hidden                    = true
recipes["power-switch"].hidden                  = true

if not mods["aai-industry"] and recipes["eg-small-iron-electric-pole"] then
    table.insert(technologies["electronics"].effects,
        { type = "unlock-recipe", recipe = "eg-small-iron-electric-pole" })
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

    if data.raw["electric-pole"]["eg-ugp-substation"] then
        data.raw["electric-pole"]["eg-ugp-substation"].fast_replaceable_group =
            data.raw["electric-pole"]["substation"].fast_replaceable_group
    end

    if data.raw["electric-pole"]["eg-ugp-substation-displayer"] then
        data.raw["electric-pole"]["eg-ugp-substation-displayer"].fast_replaceable_group =
            data.raw["electric-pole"]["substation"].fast_replaceable_group
    end
end

if mods["Bio_Industries_2"] then
    poles["bi-wooden-pole-big"].supply_area_distance = 0
    items["bi-wooden-pole-big"].subgroup = constants.EG_SUBGROUP

    poles["bi-wooden-pole-huge"].supply_area_distance = 0
    items["bi-wooden-pole-huge"].subgroup = constants.EG_SUBGROUP
end

if mods["aai-industry"] then
    local small_iron_pole = poles["eg-small-iron-electric-pole"]
    if small_iron_pole then
        local small_iron_pole_item = items["eg-small-iron-electric-pole"]
        if small_iron_pole_item then
            small_iron_pole_item.subgroup = constants.EG_SUBGROUP
        end

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

if mods["snouz_better_substation"] then
    local item = items["snouz_better_substation"]
    if item then
        item.subgroup = constants.EG_SUBGROUP
    end

    local recipe = recipes["snouz_better_substation"]
    if recipe then
        recipe.subgroup = constants.EG_SUBGROUP
    end
end
