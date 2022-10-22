
local util = require("include/util")
local PropDefs = util.LoadDefDirectory("objects/properties")

local entity = {
	Create = function (self)
		-- pos = {x, y}
		-- width
		-- height
		self.posSize = PropDefs.posSize(self.pos, self.width, self.height)
		self.timeDirection = PropDefs.timeDirection(self.timeDirection, "box", "box_r")
		return self
	end,
	
	
	-- Editor-only
	drawLayer = 20,
}

return entity
