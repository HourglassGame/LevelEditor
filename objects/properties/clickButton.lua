
local util = require("include/util")
local Font = require("include/font")

local function ClickButton(parent, name, applyFunc)
	local self = {
		name = name,
		applyFunc = applyFunc
	}
	
	local api = {}
	
	function api.SetSelected(newState)
		if newState then
			applyFunc(self)
			ShopHandler.DeselectProperty()
		end
	end
	
	function api.DrawProperty(drawQueue, drawX, drawY, mousePos)
		Font.SetSize(1)
		love.graphics.setColor(0, 0, 0, 0.8)
		love.graphics.printf(self.name or self.value, drawX + Global.SHOP_WIDTH * 0.5 + 10, drawY, Global.SHOP_WIDTH, "left")
		
		local x, y, w, h = drawX + Global.SHOP_WIDTH * 0.5, drawY + 4, Global.SHOP_WIDTH * 0.5, Global.PROP_SPACING - 8
		local hovered = util.PosInRectangle(mousePos, x, y, w, h)
		love.graphics.setLineWidth(2)
		if hovered then
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

return ClickButton
