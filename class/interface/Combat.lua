--[[ ToME - Tales of Middle-Earth
-- Copyright (C) 2009, 2010, 2011, 2012, 2013 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org ]]

require "engine.class"
local DamageType = require "engine.DamageType"
local Map = require "engine.Map"
local Target = require "engine.Target"
local Talents = require "engine.interface.ActorTalents"

--- Interface to add ToME combat system
module(..., package.seeall, class.make)

--- Checks what to do with the target
-- Talk ? attack ? displace ?
function _M:bumpInto(target)
	local reaction = self:reactionToward(target)
	if reaction < 0 then
		if self:getActions() >= 5 then
			return self:attackTarget(target)
		elseif self == game.player then 
			game.flash(game.flash.BAD, "I don't have enough Action Points to do that. (5 Required)")
			game.log("Low Action Points!")
		else
			self:useActionPoints(self:getActions())
		end
	elseif reaction >= 0 then
		if self.move_others then
			-- Displace
			game.level.map:remove(self.x, self.y, Map.ACTOR)
			game.level.map:remove(target.x, target.y, Map.ACTOR)
			game.level.map(self.x, self.y, Map.ACTOR, target)
			game.level.map(target.x, target.y, Map.ACTOR, self)
			self.x, self.y, target.x, target.y = target.x, target.y, self.x, self.y
		end
	end
end

function _M:attackTarget(target, no_actions)
	local weapon = self:getWeaponFromSlot("HAND")
	
	if weapon then
		local damage_type = weapon.combat.damtype or self.combat.damtype or DamageType.PHYSICAL
		local weapon_damage = weapon.combat.dam or 0
		local damage_modifier = self:getDamageModifier(weapon, target)
		self:attackTargetWith(target, damage_type, weapon_damage, damage_modifier)
	else
		local damage_type = self.combat.damtype or DamageType.PHYSICAL
		self:attackTargetWith(target, damage_type)
	end
	
	if not no_actions then
		self:useActionPoints(5)
	end
end

function _M:attackTargetWith(target, damage_type, weapon_damage, damage_modifier)
	local weapon_damage = weapon_damage or 0
	local damage_modifier = damage_modifier or 1
	
	local init_dam = self.combat.dam + (weapon_damage * damage_modifier)	
	local calc_dam = math.floor(math.max(0, init_dam - target.combat_armor))
	
	if calc_dam == 0 then 
		self:deflectAttack(weapon_damage, damage_type)
	else
		DamageType:get(damage_type).projector(self, target.x, target.y, damage_type, calc_dam, hit_type)
		target:onHit(damage_type, calc_dam)
	end
end

function _M:deflectAttack(damage_type, weapon_damage)
	self:attackTargetWith(self, damage_type, weapon_damage + self.combat_armor, 1 / 4)	
end

function _M:onHit(damtype, dam)
	if damtype == DamageType.ELDRITCH then
			self:setEffect(game.player.EFF_MADNESS, 1, {power = ((dam / 1) * 0.25)})
		end
		
		if damtype == DamageType.SANGUINE then
			self:heal(0.50 * dam, self)
		end
		
		if damtype == DamageType.INFECTED then
			self:setEffect(game.player.EFF_POISON, 5, {power = (dam * 0.25)})
		end
end

function _M:getDamageType()
	local weapon = self:getWeaponFromSlot("HAND")
	local damage_type
	if weapon then
		damage_type = weapon.combat.damtype or self.combat.damtype or DamageType.PHYSICAL
	else
		damage_type = self.combat.damtype or DamageType.PHYSICAL
	end
	return damage_type
end

function _M:getDamageModifier(weapon, target)
	local damage_modifier = 1
	if weapon then
		damage_modifier = 1 + self:getSuperModifier(weapon, target)
		damage_modifier = damage_modifier + self:getSubModifier(weapon, target)
	end
	return damage_modifier
end

function _M:getSuperModifier(weapon, target)
	if DamageType:get(target.combat.weakness).supertype ==  nil then return 0 end
	if DamageType:get(weapon.combat.damtype).supertype == nil then return 0 end
	if weapon.combat.dam then
		damage = damage * self:getCon()
		if DamageType:get(weapon.combat.damtype).supertype == DamageType:get(target.combat.weakness).supertype then
			return 1 / 2
		end
		if DamageType:get(weapon.combat.damtype).supertype == DamageType:get(target.combat.strength).supertype then
			return 1 / 2
		end
		return 0
	end
	return 0
end

function _M:getSubModifier(weapon, target)
	if weapon.combat.dam then
		if DamageType:get(weapon.combat.damtype).subtype == DamageType:get(target.combat.weakness).subtype then
			return 1 / 1
		end
		if DamageType:get(weapon.combat.damtype).subtype == DamageType:get(target.combat.strength).subtype then
			return 1 / 1
		end
		return 0
	end
	return 0
end
