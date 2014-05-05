newEntity{
	define_as = "DIRT",
	name = "dirt", image = "terrain/marble_floor.png",
	display = '.', color_r=185, color_g=140, color_b=75, back_color=colors.UMBER,
}
newEntity{
	define_as = "GRASS",
	name = "grass", image = "terrain/marble_floor.png",
	display = '.', color_r=9, color_g=232, color_b=46, back_color=colors.OLIVE_DRAB,
}

newEntity{
	define_as = "BRAMBLE",
	name = "bramble", image = "terrain/granite_wall1.png",
	display = '%', color_r=107, color_g=142, color_b=35, back_color=colors.DARK_GREEN,
	always_remember = true,
	does_block_move = true,
	can_pass = {pass_wall=1},
	block_sight = true,
	air_level = -20,
	dig = "FLOOR",
}

newEntity{
	define_as = "COBBLESTONE",
	name = "cobblestone", image = "terrain/marble_floor.png",
	display = '.', color_r=209, color_g=209, color_b=209, back_color=colors.DARK_GREY,
}

newEntity{
	define_as = "BOGWATER",
	name = "bog water", image = "terrain/granite_wall1.png",
	display = '~', color_r=50, color_g=57, color_b=12, back_color=colors.BLACK,
	always_remember = true,
	does_block_move = false,
	can_pass = {pass_wall=1},
	block_sight = false,
	air_level = -20,
	dig = "FLOOR",
}