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

newEntity{
	define_as = "BASE_NPC_KOBOLD",
	type = "humanoid", subtype = "kobold",
	display = "k", color=colors.WHITE,
	desc = [[Ugly and green!]],

	ai = "dumb_talented_simple", ai_state = { talent_in=3, },
	stats = { con=10, alr=7, lck=5, men=7, },
	combat_armor = 0,
}

newEntity{ base = "BASE_NPC_KOBOLD",
	name = "kobold warrior", color=colors.GREEN,
	level_range = {1, 4}, exp_worth = 100,
	rarity = 4,
	max_life = 45,
	combat = { dam=8 },
}

newEntity{ base = "BASE_NPC_KOBOLD",
	name = "armoured kobold warrior", color=colors.AQUAMARINE,
	level_range = {1, 5}, exp_worth = 500,
	rarity = 4,
	max_life = 45,
	combat_armor = 1,
	combat = { dam=10 },
}
