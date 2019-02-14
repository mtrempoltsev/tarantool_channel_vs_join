local clock = require('clock')

math.randomseed(clock.time())

local fiber = require('fiber')

local function start(chance_of_error)
    assert(chance_of_error >= 0 and chance_of_error <= 100)

    local time_to_sleep = math.random()
    fiber.sleep(time_to_sleep)

    local is_error = math.random(100) > (100 - chance_of_error)
    if is_error then
        return nil, 'failure'
    else
        return 'success'
    end
end

return { start = start }
