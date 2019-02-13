local fiber = require('fiber')

local function start(chance_of_error)
    local time_to_sleep = math.random()
    fiber.sleep(time_to_sleep)
    local is_error = math.random(100) > chance_of_error
    if is_error then
        return nil, 'failure'
    else
        return 'success'
    end
end

return { start = start }
