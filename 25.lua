#!/usr/bin/lua

require "mydebug"

function log(...)
    local arg={...}
    print(table.concat({...}, " "))
end

-- input
row = 2978
col = 3083
first_code = 20151125

function get_n(row, col)
    local n = col
    for i = 1,row+(col-2) do
        n = n + i
    end
    return n
end

function generate(n)
    local code = first_code
    for i = 1,n-1 do
        code = code * 252533
        code = code % 33554393
    end
    return code
end

--[[
log(generate(2))
log(generate(get_n(5, 5)))
log(generate(get_n(5, 1)))
log(generate(get_n(2, 6)))
--]]

log(generate(get_n(row, col)))
