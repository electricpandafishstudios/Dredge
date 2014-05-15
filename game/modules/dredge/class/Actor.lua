require "engine.class"
require "engine.Actor"
require "engine.Autolevel"
require "engine.interface.ActorTemporaryEffects"
require "engine.interface.ActorLife"
require "engine.interface.ActorProject"
require "engine.interface.ActorLevel"
require "engine.interface.ActorStats"
require "engine.interface.ActorTalents"
require "engine.interface.ActorResource"
require "engine.interface.ActorFOV"
require "engine.interface.ActorInventory"
require "mod.class.interface.Combat"
local Map = require "engine.Map"
local DamageType = require "engine.DamageType"

module(..., package.seeall, class.inherit(
	engine.Actor,
	engine.interface.ActorTemporaryEffects,
	engine.interface.ActorLife,
	engine.interface.ActorProject,
	engine.interface.ActorLevel,
	engine.interface.ActorStats,
	engine.interface.ActorTalents,
	engine.interface.ActorResource,
	engine.interface.ActorFOV,
	engine.interface.ActorInventory,
	mod.class.interface.Combat
))

function _M:getWeaponFromSlot(weapon_slot)
	if not 	weapon_slot or not self:getInven(weapon_slot) then return end
	local weapon = self:getInven(weapon_slot)[1]
	if not weapon or not weapon.combat then
		return nil
	end
		return weapon
end

function _M:init(t, no_default)
	-- Define some basic combat stats
	self.energyBase = 0
	self.moved_this_turn = 0
	self.max_action_points = 5

	t.max_actions = t.max_actions or  self.max_action_points or 5
	
	-- Default regen
	t.life_regen = t.life_regen or 1
	t.actions_regen = t.actons_regen or 100
	t.life_regen_pool = t.life_regen_pool or 0

	-- Default melee barehanded damage
	self.combat = { dam=1, ac=5, dt=0, dr=0,}

	engine.Actor.init(self, t, no_default)
	engine.interface.ActorTemporaryEffects.init(self, t)
	engine.interface.ActorLife.init(self, t)
	engine.interface.ActorProject.init(self, t)
	engine.interface.ActorTalents.init(self, t)
	engine.interface.ActorResource.init(self, t)
	engine.interface.ActorStats.init(self, t)
	engine.interface.ActorLevel.init(self, t)
	engine.interface.ActorFOV.init(self, t)
	engine.interface.ActorInventory.init(self, t)
	
	self:recalculateStats()
end

function _M:addedToLevel(level, x, y)
	if not self._rst_full then self:resetToFull() self._rst_full = true end -- Only do it once, the first time we come into being
	self:check("on_added_to_level", level, x, y)
end

function _M:actBase()
	self:recalculateCombatStats()
	self.energyBase = self.energyBase - game.energy_to_act
	-- Cooldown talents
	self:cooldownTalents()
	-- Regen resources, life, etc..
	self:regenResources()
	self:attr("moved_this_turn", 0, true)
	if self.life < self.max_life and self.life_regen > 0 then
		self:regenLife()
	end
	self:timedEffects()
end

function _M:act()
	if not engine.Actor.act(self) then return end
	self:recalculateStats()
	self.changed = true

	-- Still enough energy to act ?
	if self.energy.value < game.energy_to_act then return false end

	return true
end

function _M:useActionPoints(value)
	local value = value or 1
	self:incActions(-value)
	if self:getActions() <= 0 then
		self:useEnergy()
	end
	self.changed = true
end

function _M:move(x, y, force)
	local moved = false
	local ox, oy = self.x, self.y
	if force or self:enoughEnergy() then
		moved = engine.Actor.move(self, x, y, force)
		if not force and moved and (self.x ~= ox or self.y ~= oy) and not self.did_energy then
			self:useActionPoints()
			self:attr("moved_this_turn", 1)
		end
	end
	
	self.did_energy = nil
	return moved
end

