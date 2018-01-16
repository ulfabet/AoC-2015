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

matrix = {}
for line in io.lines() do
    local a,b,c,d = line:match("(%w+) can fly (%d+) km/s for (%d+) seconds, but then must rest for (%d+) seconds.")
    if a then
        --print(a,b,c,d)
        matrix[a] = {}
        matrix[a].speed = tonumber(b)
        matrix[a].on = tonumber(c)
        matrix[a].off = tonumber(d)
    end
end
--dump(matrix)

duration = 2503
for k,v in pairs(matrix) do
    local cycle = matrix[k].on + matrix[k].off
    --print("cycle", cycle)
    local run = matrix[k].speed * matrix[k].on * math.floor(duration / cycle)
    --print("run", run)
    local spurt = matrix[k].speed * math.min(matrix[k].on, duration % cycle)
    --print("spurt", spurt)
    print(k, run+spurt)
end

