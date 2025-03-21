---- Hashing related functions
-- The bitop is avilable both in luaJIT and in non-JIT Luanti since 5.5, so safe to use
local tobit = bit.tobit
local band = bit.band
local lshift = bit.lshift
local rshift = bit.rshift

-- u32 multiplication in luas double data types, via 16 bit multiplications
local function u32_mul(a, b)
	return (band(a, 0xffff) * b) + lshift(band(rshift(a, 16) * b,  0xffff), 16)
end

--- Simple and cheap bit mixing operation
--- to use with a seed, do bitmix32(bitmix32(seed, a), b)
--- @param a number: first value
--- @param b number: second value
--- @return number: combined hash code in signed int32 range
function mcl_util.bitmix32(a, b)
	return tobit(u32_mul(u32_mul(tobit(a), 0x85ebca6b) + tobit(b), 0xc2b2ae35))
end
local bitmix32 = mcl_util.bitmix32

--- Simple position hash function.
--- Use this with a custom seed to avoid coincidences with other mods.
--- @param x number: X coordinate (only integer part is used)
--- @param y number: Y coordinate (only integer part is used)
--- @param z number: Z coordinate (only integer part is used)
--- @param seed number: Seed value
--- @return number: combined hash code (signed int32)
function mcl_util.hash_pos(x, y, z, seed)
	if not seed then return bitmix32(bitmix32(x, y), z) end
	return bitmix32(bitmix32(bitmix32(seed, x), y), z)
end
local hash_pos = mcl_util.hash_pos

---- Some simple assertions on the hash function.
--- Count the number of bits, unfortunately not part of bitops library
local function popcnt(x)
	local b = 0
	while x ~= 0 do
		if band(x,1) == 1 then b = b + 1 end
		x = rshift(x, 1)
	end
	return b
end
assert(hash_pos(0, 0, 0, 0) ~= hash_pos(0, 0, 0, 1))
-- Expected difference is always 16 bit for an "optimal" hash function
local function assert_hash_difference(x,y,z,x2,y2,z2,seed)
	local p = popcnt(bit.bxor(hash_pos(x,y,z,seed),hash_pos(x2,y2,z2,seed)))
	-- core.log("action", "hash test "..x..","..y..","..z..": "..bit.tohex(hash_pos(x,y,z,seed)).." "..x2..","..y2..","..z2..": "..bit.tohex(hash_pos(x2,y2,z2,seed)).." difference "..p)
	-- On introduction of this function, we would observe 13 to 19 bits of difference in the tests, which is fine
	assert(p >= 10 and p <= 22, "hash codes similar, but could be coincidence: "..x..","..y..","..z.." and "..x2..","..y2..","..z2)
end
assert_hash_difference(0,0,0, 0,0,-1, 0)
assert_hash_difference(0,0,0, 0,0,1, 0)
assert_hash_difference(0,0,0, 0,1,0, 0)
assert_hash_difference(0,0,0, 1,0,0, 0)
assert_hash_difference(0,0,1, 0,1,0, 0)
assert_hash_difference(0,0,1, 1,0,0, 0)
assert_hash_difference(0,1,0, 1,0,0, 0)
assert_hash_difference(0,0,0, 1,1,1, 0)

--- DJ Bernstein hash function known as djb2.
--- @param str string: Input
--- @return number: combined hash code
function mcl_util.djb2_hash(str)
	str = tostring(str)
	local hash = 5381
	for i = 1, #str do
		-- we don't do the h<<5+h trick here, as lua only supports doubles!
		hash = band(hash * 33 + str:byte(i), 0xffffffff)
	end
	-- by default, the values would be signed, we want u32
	return hash >= 0 and hash or (0x100000000 + hash)
end
assert(mcl_util.djb2_hash("VoxeLibre") == 2331368085, "djb2 hash does not agree with expected hash code from a Python implementation")

