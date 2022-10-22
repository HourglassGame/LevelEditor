
local IterableMap = require("include/IterableMap")
local util = require("include/util")

local EntityDefs = util.LoadDefDirectory("defs/entities")
local NewEntity = require("objects/entity")

local self = {}
local api = {}

function api.AddEntity(name, data)
	local def = EntityDefs[name]
	IterableMap.Add(self.entities, NewEntity(data, def))
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
