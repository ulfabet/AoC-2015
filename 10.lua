#!/usr/bin/lua

result = 0

function translate1(arg)
    local previous
    local count = 0
    local new = ""
    for c in arg:gmatch("%d") do
        if c == previous then
            count = count + 1
        else
            if previous then
                new = new .. count .. previous
            end
            previous = c
            count = 1
        end
    end
    if previous then
        new = new .. count .. previous
    end
    return new
end

function translate2(arg)
    local previous
    local count = 0
    local new = ""
    for i = 1,#arg do
        c = arg:sub(i, i)
        if c == previous then
            count = count + 1
        else
            if previous then
                new = new .. count .. previous
            end
            previous = c
            count = 1
        end
    end
    if previous then
        new = new .. count .. previous
    end
    return new
end

function translate(arg)
    local new = ""
    local start = 1
    local arglen = #arg
    while start <= arglen do
        for i = 1,9 do
            a, b = arg:find("^"..i.."+", start)
            if a then
                --print("find", i, a, b)
                new = new .. (b-a+1) .. i
                start = start + (b-a+1)
                break
            end
        end
    end
    return new
end

for line in io.lines() do
    --[[
    for i=1,4 do
        line = translate(line)
        print(i, line, #line)
    end
    ]]--
    for i=1,40 do
        line = translate(line)
        print(i, #line)
    end
end

