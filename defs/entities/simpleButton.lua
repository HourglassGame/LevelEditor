
local util = require("include/util")

local function momentarySwitch(p)
	return {
		type = 'momentarySwitch',
		timeDirection = p.timeDirection,
		attachment = cloneAttachment(p.attachment),
		width = p.width,
		height = p.height,
		pressForceReq = p.pressForceReq or 0,
		triggerID = p.triggerID,
		stateTriggerID = p.stateTriggerID,
		extraTriggerIDs = p.extraTriggerIDs,
	}
end
local function stickySwitch(p)
	return {
		type = 'stickySwitch',
		timeDirection = p.timeDirection,
		attachment = cloneAttachment(p.attachment),
		width = p.width,
		height = p.height,
		pressForceReq = p.pressForceReq or 0,
		triggerID = p.triggerID,
		stateTriggerID = p.stateTriggerID,
		extraTriggerIDs = p.extraTriggerIDs,
	}
end

local entity = {
	Create = function (self, api)
		-- pos = {x, y}
		-- width
		-- height
		-- triggerName
		self.posSize = NewProp.posSize(api, self.pos, self.width or 0.5*Global.HG_GRID_SIZE, self.height or 0.5*Global.HG_GRID_SIZE)
		self.timeDirection = NewProp.timeDirection(api, self.timeDirection or "forwards")
		--self.attachment = 
		self.pickupType = NewProp.enumBox(api, "Type", self.pickupType or "timeJump", Global.PICKUP_LIST)
		self.pickupNumber = NewProp.numberBox(api, "Count", self.pickupNumber or 1, 1, 1)
		self.triggerName = NewProp.textBox(api, "Trigger", self.triggerName or IndexNameHandler.GetNewTriggerName('pickup'))
		
		self.propList = {
			self.posSize,
			self.timeDirection,
			self.pickupType,
			self.pickupNumber,
			self.triggerName,
		}
		self.defaultSelection = self.posSize.GetWorldClickProp()
		
		return self
	end,
	
	ImageFunc = function (self)
		return nameToImage[self.pickupType.Get()]
	end,
	
	Save = function (self, api)
	
	end,
	
	-- Editor-only
	drawLayer = 20,
}

return entity
