local modname = minetest.get_current_modname()
local S = minetest.get_translator(modname)
local modpath = minetest.get_modpath(modname)

local function spawn_witch(p1,p2)
	local c = minetest.find_node_near(p1,15,{"mcl_cauldrons:cauldron"})
	if c then
		local nn = minetest.find_nodes_in_area_under_air(vector.new(p1.x,c.y-1,p1.z),vector.new(p2.x,c.y-1,p2.z),{"mcl_core:sprucewood"})
		local witch = minetest.add_entity(vector.offset(nn[math.random(#nn)],0,1,0),"mobs_mc:witch"):get_luaentity()
		local cat = minetest.add_entity(vector.offset(nn[math.random(#nn)],0,1,0),"mobs_mc:cat"):get_luaentity()
		witch._home = c
		witch.can_despawn = false
		cat.object:set_properties({textures = {"mobs_mc_cat_black.png"}})
		cat.owner = "!witch!" --so it's not claimable by player
		cat._home = c
		cat.can_despawn = false
		return
	end
end

local function hut_placement_callback(pos,def,pr)
	local hl = def.sidelen / 2
	local p1 = vector.offset(pos,-hl,-hl,-hl)
	local p2 = vector.offset(pos,hl,hl,hl)
	local legs = minetest.find_nodes_in_area(p1, p2, "mcl_core:tree")
	local tree = {}
	for i = 1, #legs do
		while minetest.get_item_group(mcl_vars.get_node({x=legs[i].x, y=legs[i].y-1, z=legs[i].z}, true, 333333).name, "water") ~= 0 do
			legs[i].y = legs[i].y - 1
			table.insert(tree,legs[i])
		end
	end
	minetest.bulk_set_node(tree, {name = "mcl_core:tree", param2 = 2})
	spawn_witch(p1,p2)
end

mcl_structures.register_structure("witch_hut",{
	place_on = {"group:sand","group:grass_block","mcl_core:water_source","group:dirt"},
	fill_ratio = 0.01,
	flags = "place_center_x, place_center_z, liquid_surface, force_placement",
	sidelen = 5,
	chunk_probability = 256,
	y_max = mcl_vars.mg_overworld_max,
	y_min = -4,
	y_offset = 0,
	biomes = { "Swampland", "Swampland_ocean", "Swampland_shore" },
	filenames = { modpath.."/schematics/mcl_structures_witch_hut.mts" },
	after_place = hut_placement_callback,
})
