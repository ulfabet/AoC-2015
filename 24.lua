#!/usr/bin/lua

require "mydebug"

function log(...)
    local arg={...}
    print(table.concat({...}, " "))
end

v = {} -- values. Always -1 or same as weight?
w = {} -- weights 
n = 0 -- number of distinct items
W = 0 -- knapsack capacity

for line in io.lines() do
    table.insert(w, tonumber(line))
end
n = #w
W = mydebug.sum(w)/3

--[[
m = {}
m[0] = {}
for j = 0,W do
    m[0][j] = 0
end

for i = 1,n do
    m[i] = {}
    for j = 0,W do
        if w[i] <= j then
            m[i][j] = math.max(m[i-1][j], m[i-1][ j-w[i] ] + w[i]*w[i])
        else
            m[i][j] = m[i-1][j]
        end
    end
end
log(m[n][W])
mydebug.dump(m[n])
--]]

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

function check(a, selected,  limit)
    local new = {}
    for i = 1,#a do
        if not selected[i] then
            table.insert(new, a[i])
        end
    end
    for i = 1,1000 do
        shuffleTable(new)
        local sum = 0
        for i,v in pairs(new) do
            sum = sum + v
            if sum == limit then
                --mydebug.dump(new)
                return true
            end
        end
    end
    return false
end

best = math.huge
function f(a, start, selected, len, sum, limit)
    if len > best or sum > limit then
        return
    end
    if sum == limit then
        best = len
        log("found", len)
        mydebug.dump(selected)
        --log(tostring(check(a, selected, limit)))
        return
    end
    for i = start,#a do
        --if not selected[i] then
            selected[i] = a[i]
            f(a, i+1, selected, len+1, sum+a[i], limit)
            selected[i] = nil
        --end
    end
end

table.sort(w, function (a, b) return a>b end)
f(w, 1, {}, 0, 0, W)
