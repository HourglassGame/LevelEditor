
local util = require("include/util")
local Resources = require("resourceHandler")
local Font = require("include/font")


local function NewEntity(self, def)
	self = def.Create(self)
	
	function self.GetPropertyList()
		return self.propList
	end
	
	function self.HitTest(pos, hitFunc)
		if self.posSize.HitTest(pos) then
			hitFunc(self)
		end
	end
	
	function self.HandleWorldClick(pos)
		if self.activeClickProp then
			self.activeClickProp.HandleWorldClick(pos)
		end
	end
	
	function self.DrawOutline(drawQueue, outlineType)
		drawQueue:push({y=def.drawLayer; f=function()
			if outlineType == "hover" then
				love.graphics.setColor(0.1, 0.7, 0.7, 0.4)
			elseif outlineType == "selected" then
				love.graphics.setColor(0.1, 1, 0.1, 0.4)
			end
			self.posSize.DrawOutline()
		end})
	end
	
	function self.Draw(drawQueue)
		drawQueue:push({y=def.drawLayer; f=function()
			self.posSize.Draw((def.ImageFunc and def.ImageFunc()) or def.image or self.timeDirection.GetImage())
		end})
	end
	
	return self
end

return NewEntity
