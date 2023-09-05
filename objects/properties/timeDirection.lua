
local function TimeDirection(parent, dir, imageF, imageR)
	local self = {
		dir = NewProp.enumBox(api, "Time Direction", dir, {"forwards", "reverse"}),
		imageF = imageF,
		imageR = imageR,
	}
	
	local api = {}
	
	function api.Set(newValue)
		self.dir.Set(newValue)
	end
	
	function api.Get()
		return self.dir.Get()
	end
	
	function api.DrawProperty(drawQueue, drawX, drawY, mousePos)
		return self.dir.DrawProperty(drawQueue, drawX, drawY, mousePos)
	end
	
	function api.GetSelected()
		return self.dir.GetSelected()
	end
	
	function api.GetImage()
		if self.dir.Get() == "forwards" then
			return imageF
		elseif self.dir.Get() == "reverse" then
			return imageR
		end
	end
	
	return api
end

return TimeDirection
