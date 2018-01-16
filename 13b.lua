#!/usr/bin/lua

matrix = {}

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
            permgen(a, n - 1)
            a[n], a[i] = a[i], a[n]
        end
    end
end

function perm(a)
    local n = #a
    local co = coroutine.create(function () permgen(a, n) end)
    return function ()   -- iterator
        local code, result = coroutine.resume(co)
        return result
    end
end

function get_keys(t)
    local keys = {}
    for k,v in pairs(t) do
        table.insert(keys, k)
    end
    return keys
end

function get_happiness(a, b)
    return matrix[a][b]+matrix[b][a]
end

for line in io.lines() do
    local a,b,c,d = line:match("(%w+) would (%w+) (%d+) happiness units by sitting next to (%w+).")
    if a then
        matrix[a] = matrix[a] or {}
        matrix[a][d] = ({ lose = -1, gain = 1 })[b] * c
    end
end

matrix["Ulf"] = {}
for k,v in pairs(matrix) do
    matrix[k]["Ulf"] = 0
    matrix["Ulf"][k] = 0
end

first, rest = next(matrix)
for p in perm(get_keys(rest)) do
    local count = get_happiness(first, p[1]) + get_happiness(first, p[#p])
    for i = 1,#p-1 do
        count = count + get_happiness(p[i], p[i+1])
    end
    print(count)
end
