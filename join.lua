local fiber = require('fiber')

local worker = require('worker')

local function start(workers, chance_of_error, timeout)
    local fibers = {}

    for i = 1, workers do
        local fib = fiber.new(function() worker.start(chance_of_error) end)
        fib:set_joinable(true)
        table.insert(fibers, fib)
    end

    for _, fib in ipairs(fibers) do
        local _, res, err = fib:join()
        if res == nil then
            return nil, res
        end
    end

    return true
end

return { start = start }
