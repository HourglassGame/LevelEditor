
SoundHandler = require("soundHandler")
MusicHandler = require("musicHandler")
EffectsHandler = require("effectsHandler")
EntityHandler = require("entityHandler")
ShopHandler = require("shopHandler")
LevelHandler = require("levelHandler")

Camera = require("utilities/cameraUtilities")
InterfaceUtil = require("utilities/interfaceUtilities")
Delay = require("utilities/delay")

local PriorityQueue = require("include/PriorityQueue")

local self = {}
local api = {}

function api.SetMenuState(newState)
	self.menuState = newState
end

function api.ToggleMusic()
	self.musicEnabled = not self.musicEnabled
	if not self.musicEnabled then
		MusicHandler.StopCurrentTrack()
	end
end

function api.GetPaused()
	return self.paused or self.menuState
end

function api.MusicEnabled()
	return self.musicEnabled
end

function api.GetGameOver()
	return self.gameWon or self.gameLost, self.gameWon, self.gameLost, self.overType
end

function api.Restart()
	--PhysicsHandler.Destroy()
	api.Initialize(self.levelIndex, self.levelTableOverride, self.musicEnabled)
end

function api.LoadLevelByTable(levelTable)
	api.Initialize(self.levelIndex, levelTable, self.musicEnabled)
end

function api.GetLifetime()
	return self.lifetime
end

function api.TakeScreenshot()
	love.filesystem.createDirectory("screenshots")
	print("working", love.filesystem.getWorkingDirectory())
	print("save", love.filesystem.getSaveDirectory())
	love.graphics.captureScreenshot("screenshots/screenshot_" .. math.floor(math.random()*100000) .. "_.png")
end

function api.SetGameOver(hasWon, overType)
	if self.gameWon or self.gameLost then
		return
	end
	
	if hasWon then
		self.gameWon = true
	else
		self.gameLost = true
		self.overType = overType
	end
end

function api.SetPaused(newPause, force)
	self.paused = newPause
	self.forcePaused = force
end

function api.KeyPressed(key, scancode, isRepeat)
	if LevelHandler.KeyPressed(key, scancode, isRepeat) then
		return
	end
	if key == "escape" or key == "return" or key == "kpenter" then
		self.paused = not self.paused
	end
	if key == "r" and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")) then
		api.Restart()
	end
	if key == "p" then
		self.paused = not self.paused
	end
	if key == "m" and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")) then
		api.ToggleMusic()
	end
	if key == "s" and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")) then
		api.TakeScreenshot()
	end
	if key == "n" and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")) then
		api.SwitchLevel(1)
	end
	if key == "p" and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")) then
		api.SwitchLevel(-1)
	end
	if api.GetGameOver() then
		return -- No doing actions
	end
end

function api.MousePressed(x, y, button)
	self.pressButton = button
	if api.GetPaused() then
		return
	end
	local uiX, uiY = self.interfaceTransform:inverse():transformPoint(x, y)
	
	if LevelHandler.MousePressed(x, y, button) then
		return
	end
	if ShopHandler.MousePressed(x, y, button) then
		return
	end
	if api.GetGameOver() then
		return -- No doing actions
	end
	x, y = self.cameraTransform:inverse():transformPoint(x, y)
	
	-- Send event to game components
	if Global.DEBUG_PRINT_CLICK_POS and button == 2 then
		print("{")
		print([[    name = "BLA",]])
		print("    pos = {" .. (math.floor(x/10)*10) .. ", " .. (math.floor(y/10)*10) .. "},")
		print("},")
		return true
	end
end

function api.MouseReleased(x, y, button)
	x, y = self.cameraTransform:inverse():transformPoint(x, y)
	self.pressButton = false
	-- Send event to game components
end

function api.MouseMoved(x, y, dx, dy)
	if ShopHandler.MouseMoved(x, y, self.pressButton, dx, dy) then
		return
	end
end

function api.WorldToScreen(pos)
	local x, y = self.cameraTransform:transformPoint(pos[1], pos[2])
	return {x, y}
end

function api.ScreenToWorld(pos)
	local x, y = self.cameraTransform:inverse():transformPoint(pos[1], pos[2])
	return {x, y}
end

function api.ScreenToInterface(pos)
	local x, y = self.interfaceTransform:inverse():transformPoint(pos[1], pos[2])
	return {x, y}
end

function api.GetMousePositionInterface()
	local x, y = love.mouse.getPosition()
	return api.ScreenToInterface({x, y})
end

function api.GetMousePosition()
	local x, y = love.mouse.getPosition()
	return api.ScreenToWorld({x, y})
end

