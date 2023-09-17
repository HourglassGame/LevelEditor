
local IterableMap = require("include/IterableMap")
local util = require("include/util")
local Font = require("include/font")

local platformUtilities = require("utilities/platformUtilities")
local portalUtilities = require("utilities/portalUtilities")
local buttonUtilities = require("utilities/buttonUtilities")

local self = {}
local api = {}

local function SaveLevel()
	LevelHandler.SaveLevel(self.levelFile.Get())
end
local function LoadLevel()
	LevelHandler.LoadLevel(self.levelFile.Get())
end

function api.SnapToGrid(pos, xGridMax, yGridMax)
	return {math.floor(
		0.5 + pos[1] / math.min(xGridMax, self.placeGridSize.Get())) * math.min(xGridMax, self.placeGridSize.Get()),
		math.floor(0.5 + pos[2] / math.min(yGridMax, self.placeGridSize.Get())) * math.min(yGridMax, self.placeGridSize.Get())
	}
end

local function DoEntityClick(mousePos, button)
	if self.hoveredItem and button == 1 then
		if self.selectedProperty then
			self.selectedProperty.SetSelected(false)
			self.selectedProperty = false
		end
		if Global.IGNORE_MOVE_ON_SELECT and not self.selectedItem then
			-- Stop entities repositioning when clicking on them followed by an accidental mouse movement.
			self.ignoreMouseMove = true
		end
		self.selectedItem     = self.hoveredItem
		self.selectedOffset   = util.Subtract(LevelHandler.WorldToHg(mousePos), self.selectedItem.GetPosition())
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

local function DoPropertyClick(mousePos, button, mouseMove)
	if (not mouseMove) and self.selectedProperty and self.selectedProperty.HandleMousePress and self.selectedProperty.HandleMousePress(mousePos, button) then
		return true
	end
	if (not mouseMove) and self.hoveredProperty and button == 1 then
		if self.selectedProperty then
			self.selectedProperty.SetSelected(false)
		end
		self.selectedProperty = self.hoveredProperty
		self.selectedProperty.SetSelected(true)
		return true
	elseif self.selectedProperty and button == 1 and mousePos[1] < Global.VIEW_WIDTH + Global.MAIN_PADDING then
		if self.selectedProperty.HandleWorldClick then
			self.selectedProperty.HandleWorldClick(LevelHandler.WorldToHg(mousePos), mouseMove, self.selectedOffset)
			return true
		end
	elseif self.selectedProperty and button == 2 then
		api.DeselectProperty()
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
	self.ignoreMouseMove = false
	local mousePos = self.world.GetMousePosition()
	if DoPropertyClick(mousePos, button) then
		return true
	end
	if DoEntityClick(mousePos, button) then
		return true
	end
end

function api.MouseMoved(x, y, button, dx, dy)
	if self.ignoreMouseMove then
		return
	end
	local mousePos = self.world.GetMousePosition()
	if DoPropertyClick(mousePos, button, true) then
		return true
	end
end

function api.KeyPressed(key, scancode, isRepeat)
	if DoPropertyKeyPress(key, scancode, isRepeat) then
		return true
	end
	
	if key == "l" and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")) then
		LoadLevel()
	end
	if key == "s" and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")) then
		SaveLevel()
	end
end

local function DrawEntityProperties(drawQueue, propList, mousePos)
	local offset, hovered = 0, false
	for i = 1, #propList do
		offset, hovered = propList[i].DrawProperty(drawQueue, Global.VIEW_WIDTH + 30, offset, mousePos)
		if hovered then
			self.hoveredProperty = hovered
		end
	end
end

function api.Draw(drawQueue)
	local mousePos = self.world.GetMousePosition()
	self.hoveredItem = false
	self.hoveredProperty = false
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
		DrawEntityProperties(drawQueue, self.selectedItem.GetPropertyList(), mousePos)
	else
		DrawEntityProperties(drawQueue, self.propList, mousePos)
	end
end

function api.UpdateLevelParams(level)
	self.levelName.Set(level.name)
	self.levelFile.Set(level.fileName)
	self.levelWidth.Set(level.width)
	self.levelHeight.Set(level.height)
	self.timeLength.Set(level.timeLength)
	self.timeSpeed.Set(level.timeSpeed)
end

