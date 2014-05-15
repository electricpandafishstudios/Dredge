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

function _M:use(item)
	if not item then return end
	local act = item.action

	if act == "con" then
		self.actor:incStat(game.player.STAT_CON, -1)
	elseif act == "alr" then
		self.actor:incStat(game.player.STAT_ALR, -1)
	elseif act == "lck" then
		self.actor:incStat(game.player.STAT_LCK, -1)
	elseif act == "men" then
		self.actor:incStat(game.player.STAT_MEN, -1)
	end
	game:unregisterDialog(self)
	self.actor:recalculateStats()
end

function _M:generateList()
	local list = {}

	list[#list+1] = {name="Constitution: Determines your melee damage, health, and health regen", action ="con"}
	list[#list+1] = {name="Alertness: Determines the number of APs you have.", action ="alr"}
	list[#list+1] = {name="Luck: Determines how many Skills you can have.", action ="lck"}
	list[#list+1] = {name="Mental: Affects the damage output of your abilities.", action ="men"}
	self.list = list
end
