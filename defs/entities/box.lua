
local util = require("include/util")

local entity = {
	Create = function (self, api)
		-- pos = {x, y}
		-- width
		-- height
		self.posSize = NewProp.posSize(api, self.pos, self.width, self.height)
		self.timeDirection = NewProp.timeDirection(api, self.timeDirection, "box", "box_r")
		
		self.propList = {
			self.posSize,
			self.timeDirection
		}
		self.defaultSelection = self.posSize.GetWorldClickProp()
		
		return self
	end,
	
	
	-- Editor-only
	drawLayer = 20,
}

return entity
