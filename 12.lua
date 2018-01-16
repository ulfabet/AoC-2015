#!/usr/bin/lua

result = 0
for line in io.lines() do
    for number in line:gmatch("-?%d+") do
        result = result + number
    end
end
print("result", result)

