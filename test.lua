--- Calculates the maximum possible production of an electric network.
-- Evaluates the maximum energy output of generating entities across the entire surface.
-- @param pole LuaEntity An electric pole connected to the electric network.
-- @return number The maximum possible production in watts (joules per second).
function get_max_source_production(pole)
    -- Ensure the pole is valid and connected to an electric network
    if not (pole and pole.valid and pole.type == "electric-pole") then
        return 0 -- Return 0 if the pole is not valid or has no network
    end

    -- Access the electric network ID from the pole
    local electric_network_id = pole.electric_network_id
    if not electric_network_id then
        return 0 -- Return 0 if no network ID is available
    end

    -- Get the surface of the pole
    local surface = pole.surface

    -- Accumulate production from all power-producing entities on the surface
    local max_possible_production = 0

    -- Loop through all entities of type "solar-panel" and "generator" on the surface
    for _, entity in pairs(surface.find_entities_filtered { type = { "solar-panel", "generator" } }) do
        if entity.valid and entity.electric_network_id == electric_network_id then
            local prototype = entity.prototype
            local max_output = 0

            -- Check for solar panels
            if prototype.type == "solar-panel" then
                max_output = prototype.electric_energy_source_prototype.output_flow_limit or 0
            end

            -- Check for generators (e.g., steam engines)
            if prototype.type == "generator" then
                max_output = prototype.max_power_output or 0 -- Direct max output in watts
            end

            -- Accumulate the maximum possible production
            max_possible_production = max_possible_production + max_output
        end
    end

    return max_possible_production
end

--- Calculates the maximum possible consumption of a network.
-- Evaluates the maximum energy usage of consuming entities attached to a given electric pole.
-- @param pole LuaEntity An electric pole connected to the electric network.
-- @return number The maximum possible consumption in watts (joules per second).
function get_max_target_consumption(pole)
    -- Ensure the pole is valid and connected to an electric network
    if not (pole and pole.valid and pole.type == "electric-pole") then
        return 0 -- Return 0 if the pole is not valid or has no network
    end

    -- Access the electric network from the pole
    local electric_network = pole.electric_network
    if not electric_network then
        return 0 -- Return 0 if no network is available
    end

    -- Retrieve the statistics from the electric network
    local stats = electric_network.statistics
    local max_possible_consumption = 0

    -- Loop through the input counts (consuming entities)
    for prototype_name, _ in pairs(stats.input_counts) do
        -- Get the prototype of the entity consuming power
        local prototype = game.entity_prototypes[prototype_name]
        if prototype then
            -- Get the number of entities of this type consuming power
            local entity_count = stats.get_flow_count {
                name = prototype_name,
                input = true, -- Checking input (consumption)
                precision_index = defines.flow_precision_index.five_seconds,
                count = true  -- Return the number of entities
            }

            -- Get the max energy consumption per entity
            local max_consumption = prototype.max_energy_usage or 0

            -- Multiply the max consumption by the number of entities
            max_possible_consumption = max_possible_consumption + (max_consumption * entity_count)
        end
    end

    return max_possible_consumption * 60 -- Convert from per tick to per second
end

--- Sends a customized alert for transformator overload or underload.
-- This function creates both a custom alert and flying text above the specified pole.
-- @param pole LuaEntity The electric pole entity triggering the alert.
-- @param value number The relevant power value (consumption or production).
-- @param alert_type string The type of alert message, either "overload" or "underload".
function send_alert(pole, value, alert_type)
    local force = pole.force
    if force then
        -- Determine the alert message and localization key based on the alert type
        local alert_message, virtual_signal_name
        if alert_type == "overload" then
            alert_message = { "trafo-alerts.electric-transformators-overload-msg", value / 1000000 }
            virtual_signal_name = "eg-alert"
        else
            alert_message = { "trafo-alerts.electric-transformators-underload-msg", value / 1000000 }
            virtual_signal_name = "eg-alert"
        end

        -- Send the custom alert to each player on this force
        for _, player in pairs(force.players) do
            player.add_custom_alert(
                pole,
                { type = "virtual", name = virtual_signal_name },
                alert_message,
                true
            )
        end

        -- Create the flying text alert on the pole's surface
        pole.surface.create_entity({
            name = "flying-text",
            position = pole.position,
            text = alert_message,
            color = { r = 1, g = 1, b = 1 } -- white color for visibility
        })
    end
end

--- Wrapper function to alert on overload.
-- @param pole LuaEntity The electric pole entity.
-- @param consumption number The current power consumption.
function alert_on_overload(pole, consumption)
    send_alert(pole, consumption, "overload")
end

--- Wrapper function to alert on underload.
-- @param pole LuaEntity The electric pole entity.
-- @param production number The current power production.
function alert_on_underload(pole, production)
    send_alert(pole, production, "underload")
end

--- Calculates the total power consumption for a given statistics object.
-- Loops through all input counts in the electric network statistics and calculates total consumption.
-- @param statistics LuaFlowStatistics The electric network statistics.
-- @return number The total consumption in watts.
function get_total_consumption(statistics)
    local total = 0
    for name, count in pairs(statistics.input_counts) do
        total = total + statistics.get_flow_count {
            name = name,
            input = true,
            precision_index = defines.flow_precision_index.five_seconds,
            count = false,
        }
    end
    return total * 60 -- Convert from per-tick values to per-second (Factorio runs 60 ticks per second)
