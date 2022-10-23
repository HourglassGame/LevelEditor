
local function TimeDirection(dir, imageF, imageR)
	local self = {
		dir = dir,
		imageF = imageF,
		imageR = imageR,
	}
	
	local api = {}
	
	function api.DrawProperty(drawX, drawY)
	
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
