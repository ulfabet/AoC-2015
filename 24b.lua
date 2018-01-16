#!/usr/bin/lua

require "mydebug"

function log(...)
    local arg={...}
    print(table.concat({...}, " "))
end

v = {} -- values
w = {} -- weights 
n = 0 -- number of distinct items
W = 0 -- knapsack capacity

for line in io.lines() do
    table.insert(w, tonumber(line))
end
n = #w
W = mydebug.sum(w)/4

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

function shuffleTable( t )
    local rand = math.random 
    assert( t, "shuffleTable() expected a table, got nil" )
    local iterations = #t
    local j
    for i = iterations, 2, -1 do
        j = rand(i)
        t[i], t[j] = t[j], t[i]
    end
end

function remove_list(a, b)
    local new = {}
    local exclude = {} 
    for i,v in ipairs(b) do
        exclude[v] = true
    end
    for i,v in ipairs(a) do
        if not exclude[v] then
            table.insert(new, v)
        end
    end
    return new
end

--best = math.huge
--selected = {}
function f(a, start, len, limit, best, selected, level)
    if len > best[1] or limit < 0 then
        return false
    end
    if limit == 0 then
        best[1] = len
        local qe = 1
        for i,v in pairs(selected) do
            qe = qe * v
        end
        log(string.rep(">", level), "found", len, qe)
        --mydebug.dump(selected)
        --mydebug.dump(remove_list(a, selected))
        f(remove_list(a, selected), 1, 0, 381, {math.huge}, {}, level+1)
        return true
    end
    for i = start,#a do
        table.insert(selected, a[i])
        local value = f(a, i+1, len+1, limit-a[i], best, selected, level)
        table.remove(selected)
        if value and level > 0 then
            return true
        end
    end
    return false
end

table.sort(w, function (a, b) return a>b end)
f(w, 1, 0, 381, {math.huge}, {}, 0)
