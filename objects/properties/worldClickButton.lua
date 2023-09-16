
local util = require("include/util")
local Font = require("include/font")

local function WorldClickButton(parent, name, applyFunc, extraArgs)
	local self = {
		name = name,
	}
	
	local api = {
	}
	
	function api.HandleWorldClick(pos, fromMouseMove, selectedOffset)
		if applyFunc then
			if extraArgs then
				applyFunc(pos, fromMouseMove, selectedOffset, unpack(extraArgs))
			else
				applyFunc(pos, fromMouseMove, selectedOffset)
			end
			return
		end
		parent.HandleWorldClick(pos, fromMouseMove, selectedOffset)
	end
	
	function api.SetSelected(newState)
		self.selected = newState
	end
	
	function api.GetSelected()
		return self.selected
	end
	
	function api.DrawProperty(drawQueue, drawX, drawY, mousePos)
		Font.SetSize(1)
		if self.selected then
			love.graphics.setColor(1, 1, 1, 0.8)
			love.graphics.printf("Enabled", drawX + Global.SHOP_WIDTH * 0.5 + 10, drawY, Global.SHOP_WIDTH, "left")
		else
			love.graphics.setColor(0, 0, 0, 0.8)
			love.graphics.printf("Disabled", drawX + Global.SHOP_WIDTH * 0.5 + 10, drawY, Global.SHOP_WIDTH, "left")
		end
		love.graphics.printf(self.name, drawX, drawY, Global.SHOP_WIDTH * 0.5 - 10, "right")
		
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

return WorldClickButton
