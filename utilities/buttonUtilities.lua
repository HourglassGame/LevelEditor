
local api = {}

function api.GetPressForceOptions()
	return {
		"heavy box",
		"light box",
		"guy",
	}
end

function api.PressForceToString(force)
	return (force == 2 and "heavy box") or (force == 1 and "light box") or "guy"
end

function api.PressForceToInt(force)
	return (force == "heavy box" and 2) or (force == "light box" and 1) or 0
end

function api.LoadButton(proto, triggers)
	local stateTrigger = triggers.triggerOffsetsAndDefaults[proto.triggerID]
	
	util.PrintTable(proto)
	if proto.btsType == "momentarySwitch" or proto.btsType == "stickySwitch" then
		local data = {
			pos        = {proto.attachment.xOffset, proto.attachment.yOffset},
			width      = proto.width,
			height     = proto.height,
			pressForce = api.PressForceToString(proto.pressForceReq),
			
			buttonType = proto.btsType,
			triggerName = IndexNameHandler.GetOrMakeTriggerName(proto.triggerID, "button"),
			
			timeDirection = (((stateTrigger.offset == 1) and "forwards") or "reverse"),
			
			state = ((stateTrigger.default[1] == -1) and "destroyed") or ((stateTrigger.default[1] >= 1) and "on") or "off",
			-- TODO extraTriggerIDs
		}
		
		return "simpleButton", data
	end
end

function api.GetDefaultButton(buttonType)
	if buttonType == "momentarySwitch" then
		local data = {
			width      = Global.HG_GRID_SIZE,
			height     = 0.25*Global.HG_GRID_SIZE,
			buttonType = buttonType,
		}
		return "simpleButton", data
	elseif buttonType == "stickySwitch" then
		local data = {
			width      = 0.25*Global.HG_GRID_SIZE,
			height     = 0.5*Global.HG_GRID_SIZE,
			buttonType = buttonType,
		}
		return "simpleButton", data
	end
end

return api
