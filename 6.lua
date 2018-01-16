#!/usr/bin/lua

matrix = {}

commands = {}
commands.turn_on = function (matrix, i, j)
  matrix[i][j] = (matrix[i][j] or 0) | 1
end
commands.toggle = function (matrix, i, j)
  matrix[i][j] = (matrix[i][j] or 0) ~ 1
end
commands.turn_off = function (matrix, i, j)
  matrix[i][j] = (matrix[i][j] or 0) & 0
end

function execute(command, x1, y1, x2, y2)
  print(command, x1, y1, x2, y2)
  operation = commands[command:gsub(" ", "_")]
  for i=x1,x2 do
    if matrix[i] == nil then
      matrix[i] = {}
    end
    for j=y1,y2 do
      operation(matrix, i, j)
    end
  end
end

for line in io.lines() do
  command,x1,y1,x2,y2 = line:match("(.+) (%d+),(%d+) through (%d+),(%d+)")
  if command then
    execute(command, x1, y1, x2, y2)
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

