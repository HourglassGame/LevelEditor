
local util = require("include/util")
local Font = require("include/font")

local function Heading(parent, name, subheading)
	local self = {
		name = name or "",
		subheading = subheading,
	}
	
	local api = {}
	
	function api.DrawProperty(drawQueue, drawX, drawY, mousePos)
		if self.name ~= "" then
			if subheading then
				Font.SetSize(1)
				love.graphics.setColor(0, 0, 0, 0.8)
				love.graphics.printf(self.name, drawX, drawY, Global.SHOP_WIDTH, "left")
				drawY = drawY + Global.PROP_SPACING * subheading
			else
				drawY = drawY + Global.PROP_SPACING
				Font.SetSize(1)
				love.graphics.setColor(0, 0, 0, 0.8)
				love.graphics.printf(self.name, drawX + Global.SHOP_WIDTH * 0.5 + 10, drawY, Global.SHOP_WIDTH, "left")
			end
		end
		drawY = drawY + Global.PROP_SPACING
		return drawY
	end
	
	function api.GetSelected()
		return false
	end
	
	return api
end

return Heading
