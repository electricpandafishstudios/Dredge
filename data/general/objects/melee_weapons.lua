--Bludgeoning Weapons
newEntity{
	define_as = "BASE_CLUB",
	slot = "HAND",
	type = "weapon", subtype="bludgeoning",
	display = "/", color = colors.UMBER,
	encumber = 0,
	rarity = 5,
	combat = {},
	name = "club",
	desc = [[ Stout and wooden. At least its something. ]],
}
newEntity{
	define_as = "BASE_CANDLESTICK",
	slot = "HAND",
	type = "weapon", subtype="bludgeoning",
	display = "y", color = colors.SLATE,
	encumber = 0,
	rarity = 5,
	combat = {},
	name = "candlestick",
	desc = [[ Feels strong enough to smash in a man's head. ]],
}
newEntity{
	define_as = "BASE_SILVER_CANDLESTICK",
	slot = "HAND",
	type = "weapon", subtype="bludgeoning",
	display = "y", color = colors.LIGHT_SLATE,
	encumber = 0,
	rarity = 5,
	combat = {},
	name = "silver candlestick",
	desc = [[ The silver should be more effective against the undead. ]],
}

newEntity{ base = "BASE_CLUB",
	name = "Chair Leg",
	level_range = {1, 10},
	require = { stat = { con= 3}, },
	combat = { dam = 2, damtype = DamageType.BASHING, },
}
newEntity{ base = "BASE_CANDLESTICK",
	name = "Candlestick",
	level_range = {1, 10},
	require = { stat = { con= 4}, },
	combat = { dam = 3, damtype = DamageType.BASHING, },
}
newEntity{ base = "BASE_SILVER_CANDLESTICK",
	name = "Silver Candlestick",
	level_range = {1, 10},
	require = { stat = {con = 4}, },
	combat = { dam = 3, damtype = DamageType.SILVER_BASHING, },
}

--Slashing Weapons
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
newEntity{
	define_as = "BASE_SILVER_KNIFE",
	slot = "HAND",
	type = "weapon", subtype="slashing",
	display = ";", color = colors.LIGHT_SLATE,
	encumber = 0,
	rarity = 5,
	combat = {},
	name = "silver knife",
	desc = [[ A silver blade is probably one of your best friends. ]],
}

newEntity{ base = "BASE_KNIFE",
	name = "Dagger",
	level_range = {1, 10},
	require = { stat = { con= 4}, },
	combat = { dam = 5, damtype = DamageType.SLASHING, },
}
newEntity{ base = "BASE_KNIFE",
	name = "Cleaver",
	level_range = {1, 10},
	require = { stat = { con= 4}, },
	combat = { dam = 6, damtype = DamageType.SLASHING, },
}
newEntity{ base = "BASE_SILVER_KNIFE",
	name = "Silver Dagger",
	level_range = {1, 10},
	require = { stat = { con= 4}, },
	combat = { dam = 5, damtype = DamageType.SILVER_SLASHING, },
}
newEntity{ base = "BASE_SILVER_KNIFE",
	name = "Silver Cleaver",
	level_range = {1, 10},
	require = { stat = { con= 4}, },
	combat = { dam = 6, damtype = DamageType.SILVER_SLASHING, },
}

--Stabbing Weapons
newEntity{
	define_as = "BASE_SHANK",
	slot = "HAND",
	type = "weapon", subtype="stabbing",
	display = "1", color = colors.UMBER,
	encumber = 0,
	rarity = 5,
	combat = {},
	name = "shank",
	desc = [[ Great for stabbing. ]],
}
newEntity{
	define_as = "BASE_RAPIER",
	slot = "HAND",
	type = "weapon", subtype="stabbing",
	display = "1", color = colors.SLATE,
	encumber = 0,
	rarity = 5,
	combat = {},
	name = "shiv",
	desc = [[ Also great for stabbing. ]],
}
newEntity{
	define_as = "BASE_SILVER_RAPIER",
	slot = "HAND",
	type = "weapon", subtype="stabbing",
	display = "1", color = colors.LIGHT_SLATE,
	encumber = 0,
	rarity = 5,
	combat = {},
	name = "shiv",
	desc = [[ super great for stabbing. ]],
}

newEntity{ base = "BASE_SHANK",
	name = "Wooden Stake",
	level_range = {1, 10},
	require = { stat = { con= 4}, },
	combat = { dam = 2, damtype = DamageType.STABBING, },
}
newEntity{ base = "BASE_RAPIER",
	name = "Rapier",
	level_range = {1, 10},
	require = { stat = { con= 4}, },
	combat = { dam = 8, damtype = DamageType.STABBING, },
}
newEntity{ base = "BASE_SILVER_RAPIER",
	name = "Silver Rapier",
	level_range = {1, 10},
	require = { stat = { con= 4}, },
	combat = { dam = 8, damtype = DamageType.SILVER_STABBING, },
}
