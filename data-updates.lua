if mods["PowerOverload"] then
    local po_huge_pole                          = data.raw["electric-pole"]["po-huge-electric-pole"]

    po_huge_pole.light                          = constants.EG_HUGE_POLE_LIGHTS and constants.EG_HUGE_POLE_LIGHT or nil
    po_huge_pole.maximum_wire_distance          = tonumber(settings.startup["eg-max-wire-huge"].value)
    po_huge_pole.drawing_box_vertical_extension = 3

    if not constants.EG_TRANSFORMATORS_ONLY then
        data.raw["item"]["po-huge-electric-pole"].subgroup = "eg-electric-distribution"
        data.raw["item"]["po-interface"].subgroup          = "eg-electric-distribution"
    end

    data.raw["power-switch"]["po-transformer"].hidden = true
    data.raw["item"]["po-transformer"].hidden         = true
    data.raw["recipe"]["po-transformer"].hidden       = true

    if mods["quality"] then
        data.raw["recipe"]["po-transformer-recycling"].hidden = true
    end

    local poles = data.raw["electric-pole"]
    for _, pole in pairs(poles) do
        if string.sub(pole.name, 1, 3) == "po-" and string.find(pole.name, "-fuse") then
            data.raw["electric-pole"][pole.name].hidden = true
            data.raw["item"][pole.name].hidden          = true
            data.raw["recipe"][pole.name].hidden        = true
        end
    end

    data.raw["technology"]["po-electric-energy-distribution-3"].hidden = true

    table.insert(data.raw["technology"]["electric-energy-distribution-1"].effects,
        { type = "unlock-recipe", recipe = "po-huge-electric-pole" })

    table.insert(data.raw["technology"]["electric-energy-distribution-2"].effects,
        { type = "unlock-recipe", recipe = "po-interface" })
end

if constants.EG_TRANSFORMATORS_ONLY then return end

local small_pole                 = data.raw["electric-pole"]["small-electric-pole"]
local medium_pole                = data.raw["electric-pole"]["medium-electric-pole"]
local big_pole                   = data.raw["electric-pole"]["big-electric-pole"]
local substation                 = data.raw["electric-pole"]["substation"]

small_pole.maximum_wire_distance = medium_pole.maximum_wire_distance
small_pole.supply_area_distance  = medium_pole.supply_area_distance

medium_pole.supply_area_distance = 0
medium_pole.light                = constants.EG_MEDIUM_POLE_LIGHTS and constants.EG_MEDIUM_POLE_LIGHT or nil

big_pole.supply_area_distance    = 0
big_pole.maximum_wire_distance   = substation.maximum_wire_distance
big_pole.light                   = constants.EG_BIG_POLE_LIGHTS and constants.EG_BIG_POLE_LIGHT or nil
big_pole.subgroup                = "eg-electric-distribution"

substation.subgroup              = "eg-electric-distribution"
if not mods["PowerOverload"] then
    substation.next_upgrade = "eg-ugp-substation-displayer"
end

data.raw["item"]["small-electric-pole"].subgroup  = "eg-electric-distribution"
data.raw["item"]["medium-electric-pole"].subgroup = "eg-electric-distribution"
data.raw["item"]["big-electric-pole"].subgroup    = "eg-electric-distribution"
data.raw["item"]["substation"].subgroup           = "eg-electric-distribution"

data.raw["power-switch"]["power-switch"].hidden   = true
data.raw["item"]["power-switch"].hidden           = true
data.raw["recipe"]["power-switch"].hidden         = true

if not mods["aai-industry"] and data.raw["recipe"]["small-iron-electric-pole"] then
    table.insert(data.raw["technology"]["electronics"].effects,
        { type = "unlock-recipe", recipe = "small-iron-electric-pole" })
end

if mods["factorioplus"] then
    local effects = data.raw["technology"]["electric-energy-distribution-3"].effects
    for i, effect in ipairs(effects) do
        if effect.type == "unlock-recipe" and effect.recipe == "huge-electric-pole" then
            table.remove(effects, i)
            break
        end
    end

    local huge_pole = data.raw["electric-pole"]["huge-electric-pole"]

    huge_pole.supply_area_distance = 0
    huge_pole.maximum_wire_distance = tonumber(settings.startup["eg-max-wire-huge"].value)

    data.raw["item"]["medium-wooden-electric-pole"].subgroup = "eg-electric-distribution"
    data.raw["item"]["huge-electric-pole"].subgroup = "eg-electric-distribution"
    data.raw["item"]["electrical-distributor"].subgroup = "eg-electric-distribution"

    table.insert(data.raw["technology"]["electric-energy-distribution-1"].effects,
        { type = "unlock-recipe", recipe = "huge-electric-pole" })
end

