local Player = require "mod.class.Player"

newEntity{
	define_as = "BASE_HEALTH_POTION",
	slot = "ITEM",
	type = "consumable", subtype = "potion",
	display = "&", color = colors.RED,
	encumber = 0,
	rarity = 5,
	combat = {},
	name = "health potion",
	desc = [[ A potion that instantly regenerates some of your health! ]],
}

newEntity{
	define_as = "BASE_XP_POTION",
	slot = "ITEM",
	type = "consumable", subtype = "potion",
	display = "&", color = colors.WHITE,
	encumber = 0,
	rarity = 5,
	combat = {},
	name = "xp potion",
	desc = [[ A potion that instantly regenerates some of your health! ]],
}

newEntity{ base = "BASE_HEALTH_POTION",
	name = "Health Potion",
	level_range = {1, 10},
	use_simple = {
		name = "heal",
		use = function(self)
			game.player:heal(10, game.player)
			return {used = true, destroy = true}
		end
	},
}

newEntity{ base = "BASE_XP_POTION",
	name = "Experience Potion",
	level_range = {1, 10},
	use_simple = {
		name = "such",
		use = function(self)
			game.player:gainExp(-10)
			return {used = true, destroy = true}
		end
	},
}