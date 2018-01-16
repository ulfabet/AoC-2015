#!/usr/bin/lua

result = 0

cities = {}

function insert(source, destination, distance)
    cities[source] = cities[source] or {}
    cities[source][destination] = distance
end

for line in io.lines() do
    city1, city2, distance = line:match("(%w+) to (%w+) = (%d+)")
    if distance then
        print(city1, city2, distance)
        insert(city1, city2, distance)
        insert(city2, city1, distance)
    end
end

route = {}
function route_push(arg)
    table.insert(route, arg)
end

function route_pop()
    table.remove(route)
end

max_distance = nil
shortest_path = {}
visited = {}

function climb(tree, left, distance)
    if left == 0 then
        if max_distance == nil or distance < max_distance then
            print("max_distance update", distance)
            max_distance = distance
            shortest_path = {}
            for k,v in pairs(route) do
                shortest_path[k] = v
            end
        end
        return
    end
    for k,v in pairs(tree) do
        if visited[k] and visited[k] > left then
            --print("visited", k, left)
        else
            --print("climb", k, left)
            visited[k] = left - 1
            route_push(k)
            climb(cities[k], left - 1, distance + v)
            route_pop()
            visited[k] = nil
        end
    end
end

count = 0
for k,v in pairs(cities) do
    count = count + 1
end
for k,v in pairs(cities) do
    print("climb", k)
    visited[k] = count - 1
    route_push(k)
    climb(v, count - 1, 0)
    route_pop()
    visited[k] = nil
end

print("max_distance", max_distance)
print("shortest_path")
for k,v in pairs(shortest_path) do
    print(k, v)
end
