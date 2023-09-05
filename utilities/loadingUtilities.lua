
local api = {}

local function GetPlatformTarget(destination)
	return {
		destination.xDestination.desiredPosition,
		destination.yDestination.desiredPosition,
	}, {
		destination.xDestination.maxSpeed,
		destination.yDestination.maxSpeed,
	}, {
		destination.xDestination.acceleration,
		destination.yDestination.acceleration,
	}, {
		destination.xDestination.deceleration,
		destination.yDestination.deceleration,
	}
end

function api.LoadPlatform(proto, platformID, triggers)
	local stateTrigger = triggers.triggerOffsetsAndDefaults[proto.lastStateTriggerID]
	
	local onPos, onSpeed, onAccel, onDecel = GetPlatformTarget(proto.destinations.onDestination)
	local offPos, offSpeed, offAccel, offDecel = GetPlatformTarget(proto.destinations.offDestination)
	
	local data = {
		startPos   = {stateTrigger.default[1], stateTrigger.default[2]},
		startSpeed = {stateTrigger.default[3], stateTrigger.default[4]},
		width = proto.width,
		height = proto.height,
		
		onPos    = onPos,
		onSpeed  = onSpeed,
		onAccel  = onAccel,
		onDecel  = onDecel,
		offPos   = offPos,
		offSpeed = offSpeed,
		offAccel = offAccel,
		offDecel = offDecel,
		
		activeTriggerName = IndexNameHandler.GetOrMakeTriggerName(proto.buttonTriggerID, "button"),
		stateTriggerName  = IndexNameHandler.GetOrMakeTriggerName(proto.lastStateTriggerID, "platform"),
		platformName      = IndexNameHandler.GetOrMakePlatformName(platformID, "attach"),
		
		timeDirection = (((stateTrigger.offset == 1) and "forwards") or "reverse"),
		
		destroyed = (stateTrigger[5] == 1),
	}
	
	util.PrintTable(data)
	
	return data
end

return api