function _M:tooltip()
	return ([[%s%s
#00ffff#Level: %d
%sHealth: %s
#ff0000#Stats: %d /  %d / %d / %d	
%s]]):format(
	self:getDisplayString(),
	self.name,
	self.level,
	self:lifeIndicatorColor(),
	self.life,
	self:getCon(),
	self:getAlr(),
	self:getLck(),
	self:getMen(),
	self.desc or ""
	)
end

function _M:lifeIndicatorColor()
	local percentLife = self.life * 100 / self.max_life
	if percentLife >= 95 then return "#00ff00#"
	elseif 95 > percentLife and percentLife >= 50 then return "#ffff00#"
	elseif 50 > percentLife and percentLife >= 5 then return "#ff7700#"
	elseif 5 > percentLife then return "#c90000#" end
end

function _M:die(src)
	engine.interface.ActorLife.die(self, src)

	-- Gives the killer some exp for the kill
	if src and src.gainExp then
		src:gainExp(self:worthExp(src))
	end

	return true
end

function _M:levelup()
	self:recalculateStats()
end

function _M:recalculateStats()
	--Constitution (non-combat) based stats
	self.max_life = 15 + 3 * self:getCon()
	self.life_regen = math.max(1, self:getCon() / 3)
	
	--Constitution (combat) based stats
	self.combat.dam = math.max(1, self:getCon() - 5)
	
	--Alertness based stats
	self.max_actions = 5 + math.floor(self:getAlr() / 2)
	self.max_action_points = max_actions or 5 + math.floor(self:getAlr() / 2)
	self.lite = math.floor((self:getAlr() - 1) / 2)
	self.sight = 2 * self:getAlr()
	
	--Make sure resources are not above max.
	if self.life > self.max_life then
		self.life = self.max_life
	end
	if self.actions > self.max_actions then
		self.actions = self.max_actions
	end
end

function _M:recalculateCombatStats()
	self.combat.ac = self:getAlr() + self.actions
	self.combat.dt = 0
	self.combat.dr = 0
end

function _M:attack(target)
	self:bumpInto(target)
end

function _M:onTakeHit(value, src)
	return value
end

--- Called before a talent is used
-- Check the actor can cast it
-- @param ab the talent (not the id, the table)
-- @return true to continue, false to stop
function _M:preUseTalent(ab, silent)
	if not self:enoughEnergy() then return false end

	if ab.mode == "sustained" then
		-- if ab.sustain_sanity and self.max_sanity < ab.sustain_sanity and not self:isTalentActive(ab.id) then
			game.logPlayer(self, "You do not have enough sanity to activate %s.", ab.name)
			return false
		-- end
	else
		if ab.action_points and self:getActions() < ab.action_points then
			if not silent then 
				game.flyers:add(sx, sy, 30, (rng.range(0,2)-1) * 0.5, 2, "Low Action Points", {255,0,255}, true)
				game.logPlayer("I don't have enough action points to do that.")
			end 
			return false
		end
	end

	if not silent then
		-- Allow for silent talents
		if ab.message ~= nil then
			if ab.message then
				game.logSeen(self, "%s", self:useTalentMessage(ab))
			end
		elseif ab.mode == "sustained" and not self:isTalentActive(ab.id) then
			game.logSeen(self, "%s activates %s.", self.name:capitalize(), ab.name)
		elseif ab.mode == "sustained" and self:isTalentActive(ab.id) then
			game.logSeen(self, "%s deactivates %s.", self.name:capitalize(), ab.name)
		else
			game.logSeen(self, "%s uses %s.", self.name:capitalize(), ab.name)
		end
	end
	return true
end

--- Called before a talent is used
-- Check if it must use a turn, mana, stamina, ...
-- @param ab the talent (not the id, the table)
-- @param ret the return of the talent action
-- @return true to continue, false to stop
function _M:postUseTalent(ab, ret)
	if not ret then return end

	self:useActionPoints()

	if ab.mode == "sustained" then
		if not self:isTalentActive(ab.id) then
			-- if ab.sustain_sanity then
				-- self.max_sanity = self.max_sanity - ab.sustain_sanity
			-- end
		else
			-- if ab.sustain_sanity then
				-- self.max_sanity = self.max_sanity + ab.sustain_sanity
			-- end
		end
	else
		if ab.action_points then
			self:useActionPoints(ab.action_points)
		end
	end

	return true
