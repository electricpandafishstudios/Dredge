 require "engine.class"

local Dialog = require "engine.ui.Dialog"
local Talents = require "engine.interface.ActorTalents"
local Tab = require "engine.ui.Tab"
local SurfaceZone = require "engine.ui.SurfaceZone"
local Separator = require "engine.ui.Separator"
local Stats = require "engine.interface.ActorStats"
local Textzone = require "engine.ui.Textzone"

module(..., package.seeall, class.inherit(Dialog))

function _M:init(actor)
    self.actor = actor
    Dialog.init(self, "Stay C.A.L.M.", math.max(game.w * 0.7, 600), 300)

    self.font = core.display.newFont("/data/font/VeraMono.ttf", 12)
    self.font_h = self.font:lineSkip()

    self.c_character_stats = Tab.new{title="Character Stats", default=true, fct=function() end, on_change=function(s) if s then self:switchTo("character_stats") end end}
    self.c_attack = Tab.new{title="Attack", default=false, fct=function() end, on_change=function(s) if s then self:switchTo("attack") end end}
    self.c_logs = Tab.new{title="Logs", default=false, fct=function() end, on_change=function(s) if s then self:switchTo("logs") end end}

    local tw, th = self.font_bold:size(self.title)

    self.vs = Separator.new{dir="vertical", size=self.iw}

    self.c_tut = Textzone.new{width=self.iw * 0.6, auto_height=true, no_color_bleed=true, font = self.font, text=[[
Keyboard: #00FF00#'d'#LAST# to save character dump. #00FF00#TAB key#LAST# to switch between tabs.
Mouse: Hover over stat for info
]]}

    self.c_desc = SurfaceZone.new{width=self.iw, height=self.ih - self.c_character_stats.h - self.vs.h - self.c_tut.h,alpha=0}

    self.hoffset = 17 + self.c_tut.h + self.vs.h + self.c_character_stats.h

    self:loadUI{
        {left=0, top=0, ui=self.c_tut},
        {left=15, top=self.c_tut.h, ui=self.c_character_stats},
        {left=15+self.c_character_stats.w, top=self.c_tut.h, ui=self.c_attack},
        {left=15+self.c_character_stats.w+self.c_attack.w, top=self.c_tut.h, ui=self.c_logs},
        {left=0, top=self.c_tut.h + self.c_character_stats.h, ui=self.vs},

        {left=0, top=self.c_tut.h + self.c_character_stats.h + 5 + self.vs.h, ui=self.c_desc},
    }
    self:setFocus(self.c_character_stats)
    self:setupUI()

    self:switchTo("character_stats")

    self:updateKeys()
end

function _M:switchTo(kind)
    self:drawDialog(kind, cs_player_dup)
    if kind == "character_stats" then self.c_attack.selected = false self.c_logs.selected = false
    elseif kind == "attack" then self.c_character_stats.selected = false self.c_logs.selected = false
    elseif kind == "logs" then self.c_attack.selected = false self.c_character_stats.selected = false
    end
    self:updateKeys()
end

function _M:updateKeys()
    self.key:addCommands{
    _TAB = function() self:tabTabs() end,
    __TEXTINPUT = function(c)
        if c == 'd' or c == 'D' then
            self:dump()
        end
    end,
    }

    self.key:addBinds{
        EXIT = function() cs_player_dup = game.player:clone() game:unregisterDialog(self) end,
    }
end

function _M:tabTabs()
    if self.c_character_stats.selected == true then self.c_attack:select() elseif
    self.c_attack.selected == true then self.c_logs:select() elseif
    self.c_logs.selected == true then self.c_character_stats:select() end
end

function _M:mouseTooltip(text, _, _, _, w, h, x, y)
    self:mouseZones({
        { x=x, y=y+self.hoffset, w=w, h=h, fct=function(button) game.tooltip_x, game.tooltip_y = 1, 1; game.tooltip:displayAtMap(nil, nil, game.w, game.h, text) end},
    }, true)
end

function _M:mouseZones(t, no_new)
    -- Offset the x and y with the window position and window title
    if not t.norestrict then
        for i, z in ipairs(t) do
            if not z.norestrict then
                z.x = z.x + self.display_x + 5
                z.y = z.y + self.display_y + 20 + 3
            end
        end
    end

    if not no_new then self.mouse = engine.Mouse.new() end
    self.mouse:registerZones(t)
end

