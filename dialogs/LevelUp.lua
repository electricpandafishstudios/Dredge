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

require "engine.class"
local Dialog = require "engine.ui.Dialog"
local Textzone = require "engine.ui.Textzone"
local Separator = require "engine.ui.Separator"
local List = require "engine.ui.List"
local Savefile = require "engine.Savefile"
local Map = require "engine.Map"


module(..., package.seeall, class.inherit(Dialog))

function _M:init(actor)
	self.actor = actor
	Dialog.init(self, "Level Increased!", 500, 300)

	self:generateList()

	self.c_desc = Textzone.new{width=self.iw, auto_height=true, text=[[You have gained one level, and now you must
choose a stat to decrement; but choose wisely. You won't be able to get it back!]]}
	self.c_list = List.new{width=self.iw, nb_items=#self.list, list=self.list, fct=function(item) self:use(item) end}

	self:loadUI{
		{left=0, top=0, ui=self.c_desc},
		{left=5, top=self.c_desc.h, padding_h=10, ui=Separator.new{dir="vertical", size=self.iw - 10}},
		{left=0, bottom=0, ui=self.c_list},
	}
	self:setFocus(self.c_list)
	self:setupUI(false, true)
end

--- Clean the actor from debuffs/buffs
function _M:cleanActor()
	local effs = {}

	-- Go through all spell effects
	for eff_id, p in pairs(self.actor.tmp) do

		local e = self.actor.tempeffect_def[eff_id]
		effs[#effs+1] = {"effect", eff_id}
	end

	-- Go through all sustained spells
	for tid, act in pairs(self.actor.sustain_talents) do
		if act then
			effs[#effs+1] = {"talent", tid}
		end
	end

	while #effs > 0 do
		local eff = rng.tableRemove(effs)

		if eff[1] == "effect" then
			self.actor:removeEffect(eff[2])
		else
			local old = self.actor.energy.value
			self.actor:useTalent(eff[2])
			-- Prevent using energy
			self.actor.energy.value = old
		end
	end
end

--- Restore resources
function _M:restoreResources()
	self.actor.life = self.actor.max_life
	self.actor.power = self.actor.max_power

	self.actor.energy.value = game.energy_to_act
end

function _M:use(item)
	if not item then return end
	local act = item.action

	if act == "con" then
		self.actor:incStat(game.player.STAT_CON, -1)
		self:cleanActor()
		self:restoreResources()
		game:unregisterDialog(self)
	elseif act == "alr" then
		self.actor:incStat(game.player.STAT_ALR, -1)
		self:cleanActor()
		self:restoreResources()
		game:unregisterDialog(self)
	elseif act == "lck" then
		self.actor:incStat(game.player.STAT_LCK, -1)
		self:cleanActor()
		self:restoreResources()
		game:unregisterDialog(self)
	elseif act == "men" then
		self.actor:incStat(game.player.STAT_MEN, -1)
		self:cleanActor()
		self:restoreResources()
		game:unregisterDialog(self)
	end
end

function _M:generateList()
	local list = {}

	list[#list+1] = {name="Constitution", action ="con"}
	list[#list+1] = {name="Alertness", action ="alr"}
	list[#list+1] = {name="Luck", action ="lck"}
	list[#list+1] = {name="Mental", action ="men"}
	self.list = list
end
