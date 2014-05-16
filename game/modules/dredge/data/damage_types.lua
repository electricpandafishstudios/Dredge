local function doDamageFlyers(src, x, y, type, dam)
	local flash = game.flash.NEUTRAL
	if target == game.player then flash = game.flash.BAD end
	if src == game.player then flash = game.flash.GOOD end	
	
	local target = game.level.map(x, y, Map.ACTOR)
	if target then
		game.logSeen(target, flash, "%s hits %s for %s%0.2f %s damage#LAST#.", src.name:capitalize(), target.name, DamageType:get(type).text_color or "#aaaaaa#", dam, DamageType:get(type).name)		
		if target:takeHit(dam, src) then
			if src == game.player or target == game.player then
				game.flyers:add(sx, sy, 30, (rng.range(0,2)-1) * 0.5, -3, "Kill!", {255,0,255})
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
setDefaultProjector(function(src, x, y, type, dam)
	local target = game.level.map(x, y, Map.ACTOR)
	local sx, sy = game.level.map:getTileToScreen(x, y)
	if target then
		-- Note the actual damage happens inside the damage flyers when takeHit is called
		-- Any thing before damage should be above this
		doDamageFlyers(src, x, y, type, dam)
		-- Anything after below
		return dam
	end
	return 0
end)

--Physical damage types
newDamageType{
	name = "physical", type = "PHYSICAL",
}
-- Acid destroys potions
newDamageType{
	name = "acid", type = "ACID", text_color = "#GREEN#",
}