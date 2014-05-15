newEntity{
	define_as = "BASE_KNIFE",
	slot = "HAND",
	type = "weapon", subtype="slashing",
	display = ";", color = colors.SLATE,
	encumber = 0,
	rarity = 5,
	combat = {},
	name = "knife",
	desc = [[ Sharpened to a razor's edge. ]],
}

newEntity{ base = "BASE_KNIFE",
	name = "Dagger",
	level_range = {1, 10},
	require = { stat = { con= 4}, },
	combat = { dam = {3, 10}, damtype = DamageType.PHYSICAL, },
}