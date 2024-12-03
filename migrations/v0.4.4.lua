for _, force in pairs(game.forces) do
    local technologies = force.technologies
    local recipes = force.recipes

    if recipes and technologies then
        if technologies["circuit-network"] and recipes["connection-box"] then
            recipes["connection-box"].enabled = technologies["circuit-network"].researched
        end
    end
end
