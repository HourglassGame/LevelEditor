
local IterableMap = require("include/IterableMap")
local util = require("include/util")
local Font = require("include/font")

local MapDefs = util.LoadDefDirectory("defs/maps")

local self = {}
local api = {}

local function CalculateDrawScale()
	local widthFactor = Global.VIEW_WIDTH / (self.level.width * self.level.segmentSize)
	local heightFactor = Global.VIEW_HEIGHT / (self.level.height * self.level.segmentSize)
	self.drawScale = math.min(widthFactor, heightFactor)
end

function api.GetDrawScale()
	return self.drawScale
end

function api.HgToWorld(var)
	-- Transforms from HG scale, ie level scale, to the Love world scale. Use this
	-- for drawing and UI transforms.
	local scale = (self.level.segmentSize * self.drawScale) / Global.HG_GRID_SIZE
	if type(var) == "table" then
		return util.Mult(scale, var)
	end
	return var * scale
end

function api.WorldToHg(var)
	local scale = Global.HG_GRID_SIZE / (self.level.segmentSize * self.drawScale)
	if type(var) == "table" then
		return util.Mult(scale, var)
	end
	return var * scale
end

local function InitialiseNewLevel()
	self.level.wall = {}
	self.level.width = 32
	self.level.height = 19
	self.level.segmentSize = 3200
	self.level.timeLength = 10800
	self.level.timeSpeed = 24
	
	EntityHandler.AddEntity("guy", {pos = {self.level.width * Global.HG_GRID_SIZE * 0.5, self.level.height * Global.HG_GRID_SIZE * 0.5}})
	
	CalculateDrawScale()
	ShopHandler.UpdateLevelParams(self.level)
end

local function SetupWorld(levelData)
	self.level = {}
	ShopHandler.ResetState()
	EntityHandler.DeleteAll()
	
	if not levelData then
		InitialiseNewLevel()
		return
	end
	
	-- Setup wall
	local dataWall = levelData.environment.wall
	local grid = {}
	for i = 1, #dataWall do
		for j = 1, #dataWall[i] do
			grid[j - 1] = grid[j - 1] or {}
			grid[j - 1][i - 1] = dataWall[i][j]
		end
	end
	self.level.wall = grid
	self.level.width = dataWall.width
	self.level.height = dataWall.height
	self.level.segmentSize = dataWall.segmentSize
	
	-- Setup timeline
	self.level.timeLength = levelData.timelineLength
	self.level.timeSpeed = levelData.speedOfTime
	CalculateDrawScale()
	ShopHandler.UpdateLevelParams(self.level)
	
	-- Setup guy
	local guyParams = levelData.initialGuy.arrival
	guyParams.arrivalTime = levelData.initialGuy.arrivalTime
	guyParams.pos = {guyParams.x, guyParams.y}
	EntityHandler.AddEntity("guy", guyParams)
	
	-- Setup boxes
	if levelData.initialArrivals then
		for i = 1, # levelData.initialArrivals do
			local box = levelData.initialArrivals[i]
			EntityHandler.AddEntity(box.boxType or "box", {
				pos = {box.x, box.y},
				width = box.width or box.size,
				height = box.height or box.size,
				timeDirection = box.timeDirection,
				xspeed = box.xspeed,
				yspeed = box.yspeed,
			})
		end
	end
	
	-- Setup triggers 
	--IndexNameHandler.LoadTriggers()
	EntityHandler.LoadLevelItems(levelData.triggerSystem, levelData.items)
end

local function SafeLoadString(str)
	if not str then
		EffectsHandler.SpawnEffect("error_popup", {480, 15}, {text = "Level file not found.", velocity = {0, 4}})
		return false
	end
	local strFunc = loadstring(str)
	--print(str)
	if not strFunc then
		EffectsHandler.SpawnEffect("error_popup", {480, 15}, {text = "Error loading level.", velocity = {0, 4}})
		return false
	end
	local success, strData = pcall(strFunc)
	if not success then
		EffectsHandler.SpawnEffect("error_popup", {480, 15}, {text = "Level format error.", velocity = {0, 4}})
		return false
	end
	return strData
end

function api.Width()
	return self.level and self.level.width
end

function api.Height()
	return self.level and self.level.height
end

function api.GetTimeLength()
	return self.level and self.level.timelineLength
end

function api.GetTimeSpeed()
	return self.level and self.level.timeSpeed
end

function api.SetWidth(newVal)
	if not (newVal and self.level and self.level.height) then
		return
	end
	self.level.width = newVal
	CalculateDrawScale()
