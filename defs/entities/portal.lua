
local util = require("include/util")

local entity = {
	Create = function (self, api)
		self.posSize = NewProp.posSize(api, self.pos, self.width or 2*Global.HG_GRID_SIZE, self.height or 2*Global.HG_GRID_SIZE)
		self.portalName       = NewProp.textBox(api, "Portal Name", self.portalName or IndexNameHandler.GetNewPortalName('portal'))
		self.collisionOverlap = NewProp.numberBox(api, 'Overlap Percent', self.collisionOverlap, 0, 100, 1)
		self.timeDirection    = NewProp.timeDirection(api, self.timeDirection or "forwards")
		self.winner           = NewProp.boolBox(api, "Win Portal", self.winner)
		self.guyOnly          = NewProp.boolBox(api, "Player Only", self.guyOnly)
		self.fallable         = NewProp.boolBox(api, "Fallable", self.fallable)
		self.changes          = NewProp.numberBox(api, "Charges", self.changes or -1, -1, false, 1)
		
		self.destinationName   = NewProp.textBox(api, "Destination", self.destinationName or self.portalName.Get())
		self.destinationOffset = NewProp.posSize(api, self.destinationOffset or {0, 0}, false, false, {
			readSizeFrom = self.posSize,
		})
		
		self.timeDestination      = NewProp.numberBox(api, "Dest Time", self.timeDestination or 0, false, false, Global.FRAMES_PER_SECOND)
		self.destinationDirection = NewProp.timeDirection(api, self.destinationDirection or "forwards", false, false, "Dest Direction")
		self.relativeTime         = NewProp.boolBox(api, "Relative Time", self.relativeTime)
		self.relativeDirection    = NewProp.boolBox(api, "Relative Dir", self.relativeDirection)
		
		self.propList = {
			self.posSize,
			
			NewProp.heading(self, "Entry"),
			self.portalName,
			self.collisionOverlap,
			self.timeDirection,
			self.winner,
			self.guyOnly,
			self.fallable,
			self.changes,
			
			NewProp.heading(self, "Destination"),
			
			self.destinationName,
			self.destinationOffset,
			self.timeDestination,
			self.destinationDirection,
			self.relativeTime,
			self.relativeDirection,
		}
		self.defaultSelection = self.posSize.GetWorldClickProp()
		
		return self
	end,
	
	DrawFunc = function (self)
		love.graphics.setColor(0.4, 0.4, 0.4, 0.95)
		self.posSize.DrawRectangle()
	end,
	
	Save = function (self, api)
	
	end,
	
	-- Editor-only
	drawLayer = 10,
}

return entity
