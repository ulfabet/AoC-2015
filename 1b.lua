#!/usr/bin/lua

s = io.stdin:read("*all")

floor = 0
for i = 1,s:len() do
  c = s:sub(i, i)
  if c == "(" then floor = floor + 1 end
  if c == ")" then floor = floor - 1 end
  if floor == -1 then
    print("i", i)
  end
end

