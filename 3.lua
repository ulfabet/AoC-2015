#!/usr/bin/lua

s = io.stdin:read("*all")

x = 0
y = 0
visited = {}
count = 0

function visit(x, y)
  if visited[x] == nil then
    visited[x] = {}
  end
  if visited[x][y] == nil then
    count = count+1
    visited[x][y] = 1
    print("x", x, "y", y)
  end
end

visit(x, y)
for c in s:gmatch(".") do
  --print(c)
  if c == ">" then x = x+1 end
  if c == "<" then x = x-1 end
  if c == "^" then y = y+1 end
  if c == "v" then y = y-1 end
  visit(x, y)
end

print("count", count)
print(string.format("count: %d", count))