end

function api.SetHeight(newVal)
	if not (newVal and self.level and self.level.height) then
		return
	end
	self.level.height = newVal
	CalculateDrawScale()
end

function api.SetLevelParameter(name, newVal)
	if not (newVal and self.level) then
		return
	end
	self.level[name] = newVal
end

function api.GetTileSize()
	return self.level.segmentSize
end

function api.GetVertOffset()
	return self.vertOffset
end

function api.GetBaseCarts()
	return self.baseCarriages
end

function api.GetLevelHumanName()
	return self.humanName
end

function api.IsFinalMap()
	return self.finalLevel
end

function api.TownDrawParams()
	return self.townDrawParams
end

function api.GetOrderMult()
	return self.world.GetOrderMult()
end

function api.GetMapData()
	return self.map
end

function api.LoadLevel(name)
	print("Load level main.lua")
	local levelStr = "return function()\n"
	for line in love.filesystem.lines("levels/" .. name .. ".lvl/main.lua") do
		local first = string.sub(line, 0, 1)
		if first ~= "{" and first ~= "}" and first ~= [[	]] and first ~= " " and string.len(first) > 0 then
			line = "local " .. line
		end
		levelStr = levelStr .. line .. "\n"
	end
	levelStr = levelStr .. [[return {
		name = name,
		speedOfTime = speedOfTime,
		speedOfTimeFuture = speedOfTimeFuture,
		timelineLength = timelineLength,
		environment = environment,
		initialGuy = initialGuy,
		initialArrivals = initialArrivals,
		triggerSystem = triggerSystem,
	}
end
]]
	local levelData = SafeLoadString(levelStr)
	if not levelData then
		return
	end
	levelData = levelData()
	
	print("Load level triggerSystem.lua")
	local trigStr = "return "
	local writeActive = false
	for line in love.filesystem.lines("levels/" .. name .. ".lvl/triggerSystem.lua") do
		if string.find(line, "local tempStore =") then
			writeActive = true
		elseif writeActive then
			local first = string.sub(line, 0, 1)
			if first == "}" then
				trigStr = trigStr .. line .. "\n"
				writeActive = false
				break
			elseif string.find(line, "bts.") then
				local pos = string.find(line, "bts.")
				local btsType = string.sub(line, pos + 4, string.len(line) - 1)
				trigStr = trigStr .. "{\n"
				trigStr = trigStr .. "btsType = \"" .. btsType .. "\",\n"
			else
				trigStr = trigStr .. line .. "\n"
			end
		end
	end
	
	levelData.items = SafeLoadString(trigStr)
	if not levelData.items then
		return
	end
	
	SetupWorld(levelData)
	return true
end

function api.SaveLevel(name)
	name = name .. "_test"
	love.filesystem.createDirectory("levels/" .. name .. ".lvl")
	love.filesystem.write("levels/" ..name .. ".lvl/triggerSystem.lua", "bla")
	
	return true
end

function api.HgToGrid(pos)
	return self.level and {math.floor(pos[1] / self.level.segmentSize), math.floor(pos[2] / self.level.segmentSize)}
end

function api.WallAtGrid(pos)
	if not (self.level and pos) then
		return true
	end
	if not self.level.wall[pos[1]] then
		return true
	end
	return self.level.wall[pos[1]][pos[2]] ~= 0
end

function api.WallAt(pos)
	return api.WallAtGrid(api.HgToGrid(pos))
end

function api.AddWall(pos)
	pos = api.HgToGrid(pos)
	self.level.wall[pos[1]] = self.level.wall[pos[1]] or {}
	self.level.wall[pos[1]][pos[2]] = 1
end

function api.RemoveWall(pos)
	pos = api.HgToGrid(pos)
	self.level.wall[pos[1]] = self.level.wall[pos[1]] or {}
	self.level.wall[pos[1]][pos[2]] = 0
end

function api.IsMenuOpen()
	return self.loadingLevelGetName or self.saveLevelGetName
end

function api.MousePressed()
	if self.loadingLevelGetName or self.saveLevelGetName then
		return true
	end
end

function api.TownWantPopup(pos)

end

