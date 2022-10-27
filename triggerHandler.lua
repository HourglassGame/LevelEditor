
local IterableMap = require("include/IterableMap")
local util = require("include/util")
local Font = require("include/font")

local self = {}
local api = {}

function api.Update(dt)
end

function api.Draw(drawQueue)
end

function api.Initialize(world, levelIndex, mapDataOverride)
	self = {
		world = world,
	}
	
end

return api
