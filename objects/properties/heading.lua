
local util = require("include/util")
local Font = require("include/font")

local function Spacer(parent, name)
	local self = {
		name = name,
	}
	
	local api = {}
	
	function api.DrawProperty(drawQueue, drawX, drawY, mousePos)
		if self.name ~= "" then
			drawY = drawY + Global.PROP_SPACING
			Font.SetSize(1)
			love.graphics.setColor(0, 0, 0, 0.8)
			love.graphics.printf(self.name, drawX + Global.SHOP_WIDTH * 0.5 + 10, drawY, Global.SHOP_WIDTH, "left")
		end
		drawY = drawY + Global.PROP_SPACING
		return drawY
	end
	
	return api
end

return Spacer
