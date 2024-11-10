for _, force in pairs(game.forces) do
    local technologies = force.technologies
    local recipes = force.recipes

    if recipes and technologies then
        if technologies["electric-energy-distribution-1"] and recipes["eg-huge-electric-pole"] then
            recipes["eg-huge-electric-pole"].enabled = technologies["electric-energy-distribution-1"].researched
        end

        if technologies["eg-tech-1"] and recipes["eg-transformator-recipe"] then
            recipes["eg-transformator-recipe"].enabled = technologies["eg-tech-1"].researched
        end

        if technologies["electric-energy-distribution-2"] and recipes["eg-ugp-substation-displayer"] then
            recipes["eg-ugp-substation-displayer"].enabled = technologies["electric-energy-distribution-2"].researched
        end
    end
end
