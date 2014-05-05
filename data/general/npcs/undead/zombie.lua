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

local Talents = require("engine.interface.ActorTalents")
local DamageType = require("engine.DamageType")

newEntity{
	define_as = "BASE_NPC_ZOMBIE",
	type = "undead", subtype = "zombie",
	display = "z", color=colors.DARK_SLATE,
	desc = [[ ZOMGIES.]],
	ai = "dumb_talented_simple", ai_state = { talent_in=3, },
	stats = { con=5, men=5, alr=5, luck = 5 },
	inven = {HAND = 1},
	combat_armor = 0,
}	

newEntity{ base = "BASE_NPC_ZOMBIE",
	name = "zombie", color=colors.DARK_SLATE,
	level_range = {1, 4}, exp_worth = 1,
	rarity = 4,
	max_life = resolvers.rngavg(5,9),
	combat = { 	dam=2,
				damtype = DamageType.INFECTED,
				weakness = DamageType.SILVER_SLASHING,
				strength = DamageType.PIERCING,
				},
	talent = {},
}

newEntity{ base = "BASE_NPC_ZOMBIE",
	name = "powerful zombie", color=colors.White,
	level_range = {6, 10}, exp_worth = 1,
	rarity = 4,
	max_life = resolvers.rngavg(10,12),
	combat_armor = 3,
	combat = { 	dam=5,
				damtype = DamageType.INFECTED,
				weakness = DamageType.SILVER_SLASHING,
				strength = DamageType.PIERCING,
			 },
	talent = {},
}