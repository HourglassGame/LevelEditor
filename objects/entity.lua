
local util = require("include/util")
local Resources = require("resourceHandler")
local Font = require("include/font")


local function NewEntity(self, def)
	local api = {}
	self = def.Create(self, api)
	
	function api.GetPropertyList()
		return self.propList
	end
	
	function api.GetDefaultSelectedProperty()
		return self.defaultSelection
	end
	
	function api.HitTest(pos, hitFunc)
		if self.posSize.HitTest(pos) then
			hitFunc(api)
		end
	end
	
	function api.DeleteIfHit(pos)
		if (not def.undeletable) and self.posSize.HitTest(pos) then
			return true
		end
	end
	
	function api.DrawOutline(drawQueue, outlineType)
		drawQueue:push({y=def.drawLayer; f=function()
			if outlineType == "hover" then
				love.graphics.setColor(0.1, 0.7, 0.7, 0.4)
			elseif outlineType == "selected" then
				love.graphics.setColor(0.1, 1, 0.1, 0.4)
			end
			self.posSize.DrawOutline()
		end})
	end
	
	function api.Draw(drawQueue)
		drawQueue:push({y=def.drawLayer; f=function()
			if def.DrawFunc then
				def.DrawFunc(self)
			else
				self.posSize.Draw((def.ImageFunc and def.ImageFunc(self)) or def.image or self.timeDirection.GetImage())
			end
		end})
	end
	
	return api
end

return NewEntity
