
local IterableMap = require("include/IterableMap")
local util = require("include/util")
local Font = require("include/font")

local self = {}
local api = {}

local function InitIndexData(defaultPrefix)
	return {
		usedNames = {},
		indexToName = {},
		defaultPrefix = defaultPrefix,
	}
end

local function GetNewName(data, prefix)
	local nameIndex = 1
	local name = prefix .. tostring(nameIndex)
	while data.usedNames[name] do
		nameIndex = nameIndex + 1
		name = prefix .. tostring(nameIndex)
	end
	data.usedNames[name] = true
	return name
end

local function GetOrMakeName(data, index, prefix)
	if not data.indexToName[index] then
		prefix = prefix or data.defaultPrefix
		data.indexToName[index] = GetNewName(data, prefix)
	end
	return data.indexToName[index]
end

function api.GetNewTriggerName(prefix)
	return GetNewName(self.triggerData, prefix)
end

function api.GetOrMakeTriggerName(triggerID, prefix)
	return GetOrMakeName(self.triggerData, triggerID, prefix)
end

function api.GetNewPlatformName(prefix)
	return GetNewName(self.platformData, prefix)
end

function api.GetOrMakePlatformName(platformID, prefix)
	return GetOrMakeName(self.platformData, platformID, prefix)
end

function api.GetNewPortalName(prefix)
	return GetNewName(self.portalData, prefix)
end

function api.GetOrMakePortalName(portalID, prefix)
	return GetOrMakeName(self.portalData, portalID, prefix)
end

function api.Update(dt)
end

function api.Draw(drawQueue)
end

function api.Initialize(world, levelIndex, mapDataOverride)
	self = {
		world = world,
		triggerData = InitIndexData("trigger"),
		platformData = InitIndexData("platform"),
		portalData = InitIndexData("portal"),
	}
end

return api
