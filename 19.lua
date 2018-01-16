#!/usr/bin/lua

require "mydebug"

molecule = {} -- { Element1, Element2, ... }
transformations = {} -- Element => { Element1, Element2, ... }
--setmetatable(transformations, {__index = function () return {} end})

function parse_molecule(line)
    for element in line:gmatch("%u%l?") do
        table.insert(molecule, element)
    end
end

function parse_transformations(line)
    for from, to in line:gmatch("(%w+) => (%w+)") do
        transformations[from] = transformations[from] or {}
        table.insert(transformations[from], to)
    end
end

parse = parse_transformations
for line in io.lines() do
    if line == "" then
        parse = parse_molecule
    else
        parse(line)
    end
end

mydebug.dump(transformations)
--mydebug.dump(molecule)

function calibrate()
    results = {}
    for i,v in ipairs(molecule) do
        if transformations[v] then
            for j,w in ipairs(transformations[v]) do
                molecule[i] = w 
                m2 = table.concat(molecule)
                results[m2] = true
            end
            molecule[i] = v
        end
    end
    print("count", mydebug.count(results))
end

reverse = {}
reverse_keys = {}
for k,v in pairs(transformations) do
    for j,w in ipairs(v) do
        reverse[w] = k
        table.insert(reverse_keys, w)
    end
end
function sf(a, b)
    _, ac = a:gsub("%u", "%1")
    _, bc = b:gsub("%u", "%1")
    return ac > bc
end
table.sort(reverse_keys, sf)
mydebug.dump(reverse)
mydebug.dump(reverse_keys)

--[[
s = table.concat(molecule)
for q = 1,6 do
    for i,v in ipairs(reverse_keys) do
        repeat
            s, count = s:gsub(v, reverse[v], 1)
        until count == 0
        print(s)
    end
end
--]]

best = 0
skip = {}
function search(s, level)
    --local prefix = string.rep(".", level)
    if level > best and best ~= 0 then
        print("level > best")
        return
    end
    if s == "e" then
        print("DONE: " .. level)
        best = level
        return
    end
    if skip[s] then
        --print("skip")
        return
    else
        skip[s] = true
    end
    --io.write("\r", #s)
    for i,v in ipairs(reverse_keys) do
        local s2, c = s:gsub(v, reverse[v], 1)
        if c == 1 then
            --print(prefix .. v .. " -> " .. reverse[v])
            --print(v .. " -> " .. reverse[v])
            search(s2, level+1)
        end
    end
end

search(table.concat(molecule), 0)
