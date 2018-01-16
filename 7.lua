#!/usr/bin/lua

-- wire name to signal value
wires = {}
-- wire name to list of gates
connections = {}

function get_signal(input)
  return wires[input] or tonumber(input)
end

--io.write("\027[H\027[2J")
debug_count = 0

function debug_wires()
  debug_count = debug_count + 1
  if debug_count % 10000 == 0 then 
    io.write("\027[H")
    for i=string.byte("a"),string.byte("z") do
      c = string.char(i)
      print(c, wires[c], "a"..c, wires["a"..c], "b"..c, wires["b"..c], "c"..c, wires["c"..c], "d"..c, wires["d"..c], "e"..c, wires["e"..c], "f"..c, wires["f"..c], "g"..c, wires["g"..c], "h"..c, wires["h"..c])
    end
    for i=string.byte("a"),string.byte("z") do
      c = string.char(i)
      print("i"..c, wires["i"..c], "j"..c, wires["j"..c], "k"..c, wires["k"..c], "l"..c, wires["l"..c], "m"..c, wires["m"..c], "n"..c, wires["n"..c], "o"..c, wires["o"..c], "p"..c, wires["p"..c])
    end
  end
end

function debug_connections_helper(arg)
    for i=string.byte("a"),string.byte("z") do
      c = arg..string.char(i)
      count = 0
      if connections[c] == nil then
        io.write(string.format("%2s %d ", c, 0))
      else
        for k, v in pairs(connections[c]) do
          count = count + 1
        end
        io.write(string.format("%2s %d ", c, count))
      end
    end
    print("")
end

function debug_connections(wire)
  debug_count = debug_count + 1
  if debug_count % 10000 == 0 then 
    io.write("\027[H")
    print("debug_connections")
    debug_connections_helper("")
    for i=string.byte("a"),string.byte("z") do
      debug_connections_helper(string.char(i))
    end
  end
end

function debug_assign(signal, wire)
  if #wire == 1 then
    column = 0
    line = string.byte(wire) - 96 
  else
    column = (string.byte(wire:sub(1,1)) - 96) * 7 + 1
    line = string.byte(wire:sub(2,2)) - 96 
  end
  io.write(string.format("\027[%d;%dH", line, column))
  print(signal)
  sleep(0.1)
end

function sleep(s)
  os.execute(string.format("sleep %f", s))
end

function sleep_lua(s)
  local ntime = os.time() + s
  repeat until os.time() > ntime
end

function assign(signal, wire)
  --debug_assign(signal, wire)
  --debug_wires()
  --debug_connections(wire)
  if wires[wire] == signal then
    return
  else
    wires[wire] = signal
  end
  if connections[wire] == nil then return end
  for k, v in pairs(connections[wire]) do
    v.fn(v)
  end
end

function create_gate(name, input1, input2, output)
  gate = {}
  gate.name = name
  gate.count = 0
  gate.input1 = input1
  gate.input2 = input2
  gate.output = output
  if name == "AND" then
    gate.fn = function (gate)
      if get_signal(input1) == nil or get_signal(input2) == nil then return end
      gate.count = gate.count + 1
      --print("gate.fn", name, input1, input2, output, gate.count)
      assign(get_signal(input1) & get_signal(input2), output)
    end
  end
  if name == "OR" then
    gate.fn = function (gate)
      if get_signal(input1) == nil or get_signal(input2) == nil then return end
      gate.count = gate.count + 1
      --print("gate.fn", name, input1, input2, output, gate.count)
      assign(get_signal(input1) | get_signal(input2), output)
    end
  end
  if name == "LSHIFT" then
    gate.fn = function (gate)
      if get_signal(input1) == nil or get_signal(input2) == nil then return end
      gate.count = gate.count + 1
      --print("gate.fn", name, input1, input2, output, gate.count)
      assign((get_signal(input1) << get_signal(input2)) & 65535, output)
    end
  end
  if name == "RSHIFT" then
    gate.fn = function (gate)
      if get_signal(input1) == nil or get_signal(input2) == nil then return end
      gate.count = gate.count + 1
      --print("gate.fn", name, input1, input2, output, gate.count)
      assign(get_signal(input1) >> get_signal(input2), output)
    end
  end
  if name == "NOT" then
    gate.fn = function (gate)
      if get_signal(input1) == nil then return end
      gate.count = gate.count + 1
      --print("gate.fn", name, input1, input2, output, gate.count)
      assign(~get_signal(input1) & 65535, output)
    end
  end
  if name == "CONNECTOR" then
    gate.fn = function (gate)
      if get_signal(input1) == nil then return end
      gate.count = gate.count + 1
      --print("gate.fn", name, input1, input2, output, gate.count)
      assign(get_signal(input1), output)
    end
  end
  return gate
end

function connect(wire, gate)
  if wire == nil then return end
  if tonumber(wire) then return end
  connections[wire] = connections[wire] or {}
  table.insert(connections[wire], gate)
end

outputs = {}

function create(input1, input2, gatename, output)
  gate = create_gate(gatename, input1, input2, output)
  if outputs[output] then 
    print("Warning: output override!", output)
    os.exit(1)
  else
    outputs[output] = gate
  end
  connect(input1, gate)
  connect(input2, gate)
  gate.fn(gate)
end

for line in io.lines() do
  print(line)
  input, output = line:match("^([%l%d]+) %-> (%l+)")
  if input then
    create(input, nil, "CONNECTOR", output)
  end
  input1, gate, input2, output = line:match("^([%l%d]+) (%u+) ([%l%d]+) %-> (%l+)")
  if output then
    create(input1, input2, gate, output)
  end
  gate, input1, output = line:match("^(%u+) ([%l%d]+) %-> (%l+)")
  if output then
    create(input1, nil, gate, output)
  end
end

print("result")
for k,v in pairs(wires) do
  print(k, v)
end
