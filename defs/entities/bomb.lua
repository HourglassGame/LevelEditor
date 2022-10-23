
local util = require("include/util")

local entity = {
	Create = function (self, api)
		-- pos = {x, y}
		-- width
		-- height
		self.posSize = NewProp.posSize(api, self.pos, self.width or Global.HG_GRID_SIZE, self.height or Global.HG_GRID_SIZE)
		self.timeDirection = NewProp.timeDirection(api, self.timeDirection or "forwards", "bomb", "bomb_r")
		self.xspeed = NewProp.numberBox(api, "X Speed", self.xspeed or 0)
		self.yspeed = NewProp.numberBox(api, "Y Speed", self.yspeed or 0)
		
		self.propList = {
			self.posSize,
			self.xspeed,
			self.yspeed,
			self.timeDirection,
		}
		self.defaultSelection = self.posSize.GetWorldClickProp()
		
		return self
	end,
	
	Save = function (self, api)
	
	end,
	
	-- Editor-only
	drawLayer = 20,
}

return entity
