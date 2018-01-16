#!/usr/bin/lua

matrix = { [0] = {} }
new_matrix = { [0] = {} }
    
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
    --[[
    if (x == 1 or x == 100) and (y == 1 or y == 100) then
        return 1
    end
    --]]
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
    new_matrix[1][1] = 1
    new_matrix[1][cols] = 1
    new_matrix[rows][1] = 1
    new_matrix[rows][cols] = 1
    matrix, new_matrix = new_matrix, matrix
end

matrix[1][1] = 1
matrix[1][cols] = 1
matrix[rows][1] = 1
matrix[rows][cols] = 1
--show_matrix()
for i = 1,100 do
    print("--", i)
    animate()
    --show_matrix()
end

value = 0
for i=1,rows do
    for j=1,cols do
        value = value + matrix[i][j]
    end
end
print("value", value)
