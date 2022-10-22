
local IterableMap = require("include/IterableMap")
local util = require("include/util")
local Font = require("include/font")

local self = {}
local api = {}


function api.Update(dt)
end

function api.Draw(drawQueue)
	local mousePos = self.world.GetMousePosition()
	self.hoveredItem = false
	local hgPos = LevelHandler.WorldToHg(mousePos)
	local hitEntity = EntityHandler.HitTest(hgPos)
	if hitEntity then
		self.hoveredItem = hitEntity
	end
	if self.hoveredItem then
		self.hoveredItem.DrawOutline(drawQueue)
	end
end


function api.Initialize(world)
	self = {
		world = world,
	}
end

return api
