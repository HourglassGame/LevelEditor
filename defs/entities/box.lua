
local util = require("include/util")

local entity = {
	Create = function (self, api)
		-- pos = {x, y}
		-- width
		-- height
		self.posSize = NewProp.posSize(api, self.pos, self.width, self.height)
		self.timeDirection = NewProp.timeDirection(api, self.timeDirection, "box", "box_r")
		self.boxType = NewProp.enumBox(api, "Type", self.boxType, {"box", "light", "bomb", "balloon"})
		self.xspeed = NewProp.numberBox(api, "X Speed", self.xspeed)
		self.yspeed = NewProp.numberBox(api, "Y Speed", self.yspeed)
		
		self.propList = {
			self.posSize,
			self.xspeed,
			self.yspeed,
			self.timeDirection,
			self.boxType
		}
		self.defaultSelection = self.posSize.GetWorldClickProp()
		
		return self
	end,
	
	
	-- Editor-only
	drawLayer = 20,
}

return entity
