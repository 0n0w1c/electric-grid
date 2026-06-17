if game.simulation then return end

local replacements = {
    ["small-electric-pole"] = "eg-small-electric-pole",
    ["medium-electric-pole"] = "eg-medium-electric-pole",
    ["big-electric-pole"] = "eg-big-electric-pole",
    ["substation"] = "eg-substation",
    ["small-iron-electric-pole"] = "eg-small-iron-electric-pole"
}

local function replace_item_stack(stack)
    if not (stack and stack.valid_for_read) then return end

    local new_name = replacements[stack.name]
    if not (new_name and prototypes.item[new_name]) then return end

    stack.set_stack {
        name = new_name,
        count = stack.count,
        quality = stack.quality
    }
end

local function migrate_inventory(inventory)
    if not (inventory and inventory.valid) then return end

    for index = 1, #inventory do
        replace_item_stack(inventory[index])
    end
end

local function replace_ghost(ghost, new_name)
    if not (ghost and ghost.valid) then return end

    local params = {
        name = "entity-ghost",
        inner_name = new_name,
        position = ghost.position,
        direction = ghost.direction,
        force = ghost.force,
        tags = ghost.tags,
        raise_built = false
    }

    if ghost.quality then
        params.quality = ghost.quality
    end

    local new_ghost = ghost.surface.create_entity(params)
    if new_ghost then
        ghost.destroy { raise_destroy = false }
    end
end

local function replace_pole(entity, new_name)
    if not (entity and entity.valid) then return end

    local params = {
        name = new_name,
        position = entity.position,
        direction = entity.direction,
        force = entity.force,
        fast_replace = true,
        spill = false,
        raise_built = false,
        create_build_effect_smoke = false
    }

    if entity.quality then
        params.quality = entity.quality
    end

    entity.surface.create_entity(params)
end

for _, surface in pairs(game.surfaces) do
    for old_name, new_name in pairs(replacements) do
        if prototypes.entity[new_name] then
            for _, entity in ipairs(surface.find_entities_filtered { name = old_name }) do
                replace_pole(entity, new_name)
            end

            for _, ghost in ipairs(surface.find_entities_filtered {
                type = "entity-ghost",
                ghost_name = old_name
            }) do
                replace_ghost(ghost, new_name)
            end
        end
    end
end

for _, player in pairs(game.players) do
    migrate_inventory(player.get_main_inventory())
    replace_item_stack(player.cursor_stack)
end

for _, surface in pairs(game.surfaces) do
    local chests = surface.find_entities_filtered {
        type = { "container", "logistic-container", "linked-container", "infinity-container" }
    }

    for _, chest in pairs(chests) do
        migrate_inventory(chest.get_inventory(defines.inventory.chest))
    end
end

for _, force in pairs(game.forces) do
    for old_name, new_name in pairs(replacements) do
        local old_recipe = force.recipes[old_name]
        local new_recipe = force.recipes[new_name]

        if new_recipe then
            if old_recipe and old_recipe.enabled then
                new_recipe.enabled = true
            end
            if old_recipe then
                old_recipe.enabled = false
            end
        end
    end
end
