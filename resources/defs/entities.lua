
local names = util.GetDefDirList("resources/images/entities")
local data = {}

local sizes = {
	rhino_left_stop    = {0.5, 1},
	rhino_right_stop   = {0.5, 1},
	rhino_left_stop_r  = {0.5, 1},
	rhino_right_stop_r = {0.5, 1},
	time_gun     = {0.5, 0.5},
	time_jump    = {0.5, 0.5},
	time_reverse = {0.5, 0.5},
	reverse_gun  = {0.5, 0.5},
	time_pause   = {0.5, 0.5},
}

local offsets = {
	time_gun     = {0.18, 0.18},
	time_jump    = {0.18, 0.18},
	time_reverse = {0.18, 0.18},
	reverse_gun  = {0.18, 0.18},
	time_pause   = {0.18, 0.18},
}

for i = 1, #names do
	local size = sizes[names[i]]
	local offset = offsets[names[i]]
	data[#data + 1] = {
		name = names[i],
		file = "resources/images/entities/" .. names[i] .. ".png",
		form = "image",
		xScale = 1 / (32 * (size and size[1] or 1)),
		yScale = 1 / (32 * (size and size[2] or 1)),
		xOffset = (offset and offset[1] or 0),
		yOffset = (offset and offset[2] or 0),
	}
	print("added", names[i])
end

return data