function api.KeyPressed(key, scancode, isRepeat)
	self.enteredText = self.enteredText or Global.DEFAULT_LEVEL
	
	if self.loadingLevelGetName or self.saveLevelGetName then
		if key and string.len(key) == 1 then
			if (love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift")) then
				key = string.upper(key)
			end
			self.enteredText = (self.enteredText or "") .. key
		end
		if key == "meta" or key == "space" then
			self.enteredText = (self.enteredText or "") .. " "
		end
		if (key == "delete" or key == "backspace") and self.enteredText and string.len(self.enteredText) > 0 then
			self.enteredText = string.sub(self.enteredText, 0, string.len(self.enteredText) - 1)
		end
		if key == "escape" then
			self.loadingLevelGetName = false
			self.saveLevelGetName = false
		end
		if key == "return" and self.enteredText then
			if self.loadingLevelGetName then
				if api.LoadLevel(self.enteredText) then
					self.loadingLevelGetName = false
				end
			elseif self.saveLevelGetName then
				if api.SaveLevel(self.enteredText) then
					self.saveLevelGetName = false
				end
			end
		end
		return true
	end
	
	if self.townWantConf then
		
		return true
	end
	
	if key == "l" and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")) then
		self.loadingLevelGetName = true
	end
	if key == "k" and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")) then
		self.saveLevelGetName = true
	end
	if key == "j" and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")) then
		self.editMode = not self.editMode
	end
	
	local level = self.level
	if not level then
		return
	end
end

function api.Draw(drawQueue)
	if not self.level then
		return
	end
	drawQueue:push({y=-100; f=function()
		local scale = self.drawScale * self.level.segmentSize
		for x = 0, self.level.width - 1 do
			for y = 0, self.level.height- 1 do
				love.graphics.setLineWidth(5)
				if api.WallAtGrid({x, y}) then
					love.graphics.setColor(0.4, 0.4, 0.4, 0.3)
					love.graphics.rectangle("fill", x*scale, y*scale, scale, scale, 4, 4, 8)
				end
				love.graphics.setColor(0.2, 0.2, 0.2, 0.3)
				love.graphics.rectangle("line", x*scale, y*scale, scale, scale, 4, 4, 8)
			end
		end
	end})
end

function api.DrawInterface()
	local gameOver, gameWon, gameLost = self.world.GetGameOver()
	local windowX, windowY = love.window.getMode()
	local overX = windowX*0.25
	local overWidth = windowX*0.5
	local overY = windowY*0.25
	local overHeight = windowY*0.5
	
	local drawWindow = self.loadingLevelGetName or self.saveLevelGetName or self.townWantConf
	if drawWindow then
		love.graphics.setColor(Global.PANEL_COL[1], Global.PANEL_COL[2], Global.PANEL_COL[3], 0.97)
		love.graphics.setLineWidth(4)
		love.graphics.rectangle("fill", overX, overY, overWidth, overHeight, 8, 8, 16)
		love.graphics.setColor(0, 0, 0, 0.8)
		love.graphics.setLineWidth(10)
		love.graphics.rectangle("line", overX, overY, overWidth, overHeight, 8, 8, 16)
		
	end
	
	if self.townWantConf then
		
	elseif self.loadingLevelGetName then
		Font.SetSize(0)
		love.graphics.setColor(0, 0, 0, 0.8)
		love.graphics.printf("Loading Level", overX, overY + overHeight * 0.04, overWidth, "center")
		
		Font.SetSize(3)
		love.graphics.printf("Type level name (Enter accept, ESC cancel)\n" .. (self.enteredText or ""), overX + overWidth*0.05, overY + overHeight * 0.32 , overWidth*0.9, "center")
		
		Font.SetSize(3)
		love.graphics.printf("Loading from " .. (love.filesystem.getSaveDirectory() or "DIR_ERROR"), overX + overWidth*0.05, overY + overHeight * 0.65, overWidth*0.9, "center")

	elseif self.saveLevelGetName then
		Font.SetSize(0)
		love.graphics.setColor(0, 0, 0, 0.8)
		love.graphics.printf("Saving Level", overX, overY + overHeight * 0.04, overWidth, "center")
		
		Font.SetSize(3)
		love.graphics.printf("Type level name (Enter accept, ESC cancel)\n" .. (self.enteredText or ""), overX + overWidth*0.05, overY + overHeight * 0.32 , overWidth*0.9, "center")
		
		Font.SetSize(3)
		love.graphics.printf("Saving to " .. (love.filesystem.getSaveDirectory() or "DIR_ERROR") .. "/levels", overX + overWidth*0.05, overY + overHeight * 0.65, overWidth*0.9, "center")
	end
	return drawWindow
end

function api.Initialize(world, levelIndex, mapDataOverride)
	self = {
		world = world,
	}
	
	SetupWorld()
end

return api
