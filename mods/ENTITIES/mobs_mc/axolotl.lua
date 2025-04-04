local S = minetest.get_translator(minetest.get_current_modname())

local axolotl = {
	description = S("Axolotl"),
	type = "animal",
	spawn_class = "axolotl",
	can_despawn = true,
	passive = false,
	initial_properties = {
		hp_min = 14,
		hp_max = 14,
		collisionbox = {-0.5, 0.0, -0.5, 0.5, 0.8, 0.5},
	},
	xp_min = 1,
	xp_max = 7,

	head_swivel = "head.control",
	head_eye_height = 0.5,
	head_bone_position = vector.new( 0, -1, 0 ), -- for minetest <= 5.8
	curiosity = 10,
	head_yaw="z",
	head_scale = vector.new(-1,-1,1),

	armor = 100,
	rotate = 180,
	spawn_in_group_min = 1,
	spawn_in_group = 4,
	tilt_swim = true,
	visual = "mesh",
	mesh = "mobs_mc_axolotl.b3d",
	textures = {
		{"mobs_mc_axolotl_brown.png"},
		{"mobs_mc_axolotl_yellow.png"},
		{"mobs_mc_axolotl_green.png"},
		{"mobs_mc_axolotl_pink.png"},
		{"mobs_mc_axolotl_black.png"},
		{"mobs_mc_axolotl_purple.png"},
		{"mobs_mc_axolotl_white.png"}
	},
	sounds = {
		random = "mobs_mc_axolotl",
		damage = "mobs_mc_axolotl_hurt",
		distance = 16,
		},
	animation = {-- Stand: 1-20; Walk: 20-60; Swim: 61-81
		stand_start = 61, stand_end = 81, stand_speed = 15,
		walk_start = 61, walk_end = 81, walk_speed = 15,
		run_start = 61, run_end = 81, run_speed = 20,
	},

	follow = {
		"mcl_fishing:clownfish_raw"
	},

	view_range = 16,
	fear_height = 4,

	on_rightclick = function(self, clicker)
		local bn = clicker:get_wielded_item():get_name()
		if bn == "mcl_buckets:bucket_water" or bn == "mcl_buckets:bucket_river_water" then
			if clicker:set_wielded_item("mcl_buckets:bucket_axolotl") then
				local it = clicker:get_wielded_item()
				local m = it:get_meta()
				m:set_string("properties",minetest.serialize(self.object:get_properties()))
				clicker:set_wielded_item(it)
				self.object:remove()
			end
			awards.unlock(clicker:get_player_name(), "mcl:cutestPredator")
			return
		end
		if self:feed_tame(clicker, 1, true, false) then return end
	end,
	makes_footstep_sound = false,
	fly = true,
	fly_in = { "mcl_core:water_source", "mclx_core:river_water_source" },
	breathes_in_water = true,
	jump = false, -- would get them out of the water too often
	damage = 2,
	reach = 2,
	attack_type = "dogfight",
	attack_animals = true,
	specific_attack = {
		"mobs_mc:cod",
		"mobs_mc:glow_squid",
		"mobs_mc:salmon",
		"mobs_mc:tropical_fish",
		"mobs_mc:squid",
		"mobs_mc:zombie", -- todo: only drowned?
		"mobs_mc:baby_zombie",
		"mobs_mc:husk",
		"mobs_mc:baby_husk",
		"mobs_mc:guardian_elder",
		"mobs_mc:guardian",
	},
	runaway = true,
}

mcl_mobs.register_mob("mobs_mc:axolotl", axolotl)

mcl_mobs:spawn_setup({
	name = "mobs_mc:axolotl",
	dimension = "overworld",
	type_of_spawning = "water",
	biomes = {
		"Swampland",
		"MushroomIsland",
		"RoofedForest",
		"FlowerForest_beach",
		"Forest_beach",
		"StoneBeach",
		"Taiga_beach",
		"Savanna_beach",
		"Plains_beach",
		"ExtremeHills_beach",
		"Swampland_shore",
		"MushroomIslandShore",
		"JungleM_shore",
		"Jungle_shore",
		"RoofedForest_ocean",
		"JungleEdgeM_ocean",
		"BirchForestM_ocean",
		"BirchForest_ocean",
		"IcePlains_deep_ocean",
		"Jungle_deep_ocean",
		"Savanna_ocean",
		"MesaPlateauF_ocean",
		"SunflowerPlains_ocean",
		"Swampland_ocean",
		"ExtremeHillsM_ocean",
		"Mesa_ocean",
		"StoneBeach_ocean",
		"Plains_ocean",
		"MesaPlateauFM_ocean",
		"MushroomIsland_ocean",
		"MegaTaiga_ocean",
		"StoneBeach_deep_ocean",
		"SavannaM_ocean",
		"ExtremeHills_ocean",
		"Forest_ocean",
		"JungleEdge_ocean",
		"MesaBryce_ocean",
		"MegaSpruceTaiga_ocean",
		"ExtremeHills+_ocean",
		"Jungle_ocean",
		"FlowerForest_ocean",
		"Desert_ocean",
		"Taiga_ocean",
		"JungleM_ocean",
		"FlowerForest_underground",
		"JungleEdge_underground",
		"StoneBeach_underground",
		"MesaBryce_underground",
		"Mesa_underground",
		"RoofedForest_underground",
		"Jungle_underground",
		"Swampland_underground",
		"MushroomIsland_underground",
		"BirchForest_underground",
		"Plains_underground",
		"MesaPlateauF_underground",
		"ExtremeHills_underground",
		"MegaSpruceTaiga_underground",
		"BirchForestM_underground",
		"SavannaM_underground",
		"MesaPlateauFM_underground",
		"Desert_underground",
		"Savanna_underground",
		"Forest_underground",
		"SunflowerPlains_underground",
		"MegaTaiga_underground",
		"Taiga_underground",
		"ExtremeHills+_underground",
		"JungleM_underground",
		"ExtremeHillsM_underground",
		"JungleEdgeM_underground",
		"LushCaves",
	},
	min_light = 0,
	max_light = core.LIGHT_MAX + 1,
	chance = 100,
	interval = 30,
	aoc = 3,
	min_height = mobs_mc.water_level - 16,
	max_height = mobs_mc.water_level + 1,
})

-- spawn eggs
mcl_mobs.register_egg("mobs_mc:axolotl", S("Axolotl"), "#e890bf", "#b83D7e", 0)
