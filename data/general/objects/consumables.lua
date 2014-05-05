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
	define_as = "BASE_ABSINTHE",
	slot = "ITEM",
	type = "consumable", subtype = "potion",
	display = "&", color = colors.YELLOW_GREEN,
	encumber = 0,
	rarity = 5,
	combat = {},
	name = "absinthe",
	desc == [[ A potent mixture that instantly regenerates some of your sanity. ]],
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
newEntity{ base = "BASE_ABSINTHE",
	name = "Absinthe",
	level_range = {1, 10},
	use_simple = {
		name = "sane",
		use = function(self)
			game.player:incSanity(10)
			return {used = true, destroy = true}
		end
	},
}