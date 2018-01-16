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

function score()
    local capacity, durability, flavor, texture, calories = 0,0,0,0,0
    for k,v in pairs(ingredients) do
        capacity = capacity + v.capacity * counters[v.index]
        durability = durability + v.durability * counters[v.index]
        flavor = flavor + v.flavor * counters[v.index]
        texture = texture + v.texture * counters[v.index]
        calories = calories + v.calories * counters[v.index]
    end
    if calories == 500 then
        return math.max(0, capacity) * math.max(0, durability) * math.max(0, flavor) * math.max(0, texture)
    else
        return 0
    end
end

counters = {}
hiscore = 0
function inc(level, max, limit)
    if level == max then
        counters[level] = limit
        hiscore = math.max(hiscore, score())
    else
        for i = 0,limit do
            counters[level] = i
            inc(level+1, max, limit-i)
        end
    end
end

i = 0
ingredients = {}
for line in io.lines() do
    local ingredient = line:match("(%w+):")
    i = i+1
    ingredients[ingredient] = { index = i }
    for property, value in line:gmatch(" (%w+) (-?%d+)") do
        ingredients[ingredient][property] = value
    end
end
inc(1, i, 100)
print(hiscore)

