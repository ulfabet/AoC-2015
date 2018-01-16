#!/usr/bin/lua

-- dump(table) - show table contents for debugging purposes
-- 
function dump(t)
    io.write("{")
    if next(t) == nil then
        io.write("}\n")
    else
        for k,v in pairs(t) do
            io.write(k, "=")
            if type(v) == "table" then dump(v)
            else io.write(v)
            end
            io.write(", ")
        end
        io.write("\b\b}\n")
    end
end

function permgen(a, n)
    if n == 0 then
        coroutine.yield(a)
    else
        for i=1,n do
            a[n], a[i] = a[i], a[n]
            permgen(a, n-1)
            a[n], a[i] = a[i], a[n]
        end
    end
end

function perm(a)
    return coroutine.wrap(function () permgen(a, #a) end)
end

function get_keys(t)
    local keys = {}
    for k,v in pairs(t) do
        table.insert(keys, k)
    end
    return keys
end

function sum(a)
    local sum = 0
    for i,v in ipairs(a) do
        sum = sum + v
    end
    return sum
end

operators = {}
operators.eq = function (a, b) return a == b end
operators.neq = function (a, b) return a ~= b end
operators.gt = function (a, b) return a > b end
operators.lt = function (a, b) return a < b end

function compare()
    for k,v in pairs(aunts) do
        local found_aunt = true
        for property,value in pairs(v) do
            local op = operators.eq
            if property == "cats" or property == "trees" then
                op = operators.gt
            end
            if property == "pomeranians" or property == "goldfish" then
                op = operators.lt
            end
            if not op(value, mfcsam[property]) then
                found_aunt = false 
            end
        end
        if found_aunt then
            print (k)
        end
    end
end

mfcsam = { children = 3, cats = 7, samoyeds = 2, pomeranians = 3, akitas = 0, vizslas = 0, goldfish = 5, trees = 3, cars = 2, perfumes = 1 }

aunts = {}
for line in io.lines() do
    local i = line:match("Sue (%d+):")
    aunts[i] = {}
    for property, value in line:gmatch(" (%w+): (%d+)") do
        aunts[i][property] = tonumber(value)
    end
end

compare()
