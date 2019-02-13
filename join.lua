local fiber = require('fiber')

local worker = require('worker')

local function start(workers, chance_of_error, timeout)
    local fibers = {}

    for i = 1, workers do
        local fib = fiber.new(function() worker.start(chance_of_error) end)
        fib:set_joinable(true)
        table.insert(fibers, fib)
    end

    local ok, res, err
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
end

return { start = start }
