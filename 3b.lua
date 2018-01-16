#!/usr/bin/lua

s = io.stdin:read("*all")

real = {}
real.x = 0
real.y = 0

robo = {}
robo.x = 0
robo.y = 0

santa = { [0] = real, [1] = robo }

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

function move(o, dx, dy)
  o.x = o.x + dx
  o.y = o.y + dy
  visit(o.x, o.y)
end

turn = 0
visit(0, 0)
for c in s:gmatch("[><^v]") do
  --print(c)
  if c == ">" then move(santa[turn], 1, 0) end
  if c == "<" then move(santa[turn], -1, 0) end
  if c == "^" then move(santa[turn], 0, 1) end
  if c == "v" then move(santa[turn], 0, -1) end
  turn = turn ~ 1
end

print("count", count)
print(string.format("count: %d", count))

