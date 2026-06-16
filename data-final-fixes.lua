local base_to_eg = constants.EG_BASE_TO_EG_POLES

local items = data.raw.item or {}
local poles = data.raw["electric-pole"] or {}
local recipes = data.raw.recipe or {}
local technologies = data.raw.technology or {}

local function redirect_recipe_unlocks()
    for _, technology in pairs(technologies) do
        for _, effect in pairs(technology.effects or {}) do
            local replacement = effect.type == "unlock-recipe" and base_to_eg[effect.recipe]
            if replacement then
                effect.recipe = replacement
            end
        end
    end
end

local function hide_base_prototypes(base_name)
    local base_entity = poles[base_name]
    if base_entity then
        base_entity.hidden_in_factoriopedia = true
    end

    local base_item = items[base_name]
    if base_item then
        base_item.hidden_in_factoriopedia = true
    end

    local base_recipe = recipes[base_name]
    if base_recipe then
        base_recipe.hidden = true
        base_recipe.enabled = false
        base_recipe.hidden_in_factoriopedia = true
    end
end

local function enforce_eg_links(base_name, eg_name)
    local eg_item = items[eg_name]
    if eg_item then
        eg_item.place_result = eg_name
    end

    local eg_entity = poles[eg_name]
    if eg_entity then
        if eg_entity.minable and eg_entity.minable.result then
            eg_entity.minable.result = eg_name
        end

        local placeable_by = eg_entity.placeable_by
        if placeable_by then
            if placeable_by.item then
                placeable_by.item = eg_name
            else
                for _, entry in pairs(placeable_by) do
                    if type(entry) == "table" and entry.item then
                        entry.item = eg_name
                    end
                end
            end
        end
    end

    local eg_recipe = recipes[eg_name]
    if not eg_recipe then return end

    eg_recipe.main_product = eg_name
    for _, result in pairs(eg_recipe.results or {}) do
        if result.name == base_name or result.name == eg_name then
            result.name = eg_name
        elseif result[1] == base_name or result[1] == eg_name then
            result[1] = eg_name
        end
    end
end

redirect_recipe_unlocks()

for base_name, eg_name in pairs(base_to_eg) do
    hide_base_prototypes(base_name)
    enforce_eg_links(base_name, eg_name)
end
