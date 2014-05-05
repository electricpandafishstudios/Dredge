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

module(..., package.seeall, class.inherit(engine.Dialog))

function _M:init()
	engine.Dialog.init(self, "Introduction", 500, 300)
	-- self.c_desc = Textzone.new{width=self.iw, auto_height=true, text=[[Indroction paragraphs go here.]]}
	-- self:loadUI{
	-- {left=0, top=0, ui=self.c_desc},
	-- }
	--self:setFocus(self.c_desc)
	-- self:setupUI(false, true)
	--self:simpleLongPopup("A", "B", game.w * 0.7, game.player:heal(1, self), false)
	self:keyCommands({
    __DEFAULT = function(c)
        game:unregisterDialog(self)
    end,
})
end

function _M:drawDialog(s, w, h)
	s:drawColorStringCentered(self.font, "Indroction paragraphs go here.", 2, 2, self.iw - 2, self.ih - 2)
end