if mods["James-Train-Mod"] then
    data.raw["technology"]["electric-trains"].icons =
    {
        {
            icon = "__James-Train-Mod__/graphics/Technology-Backing.png",
            icon_size = 128
        },
        {
            icon = "__base__/graphics/icons/locomotive.png",
            icon_size = 64,
            shift = { 0, 0 }
        },
        {
            icon = "__core__/graphics/icons/tooltips/tooltip-category-electricity.png",
            icon_size = 32,
            scale = 1,
            shift = { 0, 0 }
        },
        {
            icon = "__James-Train-Mod__/graphics/speed.png",
            icon_size = 64,
            scale = 0.5,
            shift = { 48, 48 }
        }
    }

    data.raw["technology"]["electrified-tracks"].icons =
    {
        {
            icon = "__base__/graphics/icons/rail.png",
            icon_size = 64
        },
        {
            icon = "__core__/graphics/icons/tooltips/tooltip-category-electricity.png",
            icon_size = 32,
            scale = 1,
            shift = { 0, 0 }
        }
    }

    data.raw["technology"]["electrified-elevated-tracks"].icons =
    {
        {
            icon = "__elevated-rails__/graphics/technology/elevated-rail.png",
            icon_size = 256
        },
        {
            icon = "__core__/graphics/icons/tooltips/tooltip-category-electricity.png",
            icon_size = 32,
            scale = 1,
            shift = { 0, 0 }
        }
    }

    local rail_pole = data.raw["electric-pole"]["james-rail-pole"]

    rail_pole.drawing_box_vertical_extension = medium_pole.drawing_box_vertical_extension
    rail_pole.selection_box = medium_pole.selection_box
    rail_pole.corpse = medium_pole.corpse
    rail_pole.pictures = medium_pole.pictures
    rail_pole.connection_points = medium_pole.connection_points
    rail_pole.supply_area_distance = 0

    data.raw["technology"]["electrified-tracks"].prerequisites = { "electric-trains" }

    -- note: rails under trains do not upgrade, gotta move'em
    data.raw["straight-rail"]["straight-rail"].next_upgrade = "james-powered-rail-straight-rail"
    data.raw["curved-rail-a"]["curved-rail-a"].next_upgrade = "james-powered-rail-curved-rail-a"
    data.raw["curved-rail-b"]["curved-rail-b"].next_upgrade = "james-powered-rail-curved-rail-b"
    data.raw["half-diagonal-rail"]["half-diagonal-rail"].next_upgrade = "james-powered-rail-half-diagonal-rail"

    data.raw["accumulator"]["james-rail-accumulator"].icon = nil
    data.raw["accumulator"]["james-rail-accumulator"].icons =
        data.raw["straight-rail"]["james-powered-rail-straight-rail"].icons

    if mods["elevated-rails"] then
        -- elevated ramp and first attached elevated rail do not upgrade via the planner
        -- maybe this gets fixed?
        --[[
        data.raw["elevated-straight-rail"]["elevated-straight-rail"].next_upgrade =
        "james-powered-rail-elevated-straight-rail"
        data.raw["elevated-curved-rail-a"]["elevated-curved-rail-a"].next_upgrade =
        "james-powered-rail-elevated-curved-rail-a"
        data.raw["elevated-curved-rail-b"]["elevated-curved-rail-b"].next_upgrade =
        "james-powered-rail-elevated-curved-rail-b"
        data.raw["elevated-half-diagonal-rail"]["elevated-half-diagonal-rail"].next_upgrade =
        "james-powered-rail-elevated-half-diagonal-rail"

        data.raw["rail-ramp"]["rail-ramp"].next_upgrade = "james-powered-rail-ramp"
        ]]

        data.raw["elevated-straight-rail"]["james-powered-rail-elevated-straight-rail"].icons =
        {
            {
                icon = "__elevated-rails__/graphics/icons/elevated-rail.png",
                icon_size = 64
            },
            {
                icon = "__core__/graphics/icons/tooltips/tooltip-category-electricity.png",
                icon_size = 32,
                scale = 0.5,
                shift = { 0, 0 }
            }
        }
    end
end

if mods["aai-industry"] then
    local iron_pole = data.raw["electric-pole"]["small-iron-electric-pole"]

    if iron_pole then
        iron_pole.maximum_wire_distance = small_pole.maximum_wire_distance
        iron_pole.supply_area_distance  = small_pole.supply_area_distance

        local iron_pole_item            = data.raw["item"]["small-iron-electric-pole"]
        iron_pole_item.subgroup         = "eg-electric-distribution"
    end

    local huge_pole_recipe = data.raw["recipe"]["eg-huge-electric-pole"]

    if huge_pole_recipe then
        huge_pole_recipe.ingredients =
        {
            { type = "item", name = "steel-plate",  amount = 8 },
            { type = "item", name = "iron-stick",   amount = 12 },
            { type = "item", name = "copper-cable", amount = 20 },
            { type = "item", name = "concrete",     amount = 2 }
        }

        if mods["quality"] then
            local recycling = require("__quality__/prototypes/recycling")

            recycling.generate_recycling_recipe(huge_pole_recipe)
        end
    end
end

if mods["cargo-ships"] and data.raw["item"]["floating-electric-pole"] then
    data.raw["item"]["floating-electric-pole"].subgroup = "eg-electric-distribution"
end

if mods["quality"] and data.raw["recipe"]["eg-ugp-substation-displayer-recycling"] then
    data.raw["recipe"]["eg-ugp-substation-displayer-recycling"].results =
        data.raw["recipe"]["substation-recycling"].results
end

if constants.EG_EVEN_ALIGN_RADAR then
    local radars = data.raw["radar"]

    for _, radar in pairs(radars) do
        radar.collision_box = { { -1.51, -1.51 }, { 1.51, 1.51 } }
    end
end

local function version_gte(version, target)
    local v_major, v_minor, v_patch = version:match("^(%d+)%.(%d+)%.(%d+)$")
    local t_major, t_minor, t_patch = target:match("^(%d+)%.(%d+)%.(%d+)$")

    v_major, v_minor, v_patch = tonumber(v_major), tonumber(v_minor), tonumber(v_patch)
    t_major, t_minor, t_patch = tonumber(t_major), tonumber(t_minor), tonumber(t_patch)

    if v_major > t_major then return true end
    if v_major < t_major then return false end

    if v_minor > t_minor then return true end
    if v_minor < t_minor then return false end

    return v_patch >= t_patch
end

if version_gte(mods["base"], "2.0.40") then
    local poles = data.raw["electric-pole"]

    for _, pole in pairs(poles) do
        pole.rewire_neighbours_when_destroying = false
    end
end
