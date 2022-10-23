
local IterableMap = require("include/IterableMap")
local util = require("include/util")
local Font = require("include/font")

local self = {}
local api = {}

function api.SnapToGrid(pos)
	return {math.floor(pos[1] / self.placeGridSize) * self.placeGridSize, math.floor(pos[2] / self.placeGridSize) * self.placeGridSize}
end

local function DoEntityClick(mousePos, button)
	if self.hoveredItem and button == 1 then
		if self.selectedItem then
			if self.selectedProperty then
				self.selectedProperty.SetSelected(false)
				self.selectedProperty = false
			end
		end
		self.selectedItem = self.hoveredItem
		self.selectedProperty = self.selectedItem.GetDefaultSelectedProperty()
		self.selectedProperty.SetSelected(true)
		return true
	elseif self.selectedItem and button == 2 then
		if self.selectedProperty then
			self.selectedProperty.SetSelected(false)
			self.selectedProperty = false
		end
		self.selectedItem = false
		return true
	end
end

local function DoPropertyClick(mousePos, button)
	if self.hoveredProperty and button == 1 then
		if self.selectedProperty then
			self.selectedProperty.SetSelected(false)
		end
		self.selectedProperty = self.hoveredProperty
		self.selectedProperty.SetSelected(true)
		return true
	elseif self.selectedProperty and button == 1 and mousePos[1] < Global.VIEW_WIDTH + Global.MAIN_PADDING then
		if self.selectedProperty.HandleWorldClick then
			self.selectedProperty.HandleWorldClick(LevelHandler.WorldToHg(mousePos))
			return true
		end
	end
end

local function DoPropertyKeyPress(key, scancode, isRepeat)
	if self.selectedProperty and self.selectedProperty.HandleKeyPress then
		self.selectedProperty.HandleKeyPress(key)
	end
end

function api.DeselectProperty()
	if self.selectedProperty then
		self.selectedProperty.SetSelected(false)
		self.selectedProperty = false
	end
end

function api.Update(dt)
	
end

function api.MousePressed(x, y, button)
	local mousePos = self.world.GetMousePosition()
	if DoPropertyClick(mousePos, button) then
		return true
	end
	if DoEntityClick(mousePos, button) then
		return true
	end
end

function api.MouseMoved(x, y, button, dx, dy)
	local mousePos = self.world.GetMousePosition()
	if DoPropertyClick(mousePos, button) then
		return true
	end
	if DoEntityClick(mousePos, button) then
		return true
	end
end

function api.KeyPressed(key, scancode, isRepeat)
	if DoPropertyKeyPress(key, scancode, isRepeat) then
		return true
	end
end

local function DrawEntityProperties(entity, mousePos)
	local propList = entity.GetPropertyList()
	local offset, hovered = 0, false
	self.hoveredProperty = false
	for i = 1, #propList do
		offset, hovered = propList[i].DrawProperty(Global.VIEW_WIDTH + 30, offset, mousePos)
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
