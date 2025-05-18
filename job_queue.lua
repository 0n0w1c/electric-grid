local job_queue = {}
local function_registry = {}

function job_queue.init()
    storage.jobs = storage.jobs or {}
end

function job_queue.register_function(name, function_pointer)
    if type(name) ~= "string" then
        log("Error: Function name must be a string. Received: " .. tostring(name))
        return
    end

    if type(function_pointer) ~= "function" then
        log("Error: Only functions can be registered. Received: " .. tostring(function_pointer))
        return
    end

    function_registry[name] = function_pointer
end

function job_queue.schedule(tick, function_name, arguments, repeat_interval)
    if type(tick) ~= "number" then
        log("Error: Tick must be a number. Received: " .. tostring(tick))
        return
    end

    if not function_registry[function_name] then
        log("Error: Function name must reference a registered function. Received: " .. tostring(function_name))
        return
    end

    storage.jobs = storage.jobs or {}
    storage.jobs[tick] = storage.jobs[tick] or {}
    table.insert(storage.jobs[tick], {
        function_name = function_name,
        arguments = arguments,
        repeat_interval = repeat_interval
    })

    --game.print("Scheduled job '" .. function_name .. "' for tick " .. tick .. (repeat_interval and " (repeating)" or ""))
end

function job_queue.process(current_tick)
    --game.print("Processing jobs at tick " .. current_tick)
    local to_process = {}

    for tick, jobs in pairs(storage.jobs) do
        if tick <= current_tick then
            to_process[tick] = jobs
        end
    end

    for tick, jobs in pairs(to_process) do
        for _, job in pairs(jobs) do
            local func = function_registry[job.function_name]
            local success = false

            if func then
                local ok, err = pcall(func, job.arguments)
                if not ok then
                    log("Error running job '" .. job.function_name .. "' at tick " .. tick .. ": " .. err)
                else
                    --game.print("Executed job '" .. job.function_name .. "' at tick " .. tick)
                    success = true
                end
            else
                log("Function not found for name: " .. job.function_name)
            end

            if success and job.repeat_interval then
                local next_tick = tick + constants.EG_TICK_INTERVAL
                --game.print("Rescheduling job '" .. job.function_name .. "' for tick " .. next_tick)
                job_queue.schedule(next_tick, job.function_name, job.arguments, true)
            end
        end
        storage.jobs[tick] = nil
    end
end

function job_queue.update_registration()
    script.on_nth_tick(constants.EG_TICK_INTERVAL, function(event)
        job_queue.process(event.tick)
    end)
end

return job_queue
