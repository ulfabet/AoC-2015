#!/usr/bin/lua

nice = 0

for line in io.lines() do
  local x,y,z = 0,0,0
  if line:match("[aeiou].*[aeiou].*[aeiou]") then
    --print("nice: at least three vowels")
    x = 1
  end
  if line:match("(%w)%1") then
    --print("nice: letter twice in a row")
    y = 1
  end
  if line:match("ab") or line:match("cd") or line:match("pq") or line:match("xy") then
  else
    --print("nice: does not contain forbidden strings")
    z = 1
  end
  nice = nice + x*y*z
end

print("nice", nice)

