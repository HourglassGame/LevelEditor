
local util = require("include/util")

local function PosSize(parent, pos, width, height, extras)
	local api = {}
	local self = {
		propX = NewProp.numberBox(api, 'X', pos[1]),
		propY = NewProp.numberBox(api, 'Y', pos[2]),
		worldClickToggle = NewProp.worldClickButton(api, 'Click Move')
	}
	
	self.propList = {}
	if extras and extras.name then
		self.propList[#self.propList + 1] = NewProp.heading(api, extras.name)
	end
	
	self.propList[#self.propList + 1] = self.worldClickToggle
	self.propList[#self.propList + 1] = self.propX
	self.propList[#self.propList + 1] = self.propY
	
	if width then
		self.propW = NewProp.numberBox(api, 'Width', width, Global.MIN_DIMENSION)
		self.propList[#self.propList + 1] = self.propW
	end
	if height then
		self.propH = NewProp.numberBox(api, 'Height', height, Global.MIN_DIMENSION)
		self.propList[#self.propList + 1] = self.propH
	end
	
	if extras and extras.speed then
		self.xSpeed = NewProp.numberBox(api, 'X Speed', (type(extras.speed) == "table" and extras.speed[1]) or 0, 0, false, 1)
		self.ySpeed = NewProp.numberBox(api, 'Y Speed', (type(extras.speed) == "table" and extras.speed[2]) or 0, 0, false, 1)
		self.propList[#self.propList + 1] = self.xSpeed
		if not extras.accel then
			self.propList[#self.propList + 1] = self.ySpeed
		end
	end
	if extras and extras.accel then
		self.xAccel = NewProp.numberBox(api, 'X Accel', (type(extras.accel) == "table" and extras.accel[1]) or 0, 0, false, 1)
		self.xDecel = NewProp.numberBox(api, 'X Decel', (extras.decel and type(extras.decel) == "table" and extras.decel[1]) or 0, 0, false, 1)
		self.yAccel = NewProp.numberBox(api, 'Y Accel', (type(extras.accel) == "table" and extras.accel[2]) or 0, 0, false, 1)
		self.yDecel = NewProp.numberBox(api, 'Y Decel', (extras.decel and type(extras.decel) == "table" and extras.decel[2]) or 0, 0, false, 1)
		
		self.propList[#self.propList + 1] = self.xAccel
		self.propList[#self.propList + 1] = self.xDecel
		if extras.speed then
			self.propList[#self.propList + 1] = self.ySpeed
		end
		self.propList[#self.propList + 1] = self.yAccel
		self.propList[#self.propList + 1] = self.yDecel
	end
	
	if extras and extras.readSizeFrom then
		self.readSizeFrom = extras.readSizeFrom
	end
	if extras and extras.minimiseTo then
		self.minimiseTo = extras.minimiseTo
	end
	
	local function GetWorldDimensions()
		local sizeSource = (self.readSizeFrom or api)
		local x, y = LevelHandler.HgToWorld(self.propX.Get()), LevelHandler.HgToWorld(self.propY.Get())
		local w, h = LevelHandler.HgToWorld(sizeSource.GetWidth()), LevelHandler.HgToWorld(sizeSource.GetHeight())
		return x, y, w, h
	end
	
	function api.GetWorldClickProp()
		return self.worldClickToggle
	end
	
	function api.SetSize(newWidth, newHeight)
		self.propW.Set(newWidth)
		self.propH.Set(newHeight)
	end
	
	function api.GetWidth()
		return self.propW.Get()
	end
	
	function api.GetHeight()
		return self.propH.Get()
	end
	
	function api.HandleWorldClick(pos, fromMouseMove)
		local sizeSource = (self.readSizeFrom or api)
		pos = ShopHandler.SnapToGrid(pos, sizeSource.GetWidth()*0.5, sizeSource.GetHeight()*0.5)
		self.propX.Set(pos[1] - sizeSource.GetWidth()*0.5)
		self.propY.Set(pos[2] - sizeSource.GetHeight()*0.5)
	end
	
	function api.HitTest(pos)
		local sizeSource = (self.readSizeFrom or api)
		return util.PosInRectangle(pos, self.propX.Get(), self.propY.Get(), sizeSource.GetWidth(), sizeSource.GetHeight())
	end
	
	function api.GetSelected()
		for i = 1, #self.propList do
			if self.propList[i].GetSelected() then
				return true
			end
		end
		return false
	end
	
	function api.DrawProperty(drawQueue, drawX, drawY, mousePos)
		local hovered, thisHovered = false
		local drawCount = (((not self.minimiseTo) or api.GetSelected()) and #self.propList) or self.minimiseTo
		for i = 1, drawCount do
			drawY, thisHovered = self.propList[i].DrawProperty(drawQueue, drawX, drawY, mousePos)
			if thisHovered then
				hovered = thisHovered
			end
		end
		return drawY, hovered
	end
	
	function api.DrawOutline()
		local x, y, w, h = GetWorldDimensions()
		love.graphics.setLineWidth(8)
		love.graphics.rectangle("line", x - 8, y - 8, w + 16, h + 16, 8, 8, 12)
	end
	
	function api.DrawRectangle()
		local x, y, w, h = GetWorldDimensions()
		love.graphics.setLineWidth(0)
		love.graphics.rectangle("fill", x, y, w, h, 0, 0, 12)
	end
	
	function api.Draw(image)
		local x, y, w, h = GetWorldDimensions()
		Resources.DrawImage(image, x, y, 0, 0.8, {w, h})
	end
	
	return api
end

return PosSize
