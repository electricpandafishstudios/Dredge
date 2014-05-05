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
	
local function doDamageFlyers(src, x, y, type, dam, hit_type)
	local flash = game.flash.NEUTRAL
	if target == game.player then flash = game.flash.BAD end
	if src == game.player then flash = game.flash.GOOD end	
	
	local target = game.level.map(x, y, Map.ACTOR)
	if target then
		if src == game.player then
			game.logSeen(target, flash, "Your attack %s %s", target:getHitMessage(src:getDamageType()), target.name)
		elseif target == game.player then
			game.logSeen(target, flash, "%s's attack %s you", src.name:capitalize(), target:getHitMessage(src:getDamageType()))
		end
		
		if target:takeHit(dam, src) then
			if src == game.player or target == game.player then
				game.flyers:add(sx, sy, 30, (rng.range(0,2)-1) * 0.5, -3, "Kill!", {255,0,255})
				game.logSeen(target, flash, "%s %s", target.name:capitalize(), target:getDeathMessage(src:getDamageType())) 
			 end
		else
			if src == game.player then
				game.flyers:add(sx, sy, 30, (rng.range(0,2)-1) * 0.5, -3, tostring(-math.ceil(dam)), {0,255,0})
			elseif target == game.player then
				game.flyers:add(sx, sy, 30, (rng.range(0,2)-1) * 0.5, -3, tostring(-math.ceil(dam)), {255,0,0})
			end
		end
	end
end

-- The basic stuff used to damage a grid
setDefaultProjector(function(src, x, y, type, dam, hit_type)
	local target = game.level.map(x, y, Map.ACTOR)
	local sx, sy = game.level.map:getTileToScreen(x, y)
	if target then
		-- Note the actual damage happens inside the damage flyers when takeHit is called
		-- Any thing before damage should be above this
		doDamageFlyers(src, x, y, type, dam, hit_type)
		-- Anything after below
		return dam
	end
	return 0
end)

--Physical damage types
newDamageType{
	name = "physical", type = "PHYSICAL",
	supertype = nil, subtype = "PHYSICAL",
}
newDamageType{
	name = "bashing", type = "BASHING", text_color = "#UMBER#",
	supertype = nil, subtype = "BASHING",
}
newDamageType{
	name = "slashing", type = "SLASHING",
	supertype = nil, subtype = "SLASHING",
}
newDamageType{
	name = "stabbing", type = "STABBING",
	supertype = nil, subtype = "PIERCING",
}

--Physical (Ranged) types
newDamageType{
	name = "piercing", type = "PIERCING",
	supertype = nil, subtype = "PIERCING",
}

--Physical (Silver) damage types
newDamageType{
	name = "silver bashing", type = "SILVER_BASHING", text_color = "#LIGHT_SLATE#",
	supertype = "SILVER", subtype = "BASHING",
}
newDamageType{
	name = "silver slashing", type = "SILVER_SLASHING", text_color = "#LIGHT_SLATE#",
	supertype = "SILVER", subtype = "SLASHING",
}
newDamageType{
	name = "silver stabbing", type = "SILVER_STABBING", text_color = "#LIGHT_SLATE#",
	supertype = "SILVER", subtype = "PIERCING",
}

--Physical (Silver - Ranged) types
newDamageType{
	name = "silver piercing", type = "SILVER_PIERCING", text_color = "#LIGHT_SLATE#",
	supertype = "SILVER", subtype = "PIERCING",
}

--Holy and Unholy
newDamageType{
	name = "holy", type = "HOLY", text_color = "#OLD_LACE#",
	supertype = "HOLY", subtype = nil,
}
newDamageType{
	name = "unholy", type = "UNHOLY", text_color = "#DARK_GREY#",
	supertype = "UNHOLY", subtype = nil,
}

--'Weird' damage types
newDamageType{
	name = "eldritch", type = "ELDRITCH", text_color = "#LIGHT_GREEN#",
	supertype = "ELDRITCH", subtype = nil,
}
newDamageType{	
	name = "sanguine", type = "SANGUINE", text_color = "#RED#",
	supertype = "SANGUINE", subtype = nil,
}
newDamageType{
	name = "infected", type = "INFECTED", text_color = "#GREY#",
	supertype = "INFECTED", subtype = nil,
}


-- Acid destroys potions
newDamageType{
	name = "acid", type = "ACID", text_color = "#GREEN#",
}