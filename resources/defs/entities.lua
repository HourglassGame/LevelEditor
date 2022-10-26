
local names = util.GetDefDirList("resources/images/entities")
local data = {}

local sizes = {
	rhino_left_stop    = {0.5, 1},
	rhino_right_stop   = {0.5, 1},
	rhino_left_stop_r  = {0.5, 1},
	rhino_right_stop_r = {0.5, 1},
}


for i = 1, #names do
	local size = sizes[names[i]]
	data[#data + 1] = {
		name = names[i],
		file = "resources/images/entities/" .. names[i] .. ".png",
		form = "image",
		xScale = 1 / (32 * (size and size[1] or 1)),
		yScale = 1 / (32 * (size and size[2] or 1)),
		xOffset = 0,
		yOffset = 0,
	}
	print("added", names[i])
end

return data
