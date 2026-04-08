if mods["Engineersvsenvironmentalist-redux"] then
    local poles = data.raw["electric-pole"]

    -- restore the connection points
    poles["small-iron-electric-pole"].connection_points = table.deepcopy(poles["small-electric-pole"].connection_points)

    -- load error due to assigning next_upgrade to big-electric-pole-mk2
    poles["eg-huge-electric-pole"].next_upgrade = nil

    -- revert modifications to transformator poles
    for direction, _ in pairs(constants.EG_DIRECTION_TO_CARDINAL) do
        for _, pole_type in ipairs({ "high", "low" }) do
            local pole_name = "eg-" .. pole_type .. "-voltage-pole-" .. direction
            local pole = poles[pole_name]
            if pole then
                pole.next_upgrade                      = nil
                pole.rewire_neighbours_when_destroying = false
                pole.auto_connect_up_to_n_wires        = 0
                pole.draw_copper_wires                 = true
            end
        end
    end

    -- mods are not compatible in wiring behavior
    -- auto_connect_up_to_n_wires = 255,
    -- rewire_neighbours_when_destroying = true

    -- reset desired behavior
    for _, pole in pairs(poles) do
        if not (string.sub(pole.name, 1, 8) == "eg-high-" or string.sub(pole.name, 1, 7) == "eg-low-") then
            pole.rewire_neighbours_when_destroying = false
            pole.auto_connect_up_to_n_wires = nil
        end
    end
end
