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

solution = {}
function get_combinations(target, index)
    if target == 0 then
        io.write(#solution, " ")
        dump(solution)
        return
    end
    for i = index,1,-1 do
        local v = containers[i]
        if v > target then
            get_combinations(target, i-1)
            break
        else
            if target > left[i] then
                break
            end
            table.insert(solution, v)
            get_combinations(target-v, i-1)
            table.remove(solution)
        end
    end
end

containers = {}
for line in io.lines() do
    local i = tonumber(line:match("(%d+)"))
    table.insert(containers, i)
end

--containers = {20,15,10,5,5}
table.sort(containers)
left = {}
for i,v in ipairs(containers) do
    left[i] = (left[i-1] or 0) + v
end
--dump(containers)
--dump(left)
get_combinations(150, #containers)
