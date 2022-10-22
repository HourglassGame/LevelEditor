
local function PosSize(pos, width, height)
	local self = {
		pos = pos,
		width = width,
		height = height,
	}
	
	local function GetWorldDimensions()
		return LevelHandler.HgToWorld(self.pos[1]), LevelHandler.HgToWorld(self.pos[2]), LevelHandler.HgToWorld(self.width), LevelHandler.HgToWorld(self.height)
	end
	
	local api = {}
	
	function api.HitTest(pos)
		return util.PosInRectangle(pos, self.pos[1], self.pos[2], self.width, self.height)
	end
	
	function api.DrawOutline()
		local x, y, w, h = GetWorldDimensions()
		love.graphics.setLineWidth(8)
		love.graphics.rectangle("line", x - 8, y - 8, w + 16, h + 16, 8, 8, 12)
	end
	
	function api.Draw(image)
		local x, y, w, h = GetWorldDimensions()
		Resources.DrawImage(image, x, y, 0, 0.8, {w, h})
	end
	
	return api
end

return PosSize
