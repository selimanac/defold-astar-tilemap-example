local utils = {}

local DISPLAY_WIDTH = sys.get_config_int("display.width")
local DISPLAY_HEIGHT = sys.get_config_int("display.height")

function utils.contains(t, value)
	for _, v in ipairs(t) do
		if v == value then return true end
	end
end

function utils.screen_to_world(x, y, z, camera_id)
	local projection = camera.get_projection(camera_id)
	local view = camera.get_view(camera_id)
	local w, h = window.get_size()
	-- The window.get_size() function will return the scaled window size,
	-- ie taking into account display scaling (Retina screens on macOS for
	-- instance). We need to adjust for display scaling in our calculation.
	w = w / (w / DISPLAY_WIDTH)
	h = h / (h / DISPLAY_HEIGHT)

	-- https://defold.com/manuals/camera/#converting-mouse-to-world-coordinates
	local inv = vmath.inv(projection * view)
	x = (2 * x / w) - 1
	y = (2 * y / h) - 1
	z = (2 * z) - 1
	local x1 = x * inv.m00 + y * inv.m01 + z * inv.m02 + inv.m03
	local y1 = x * inv.m10 + y * inv.m11 + z * inv.m12 + inv.m13
	local z1 = x * inv.m20 + y * inv.m21 + z * inv.m22 + inv.m23
	return x1, y1, z1
end

function utils.tile_to_screen(tile_x, tile_y, z, tile_size)
	local scrx = tile_size * (tile_x - 1) + tile_size / 2
	local scry = tile_size * (tile_y - 1) + tile_size / 2
	return vmath.vector3(scrx, scry, z)
end

function utils.screen_to_tile(x, y, tile_size)
	return math.ceil(x / tile_size), math.ceil(y / tile_size)
end

return utils
