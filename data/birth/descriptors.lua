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
-- darkgod@te4.org]]

local DamageType = require("engine.DamageType")
newBirthDescriptor{
	type = "base",
	name = "base",
	desc = {},
	experience = 1.0,

	body = { INVEN = 10, HAND = 1, BODY = 1, ITEM = 1 },
	copy = {
		max_level = 10,
		lite = 4,
		max_life = 30,
		life = 30,
	},
	combat = 
	{
		dam = 0.5, damtype = DamageType.PHYSICAL
	},
	
	talents =
	{
		[ActorTalents.T_ATTACK] = 1,
		[ActorTalents.T_FIRE] = 1,
	},
}

newBirthDescriptor{
	type = "role",
	name = "Champion",
	desc =
	{
		"Adventure!",
		"<Choose this class to start with a myriad of the currently implemented items>",
		"[Mechanical Description goes here]",
	},
	stats = {con = 0, men = 0, alr = 0, lck = 0	},
	copy = {
		resolvers.equip{
								{type="weapon", subtype="firearm", name="Colt .45",},},
		resolvers.inventory{  id = true,
								{type="consumable", subtype="potion", name="Health Potion"},
								{type="consumable", subtype="potion", name="Absinthe"},
								{type="weapon", subtype="bludgeoning", name="Silver Candlestick"},
								{type="weapon", subtype="slashing", name="Cleaver"},
								{type="weapon", subtype="slashing", name="Silver Cleaver"},
								{type="weapon", subtype="stabbing", name="Wooden Stake"},
								{type="ammunition", subtype="bullet", name=".45 ACP Round"},
								{type="ammunition", subtype="bullet", name=".45 ACP Round"},
						   },
	},	
	combat =
	{
		-- dam = ,
	},
	talents = {},
}

newBirthDescriptor{
	type = "role",
	name = "Anthropologist",	
	desc =
	{
		"I read about this castle in a book once!",
		"[Mechanical Description goes here]",
	},
	stats = {con = -1, men = 3, alr = -1, lck = -1},
	talents = {},
}

newBirthDescriptor{
	type = "role",
	name = "Lover",
	desc =
	{
		"Love is in the air!",
		"[Mechanical Description goes here]",
	},
	stats = {con = -1, men = -1, alr = 3, lck = -1},
	talents = {},
}

newBirthDescriptor{
	type = "role",
	name = "Madman",
	desc =
	{
		"I AM LOVECRAFT!",
		"[Mechanical Description goes here]",
	},
	stats = {con = -1, men = -1, alr = -1, lck = 3},
	talents = {},
}
