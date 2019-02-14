local fiber = require('fiber')

local worker = require('worker')

local function start(workers, chance_of_error, timeout)
    local fibers = {}

    for i = 1, workers do
        local fib = fiber.new(function()
            return worker.start(chance_of_error)
        end)
        fib:set_joinable(true)
        table.insert(fibers, fib)
    end

    local ok, res, err

    local poll_fiber = fiber.new(function()
        local stop_work = false
        for _, fib in ipairs(fibers) do
            if stop_work then
                fib:cancel()
            else
                ok, res, err = fib:join()
                if res == nil then
                    err = res
                    res = nil
                    stop_work = true
                end
            end
        end

        return res, err
    end)

    local is_timeout = false

    local timeout_fiber = fiber.create(function()
        fiber.sleep(timeout)
        if poll_fiber:status() == 'running' then
            is_timeout = true
            poll_fiber:cancel()
        end
    end)

    poll_fiber:set_joinable(true)
    poll_fiber:join()

    if is_timeout then
        return nil, 'timeout'
    end

    timeout_fiber:cancel()

    local ok, res
end

return { start = start }
