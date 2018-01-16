#!/usr/bin/lua

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

--
function dijkstra(graph, source)

    print("dijkstra", source)

    local Q = {}
    local count = 0

    local dist = {}
    local prev = {}

    for v in pairs(graph) do
        Q[v] = true
        count = count + 1
    end

    dist[source] = 0
    
    function get_closest_vertex(Q)
        local min_dist
        local min_dist_node

        for node in pairs(Q) do
            if dist[node] == nil then
            else
                if min_dist == nil or dist[node] < min_dist then
                    min_dist = dist[node]
                    min_dist_node = node
                end
            end
        end
        return min_dist_node
    end

    while count > 0 do
        u = get_closest_vertex(Q)
        print("closest", u)
        Q[u] = nil
        count = count - 1

        for v in pairs(graph[u]) do
            if not (Q[v] == nil) then
               alt = dist[u] + graph[u][v]
               if dist[v] == nil or alt < dist[v] then
                   dist[v] = alt
                   prev[v] = u
               end
            end
        end
    end

    return dist, prev
end

--
min_total = nil
for source in pairs(cities) do
    dist, prev = dijkstra(cities, source)
    total = 0
    for k,v in pairs(dist) do
        print("--", k, v)
        total = total + v
    end
    print("total", total)
    if min_total == nil or total < min_total then
        min_total = total
    end
end
print("min_total", min_total)

os.exit(0)

--
max_distance = nil
visited = {}

function climb(tree, left, distance)
    if left == 0 then
        if max_distance == nil then
            max_distance = distance
        else
            max_distance = math.min(max_distance, distance)
        end
        return
    end
    for k,v in pairs(tree) do
        if visited[k] and visited[k] > left then
            print("visited", k, left)
        else
            print("climb", k, left)
            visited[k] = left - 1
            climb(cities[k], left - 1, distance + v)
        end
    end
end

count = 0
for k,v in pairs(cities) do
    count = count + 1
end
for k,v in pairs(cities) do
    print("climb", k)
    visited = {}
    visited[k] = count - 1
    climb(v, count - 1, 0)
end

print("max_distance", max_distance)
