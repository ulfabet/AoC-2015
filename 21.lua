#!/usr/bin/lua

require "mydebug"

player = {}
player.hp = 100
player.damage = 0
player.armor = 0
player.cost = 0

boss = {}
boss.hp = 109
boss.damage = 8
boss.armor = 2

function equip(a)
    player.cost = player.cost + a[1]
    player.damage = player.damage + a[2]
    player.armor = player.armor + a[3]
end

function unequip(a)
    player.cost = player.cost - a[1]
    player.damage = player.damage - a[2]
    player.armor = player.armor - a[3]
end

stack = {}
function push(a)
    table.insert(stack, a)
end
function pop(a)
    table.remove(stack)
end

-- buy 1 weapon
function buy_weapon()
    for k,v in pairs(shop.Weapons) do
        equip(v);push(k)
        buy_armor()
        unequip(v);pop()
    end
end

-- buy 0-1 armor
function buy_armor()
    for k,v in pairs(shop.Armor) do
        equip(v);push(k)
        buy_ring()
        unequip(v);pop()
    end
end

-- buy 0-2 rings
function buy_ring()
    for k,v in pairs(shop.Rings) do
        equip(v);push(k)
        for l,w in pairs(shop.Rings) do
            if l ~= k then
                equip(w);push(l)
                calculate()
                unequip(w);pop()
            end
        end
        unequip(v);pop()
    end
end
--[[
function check()
    pl_attack = math.max(1, player.damage-boss.armor)
    bo_attack = math.max(1, boss.damage-player.armor)
    pl_hp = player.hp
    bo_hp = boss.hp
    while true do
        bo_hp = bo_hp - pl_attack
        if bo_hp <= 0 then
            print("player wins")
            return
        end
        pl_hp = pl_hp - bo_attack
        if pl_hp <= 0 then
            print("boss wins")
            return
        end
    end
end
--]]

costs = {}
function calculate()
    player_attack = math.max(1, player.damage-boss.armor)
    boss_attack = math.max(1, boss.damage-player.armor)
    if boss.hp/player_attack >= player.hp/boss_attack then
        --print("boss wins")
        table.insert(costs, player.cost)
        if player.cost == 188 then
            mydebug.dump(player)
            mydebug.dump(stack)
        end
    else
        --print("player wins")
    end
end

shop = {}
tmp = nil
for line in io.lines() do
    m = line:match("(%w+):")
    if m then
        shop[m] = {}
        tmp = shop[m]
    end
    m1,m2,m3,m4 = line:match("(.+)%s+(%d+)%s+(%d+)%s+(%d+)$")
    if m1 then
        tmp[m1] = {m2, m3, m4}
    end
end

shop.Armor.None = {0,0,0}
shop.Rings.EmptyLeft = {0,0,0}
shop.Rings.EmptyRight = {0,0,0}

buy_weapon()
table.sort(costs)
print("cost", costs[1], costs[#costs])
