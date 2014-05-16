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
	local dam = self.combat.dam or 1
	if weapon then
		local damage_type = weapon.combat.damtype or DamageType.PHYSICAL
		self:attackTargetWith(target, dam, damage_type, weapon)
	else
		self:attackTargetWith(target, dam, DamageType.PHYSICAL)
	end
	
	if not no_actions then
		self:useActionPoints(4)
	end
end

function _M:attackTargetWith(target, dam, damage_type, weapon)
	local adjustedHitChance = math.min(self:getHitChance(weapon), 95) - target.armor_class
	local hit = game.rng.percent(adjustedHitChance)
	
	local dmg = self:getBaseDam(dam, weapon)
		  dmg = self:getAdjustedDamage(dmg, target.damage_threshold)
		  dmg = self:getFinalDamage(dmg, target.damage_resistance)
	
	if hit then
		DamageType:get(damage_type).projector(self, target.x, target.y, damage_type, dmg)
	else
		self:missed(target, self)
	end
end

function _M:getHitChance(weapon)
	if weapon then
		return 55 + 0.5 * self:getCon() + 0.5 * self:getAlr()
	else
		return 30 + 0.5 * self:getCon() + 0.5 * self:getAlr()
	end
end

function _M:getBaseDam(raw, weapon)
	local base = raw or 0
	if weapon then
		base = base + game.rng.range(weapon.combat.dam[1], weapon.combat.dam[2])
	end
	return base
end

function _M:getAdjustedDamage(base, DT)
	return math.max(0, base - DT)
end

function _M:getFinalDamage(adjusted, DR)
	return math.max(1, adjusted * ((100 - math.min(DR, 90)) / 100))
end

function _M:missed(target, src)
	local flash = game.flash.GOOD
	if target == game.player then flash = game.flash.BAD end	
	if target then
		game.logSeen(target, flash, "%s misses.", src.name.capitalize())
	end
end