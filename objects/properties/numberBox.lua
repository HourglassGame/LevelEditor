
local function NumberBox(name, value, minValue)
	local self = {
		name = name,
		value = value,
	}
	
	local api = {}
	
	function api.Set(newValue)
		if minValue and newValue < minValue then
			newValue = minValue
		end
		value = newValue
	end
	
	function api.Get(newValue)
		return value
	end
	
	function api.DrawProperty(drawX, drawY)
	
	end
	
	return api
end

return NumberBox
