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

--input = 120
input = 34000000
--house_guess = 1100000

--[[
house = 1100000
elf = 1
sum = 0
repeat
    if (house % elf) == 0 then
        sum = sum + (elf * 10)
    end
    elf = elf + 1
until elf > house
print(elf-1, sum)
--]]


function sum(a)
    local value = 0
    for i,v in pairs(a) do
        value = value + v
    end
    return value
end

house = 786240
house = house - 1
target = 34000000/10
repeat
    --print("house", house)
    t = get_all_factors(house)
    house = house - 1
until sum(t) > target or house == 1
house = house+1
print("house", house, 10*sum(t))


--[[
count = 0
for i,v in ipairs(t) do
    count = count + (v*10)
end
print("count", count)
--]]
