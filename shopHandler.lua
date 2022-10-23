
local IterableMap = require("include/IterableMap")
local util = require("include/util")
local Font = require("include/font")

local self = {}
local api = {}

function api.SnapToGrid(pos)
	return {math.floor(pos[1] / self.placeGridSize) * self.placeGridSize, math.floor(pos[2] / self.placeGridSize) * self.placeGridSize}
end

local function DoEntityClick(mousePos, button)
	if self.selectedItem and button == 1 then
		self.selectedItem.HandleWorldClick(LevelHandler.WorldToHg(mousePos))
	elseif self.hoveredItem and button == 1 then
		self.selectedItem = self.hoveredItem
	elseif self.selectedItem and button == 2 then
		self.selectedItem = false
	end
end

function api.Update(dt)
end

function api.MousePressed(x, y, button)
	local mousePos = self.world.GetMousePosition()
	DoEntityClick(mousePos, button)
end

function api.MouseMoved(x, y, button, dx, dy)
	local mousePos = self.world.GetMousePosition()
	DoEntityClick(mousePos, button)
end

local function DrawEntityProperties(entity, mousePos)
	local propList = entity.GetPropertyList()
	local offset, hovered = 0, false
	self.hoveredProperty = false
	for i = 1, #propList do
		offset, hovered = propList[i].DrawProperty(Global.VIEW_WIDTH + 30, offset)
		if hovered then
			self.hoveredProperty = hovered

		end
	end
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
		self.hoveredItem.DrawOutline(drawQueue, "hover")
	end
	if self.selectedItem then
		self.selectedItem.DrawOutline(drawQueue, "selected")
		DrawEntityProperties(self.selectedItem, mousePos)
	end
end


function api.Initialize(world)
	self = {
		world = world,
		placeGridSize = 800
	}
end

return api
