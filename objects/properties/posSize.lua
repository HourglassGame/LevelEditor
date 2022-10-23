
local util = require("include/util")

local function PosSize(pos, width, height)
	local self = {
		propX = NewProp.numberBox('X', pos[1]),
		propY = NewProp.numberBox('Y', pos[2]),
		propW = NewProp.numberBox('W', width, 400),
		propH = NewProp.numberBox('H', height, 400),
	}
	
	
	local function GetWorldDimensions()
		local x, y = LevelHandler.HgToWorld(self.propX.Get()), LevelHandler.HgToWorld(self.propY.Get())
		local w, h = LevelHandler.HgToWorld(self.propW.Get()), LevelHandler.HgToWorld(self.propH.Get())
		return x, y, w, h
	end
	
	local api = {}
	self.worldClickToggle = NewProp.worldClickButton('Move Box', api)
	
	function api.GetWorldClickProp()
		return self.worldClickToggle
	end
	
	function api.HandleWorldClick(pos)
		pos = ShopHandler.SnapToGrid(pos)
		self.propX.Set(pos[1])
		self.propY.Set(pos[2])
	end
	
	function api.HitTest(pos)
		return util.PosInRectangle(pos, self.propX.Get(), self.propY.Get(), self.propW.Get(), self.propH.Get())
	end
	
	function api.DrawProperty(drawX, drawY)
		
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
