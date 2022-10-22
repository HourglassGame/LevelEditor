
local util = require("include/util")
local Resources = require("resourceHandler")
local Font = require("include/font")


local function NewEntity(self, def)
	self = def.Create(self)
	
	function self.Draw(drawQueue)
		drawQueue:push({y=def.drawLayer; f=function()
			self.posSize.Draw(def.image or self.timeDirection.GetImage())
		end})
	end
	
	return self
end

return NewEntity