function _M:drawDialog(kind)
    self.mouse:reset()

    self:setupUI()

    local player = self.actor
    local s = self.c_desc.s

    s:erase(0,0,0,0)

    local h = 0
    local w = 0

    if kind == "character_stats" then
        h = 0
        w = 0
        s:drawStringBlended(self.font, "Name : "..(player.name or "Unnamed"), w, h, 255, 255, 255, true) h = h + self.font_h
		self:mouseTooltip([[#GOLD#A Tooltip!!#LAST#]], s:drawColorStringBlended(self.font, ("#c00000#Life: #00ff00#%d/%d (%d%%)"):format(player.life, player.max_life, player.life * 100 / player.max_life), w, h, 255, 255, 255, true)) h = h + self.font_h
		h = h + self.font_h -- Adds an empty row
		s:drawStringBlended(self.font, "CON : "..(player:getCon()), w, h, 0, 255, 255, true) h = h + self.font_h
        s:drawStringBlended(self.font, "ALR : "..(player:getAlr()), w, h, 255, 255, 0, true) h = h + self.font_h
		s:drawStringBlended(self.font, "LCK : "..(player:getLck()), w, h, 255, 255, 255, true) h = h + self.font_h
		s:drawStringBlended(self.font, "MEN : "..(player:getMen()), w, h, 255, 0, 255, true) h = h + self.font_h
		h = h + self.font_h -- Adds an empty row
         
        h = 0
        w = self.w * 0.125 
        -- start on second column
        
		s:drawStringBlended(self.font, "Role : "..(player.descriptor.role or player.type:capitalize()), w, h, 255, 255, 255, true) h = h + self.font_h
    elseif kind=="attack" then
		local dam = player.combat.dam + player:getCon()
		local wpn = player:getWeaponDam()
        h = 0
        w = 0
		s:drawStringBlended(self.font, "Base Damage: "..(dam), w, h, 255, 255, 255, true) h = h + self.font_h
		s:drawStringBlended(self.font, "Weapon Damage: "..(wpn), w, h, 0, 255, 255, true) h = h + self.font_h
		s:drawStringBlended(self.font, "Type Damage Bonus: "..(wpn * 1.00), w, h, 255, 255, 0, true) h = h + self.font_h
		s:drawStringBlended(self.font, "Silver Damage Bonus: "..(wpn * 0.50), w, h, 255, 0, 255, true) h = h + self.font_h
		
		h = 0
		w = self.w * 0.50
		
		s:drawStringBlended(self.font, "Normal Attack Damage: "..(dam + wpn), w, h, 255, 255, 255, true) h = h + self.font_h
		s:drawStringBlended(self.font, "Silver Attack Damage: "..(dam + (wpn * 1.50)), w, h, 0, 255, 255, true) h = h + self.font_h
		s:drawStringBlended(self.font, "Type Attack Damage: "..(dam + (wpn * 2.00)), w, h, 255, 0, 255, true) h = h + self.font_h
		s:drawStringBlended(self.font, "Super Attack Damage: "..(dam + (wpn * 2.50)), w, h, 255, 255, 0, true) h = h + self.font_h
        
        -- draw the attack tab here

    elseif kind=="logs" then
        h = 0
        w = 0
        
        -- draw the logs tab here

    end

    self.c_desc:generate()
    self.changed = false
end

function _M:dump()
    local player = self.actor

    fs.mkdir("/character-dumps")
    local file = "/character-dumps/"..(player.name:gsub("[^a-zA-Z0-9_-.]", "_")).."-"..os.date("%Y%m%d-%H%M%S")..".txt"
    local fff = fs.open(file, "w")
    local labelwidth = 17
    local w1 = function(s) s = s or "" fff:write(s:removeColorCodes()) fff:write("\n") end
    --prepare label and value
    local makelabel = function(s,r) while s:len() < labelwidth do s = s.." " end return ("%s: %s"):format(s, r) end

    w1("  [MyModule Character Dump]")
    w1()
    
    w1(("%-32s"):format(makelabel("Name", player.name)))
    w1(("%-32s"):format(makelabel("Role", player.descriptor.role or player.type:capitalize())))
    
    w1(("CON:  %d"):format(player:getCon()))
    
    w1(("MEN:  %d"):format(player:getMen()))

    w1(("ALR:  %d"):format(player:getAlr()))

    fff:close()

    Dialog:simplePopup("Character dump complete", "File: "..fs.getRealPath(file))
end 