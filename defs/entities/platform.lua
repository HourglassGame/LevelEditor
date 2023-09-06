
local util = require("include/util")

local entity = {
	Create = function (self, api)
		self.posSize = NewProp.posSize(api, self.pos, self.width or 2*Global.HG_GRID_SIZE, self.height or 0.5*Global.HG_GRID_SIZE, {
			speed = (self.startSpeed or true),
			name = "Initial Position",
			minimiseTo = 2,
		})
		self.onPos    = NewProp.posSize(api, self.onPos or self.pos, false, false, {
			speed = (self.onSpeed or true),
			accel = (self.onAccel or true),
			decel = (self.onDecel or true),
			readSizeFrom = self.posSize,
			name = "On Position",
			minimiseTo = 2,
		})
		self.offPos   = NewProp.posSize(api, self.offPos or self.pos, false, false, {
			speed = (self.offSpeed or true),
			accel = (self.offAccel or true),
			decel = (self.offDecel or true),
			readSizeFrom = self.posSize,
			name = "Off Position",
			minimiseTo = 2,
		})
		
		self.activeTriggerName = NewProp.textBox(api, "Active Trigger", self.activeTriggerName or IndexNameHandler.GetNewTriggerName('button'))
		self.stateTriggerName  = NewProp.textBox(api, "State Trigger", self.stateTriggerName or IndexNameHandler.GetNewTriggerName('platform'))
		self.platformName      = NewProp.textBox(api, "Platform Name", self.platformName or IndexNameHandler.GetNewPlatformName('attach'))
		self.timeDirection     = NewProp.timeDirection(api, self.timeDirection or "forwards")
		self.destroyed         = NewProp.boolBox(api, "Destroyed", self.destroyed)
		
		self.propList = {
			self.activeTriggerName,
			self.stateTriggerName,
			self.platformName,
			self.timeDirection,
			self.destroyed,
			
			self.posSize,
			self.onPos,
			self.offPos,
		}
		self.defaultSelection = self.posSize.GetWorldClickProp()
		
		return self
	end,
	
	DrawFunc = function (self)
		love.graphics.setColor(0.2, 0.2, 0.2, 0.6)
		self.posSize.DrawRectangle()
		
		love.graphics.setColor(0.1, 0.9, 0.1, 0.3)
		self.onPos.DrawRectangle()
		
		love.graphics.setColor(0.9, 0.1, 0.1, 0.3)
		self.offPos.DrawRectangle()
	end,
	
	Save = function (self, api)
	
	end,
	
	-- Editor-only
	drawLayer = 20,
}

return entity
