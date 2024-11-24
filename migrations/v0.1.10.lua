for _, force in pairs(game.forces) do
    local technologies = force.technologies
    local recipes = force.recipes

    if recipes and technologies then
        if technologies["eg-tech-1"] and recipes["eg-transformator"] then
            recipes["eg-transformator"].enabled = technologies["eg-tech-1"].researched
        end
    end
end
