minetest.register_on_dieplayer(function(player)
	local keep = minetest.setting_getbool("mcl_keepInventory")
	if keep == false then
		local inv = player:get_inventory()
		local pos = player:getpos()
		local lists = { "main", "craft", "armor" }
		for l=1,#lists do
			for i,stack in ipairs(inv:get_list(lists[l])) do
				local x = math.random(0, 9)/3
				local z = math.random(0, 9)/3
				pos.x = pos.x + x
				pos.z = pos.z + z
				minetest.add_item(pos, stack)
				stack:clear()
				inv:set_stack(lists[l], i, stack)
				pos.x = pos.x - x
				pos.z = pos.z - z
			end
		end
		armor:update_inventory(player)
	end

	-- Death message
	local message = minetest.setting_getbool("mcl_showDeathMessages")
	if message == nil then message = true end
	if message then
		local name = player:get_player_name()

		-- Death messages
		local msgs = {
			["arrow"] = {
				"%s was fatally hit by an arrow.",
				"%s has been killed with an arrow.",
			},
			["cactus"] = {
				"%s was killed by a cactus.",
				"%s was pricked to death.",
			},
			["fire"] = {
				"%s has been cooked crisp.",
				"%s felt the burn.",
				"%s died in the flames.",
				"%s died in a fire.",
			},
			["explosion"] = {
				"%s was caught in an explosion.",
			},
			["lava"] = {
				"%s melted in lava.",
				"%s took a bath in a hot lava tub.",
				"%s died in lava.",
				"%s could not survive in lava.",
			},
			["drown"] = {
				"%s forgot to breathe.",
				"%s drowned.",
				"%s ran out of oxygen.",
			},
			["void"] = {
				"%s fell into the endless void.",
			},
			["suffocation"] = {
				"%s suffocated to death.",
			},
			["starve"] = {
				"%s starved.",
			},
			["murder"] = {
				"%s was killed by %s.",
			},
			["falling_anvil"] = {
				"%s was smashed by a falling anvil!",
			},
			["falling_block"] = {
				"%s was smashed by a falling block.",
				"%s was buried under a falling block.",
			},
			["fall_damage"] = {
				"%s fell from a high cliff.",
				"%s took fatal fall damage.",
				"%s fell victim to gravity.",
			},
			["other"] = {
				"%s died.",
			}
		}

		-- Select death message
		local dmsg = function(mtype, ...)
			local r = math.random(1, #msgs[mtype])
			return string.format(msgs[mtype][r], ...)
		end

		local node = minetest.registered_nodes[minetest.get_node(player:getpos()).name]
		local msg
		-- Lava
		if minetest.get_item_group(node.name, "lava") ~= 0 then
			msg = dmsg("lava", name)
		-- Drowning
		elseif player:get_breath() == 0 then
			msg = dmsg("drown", name)
		-- Fire
		elseif minetest.get_item_group(node.name, "fire") ~= 0 then
			msg = dmsg("fire", name)
		-- Void
		elseif node.name == "mcl_core:void" then
			msg = dmsg("void", name)
		-- Cactus
		elseif node.name == "mcl_core:cactus" then
			msg = dmsg("cactus", name)
		-- Other
		else
			msg = dmsg("other", name)
		end
		minetest.chat_send_all(msg)
	end
end)
