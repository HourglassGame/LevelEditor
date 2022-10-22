
local function PosSize(pos, width, height)
	local self = {
		pos = pos,
		width = width,
		height = height,
	}
	
	local api = {}
	function api.Draw(image)
		Resources.DrawImage(
			image,
			LevelHandler.HgToWorld(self.pos[1]),
			LevelHandler.HgToWorld(self.pos[2]),
			0, 0.8,
			{
				LevelHandler.HgToWorld(self.width),
				LevelHandler.HgToWorld(self.height)
			})
	end
	
	return api
end

return PosSize
