
local function TimeDirection(parent, dir, imageF, imageR)
	local self = {
		dir =  NewProp.enumBox(api, 'Time Direction', dir, {"forwards", "reverse"}),
		imageF = imageF,
		imageR = imageR,
	}
	
	local api = {}
	
	function api.DrawProperty(drawQueue, drawX, drawY, mousePos)
		return self.dir.DrawProperty(drawQueue, drawX, drawY, mousePos)
	end
	
	function api.GetImage()
		if dir == "forwards" then
			return imageF
		elseif dir == "reverse" then
			return imageR
		end
	end
	
	return api
end

return TimeDirection
