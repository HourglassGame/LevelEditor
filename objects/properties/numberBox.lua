
local util = require("include/util")
local Font = require("include/font")

local function NumberBox(parent, name, value, minValue)
	local self = {
		name = name,
		value = value / Global.HG_GRID_SIZE,
	}
	self.valueStr = tostring(self.value)
	
	local api = {}
	
	function api.Set(newValue)
		if minValue and newValue < minValue then
			newValue = minValue
		end
		self.value = newValue / Global.HG_GRID_SIZE
		self.valueStr = tostring(self.value)
	end
	
	function api.Get(newValue)
		return self.value * Global.HG_GRID_SIZE
	end
	
	local function UpdateValueFromStr()
		local newVal = tonumber(self.valueStr)
		if newVal and ((not minValue) or newVal >= (minValue / Global.HG_GRID_SIZE)) then
			self.value = newVal
		end
	end
	
	function api.HandleKeyPress(key)
		print(key)
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
	
	function api.DrawProperty(drawX, drawY, mousePos)
		Font.SetSize(1)
		if self.selected then
			love.graphics.setColor(1, 1, 1, 0.8)
		else
			love.graphics.setColor(0, 0, 0, 0.8)
		end
		love.graphics.printf(name, drawX, drawY, Global.SHOP_WIDTH * 0.5 - 10, "right")
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
