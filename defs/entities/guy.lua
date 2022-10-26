
local util = require("include/util")

local entity = {
	Create = function (self, api)
		-- pos = {x, y}
		-- width
		-- height
		self.posSize = NewProp.posSize(api, self.pos, self.width or (Global.HG_GRID_SIZE*0.5), self.height or Global.HG_GRID_SIZE)
		self.xspeed = NewProp.numberBox(api, "X Speed", self.xspeed or 0)
		self.yspeed = NewProp.numberBox(api, "Y Speed", self.yspeed or 0)
		self.facing = NewProp.enumBox(api, "Facing", self.facing or "right", {"left", "right"})
		
		self.arrivalTime = NewProp.numberBox(api, "Arrival Time", self.arrivalTime or 0, 0, 60)
		self.timeDirection = NewProp.timeDirection(api, self.timeDirection or "forwards")
		self.timePaused = NewProp.boolBox(api, "Time Paused", self.timePaused)
		-- Jump speed is technically configurable but we choose not to let the editor do it.
		
		self.boxCarrying = NewProp.enumBox(api, "Carried Box", self.boxCarrying or "none", Global.BOX_TYPES)
		self.boxCarryWidth = NewProp.numberBox(api, "Box Width", self.boxCarryWidth or Global.HG_GRID_SIZE, 400)
		self.boxCarryHeight = NewProp.numberBox(api, "Box Height", self.boxCarryHeight or Global.HG_GRID_SIZE, 400)
		-- boxCarryState (basically bomb countdown) is also configurable but we choose to not expose it.
		self.boxCarryDirection = NewProp.timeDirection(api, self.boxCarryDirection or self.timeDirection.Get())
		
		self.propList = {
			self.posSize,
			self.xspeed,
			self.yspeed,
			self.facing,
			NewProp.heading(api, "Time"),
			self.arrivalTime,
			self.timeDirection,
			self.timePaused,
			NewProp.heading(api, "Box Status"),
			self.boxCarrying,
			self.boxCarryWidth,
			self.boxCarryHeight,
			self.boxCarryDirection,
			NewProp.heading(api, "Items"),
		}
		
		self.pickups = self.pickups or {}
		for i = 1, #Global.PICKUP_LIST do
			local pickup = Global.PICKUP_LIST[i]
			self.pickups[pickup] = NewProp.numberBox(api, pickup, self.pickups[pickup] or 0)
			self.propList[#self.propList + 1] = self.pickups[pickup]
		end
		
		self.defaultSelection = self.posSize.GetWorldClickProp()
		
		return self
	end,
	
	ImageFunc = function (self)
		if self.facing.Get() == "right" then
			if self.timeDirection.Get() == "forwards" then
				return "rhino_right_stop"
			else
				return "rhino_right_stop_r"
			end
		else
			if self.timeDirection.Get() == "forwards" then
				return "rhino_left_stop"
			else
				return "rhino_left_stop_r"
			end
		end
	end,
	
	Save = function (self, api)
	
	end,
	
	-- Editor-only
	drawLayer = 20,
	undeletable = true, -- There can only be (exactly) one
}

return entity