function api.WorldScaleToScreenScale()
	local m11 = self.cameraTransform:getMatrix()
	return m11
end

function api.GetOrderMult()
	return self.orderMult
end

function api.GetCameraExtents(buffer)
	local screenWidth, screenHeight = love.window.getMode()
	local topLeftPos = api.ScreenToWorld({0, 0})
	local botRightPos = api.ScreenToWorld({screenWidth, screenHeight})
	buffer = buffer or 0
	return topLeftPos[1] - buffer, topLeftPos[2] - buffer, botRightPos[1] + buffer, botRightPos[2] + buffer
end

function api.GetPhysicsWorld()
	return PhysicsHandler.GetPhysicsWorld()
end

local function UpdateCamera()
	local cameraX, cameraY, cameraScale = Camera.UpdateCameraToViewPoints(dt, 
		{
			{pos = {0, 0}, radius = Global.MAIN_PADDING},
			{pos = {Global.VIEW_WIDTH + Global.SHOP_WIDTH, Global.VIEW_HEIGHT}, radius = Global.MAIN_PADDING}
		}, 0, 0)
	Camera.UpdateTransform(self.cameraTransform, cameraX, cameraY, cameraScale)
end

function api.Update(dt, realDt)
	MusicHandler.Update(realDt)
	SoundHandler.Update(realDt)
	if api.GetPaused() then
		UpdateCamera()
		return
	end
	
	self.lifetime = self.lifetime + dt
	Delay.Update(dt)
	InterfaceUtil.Update(dt)
	
	EffectsHandler.Update(dt)
	EntityHandler.Update(dt)
	ShopHandler.Update(dt)
	UpdateCamera()
end

function api.Draw()
	local preShadowQueue = PriorityQueue.new(function(l, r) return l.y < r.y end)
	local drawQueue = PriorityQueue.new(function(l, r) return l.y < r.y end)

	-- Draw world
	love.graphics.replaceTransform(self.cameraTransform)
	--ModuleTest.Draw(drawQueue)
	
	love.graphics.replaceTransform(self.cameraTransform)
	while true do
		local d = preShadowQueue:pop()
		if not d then break end
		d.f()
	end
	
	EffectsHandler.Draw(drawQueue)
	EntityHandler.Draw(drawQueue)
	ShopHandler.Draw(drawQueue)
	LevelHandler.Draw(drawQueue)
	
	if not Global.DEBUG_NO_SHADOW and not (Global.DEBUG_SPACE_ZOOM_OUT and love.keyboard.isDown("space")) then
		--ShadowHandler.DrawGroundShadow(self.cameraTransform)
	end
	love.graphics.replaceTransform(self.cameraTransform)
	while true do
		local d = drawQueue:pop()
		if not d then break end
		d.f()
	end
	if not Global.DEBUG_NO_SHADOW and not (Global.DEBUG_SPACE_ZOOM_OUT and love.keyboard.isDown("space")) then
		--ShadowHandler.DrawVisionShadow(self.cameraTransform)
	end
	
	--local windowX, windowY = love.window.getMode()
	--if windowX/windowY > 16/9 then
	--	self.interfaceTransform:setTransformation(0, 0, 0, windowY/1080, windowY/1080, 0, 0)
	--else
	--	self.interfaceTransform:setTransformation(0, 0, 0, windowX/1920, windowX/1920, 0, 0)
	--end
	love.graphics.replaceTransform(self.emptyTransform)
	
	-- Draw interface
	LevelHandler.DrawInterface()
	EffectsHandler.DrawInterface()
	
	love.graphics.replaceTransform(self.emptyTransform)
end

function api.ViewResize(width, height)
	--ShadowHandler.ViewResize(width, height)
end

function api.Initialize(levelIndex, levelTableOverride, musicEnabled)
	self = {}
	self.cameraTransform = love.math.newTransform()
	self.interfaceTransform = love.math.newTransform()
	self.emptyTransform = love.math.newTransform()
	self.paused = false
	self.musicEnabled = false
	self.lifetime = Global.DEBUG_START_LIFETIME or 0
	self.levelIndex = levelIndex or Global.INIT_LEVEL
	self.levelTableOverride = levelTableOverride
	
	Delay.Initialise()
	InterfaceUtil.Initialize()
	EffectsHandler.Initialize(api)
	SoundHandler.Initialize()
	MusicHandler.Initialize(api)
	
	EntityHandler.Initialize(api)
	ShopHandler.Initialize(api)
	LevelHandler.Initialize(api, self.levelIndex, self.levelTableOverride)
	
	-- Note that the camera pins only function for these particular second entries.
	Camera.Initialize({
		minScale = 1000,
		initPos = {0, 0},
	})
end

return api
