
local function WorldClickButton(name, parent)
	local self = {
		name = name,
		parent = parent,
	}
	
	local api = {
		wantWorldClick = true,
	}
	
	function api.HandleWorldClick(pos)
		self.parent.HandleWorldClick(pos)
	end
	
	function api.DrawProperty(drawX, drawY)
	
	end
	
	return api
end

return WorldClickButton
