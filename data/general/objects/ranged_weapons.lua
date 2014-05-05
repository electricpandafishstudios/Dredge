local DamageType = require "engine.DamageType"

newEntity{
	define_as = "BASE_HANDGUN",
	slot = "HAND",
	type = "weapon", subtype="firearm",
	display = "L", color = colors.SLATE,
	encumber = 0,
	rarity = 5,
	combat = {},
	name = "gun",
	desc = [[ Stout and wooden. At least its something. ]],
}
newEntity{
	define_as = "BASE_BULLET",
	type = "ammunition", subtype = "bullet",
	display = ",", color = colors.LIGHT_SLATE,
	encumber = 0,
	rarity = 5,
	combat = {},
	name = "bullet",
	desc == [[ BANG! ]],
}

newEntity{ base = "BASE_HANDGUN",
	name = "Colt .45",
	level_range = {1, 10},
	range = 5,
	require = { stat = { alr= 4}, },
	combat = { dam = 4, damtype = DamageType.BASHING, },
}
newEntity{ base = "BASE_BULLET",
	name = ".45 ACP Round",
	level_range = {1, 10},
	power = 4,
	stacking = false,
	use_simple = {
		name = "use",
		use = function(self, who)
			return {used = true, destroy = true}
		end
	},
}	