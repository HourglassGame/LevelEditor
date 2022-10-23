
local util = require("include/util")

local function PosSize(parent, pos, width, height)
	local api = {}
	local self = {
		propX = NewProp.numberBox(api, 'X', pos[1]),
		propY = NewProp.numberBox(api, 'Y', pos[2]),
		propW = NewProp.numberBox(api, 'Width', width, 400),
		propH = NewProp.numberBox(api, 'Height', height, 400),
		worldClickToggle = NewProp.worldClickButton(api, 'Click Move')
	}
	
	local function GetWorldDimensions()
		local x, y = LevelHandler.HgToWorld(self.propX.Get()), LevelHandler.HgToWorld(self.propY.Get())
		local w, h = LevelHandler.HgToWorld(self.propW.Get()), LevelHandler.HgToWorld(self.propH.Get())
		return x, y, w, h
	end
	
	
	self.propList = {
		self.worldClickToggle,
		self.propX,
		self.propY,
		self.propW,
		self.propH,
	}
	
	function api.GetWorldClickProp()
		return self.worldClickToggle
	end
	
	function api.SetSize(newWidth, newHeight)
		self.propW.Set(newWidth)
		self.propH.Set(newHeight)
	end
	
	function api.HandleWorldClick(pos, fromMouseMove)
		pos = ShopHandler.SnapToGrid(pos)
		self.propX.Set(pos[1] - self.propW.Get()*0.5)
		self.propY.Set(pos[2] - self.propW.Get()*0.5)
	end
	
	function api.HitTest(pos)
		return util.PosInRectangle(pos, self.propX.Get(), self.propY.Get(), self.propW.Get(), self.propH.Get())
	end
	
	function api.DrawProperty(drawQueue, drawX, drawY, mousePos)
		local hovered, thisHovered = false
		for i = 1, #self.propList do
			drawY, thisHovered = self.propList[i].DrawProperty(drawQueue, drawX, drawY, mousePos)
			if thisHovered then
				hovered = thisHovered
			end
		end
		return drawY, hovered
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
