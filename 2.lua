#!/usr/bin/lua

ribbon = 0
paper = 0
for s in io.stdin:lines() do
  l, w, h = s:match("(%d+)x(%d+)x(%d+)")
  lw, wh, lh = l*w, w*h, l*h
  paper = paper + math.tointeger(2*(lw+wh+lh)+math.min(lw, wh, lh))
  ribbon = ribbon + math.tointeger(2*math.min(l+w, w+h, l+h)+l*w*h)
  print(ribbon)
end
print("paper", paper)
print("ribbon", ribbon)

