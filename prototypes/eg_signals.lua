data:extend({
    {
        type                  = "virtual-signal",
        name                  = "eg-alert",
        icon_size             = 32,
        hidden                = true,
        localised_name        = { "virtual-signal.eg-alert" },
        localised_description = { "virtual-signal-description.eg-alert" },
        icons                 = { {
            icon = constants.EG_GRAPHICS .. "/icons/flash.png",
            tint = { r = 1, g = 1, b = 0 },
            icon_size = 32,
        } }
    }
})
