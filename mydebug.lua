mydebug = {}

function mydebug.dump(t)
    io.write("{")
    if next(t) == nil then
        io.write("}\n")
    else
        for k,v in pairs(t) do
            io.write(k, "=")
            if type(v) == "table" then
                mydebug.dump(v)
            else
                io.write(tostring(v))
            end
            io.write(", ")
        end
        io.write("\b\b}\n")
    end
end

function mydebug.get_all_factors(number)
    local factors = {}
    for possible_factor = 1, math.sqrt(number) do
        local remainder = number % possible_factor
        if remainder == 0 then
            local factor, factor_pair = possible_factor, number/possible_factor
            table.insert(factors, factor)
            if factor ~= factor_pair then
                table.insert(factors, factor_pair)
            end
        end
    end
    table.sort(factors)
    return factors
end

function mydebug.count(t)
    local i = 0
    for k,v in pairs(t) do
        i = i+1
    end
    return i
end

function mydebug.sum(a)
    local value = 0
    for i,v in pairs(a) do
        value = value + v
    end
    return value
end

return mydebug
