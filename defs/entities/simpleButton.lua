
local util = require("include/util")
local buttonUtilities = require("utilities/buttonUtilities")

local entity = {
	Create = function (self, api)
		-- pos = {x, y}
		-- width
		-- height
		-- triggerName
		self.posSize = NewProp.posSize(api, self.pos, self.width or 0.5*Global.HG_GRID_SIZE, self.height or 0.5*Global.HG_GRID_SIZE)
		self.timeDirection = NewProp.timeDirection(api, self.timeDirection or "forwards")
		self.buttonType = NewProp.enumBox(api, self.buttonType or "momentarySwitch", {"momentarySwitch", "stickySwitch"})
		--self.attachment = 
		self.triggerName = NewProp.textBox(api, "Trigger", self.triggerName or IndexNameHandler.GetNewTriggerName('button'))
		self.state = NewProp.enumBox(api, "Initial State", self.state or "off", {"on", "off", "destroyed"})
		self.pressForce = NewProp.enumBox(api, "Press Force", self.pressForce or "guy", buttonUtilities.GetPressForceOptions())
		
		self.propList = {
			self.posSize,
			self.timeDirection,
			self.triggerName,
			self.state,
			self.pressForce,
		}
		self.defaultSelection = self.posSize.GetWorldClickProp()
		
		return self
	end,
	
	DrawFunc = function (self)
		love.graphics.setColor(1, 0.588, 0.588, 0.9)
		self.posSize.DrawRectangle()
	end,
	
	Save = function (self, api)
	
	end,
	
	-- Editor-only
	drawLayer = 20,
}

return entity
