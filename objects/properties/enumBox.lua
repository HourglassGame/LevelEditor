
local util = require("include/util")
local Font = require("include/font")

local function EnumBox(parent, name, value, options, applyFunc, textOverride)
	local self = {
		name = name,
		value = value,
		options = options,
		textOverride = textOverride
	}
	
	local api = {}
	
	function api.Set(newValue)
		self.value = newValue
	end
	
	function api.Get()
		return self.value
	end
	
	function api.HandleMousePress(pos, button)
		if button ~= 1 then
			ShopHandler.DeselectProperty()
			return true
		end
		
		if self.hoverItem then
			self.value = self.options[self.hoverItem]
			if applyFunc then
				applyFunc(self.value)
			end
			ShopHandler.DeselectProperty()
			return true
		end
	end
	
	function api.SetSelected(newState)
		self.selected = newState
	end
	
	function api.DrawProperty(drawQueue, drawX, drawY, mousePos)
		Font.SetSize(1)
		if self.selected then
			love.graphics.setColor(1, 1, 1, 0.8)
		else
			love.graphics.setColor(0, 0, 0, 0.8)
		end
		love.graphics.printf(self.name, drawX, drawY, Global.SHOP_WIDTH * 0.5 - 10, "right")
		love.graphics.printf(self.textOverride or self.value, drawX + Global.SHOP_WIDTH * 0.5 + 10, drawY, Global.SHOP_WIDTH, "left")
		
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
		
		if self.selected then
			self.hoverItem = false
			for i = 1, #self.options do
				drawY = drawY + Global.PROP_SPACING
				x, y, w, h = drawX + Global.SHOP_WIDTH * 0.5, drawY + 4, Global.SHOP_WIDTH * 0.5, Global.PROP_SPACING - 8
				local hoveredItem = util.PosInRectangle(mousePos, x, y, w, h)
				if hoveredItem then
					love.graphics.setColor(1, 1, 1, 0.8)
					self.hoverItem = i
				else
					love.graphics.setColor(0.8, 0.8, 0.8, 0.8)
				end
				love.graphics.printf(self.options[i], drawX + Global.SHOP_WIDTH * 0.5 + 10, drawY, Global.SHOP_WIDTH, "left")
				love.graphics.rectangle("line", x, y, w, h)
			end
		end
		drawY = drawY + Global.PROP_SPACING
		return drawY, hovered and api
	end
	
	return api
end

return EnumBox
