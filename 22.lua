#!/usr/bin/lua

require "mydebug"

player = {}
player.hp = 50
player.mana = 500
player.damage = 0
player.armor = 0
player.effects = {}
player.total = 0

boss = {}
boss.hp = 71
boss.damage = 10
boss.armor = 0
boss.effects = {}

spells = {}

spell = {}
spell.name = "Magic Missile"
spell.cost = 53
spell.damage = 4
spell.cast = function (self, player, boss)
    boss.hp = boss.hp - self.damage
    return true
end
spells[spell.name] = spell

spell = {}
spell.name = "Drain"
spell.cost = 73
spell.damage = 2
spell.heal = 2
spell.cast = function (self, player, boss)
    player.hp = player.hp + self.heal
    boss.hp = boss.hp - self.damage
    return true
end
spells[spell.name] = spell

spell = {}
spell.name = "Shield"
spell.cost = 113
spell.armor = 7
spell.cast = function (self, player, boss)
    return add_effect(player, self, 6)
end
spell.effect = function (self, player, boss)
    player.armor = self.armor
    success = remove_effect(player, self)
    if success then
        player.armor = 0
    end
    return success
end
spells[spell.name] = spell

spell = {}
spell.name = "Poison"
spell.cost = 173
spell.damage = 3
spell.cast = function (self, player, boss)
    return add_effect(boss, self, 6)
end
spell.effect = function (self, player, boss)
    boss.hp = boss.hp - self.damage
    return remove_effect(boss, self)
end
spells[spell.name] = spell

spell = {}
spell.name = "Recharge"
spell.cost = 229
spell.mana = 101
spell.cast = function (self, player, boss)
    return add_effect(player, self, 5)
end
spell.effect = function (self, player, boss)
    player.mana = player.mana + self.mana
    return remove_effect(player, self)
end
spells[spell.name] = spell

--
function add_effect(target, spell, timeout)
    if target.effects[spell.name] then
        return false
    else
        target.effects[spell.name] = spell
        spell.timer = timeout
        return true
    end
end

function remove_effect(target, spell)
    spell.timer = spell.timer - 1
    if spell.timer == 0 then
        target.effects[spell.name] = nil
        return true
    else
        return false
    end
end

stack = {}
function push(a)
    table.insert(stack, a)
end
function pop(a)
    return table.remove(stack)
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function apply_effects(player, boss)
    -- player effects
    for k,v in pairs(player.effects) do
        v:effect(player, boss)
    end
    -- boss effects
    for k,v in pairs(boss.effects) do
        v:effect(boss, boss)
    end
end

best = 2010 -- initial for testing. there are better.
function check_hp(player, boss)
    if boss.hp <= 0 then
        print("win", player.total)
        if player.total < best then
            best = player.total
        end
        return false
    end
    if player.hp <= 0 then
        --print("loss", player.total)
        return false
    end
    return true
end

function print_status(status, player, boss)
    print(status)
    print(string.format(" player hp %d, armor %d, mana %d", player.hp, player.armor, player.mana))
    print(string.format(" boss hp %d", boss.hp))
end

function player_action(spell, player, boss)
    --print_status("-- player turn --", player, boss)
    apply_effects(player, boss)
    if check_hp(player, boss) then
        if spell.cost > player.mana then
            --print("cannot afford spell", spell.name)
        else
            local success = spell:cast(player, boss)
            --print("cast", spell.name, success)
            if success then
                player.mana = player.mana - spell.cost
                player.total = player.total + spell.cost
                if check_hp(player, boss) then
                    return true
                end
            end
        end
    end
    return false
end

function boss_action(player, boss)
    --print_status("-- boss turn --", player, boss)
    apply_effects(player, boss)
    if check_hp(player, boss) then
        player.hp = player.hp - math.max(1, boss.damage-player.armor)
        --print("boss does "..math.max(1, boss.damage-player.armor).." damage")
        if check_hp(player, boss) then
            return true
        end
    end
    return false
end

function play(player, boss, turn)
    if player.total > best then
        return
    end
    for k,v in pairs(spells) do
        -- save state
        push(deepcopy(player))
        push(deepcopy(boss))
        if player_action(v, player, boss) then
            if boss_action(player, boss) then
                -- next move
                play(player, boss, turn+1)
                --print("> return to " .. turn)
            end
        end
        -- restore state
        boss = pop()
        player = pop()
    end
end

play(player, boss, 1)

--[[
-- example 1
player.hp = 10
player.mana = 250
boss.hp = 13
boss.damage = 8
player_action(spells["Poison"], player, boss)
boss_action(player, boss)
player_action(spells["Magic Missile"], player, boss)
boss_action(player, boss)
--]]

--[[
-- example 2
player.hp = 10
player.mana = 250
boss.hp = 14
boss.damage = 8
player_action(spells["Recharge"], player, boss)
boss_action(player, boss)
player_action(spells["Shield"], player, boss)
boss_action(player, boss)
player_action(spells["Drain"], player, boss)
boss_action(player, boss)
player_action(spells["Poison"], player, boss)
boss_action(player, boss)
player_action(spells["Magic Missile"], player, boss)
boss_action(player, boss)
--]]

