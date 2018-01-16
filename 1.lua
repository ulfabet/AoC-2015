#!/usr/bin/lua

s = io.stdin:read("*all")

tmp, up = s:gsub("%(", "")
tmp, down = s:gsub("%)", "")
print(up-down)

