#!/usr/bin/lua

matrix = {}

function dump(t)
    io.write("{")
    if next(t) == nil then
        io.write("}\n")
    else
        for k,v in pairs(t) do
            io.write(k, "=")
            if type(v) == "table" then dump(v)
            else io.write(v)
            end
            io.write(", ")
        end
        io.write("\b\b}\n")
    end
end

function get_happiness(a, b)
    return matrix[a][b]+matrix[b][a]
end

--function maximum_happiness(a, b)
--end

function generate_tree(parents, children)
    -- {a = {b = {c = {d}, d = {c}}, c = {b = {d}, d = {b}}, ...
    -- source: matrix {a -> {b -> 1, c -> 2, d -> 3}, b -> {...}, c -> {...}, d -> {...}}
    -- todo: remove arg parents
    
    --[[
    print("generate_tree", parents and #parents, children and #children)
    if parents then dump(parents) end
    if children then dump(children) end
    --]]

    local t = {}

    if children and #children == 0 then
        --print("no children")
        return t
    end

    if parents == nil then
        local new_parent,v = next(matrix)
        local list = {}
        for k,v in pairs(v) do
            table.insert(list, k)
        end
        t[new_parent] = generate_tree({new_parent}, list)
    else
        for k, new_parent in pairs(children) do
            local list = {}
            for k,v in pairs(children) do
                if v ~= new_parent then
                    table.insert(list, v)
                end
            end
            --table.insert(parents, new_parent) -- push
            t[new_parent] = generate_tree({}, list)
            --table.remove(parents) -- pop
        end
    end
    return t
end

function empty(t)
    return next(t) == nil
end

--[[
function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end
--]]

debug = {}

function optimal_seating(parent, children, happiness, level)
    debug[level] = parent
    --print("parent", parent, happiness, level)
    if empty(children) then
        --print(happiness + get_happiness(parent, debug[1]))
        --[[
        local count = 0
        for i = 1,8 do
            count = count + get_happiness(debug[i], debug[(i%8)+1])
        end
        print(count)
        --]]
    else
        for child,grandchildren in pairs(children) do
            optimal_seating(child, grandchildren, happiness + get_happiness(parent, child), level+1)
        end
    end
end

for line in io.lines() do
    local a,b,c,d = line:match("(%w+) would (%w+) (%d+) happiness units by sitting next to (%w+).")
    if a then
        matrix[a] = matrix[a] or {}
        matrix[a][d] = ({ lose = -1, gain = 1 })[b] * c
    end
end
--dump(matrix)
tree = generate_tree()
--dump(tree)
--optimal_seating(tree, 0, 1)
parent, children = next(tree)
optimal_seating(parent, children, 0, 1)
