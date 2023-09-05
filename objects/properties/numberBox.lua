
local util = require("include/util")
local Font = require("include/font")

local function NumberBox(parent, name, value, minValue, divisor, applyFunc)
	local self = {
		name = name,
		divisor = (divisor or Global.HG_GRID_SIZE),
		value = (value or 0) / (divisor or Global.HG_GRID_SIZE),
		minValue = minValue and minValue / (divisor or Global.HG_GRID_SIZE),
	}
	self.valueStr = tostring(self.value)
	
	local api = {}
	
	function api.Set(newValue)
		newValue = newValue / self.divisor
		if self.minValue and newValue < self.minValue then
			newValue = self.minValue
		end
		self.value = newValue
		self.valueStr = tostring(self.value)
		if applyFunc then
			applyFunc(self.value)
		end
	end
	
	function api.Get()
		return self.value * self.divisor
	end
	
	local function UpdateValueFromStr()
		local newVal = tonumber(self.valueStr)
		if newVal and ((not self.minValue) or newVal >= self.minValue) then
			self.value = newVal
			if applyFunc then
				applyFunc(self.value)
			end
		end
	end
	
	function api.HandleKeyPress(key)
		if key == "backspace" or key == "delete" then
			if string.len(self.valueStr) > 0 then
				self.valueStr = string.sub(self.valueStr, 0, string.len(self.valueStr) - 1)
				UpdateValueFromStr()
			end
			return
		elseif key == "return" or key == "kpenter" then
			ShopHandler.DeselectProperty()
			return
		end
		key = string.gsub(key, "kp", "")
		self.valueStr = self.valueStr .. key
		UpdateValueFromStr()
	end
	
	function api.SetSelected(newState)
		self.selected = newState
		if not self.selected then
			self.valueStr = tostring(self.value)
		end
	end
	
	function api.GetSelected()
		return self.selected
	end
	
	function api.DrawProperty(drawQueue, drawX, drawY, mousePos)
		Font.SetSize(1)
		if self.selected then
			love.graphics.setColor(1, 1, 1, 0.8)
		else
			love.graphics.setColor(0, 0, 0, 0.8)
		end
		love.graphics.printf(self.name, drawX, drawY, Global.SHOP_WIDTH * 0.5 - 10, "right")
		love.graphics.printf(self.valueStr, drawX + Global.SHOP_WIDTH * 0.5 + 10, drawY, Global.SHOP_WIDTH, "left")
		
		local x, y, w, h = drawX + Global.SHOP_WIDTH * 0.5, drawY + 4, Global.SHOP_WIDTH * 0.5, Global.PROP_SPACING - 8
		local hovered = util.PosInRectangle(mousePos, x, y, w, h)
		love.graphics.setLineWidth(2)
		if self.selected then
			love.graphics.setColor(1, 1, 1, 0.8)
		elseif hovered then
			love.graphics.setColor(0.9, 0.9, 0.9, 0.8)
		else
			love.graphics.setColor(0, 0, 0, 0.8)
		end
		love.graphics.rectangle("line", x, y, w, h)
		drawY = drawY + Global.PROP_SPACING
		return drawY, hovered and api
	end
	
	return api
end

return NumberBox
