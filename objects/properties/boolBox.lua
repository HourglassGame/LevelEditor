
local function BoolBox(parent, name, default)
	local self = {
		value = NewProp.enumBox(api, name, (default and "true") or "false", {"true", "false"}),
	}
	
	local api = {}
	
	function api.Set(newValue)
		self.dir.Set((default and "true") or "false")
	end
	
	function api.Get()
		return (self.dir.Get() == "true")
	end
	
	function api.GetSelected()
		return value.GetSelected()
	end
	
	function api.DrawProperty(drawQueue, drawX, drawY, mousePos)
		return self.value.DrawProperty(drawQueue, drawX, drawY, mousePos)
	end
	
	return api
end

return BoolBox