end

--- Return the full description of a talent
-- You may overload it to add more data (like sanity usage, ...)
function _M:getTalentFullDescription(t)
	local d = {}

	if t.mode == "passive" then d[#d+1] = "#6fff83#Use mode: #00FF00#Passive"
	elseif t.mode == "sustained" then d[#d+1] = "#6fff83#Use mode: #00FF00#Sustained"
	else d[#d+1] = "#6fff83#Use mode: #00FF00#Activated"
	end

	if t.action_points or t.sustain_action_points then d[#d+1] = "#6fff83#Action Point cost: #7fffd4#"..(t.action_points or t.sustain_action_points) end
	if self:getTalentRange(t) > 1 then d[#d+1] = "#6fff83#Range: #FFFFFF#"..self:getTalentRange(t)
	else d[#d+1] = "#6fff83#Range: #FFFFFF#melee/personal"
	end
	if t.cooldown then d[#d+1] = "#6fff83#Cooldown: #FFFFFF#"..t.cooldown end

	return table.concat(d, "\n").."\n#6fff83#Description: #FFFFFF#"..t.info(self, t)
end

function _M:resetToFull()
	if self.dead then return end
	self.life = self.max_life
	self.actions = self.max_actions
end

function _M:regenLife()
	-- Increase the pool size
	self.life_regen_pool = self.life_regen_pool + self.life_regen
	-- If the pool is greater then 1 we heal
	if self.life_regen_pool >= 1 then
		-- round it down
		local regen_now = math.floor(self.life_regen_pool)
		-- but keep the decimal
		self.life_regen_pool = self.life_regen_pool - regen_now
		-- and regen
		self.life = util.bound(self.life + regen_now, self.die_at, self.max_life)
	end
end

--- How much experience is this actor worth
-- @param target to whom is the exp rewarded
-- @return the experience rewarded
function _M:worthExp(target)
	if not target.level or self.level < target.level - 3 then return 0 end

	local mult = 2
	if self.unique then mult = 6
	elseif self.egoed then mult = 3 end
	return self.level * mult * self.exp_worth
end

--- Can the actor see the target actor
-- This does not check LOS or such, only the actual ability to see it.<br/>
-- Check for telepathy, invisibility, stealth, ...
function _M:canSee(actor, def, def_pct)
	if not actor then return false, 0 end

	-- Check for stealth. Checks against the target cunning and level
	if actor:attr("stealth") and actor ~= self then
		local def = self.level / 2 + self:getCun(25)
		local hit, chance = self:checkHit(def, actor:attr("stealth") + (actor:attr("inc_stealth") or 0), 0, 100)
		if not hit then
			return false, chance
		end
	end

	if def ~= nil then
		return def, def_pct
	else
		return true, 100
	end
end

--- Can the target be applied some effects
-- @param what a string describing what is being tried
function _M:canBe(what)
	if what == "poison" and rng.percent(100 * (self:attr("poison_immune") or 0)) then return false end
	if what == "cut" and rng.percent(100 * (self:attr("cut_immune") or 0)) then return false end
	if what == "confusion" and rng.percent(100 * (self:attr("confusion_immune") or 0)) then return false end
	if what == "blind" and rng.percent(100 * (self:attr("blind_immune") or 0)) then return false end
	if what == "stun" and rng.percent(100 * (self:attr("stun_immune") or 0)) then return false end
	if what == "fear" and rng.percent(100 * (self:attr("fear_immune") or 0)) then return false end
	if what == "knockback" and rng.percent(100 * (self:attr("knockback_immune") or 0)) then return false end
	if what == "instakill" and rng.percent(100 * (self:attr("instakill_immune") or 0)) then return false end
	return true
end
