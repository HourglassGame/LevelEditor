
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
		pos        = {stateTrigger.default[1], stateTrigger.default[2]},
		width      = proto.width,
		height     = proto.height,
		startSpeed = {stateTrigger.default[3], stateTrigger.default[4]},
		
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
	
	return data
end

function api.GetDefaultPlatform(platformType, addFunction)
	if platformType == "elevator" then
		local speed = {260, 260}
		local accel = {30, 30}
		local decel = {30, 30}
		local data = {
			width      = 3*Global.HG_GRID_SIZE,
			height     = Global.HG_GRID_SIZE,
			
			onSpeed  = speed,
			onAccel  = accel,
			onDecel  = decel,
			offSpeed = speed,
			offAccel = accel,
			offDecel = decel,
		}
		return data
	elseif platformType == "platform" then
		local speed = {200, 200}
		local accel = {10, 10}
		local decel = {10, 10}
		local data = {
			width      = 3*Global.HG_GRID_SIZE,
			height     = 0.5*Global.HG_GRID_SIZE,
			
			onSpeed  = speed,
			onAccel  = accel,
			onDecel  = decel,
			offSpeed = speed,
			offAccel = accel,
			offDecel = decel,
		}
		return data
	elseif platformType == "door" then
		local speed = {300, 300}
		local accel = {50, 50}
		local decel = {50, 50}
		local data = {
			width      = 0.5*Global.HG_GRID_SIZE,
			height     = 3*Global.HG_GRID_SIZE,
			
			onSpeed  = speed,
			onAccel  = accel,
			onDecel  = decel,
			offSpeed = speed,
			offAccel = accel,
			offDecel = decel,
		}
		return data
	end
end

return api
