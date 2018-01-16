#!/usr/bin/lua

--require "mydebug"

function log(...)
    local arg={...}
    print(table.concat({...}, " "))
end

--foldr(function, default_value, table)
-- e.g: foldr(operator.mul, 1, {1,2,3,4,5}) -> 120
function foldr(func, val, tbl)
    for i,v in pairs(tbl) do
        val = func(val, v)
    end
    return val
end
log(foldr(function(a,b) return a*b end, 1, {1,2,3,4,5}))

-- reduce(function, table)
-- e.g: reduce(operator.add, {1,2,3,4}) -> 10
--function reduce(func, tbl)
--    return foldr(func, head(tbl), tail(tbl))
--end

function reduce(f, value, t)
    --local value = 0
    for i,v in pairs(t) do
        value = f(value, v)
    end
    return value
end
log(reduce(function(a,b) return a*b end, 1, {1,2,3,4,5}))

function math.round(v)
    return math.floor(v + 0.5)
end

