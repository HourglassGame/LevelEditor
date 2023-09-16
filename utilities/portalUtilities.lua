
local api = {}

function api.LoadPortal(proto, portalID, triggers)
	local changes = -1
	if proto.chargeTriggerID then
		changes = triggers.triggerOffsetsAndDefaults[proto.chargeTriggerID][1]
	end
	
	local data = {
		pos              = {proto.attachment.xOffset, proto.attachment.yOffset},
		width            = proto.width,
		height           = proto.height,
		collisionOverlap = proto.collisionOverlap,
		
		portalName    = IndexNameHandler.GetOrMakePortalName(portalID, "portal"),
		timeDirection = proto.timeDirection,
		winner        = proto.winner,
		guyOnly       = proto.guyOnly,
		fallable      = proto.fallable,
		changes       = changes,
		
		destinationName      = IndexNameHandler.GetOrMakePortalName(proto.destinationIndex, "portal"),
		destinationOffset    = {proto.xDestination, proto.yDestination},
		timeDestination      = proto.timeDestination,
		destinationDirection = proto.destinationDirection,
		relativeTime         = proto.relativeTime,
		relativeDirection    = proto.relativeDirection,
	}
	
	return data
end

function api.GetDefaultPortal(portal)
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
