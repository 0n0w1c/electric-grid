local job_queue = {}

-- Function registry: { [queue_name]: { [function_name]: function } }
local function_registry = {}

-- Tracks the next tick at which any job should run
local next_job_tick = nil

--- Initializes job queue storage and sets up the on_tick handler.
function job_queue.init()
    storage.job_queues = storage.job_queues or {}

    script.on_event(defines.events.on_tick, function(event)
        if next_job_tick and event.tick >= next_job_tick then
            job_queue.process(event.tick)
        end
    end)
end

--- Registers a function in a specific queue.
--- @param queue string The queue name (e.g. "entity", "logic").
--- @param name string The unique name of the function.
--- @param fn function The function to register. It must accept a single argument table.
function job_queue.register_function(queue, name, fn)
    assert(type(queue) == "string" and type(name) == "string", "job_queue: queue and function name must be strings")
    assert(type(fn) == "function", "job_queue: registered function must be callable")

    function_registry[queue] = function_registry[queue] or {}
    function_registry[queue][name] = fn
end

--- Schedules a job in a named queue to run at a given tick.
--- @param queue string The queue in which to schedule the job.
--- @param tick integer The game tick at which to execute the job.
--- @param function_name string The name of the registered function to call.
--- @param args table The arguments passed to the function when executed.
--- @param repeat_interval integer|nil Optional interval (in ticks) for job repetition.
function job_queue.schedule(queue, tick, function_name, args, repeat_interval)
    assert(type(queue) == "string", "job_queue.schedule: queue name must be a string")
    assert(type(tick) == "number", "job_queue.schedule: tick must be a number")

    local reg = function_registry[queue]
    assert(reg and reg[function_name],
        "job_queue.schedule: function '" .. tostring(function_name) .. "' not registered in queue '" .. queue .. "'")

    local q = storage.job_queues
    q[queue] = q[queue] or {}
    q[queue][tick] = q[queue][tick] or {}
    table.insert(q[queue][tick], {
        function_name = function_name,
        arguments = args,
        repeat_interval = repeat_interval
    })

    if not next_job_tick or tick < next_job_tick then
        next_job_tick = tick
    end
end

--- Ensures a job is scheduled in the queue if it's not already present.
--- @param queue string The queue name.
--- @param function_name string The name of the registered function.
--- @param interval integer The interval in ticks for repetition.
--- @param args table|nil Optional arguments to pass to the function.
function job_queue.ensure_scheduled(queue, function_name, interval, args)
    assert(type(queue) == "string", "job_queue.ensure_scheduled: queue must be a string")
    assert(type(function_name) == "string", "job_queue.ensure_scheduled: function_name must be a string")
    assert(type(interval) == "number" and interval > 0, "job_queue.ensure_scheduled: interval must be a positive number")

    job_queue.schedule(queue, game.tick + interval, function_name, args or {}, interval)
end

--- Processes all jobs across all queues for the current tick.
--- Called automatically from the on_tick handler when `event.tick >= next_tick`.
--- @param tick integer The current game tick being processed.
function job_queue.process(tick)
    local queues = storage.job_queues
    local next_tick_candidate = nil

    for queue_name, queue in pairs(queues) do
        local jobs = queue[tick]
        if jobs then
            for _, job in ipairs(jobs) do
                local fn = function_registry[queue_name] and function_registry[queue_name][job.function_name]
                if fn then
                    local ok, error = pcall(fn, job.arguments)
                    if not ok then
                        log("Error in queue [" .. queue_name .. "] at tick " .. tick .. ": " .. error)
                    end
                else
                    log("Missing function: " .. job.function_name .. " in queue: " .. queue_name)
                end

                if job.repeat_interval and storage.eg_check_interval and storage.eg_check_interval > 0 then
                    local new_tick = tick + job.repeat_interval
                    job_queue.schedule(queue_name, new_tick, job.function_name, job.arguments, job.repeat_interval)
                    if not next_tick_candidate or new_tick < next_tick_candidate then
                        next_tick_candidate = new_tick
                    end
                end
            end

            queue[tick] = nil
        end

        for future_tick in pairs(queue) do
            if not next_tick_candidate or future_tick < next_tick_candidate then
                next_tick_candidate = future_tick
            end
        end
    end

    next_job_tick = next_tick_candidate
end

return job_queue
