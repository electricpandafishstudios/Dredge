-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009, 2010, 2011, 2012, 2013 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

return {
	name = "Valley_Entrance",
	level_range = {1, 5},
	level_scheme = "player",
	max_level = 3,
	decay = {300, 800},
	actor_adjust_level = function(zone, level, e) return zone.base_level + e:getRankLevelAdjust() + level.level-1 + rng.range(-1,2) end,
	width = 65, height = 40,
	all_lited = true,
	persistent = "zone",
	min_material_level = function() return game.state:isAdvanced() and 3 or 1 end,
	max_material_level = function() return game.state:isAdvanced() and 4 or 2 end,
	generator =  {
		map = {
			class = "engine.generator.map.Forest",
			edge_entrances = {4,6},
			zoom = 10,
			sqrt_percent = 100,
			noise = "fbm_perlin",
			-- floor2 = function() if rng.chance(20) then return "BOGWATER_MISC" else return "BOGWATER" end end,
			floor = function() if rng.chance(20) then return "GRASS" else return "DIRT" end end,
			
			
			-- wall = "TREE",
			-- up = "GRASS_UP4",
			-- down = "GRASS_DOWN6",
			-- door = "GRASS",
			-- road = "GRASS_ROAD_DIRT",			
			
			wall = "BRAMBLE",
			up = "UP",
			down = "DOWN",
			door = "DOOR",
			road = "COBBLESTONE",
			add_road = true,
			
			do_ponds = {
				nb = {1, 3},
				size = {w=25, h=25},
				-- pond = {{0.6, "DEEP_WATER"}, {0.8, "DEEP_WATER"}},
				pond = {{0.6, "BOGWATER"}, {0.8, "BOGWATER"}},
			},
			
			-- Re-enable after rooms are actually coded.
			nb_rooms = {5,5,5,5},
			rooms = {"pilar"},
			-- lesser_vaults_list = {"honey_glade", "forest-ruined-building1", "forest-ruined-building2", "forest-ruined-building3", "forest-snake-pit", "mage-hideout"},
			lite_room_chance = 100,
		},
		-- actor = {
			-- class = "mod.class.generator.actor.OnSpots",
			-- nb_npc = {20, 30},
			-- filters = { {max_ood=2}, },
			-- nb_spots = 2, on_spot_chance = 35,
			-- guardian = "TROLL_PROX",
			-- guardian_spot = {type="guardian", subtype="guardian"},
		-- },
		-- object = {
			-- class = "engine.generator.object.OnSpots",
			-- nb_object = {6, 9},
			-- nb_spots = 2, on_spot_chance = 80,
		-- },
		-- trap = {
			-- class = "engine.generator.trap.Random",
			-- nb_trap = {0, 0},
		-- },
	},
	levels =
	{
		-- [1] = {
			-- generator = { map = {
				-- up = "GRASS_UP_WILDERNESS",
			-- }, },
		-- },
		-- [3] = {
			-- generator = { map = {
				-- end_road = true,
				-- end_road_room = "zones/prox",
				-- force_last_stair = true,
				-- down = "GRASS",
				-- stew = "STEW",
			-- }, },
		-- },
		-- Hidden treasure level
		-- [4] = {
			-- ambient_music = {"Rainy Day.ogg", "weather/rain.ogg"},
			-- generator = {
				-- map = {
					-- class = "engine.generator.map.Static",
					-- map = "zones/trollmire-treasure",
				-- },
				-- trap = { nb_trap = {0, 0} },
				-- object = { nb_object = {3, 4} },
				-- actor = { nb_npc = {2, 2} },
			-- },
		-- },
	},
}