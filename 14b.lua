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
        matrix[a].points = 0
    end
end
--dump(matrix)

function calculate(duration)
    local best = 0
    local names = {}
    for k,v in pairs(matrix) do
        local cycle = matrix[k].on + matrix[k].off
        local run = matrix[k].speed * matrix[k].on * math.floor(duration / cycle)
        local spurt = matrix[k].speed * math.min(matrix[k].on, duration % cycle)
        local distance = run + spurt
        if distance > best then
            names = {k}
            best = distance
        elseif distance == best then
            table.insert(names, k)
            --print("equal")
            --dump(names)
        end
    end
    --dump(names)
    for k,v in pairs(names) do
        matrix[v].points = matrix[v].points + 1
    end
end

for i = 1,2503 do
    calculate(i)
end
dump(matrix)