local function SetupMenu()
	local function SetWidth(newVal)
		LevelHandler.SetWidth(newVal)
	end
	local function SetHeight(name)
		LevelHandler.SetHeight(newVal)
	end
	local function SetTimeLength(newVal)
		LevelHandler.SetLevelParameter("timeLength", newVal)
	end
	local function SetTimeSpeed(newVal)
		LevelHandler.SetLevelParameter("timeSpeed", newVal)
	end
	local function ToggleWall(pos, fromMouseMove, offset, size)
		if not fromMouseMove then
			self.wallAddMode = not LevelHandler.WallAt(pos)
		end
		size = (size or 0) * LevelHandler.GetTileSize()
		for x = pos[1] - size, pos[1] + size, LevelHandler.GetTileSize() do
			for y = pos[2] - size, pos[2] + size, LevelHandler.GetTileSize() do
				if self.wallAddMode then
					LevelHandler.AddWall({x, y})
				else
					LevelHandler.RemoveWall({x, y})
				end
			end
		end
	end
	local function DeleteEntity(pos)
		EntityHandler.RemoveEntitiesAtPos(pos)
	end
	local function AddDefaultEntity(name, data)
		data = data or {}
		data.pos = {LevelHandler.Width() * Global.HG_GRID_SIZE * 0.5, LevelHandler.Height() * Global.HG_GRID_SIZE * 0.5}
		EntityHandler.AddEntity(name, data)
	end

	self.levelName = NewProp.textBox(api, "Level Name", "")
	self.levelFile = NewProp.textBox(api, "Level File", "")
	self.saveButton = NewProp.clickButton(api, "Save (ctrl+S)", SaveLevel)
	self.loadButton = NewProp.clickButton(api, "Load (ctrl+L)", LoadLevel)
	self.levelPath = NewProp.heading(api, love.filesystem.getSaveDirectory() .. "/levels", 2)
	
	self.levelWidth  = NewProp.numberBox(api, "Level Width", LevelHandler.Width(), 1, false, 1, SetWidth)
	self.levelHeight = NewProp.numberBox(api, "Level Height",LevelHandler.Height(), 1, false, 1, SetHeight)
	self.timeLength  = NewProp.numberBox(api, "Time Length (s)", LevelHandler.GetTimeLength(), 60, false, Global.FRAMES_PER_SECOND, SetTimeLength)
	self.timeSpeed   = NewProp.numberBox(api, "Time Speed (s/s)", LevelHandler.GetTimeSpeed(), 1, false, 1, SetTimeSpeed)
	
	self.placeGridSize    = NewProp.numberBox(api, "Place Grid Snap", 800, 100, 3200, 100)
	self.toggleWallSmall  = NewProp.worldClickButton(api, "Wall Brush 1", ToggleWall, {0})
	self.toggleWallMedium = NewProp.worldClickButton(api, "Wall Brush 2", ToggleWall, {1})
	self.toggleWallLarge  = NewProp.worldClickButton(api, "Wall Brush 3", ToggleWall, {2})
	self.deleteEntity     = NewProp.worldClickButton(api, "Delete Entities", DeleteEntity)
	
	self.boxSelector = NewProp.enumBox(api, "", "", {"box", "bomb", "balloon", "light"}, AddDefaultEntity, "New Box")
	
	self.pickupSelector = NewProp.enumBox(api, "", "", Global.PICKUP_LIST,
		function (name) AddDefaultEntity("pickup", {pickupType = name}) end, "New Pickup")
	
	self.platformSelector = NewProp.enumBox(api, "", "", {"elevator", "platform", "door"},
		function (name) AddDefaultEntity("platform", platformUtilities.GetDefaultPlatform(name)) end, "New Platform")
	self.portalSelector = NewProp.enumBox(api, "", "", {"win", "zero", "reverse"},
		function (name) AddDefaultEntity("portal", portalUtilities.GetDefaultPortal(name)) end, "New Portal")
	
	self.buttonSelector = NewProp.enumBox(api, "", "", {"momentarySwitch", "stickySwitch"},
		function (name)
			local buttonType, buttonData = buttonUtilities.GetDefaultButton(name)
			AddDefaultEntity(buttonType, buttonData)
		end, "New Button")
	
	self.propList = {
		self.levelName,
		self.levelFile,
		self.saveButton,
		self.loadButton,
		self.levelPath,
		
		self.levelWidth,
		self.levelHeight,
		self.timeLength,
		self.timeSpeed,
		
		NewProp.heading(api, ""),
		self.placeGridSize,
		self.toggleWallSmall,
		self.toggleWallMedium,
		self.toggleWallLarge,
		self.deleteEntity,
		
		NewProp.heading(api, ""),
		self.boxSelector,
		self.pickupSelector,
		self.platformSelector,
		self.portalSelector,
		self.buttonSelector,
	}
end

function api.ResetState()
	if self.selectedProperty then
		self.selectedProperty.SetSelected(false)
		self.selectedProperty = false
	end
	self.selectedItem = false
end

function api.Initialize(world)
	self = {
		world = world,
	}
	SetupMenu()
end

return api
