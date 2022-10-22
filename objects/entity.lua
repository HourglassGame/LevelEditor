
local util = require("include/util")
local Resources = require("resourceHandler")
local Font = require("include/font")


local function NewEntity(self, def)
	self = def.Create(self)
	
	function self.HitTest(pos, hitFunc)
		if self.posSize.HitTest(pos) then
			hitFunc(self)
		end
	end
	
	function self.DrawOutline(drawQueue)
		drawQueue:push({y=def.drawLayer; f=function()
			love.graphics.setColor(0.1, 1, 0.1, 0.5)
			self.posSize.DrawOutline()
		end})
	end
	
	function self.Draw(drawQueue)
		drawQueue:push({y=def.drawLayer; f=function()
			self.posSize.Draw(def.image or self.timeDirection.GetImage())
		end})
	end
	
	return self
end

return NewEntity
