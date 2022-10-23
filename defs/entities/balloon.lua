
local util = require("include/util")

local entity = {
	Create = function (self, api)
		-- pos = {x, y}
		-- width
		-- height
		self.posSize = NewProp.posSize(api, self.pos, self.width or (0.5 * Global.HG_GRID_SIZE), self.height or (1.3 * Global.HG_GRID_SIZE))
		self.timeDirection = NewProp.timeDirection(api, self.timeDirection or "forwards", "balloon", "balloon_r")
		self.xspeed = NewProp.numberBox(api, "X Speed", self.xspeed or 0)
		self.yspeed = NewProp.numberBox(api, "Y Speed", self.yspeed or 0)
		
		local function SetBalloonJump(newVal)
			if newVal == 3 then
				self.posSize.SetSize(1 * 1600, 1 * 3200)
			elseif newVal == 4 then
				self.posSize.SetSize(1.3 * 1600, 1.3 * 3200)
			elseif newVal == 5 then
				self.posSize.SetSize(1.6 * 1600, 1.6 * 3200)
			elseif newVal == 6 then
				self.posSize.SetSize(2 * 1600, 2 * 3200)
			elseif newVal == 7 then
				self.posSize.SetSize(2.4 * 1600, 2.4 * 3200)
			elseif newVal == 8 then
				self.posSize.SetSize(2.9 * 1600, 2.9 * 3200)
			elseif newVal == 9 then
				self.posSize.SetSize(3.6 * 1600, 3.6 * 3200)
			end
		end
		
		local balloonDefault = 3
		if self.width == 1 * 1600 then
			balloonDefault = 3
		elseif newVal == 1.3 * 1600 then
			balloonDefault = 4
		elseif newVal == 1.6 * 1600 then
			balloonDefault = 5
		elseif newVal == 2 * 1600 then
			balloonDefault = 6
		elseif newVal == 2.4 * 1600 then
			balloonDefault = 7
		elseif newVal == 2.9 * 1600 then
			balloonDefault = 8
		elseif newVal == 3.6 * 1600 then
			balloonDefault = 9
		end
		self.sizePreset = NewProp.enumBox(api, "Balloon Jump", balloonDefault, {3, 4, 5, 6, 7, 8, 9}, SetBalloonJump)
		
		self.propList = {
			self.posSize,
			self.sizePreset,
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
