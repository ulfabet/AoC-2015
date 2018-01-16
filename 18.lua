#!/usr/bin/lua

matrix = {}
new_matrix = {}

commands = {}
commands.turn_on = function (matrix, i, j)
  matrix[i][j] = (matrix[i][j] or 0) + 1
end
commands.toggle = function (matrix, i, j)
  matrix[i][j] = (matrix[i][j] or 0) + 2
end
commands.turn_off = function (matrix, i, j)
  matrix[i][j] = math.max(0, (matrix[i][j] or 0) - 1)
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

matrix = { [0] = {}}
new_matrix = { [0] = {}}
    
y = 1
for line in io.lines() do
    x = 1
    matrix[y] = {}
    new_matrix[y] = {}
    for c in line:gmatch(".") do
        matrix[y][x] = (c == "#") and 1 or 0
        x = x+1
    end
    y = y+1
end
cols = x-1
rows = y-1
matrix[y] = {}
new_matrix[y] = {}

function show_matrix()
    for i=1,rows do
        for j=1,cols do
            io.write(matrix[i][j])
        end
        print()
    end
end

function get_state(x, y)
    local value = 0
    for i = -1,1 do
        for j = -1,1 do
            value = value + (matrix[y+i][x+j] or 0)
        end
    end
    if matrix[y][x] == 0 then
        return (value == 3) and 1 or 0
    else
        return (value == 3 or value == 4) and 1 or 0
    end
end

function animate()
    for y=1,rows do
        for x=1,cols do
            new_matrix[y][x] = get_state(x, y)
        end
    end
    matrix, new_matrix = new_matrix, matrix
end

--show_matrix()
--print("--")
for i = 1,100 do
    --io.write(i,"\r")
    print (i)
    animate()
    --show_matrix()
    --print("--")
end

value = 0
for i=1,rows do
    for j=1,cols do
        value = value + matrix[i][j]
    end
end
print("value", value)
