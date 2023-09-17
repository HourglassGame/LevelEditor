
local util = require("include/util")
local Font = require("include/font")

local function TextBox(parent, name, value, applyFunc)
	local self = {
		name = name,
		value = value,
	}
	self.editedValue = tostring(self.value)
	
	local api = {}
	
	function api.Set(newValue)
		self.value = newValue
		self.editedValue = tostring(self.value)
		if applyFunc then
			applyFunc(self.value)
		end
	end
	
	function api.Get()
		return self.value
	end
	
	function api.HandleKeyPress(key)
		if key == "lshift" or key == "rshift" or key == "lctrl" or key == "rctrl" or key == "lalt" or key == "ralt" then
			return
		end
		if key == "backspace" or key == "delete" then
			if string.len(self.editedValue) > 0 then
				self.editedValue = string.sub(self.editedValue, 0, string.len(self.editedValue) - 1)
			end
			return
		elseif key == "return" or key == "kpenter" then
			ShopHandler.DeselectProperty()
			return
		end
		key = string.gsub(key, "kp", "")
		if (love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift")) then
			key = string.upper(key)
		end
		self.editedValue = self.editedValue .. key
	end
	
	function api.SetSelected(newState)
		self.selected = newState
		if not self.selected then
			api.Set(self.editedValue)
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
		love.graphics.printf(self.editedValue, drawX + Global.SHOP_WIDTH * 0.5 + 10, drawY, Global.SHOP_WIDTH, "left")
		
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

return TextBox
