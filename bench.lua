#!/usr/bin/env tarantool

local clock = require('clock')

math.randomseed(clock.time())

local workers = 100
local chance_of_error = 98
local iterations = 100
local timeout = 1

local function bench(func, chance_of_error)
    local start = clock.time()
    for i = 1, iterations do
        func(chance_of_error)
    end
    local finish = clock.time()
    print(finish - start, 'seconds')
end

print('workers:\t', workers)
print('chance of error, %:', chance_of_error)
print('iterations:\t', iterations)

local channel = require('channel')
print('benchmarking of channel..')
bench(function() channel.start(workers, chance_of_error, timeout) end)

local join = require('join')
print('benchmarking of join..')
bench(function() join.start(workers, chance_of_error, timeout) end)

os.exit(0)
