
local IterableMap = require("include/IterableMap")
local util = require("include/util")
local loadingUtilities = require("utilities/loadingUtilities")

local EntityDefs = util.LoadDefDirectory("defs/entities")
local NewEntity = require("objects/entity")

NewProp = util.LoadDefDirectory("objects/properties")

local self = {}
local api = {}

function api.AddEntity(name, data)
	local def = EntityDefs[name]
	IterableMap.Add(self.entities, NewEntity(data, def))
end

function api.HitTest(pos)
	local hit = false
	local function RegisterHit(entity)
		hit = entity
	end
	IterableMap.ApplySelf(self.entities, "HitTest", pos, RegisterHit)
	return hit
end

function api.RemoveEntitiesAtPos(pos)
	IterableMap.ApplySelf(self.entities, "DeleteIfHit", pos)
end

function api.LoadLevelItems(triggers, items)
	for i = 1, #items.protoCollisions do
		local proto = items.protoCollisions[i]
		api.AddEntity("platform", loadingUtilities.LoadPlatform(proto, i, triggers))
	end
	for i = 1, #items.protoMutators do
		local proto = items.protoMutators[i]
		if proto.btsType == "pickup" then
			local data = {
				pos = {proto.attachment.xOffset, proto.attachment.yOffset},
				width = proto.width,
				height = proto.height,
				timeDirection = proto.timeDirection,
				pickupType = proto.pickupType,
				triggerName = IndexNameHandler.GetOrMakeTriggerName(proto.triggerID, proto.btsType),
				-- Attachment ID
			}
			api.AddEntity("pickup", data)
		end
	end
end

function api.Update(dt)
	--IterableMap.ApplySelf(self.entities, "Update", dt)
end

function api.Draw(drawQueue)
	IterableMap.ApplySelf(self.entities, "Draw", drawQueue)
end

function api.DeleteAll()
	self.entities = IterableMap.New()
end

function api.Initialize(world)
	self = {
		entities = IterableMap.New(),
		world = world,
	}
end

return api
