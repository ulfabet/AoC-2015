#!/usr/bin/lua

function string_to_array(s)
    local a = {}
    for i in s:gmatch(".") do
        table.insert(a, i)
    end
    return a
end

function array_to_string(a)
    return table.concat(a, "")
end

function increment_array(a, pos)
    if a[pos] == "z" then
        a[pos] = "a"
        increment_array(a, pos-1)
    else
        a[pos] = string.char(string.byte(a[pos]) + 1)
    end
end

alphabet = "abcdefghijklmnopqrstuvwxyz"
function match_straight(s)
    for i = 1,#alphabet-2 do
        if s:match(alphabet:sub(i, i+2)) then
            return true
        end
    end
    return false
end

--[[
function match_straight_array(a)
    for i = 1,#a-2 do
        if string.byte(a[i]) == string.byte(a[i+1])-1 and string.byte(a[i]) == string.byte(a[i+2])-2 then
            return true
        end
    end
    return false
end
]]--

for line in io.lines() do
    print("Working...")
    local a = string_to_array(line)
    repeat
        increment_array(a, #a)
        line = array_to_string(a)
    until line:match("(%w)%1.*([^%1])%2") and not line:match("[iol]") and match_straight(line)
    --until line:match("(%w)%1.*([^%1])%2") and not line:match("[iol]") and match_straight_array(a)
    print(line)
end

