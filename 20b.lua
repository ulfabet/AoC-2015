#!/usr/bin/lua

require "mydebug"

function get_all_factors(number)
    local factors = {}
    for possible_factor = 1, math.sqrt(number) do
        local remainder = number % possible_factor
        if remainder == 0 then
            local factor, factor_pair = possible_factor, number/possible_factor
            table.insert(factors, factor)
            if factor ~= factor_pair then
                table.insert(factors, factor_pair)
            end
        end
    end
    table.sort(factors)
    return factors
end

function sum(a)
    local value = 0
    for i,v in pairs(a) do
        value = value + v
    end
    return value
end

function get_filtered_factors(number)
    local a = get_all_factors(number)
    local a2 = {}
    local limit = a[#a]/50
    for i,v in ipairs(a) do
        --[[
        if v < limit then
            table.remove(a, i)
        end
        --]]
        if v > limit then
            table.insert(a2, v)
        end
    end
    return a2 
end

house = 786240
--house = house + 1
target = 34000000/11
repeat
    t = get_filtered_factors(house)
    if house % 10000 == 0 then
        print("house", house, 11*sum(t))
    end
    house = house + 1
until sum(t) >= target or house == 1
house = house-1
print("house", house, 11*sum(t))

--[[
presents = {} -- per house
elves = 1000
for i = 1,elves*50 do 
    presents[i] = 0
end
for i = 1,elves do 
    for j = 1,50 do
        presents[i*j] = presents[i*j] + i*11
    end
end

for i = 1,elves*50 do
    print(presents[i])
end
--]]

--[[
t = get_all_factors(786240)
mydebug.dump(t)
t = get_filtered_factors(786240)
mydebug.dump(t)
--]]

