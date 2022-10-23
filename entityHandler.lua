
local IterableMap = require("include/IterableMap")
local util = require("include/util")

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

function api.Update(dt)
	--IterableMap.ApplySelf(self.entities, "Update", dt)
end

function api.Draw(drawQueue)
	IterableMap.ApplySelf(self.entities, "Draw", drawQueue)
end


function api.Initialize(world)
	self = {
		entities = IterableMap.New(),
		world = world,
	}
end

return api
