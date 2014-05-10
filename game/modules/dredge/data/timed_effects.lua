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

--local DamageType = require "engine.DamageType"
local Stats = require "engine.interface.ActorStats"

newEffect{
	name = "ACIDBURN",
	desc = "Burning from acid",
	type = "physical",
	status = "detrimental",
	parameters = { power=1 },
	on_gain = function(self, err) return "#Target# is covered in acid!", "+Acid" end,
	on_lose = function(self, err) return "#Target# is free from the acid.", "-Acid" end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.ACID).projector(eff.src or self, self.x, self.y, DamageType.ACID, eff.power)
	end,
}

newEffect{
	name = "MADNESS",
	desc = "Losing your mind",
	type = "physical",
	status = "detrimental",
	parameters = { power = 1},
	on_timeout = function(self, eff)
		self:incSanity(-eff.power)
	end,
}

newEffect{
	name = "POISON",
	desc = "Damage over time",
	type = "physical",
	status = "detrimental",
	parameters = { power = 1},
	on_gain = function(self, err) return "#Target# is poisoned!", "+Infected" end,
	on_lose = function(self, err) return "#Target# is free from poison.", "-Infected" end,
	on_timeout = function(self, eff)
		self:heal(-eff.power, self)
		--DamageType:get(DamageType.INFECTED).projector(eff.src or self, self.x, self.y, DamageType.INFECTED, eff.power)
	end,
}