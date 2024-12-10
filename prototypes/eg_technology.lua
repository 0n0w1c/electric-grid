data:extend({
    {
        type = "technology",
        name = "eg-tech-1",
        icon = constants.EG_GRAPHICS .. "/technologies/tier-1.png",
        icon_size = 128,
        localised_name = { "technology-name.eg-tech-1" },
        localised_description = { "technology-description.eg-tech-1" },
        order = "c-e-c",
        prerequisites = { "electric-energy-distribution-1" },
        effects = {
            { type = "unlock-recipe", recipe = "eg-transformator" }
        },
        unit = {
            count = 200,
            time = 60,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 }
            }
        }
    }
})
