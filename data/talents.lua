-- ToME - Tales of Middle-Earth
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
-- darkgod@te4.org


newTalentType{ type="role/combat", name = "combat", description = "Combat techniques" }
newTalentType{ type="attack/mob", name = "mob", description = "Mob auto-attacks" }

newTalent{
	name = "Mad",
	type = {"role/combat", 1},
	points = 1,
	cooldown = 2,
	sanity = 1,
	range = 1,
	mode = "passive",
	getAttack = function(self, t) return self:getTalentLevel(t) * 10 end,
	action = function(self, t) end,
	info = function(self, t)
		return "Zshhhhhhhhh!"
	end,
}

newTalent{
	name = "Attack",
	type = {"role/combat", 1},
	points = 1,
	cooldown = 0,
	sanity = 0,
	range = 1,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end

		self:bumpInto(target)
		return true
	end,
	info = function(self, t)
		return "Attack!"
	end,
}


newTalent{
	name = "Fire",
	type = {"role/combat", 1},
	points = 1,
	cooldown = 0,
	sanity = 0,
	range = 5,
	action = function(self, t)
		-- Get param data to pass to bullet
		local tg = {type="bolt", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		
		-- Check to see if we have a weapon (gun) in hand
		local weapon = self:getWeaponFromSlot("HAND")
		
		-- Check to see if we have any bullets
		local bullet_o, bullet = self:findInInventory(self:getInven("INVEN"), ".45 ACP Round")
		if not x or not y or not target or not weapon or not bullet_o then return nil end
		
		-- Fire the gun
		self:project(tg, x, y, DamageType.PIERCING, 10)
		
		--Remove the bullet from the inventory
		self:playerUseItem(bullet_o, bullet, self.INVEN_INVEN)
	end,
	info = function(self, t)
		return "Fire!"
	end,
}

--Unused / boxed
--newTalent{
--	name = "Kick",
--	type = {"role/combat", 1},
--	points = 1,
--	cooldown = 6,
--	sanity = 0,
--	range = 1,
--	action = function(self, t)
--		local tg = {type="hit", range=self:getTalentRange(t)}
--		local x, y, target = self:getTarget(tg)
--		if not x or not y or not target then return nil end
--		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
--
--		target:knockback(self.x, self.y, 2 + self:getCon())
--		return true
--	end,
--	info = function(self, t)
--		return "Kick!"
--	end,
--}
--newTalent{
--	name = "Particles",
--	type = {"role/combat", 1},
--	points = 1,
--	cooldown = 0,
--	sanity = 0,
--	range = 10,
--	action = function(self, t)
--		local tg = {type="ball", range=self:getTalentRange(t), radius=1, talent=t}
--	local x, y = self:getTarget(tg)
--		if not x or not y then return nil end
--		self:project(tg, x, y, DamageType.ACID, 1 + self:getMen(), {type="acid"})
--		return true
--	end,
--	info = function(self, t)
--		return "Zshhhhhhhhh!"
--	end,
--}