end

--- Calculates the current real-time consumption for the electric network of a given electric pole.
-- Retrieves the electric network statistics and computes the current consumption from input flows.
-- @param pole LuaEntity An electric pole connected to the electric network.
-- @return number The current consumption in watts (joules per second).
function get_current_consumption(pole)
    -- Ensure the input is a valid electric pole; if not, log an error and exit early
    if not (pole and pole.valid and pole.type == "electric-pole") then
        game.print("Error: Expected a valid electric pole entity.")
        return 0
    end

    -- Access the electric network from the pole
    local electric_network = pole.electric_network
    if electric_network then
        -- Retrieve and calculate current consumption using the network's statistics
        local stats = electric_network.statistics
        local current_consumption = get_total_consumption(stats)
        return current_consumption
    end

    return 0
end

--- Validates and parses an energy consumption value string.
-- Converts a string ending in "MW" or "GW" to a numerical value.
-- @param energy string A string representing energy consumption (e.g., "100MW").
-- @return number|boolean The parsed energy value in watts, or `false` if invalid.
function validate_and_parse_energy(energy)
    local suffix = energy:sub(-2) -- Last two characters for suffix
    if suffix == "MW" or suffix == "GW" then
        local result = util.parse_energy(energy)
        if result then
            return result * 60 -- Convert to per second
        else
            game.print("Parsing energy setting '" .. energy .. "' failed with an invalid format.")
        end
    else
        game.print("Parsing energy setting '" .. energy .. "' failed: must end with MW or GW.")
    end
    return false
end

--- Checks transformator target consumption and source production against specified thresholds.
function check_network_maximums()
    local total_low_voltage_ratings = {}
    local total_high_voltage_ratings = {}
    local low_voltage_networks = {}
    local high_voltage_networks = {}

    --- Group transformators by network and calculate ratings.
    for _, transformator in pairs(storage.transformators) do
        local low_voltage_network = transformator.eg_low_voltage_pole and
            transformator.eg_low_voltage_pole.electric_network
        local high_voltage_network = transformator.eg_high_voltage_pole and
            transformator.eg_high_voltage_pole.electric_network
        local transformator_rating = constants.EG_TRANSFORMATORS[transformator.unit.name].rating

        if low_voltage_network then
            local low_voltage_id = low_voltage_network.network_id
            total_low_voltage_ratings[low_voltage_id] = (total_low_voltage_ratings[low_voltage_id] or 0) +
                transformator_rating
            low_voltage_networks[low_voltage_id] = low_voltage_networks[low_voltage_id] or {}
            table.insert(low_voltage_networks[low_voltage_id], transformator)
        end

        if high_voltage_network then
            local high_voltage_id = high_voltage_network.network_id
            total_high_voltage_ratings[high_voltage_id] = (total_high_voltage_ratings[high_voltage_id] or 0) +
                transformator_rating
            high_voltage_networks[high_voltage_id] = high_voltage_networks[high_voltage_id] or {}
            table.insert(high_voltage_networks[high_voltage_id], transformator)
        end
    end

    --- Define the checks to perform on each network.
    local checks = {
        {
            transformators = low_voltage_networks,
            ratings = total_low_voltage_ratings,
            get_pole = function(transformator) return transformator.eg_low_voltage_pole end,
            get_network_maximum = function(network)
                return math.ceil(network.statistics.get_input_flow("electricity")) -- Real-time input flow
            end,
            alert_function = alert_on_overload,
            threshold = constants.EG_EFFICIENCY
        },
        {
            transformators = high_voltage_networks,
            ratings = total_high_voltage_ratings,
            get_pole = function(transformator) return transformator.eg_high_voltage_pole end,
            get_network_maximum = function(network)
                return math.floor(network.statistics.get_output_flow("electricity")) -- Real-time output flow
            end,
            alert_function = alert_on_underload,
            threshold = constants.EG_EFFICIENCY
        }
    }

    --- Perform both checks on each network.
    for _, check in pairs(checks) do
        for network_id, transformator_group in pairs(check.transformators) do
            local network = transformator_group[1].eg_low_voltage_pole and
                transformator_group[1].eg_low_voltage_pole.electric_network
                or transformator_group[1].eg_high_voltage_pole and
                transformator_group[1].eg_high_voltage_pole.electric_network
            local total_rating = check.ratings[network_id]

            if network then
                local maximum = check.get_network_maximum(network)
                local is_alert

                -- Check if this network meets the alert condition (overload or underload)
                if check.alert_function == alert_on_overload then
                    is_alert = (maximum >= total_rating * check.threshold)
                else
                    is_alert = (maximum > 0 and maximum < total_rating)
                end

                -- Trigger an alert for all transformators in the network if the condition is met
                if is_alert then
                    for _, transformator in pairs(transformator_group) do
                        local pole_to_alert = check.get_pole(transformator)
                        if pole_to_alert and pole_to_alert.valid then
                            check.alert_function(pole_to_alert, total_rating)
                        end
                    end
                end
            end
        end
    end
end
