#!/usr/bin/lua

function parse_key(i)
    local s = i.data:sub(i.pos, -1)
    local total, k = s:match('^("(%w+)":)')
    i.pos = i.pos + #total
    return k
end

function parse_value(i)
    local total, v
    local s = i.data:sub(i.pos, -1)
    -- number
    total, v = s:match('^((-?%d+)[,}%]])')
    if total then
        i.pos = i.pos + #total
        return v
    end
    -- string
    total, v = s:match('^("(%w+)"[,}%]])')
    if total then
        i.pos = i.pos + #total
        return v
    end
    -- list
    total, v = s:match('^((%b[])[,}%]])')
    if total then
        i.pos = i.pos + #total
        return parse_list({["pos"] = 2, ["data"] = v})
    end
    -- object
    total, v = s:match('^((%b{})[,}%]])')
    if total then
        i.pos = i.pos + #total
        return parse_object({["pos"] = 2, ["data"] = v})
    end
    print("Error: parse_value found no match")
end

function is_ready(i)
    return i.pos >= #i.data
end

function parse_list(i)
    local o = {}
    repeat
        table.insert(o, parse_value(i))
    until is_ready(i)
    return o
end

function parse_object(i)
    local o = {}
    local valid = true
    repeat
        local k = parse_key(i)
        local v = parse_value(i)
        if v == "red" then
            valid = nil
        end
        o[k] = v
    until is_ready(i) or not valid
    return valid and o
end

function is_valid(t)
    if type(t) == "table" then
        for k,v in pairs(t) do
            if tonumber(k) then
                return true -- hack to distinguish lists from objects
            end
            if v == "red" then
                return false
            end
        end
    end
    return true
end

function remove_invalid(t)
    for k,v in pairs(t) do
        if is_valid(v) then
            if type(v) == "table" then
                remove_invalid(v)
            end
        else
            t[k] = nil
        end
    end
end

function calc(t)
    local value = 0
    for k,v in pairs(t) do
        if type(v) == "table" then
            value = value + calc(v)
        else
            value = value + (tonumber(v) or 0)
        end
    end
    return value
end

for line in io.lines() do
    local o = {}
    o.pos = 2
    o.data = line
    local t = parse_object(o)
    print("calc", calc(t))
    remove_invalid(t)
    print("calc", calc(t))
end
