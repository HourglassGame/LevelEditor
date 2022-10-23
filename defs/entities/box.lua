
local util = require("include/util")

local entity = {
	Create = function (self)
		-- pos = {x, y}
		-- width
		-- height
		self.posSize = NewProp.posSize(self.pos, self.width, self.height)
		self.timeDirection = NewProp.timeDirection(self.timeDirection, "box", "box_r")
		
		self.propList = {
			self.posSize,
			self.timeDirection
		}
		self.activeClickProp = self.posSize.GetWorldClickProp()
		
		return self
	end,
	
	
	-- Editor-only
	drawLayer = 20,
}

return entity
