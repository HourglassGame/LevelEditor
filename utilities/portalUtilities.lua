
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

function api.GetDefaultPortal(portalType)
	if portalType == "win" then
		local data = {
			winner = true
		}
		return data
	elseif portalType == "zero" then
		local data = {
			relativeTime = false,
			timeDestination = 0,
		}
		return data
	elseif portalType == "reverse" then
		local data = {
			relativeTime = true,
			timeDestination = 0,
			relativeDirection = true,
			destinationDirection = "reverse",
		}
		return data
	end
end

return api
