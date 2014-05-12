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
		if self:getActions() >= 4 then
			return self:attackTarget(target)
		elseif self == game.player then 
			game.flash(game.flash.BAD, "I don't have enough Action Points to do that. (5 Required)")
			-- game.log("Low Action Points!")
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
		self:attackTargetWith(target, damage_type, weapon_damage)
	else
		local damage_type = self.combat.damtype or DamageType.PHYSICAL
		self:attackTargetWith(target, damage_type)
	end
	
	if not no_actions then
		self:useActionPoints(4)
	end
end

function _M:attackTargetWith(target, damage_type, weapon_damage, damage_modifier)
	local weapon_damage = weapon_damage or 0
	local init_dam = self.combat.dam + weapon_damage	
	local calc_dam = math.floor(math.max(0, init_dam - target.combat_armor))
	
	DamageType:get(damage_type).projector(self, target.x, target.y, damage_type, calc_dam, hit_type)
	target:onHit(damage_type, calc_dam)
end

function _M:onHit(damtype, dam)
	
end