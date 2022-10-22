
local names = util.GetDefDirList("resources/images/entities")
local data = {}

for i = 1, #names do
	data[#data + 1] = {
		name = names[i],
		file = "resources/images/entities/" .. names[i] .. ".png",
		form = "image",
		xScale = 1/32,
		yScale = 1/32,
		xOffset = 0,
		yOffset = 0,
	}
	print("added", names[i])
end

return data
