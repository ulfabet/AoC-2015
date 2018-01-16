#!/usr/bin/lua

--[[
function print_array(array)
    for i = 1,#array do
        io.write(string.char(array[i]))
    end
    print()
end
]]--

function string_to_array(s)
    local a = {}
    for c in s:gmatch(".") do
        table.insert(a, string.byte(c))
    end
    return a
end

function array_to_string(a)
    local s = ""
    for i = 1,#a do
        s = s .. string.char(a[i])
    end
    return s
end

function increment_array(password, offset)
    if password[offset] == string.byte("z") then
        password[offset] = string.byte("a")
        increment_array(password, offset-1)
    else
        password[offset] = password[offset] + 1
    end
end

function increment_string(s)
    a = string_to_array(s)
    increment_array(a, #a)
    return array_to_string(a)
end

function match_straight(s)
    alphabet = "abcdefghijklmnopqrstuvwz"
    for i = 1,#alphabet-2 do
        if s:match(alphabet:sub(i, i+2)) then
            return true
        end
    end
    return false
end

for line in io.lines() do
    print(line)
    while true do
        local continue = false
        line = increment_string(line)
        if not match_straight(line) then
            --print("does not contain a straight", line)
            continue = true
        end
        if line:match("[iol]") then
            --print("contains [iol]", line)
            continue = true
        end
        if not line:match("(%w)%1.*([^%1])%2") then
            --print("does not contain two doubles", line)
            continue = true
        end
        if not continue then
            break
        end
    end
    print(line)

    --[[
    local array = {}
    for c in line:gmatch(".") do
        table.insert(array, string.byte(c))
    end
    print_array(array)
    increment(array, 1)
    print_array(array)
    ]]--

end

