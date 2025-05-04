local job_queue = {}

-- Registry for functions
local function_registry = {}

--- Initializes the job queue storage
function job_queue.init()
    storage.jobs = storage.jobs or {}
end

--- Registers a function in the function registry
-- @param name string The unique name of the function
-- @param function_pointer function The function to register
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

--- Schedules a job to execute at a specific tick
-- @param tick number The tick when the job should run
-- @param function_name string The name of the registered function to call
-- @param arguments table Arguments to pass to the function, including the entity
-- @param repeat_interval number|nil Optional interval in ticks for the job to repeat
function job_queue.schedule(tick, function_name, arguments, repeat_interval)
    if type(tick) ~= "number" then
        log("Error: Tick must be a number. Received: " .. tostring(tick))
        return
    end

    if not function_registry[function_name] then
        log("Error: Function name must reference a registered function. Received: " .. tostring(function_name))
        return
    end

    -- Validation of arguments should be handled by the registered function

    storage.jobs = storage.jobs or {}
    storage.jobs[tick] = storage.jobs[tick] or {}
    table.insert(storage.jobs[tick], {
        function_name = function_name,
        arguments = arguments,
        repeat_interval = repeat_interval
    })

    job_queue.update_registration()
end

--- Processes all jobs scheduled for the current tick.
-- @param tick number The current tick to process jobs for.
function job_queue.process(tick)
    local jobs = storage.jobs[tick]
    if not jobs then return end

    for _, job in pairs(jobs) do
        local function_pointer = function_registry[job.function_name]
        if function_pointer then
            local success, error = pcall(function_pointer, job.arguments)
            if not success then
                log("Error processing job at tick " .. tick .. ": " .. error)
            end
        else
            log("Function not found for name: " .. job.function_name)
        end

        -- Re-schedule repeating jobs
        if job.repeat_interval and storage.eg_check_interval and storage.eg_check_interval > 0 then
            local next_tick = tick + job.repeat_interval
            job_queue.schedule(next_tick, job.function_name, job.arguments, job.repeat_interval)
        end
    end

    storage.jobs[tick] = nil
end

--- Updates the registration for the next job tick
function job_queue.update_registration()
    if not game then return end

    storage.jobs = storage.jobs or {}
    local next_tick = next(storage.jobs)

    if next_tick then
        local nth_tick = next_tick - game.tick

        if nth_tick <= 0 then nth_tick = 1 end

        script.on_nth_tick(nth_tick, function(event)
            job_queue.process(event.tick)
            job_queue.update_registration()
        end)
    else
        script.on_nth_tick(nil)
    end
end

return job_queue
