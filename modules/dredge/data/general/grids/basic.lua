newEntity{
	define_as = "UP",
	name = "go up a level",
	display = '<', color_r=255, color_g=255, color_b=0, back_color=colors.GREY,
	notice = true,
	always_remember = true,
	change_level = 1,
}
newEntity{
	define_as = "DOWN",
	name = "go down a level",
	display = '>', color_r=255, color_g=255, color_b=0, back_color=colors.GREY,
	notice = true,
	always_remember = true,
	change_level = -1,
}

newEntity{
	define_as = "FLOOR",
	name = "floor", image = "terrain/marble_floor.png",
	display = '.', color_r=209, color_g=209, color_b=209, back_color=colors.GREY,
}
newEntity{
	define_as = "WALL",
	name = "wall", image = "terrain/granite_wall1.png",
	display = '#', color_r=127, color_g=127, color_b=127, back_color=colors.LIGHT_DARK,
	always_remember = true,
	does_block_move = true,
	can_pass = {pass_wall=1},
	block_sight = true,
	air_level = -20,
	dig = "FLOOR",
}

newEntity{
	define_as = "DOOR",
	name = "door", image = "terrain/granite_door1.png",
	display = '+', color_r=238, color_g=154, color_b=77, back_color=colors.GREY,
	notice = true,
	always_remember = true,
	block_sight = true,
	door_opened = "DOOR_OPEN",
	dig = "DOOR_OPEN",
}
newEntity{
	define_as = "DOOR_OPEN",
	name = "open door", image = "terrain/granite_door1_open.png",
	display = "'", color_r=238, color_g=154, color_b=77, back_color=colors.GREY,
	always_remember = true,
	door_closed = "DOOR",
}