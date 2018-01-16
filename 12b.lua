#!/usr/bin/lua

result = 0
function count(s)
    for number in s:gmatch("-?%d+") do
        result = result + number
    end
end

table = {}

function parse_key(s)
    --print("parse_key", s:sub(1,20), #s)
    total, k = s:match('^("(%w+)":)')
    --print("found key", k, #k, #total)
    return #total
end

function parse_value(s)
    --print("parse_value", s:sub(1,20), #s)
    local total, v
    -- number
    total, v = s:match('^((-?%d+)[,}%]])')
    if total then
        --print("found value", v:sub(1,10), #v, #total)
        count(v)
        return #total
    end
    -- string
    total, v = s:match('^("(%w+)"[,}%]])')
    if total then
        --print("found value", v:sub(1,10), #v, #total)
        if v == "red" then
            -- skip this object and all children
        end
        return #total
    end
    -- list
    total, v = s:match('^((%b[])[,}%]])')
    if total then
        --print("found value", v:sub(1,10), #v, #total)
        parse_list(v)
        return #total
    end
    -- object
    total, v = s:match('^((%b{})[,}%]])')
    if total then
        --print("found value", v:sub(1,10), #v, #total)
        parse_object(v)
        return #total
    end
    print("Error: parse_value found no match")
end

function parse_list(s)
    local i = 2
    repeat
        i = i + parse_value(s:sub(i,-1))
    until i >= #s
end

function parse_object(s)
    local i = 2
    repeat
        i = i + parse_key(s:sub(i,-1))
        i = i + parse_value(s:sub(i,-1))
    until i >= #s
    --[[
    if skip then
        for n in s:match("-?%d+") do
            result = result - n
        end
    end
    ]]--
end

for line in io.lines() do
    parse_object(line)
end

print("result", result)

