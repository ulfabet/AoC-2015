#!/usr/bin/lua

require "mydebug"

p = {}
pc = 1
regs = { a = 1, b = 0 }
ii = {}
ii.hlf = function (r)
    log("hlf", r)
    regs[r] = regs[r] >> 1
    pc = pc + 1
end
ii.tpl = function (r)
    log("tpl", r)
    regs[r] = regs[r] * 3
    pc = pc + 1
end
ii.inc = function (r)
    log("inc", r)
    regs[r] = regs[r] + 1
    pc = pc + 1
end
ii.jmp = function (offset)
    log("jmp", offset)
    pc = pc + offset
end
ii.jie = function (r, offset)
    log("jie", r, offset)
    if (regs[r] % 2) == 1 then offset = 1 end
    pc = pc + offset
end
ii.jio = function (r, offset)
    log("jio", r, offset)
    if regs[r] ~= 1 then offset = 1 end
    pc = pc + offset
end

function log(...)
    local arg={...}
    --print(table.concat({...}, " "))
end

function execute(s)
    if s then
        for i, p in ipairs({ "(%w+) ([+-]%d+)", "(%w+) ([ab]), ([+-]%d+)", "(%w+) ([ab])" }) do
            m1, m2, m3 = s:match(p)
            if ii[m1] then
                --print(m1, m2, m3)
                ii[m1](m2, m3)
                return true
            end
        end
    else
        print("cannot execute", s, pc)
    end
    return false
end

for line in io.lines() do
    table.insert(p, line)
end

while execute(p[pc]) do
end

print("a = "..regs.a..", b = "..regs.b)

