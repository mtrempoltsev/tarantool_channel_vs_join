local fiber = require('fiber')

local worker = require('worker')

local function launcher(func, channel, chance_of_error)
    local res, err = func(chance_of_error)
    channel:put({ res, err })
end

local function start(workers, chance_of_error, timeout)
    local channel = fiber.channel(workers)

    for i = 1, workers do
        fiber.create(function() launcher(worker.start, channel, chance_of_error) end)
    end

    local begin = fiber.time()

    for i = 1, workers do
        local now = fiber.time()
        local wait_time = timeout - (now - begin)

        if wait_time <= 0 then
            return nil, 'timeout'
        end

        local res, err = unpack(channel:get(wait_time))
        if res == nil then
            return nil, err
        end
    end

    return true
end

return { start = start }
