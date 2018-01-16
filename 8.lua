#!/usr/bin/lua

result = 0
resultb = 0

for line in io.lines() do
  s = loadstring("return" .. line)()
  s2 = string.format("%q", line)
  print(#line, #s, #s2)
  result = result + #line - #s
  resultb = resultb + #s2 - #line
end

print("result", result)
print("resultb", resultb)
