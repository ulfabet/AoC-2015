#!/usr/bin/lua

matrix = {}

commands = {}
commands.turn_on = function (x1, y1, x2, y2)
  for i=x1,x2 do
    if matrix[i] == nil then
      matrix[i] = {}
    end
    array = matrix[i]
    for j=y1,y2 do
      array[j] = (array[j] or 0) | 1
    end
  end
end
commands.toggle = function (x1, y1, x2, y2)
  for i=x1,x2 do
    if matrix[i] == nil then
      matrix[i] = {}
    end
    array = matrix[i]
    for j=y1,y2 do
      array[j] = (array[j] or 0) ~ 1
    end
  end
end
commands.turn_off = function (x1, y1, x2, y2)
  for i=x1,x2 do
    if matrix[i] == nil then
      matrix[i] = {}
    end
    array = matrix[i]
    for j=y1,y2 do
      array[j] = (array[j] or 0) & 0
    end
  end
end

for line in io.lines() do
  command,x1,y1,x2,y2 = line:match("(.+) (%d+),(%d+) through (%d+),(%d+)")
  if command then
    print(command, x1, y1, x2, y2)
    commands[command:gsub(" ", "_")](x1, y1, x2, y2)
  end
end

result = 0
 
for i=0,999 do
  io.write(i, "\r")
  for j=0,999 do
    if matrix[i] == nil then
    else
      result = result + (matrix[i][j] or 0)
    end
  end
end

print("result", result)

