
local api = {}

local function MakeWallRow(wall)
	local retStr = "{"
	for i = 1, #wall do
		if i < #wall then
			retStr = retStr .. wall[i] .. ","
		else
			retStr = retStr .. wall[i] .. "}"
		end
	end
	return retStr
end

local function FormatTable(data, sortOrder, opts, indent)
	indent = indent or ""
	local newIndent = indent .. "\t"
	local retStr = "\n" .. indent .. "{\n"
	
	local added = {}
	for i = 1, #(sortOrder or {}) do
		local item = sortOrder[i]
		if data[item] then
			added[item] = true
			if type(data[item]) == "string" then
				retStr = retStr .. newIndent .. item .. [[ = "]] .. data[item] .. [["]] .. ",\n"
			elseif type(data[item]) == "number" then
				retStr = retStr .. newIndent .. item .. " = " .. tonumber(data[item]) .. ",\n"
			elseif type(data[item]) == "table" then
				retStr = retStr .. newIndent .. item .. " =" .. FormatTable(data[item], sortOrder, opts, newIndent) .. ",\n"
			else
				print("Found unknown type in save table for " .. item .. " with type " .. type(data[item]))
			end
		end
	end
	
	if opts and opts.wallFormat then
		for i = 1, #data do
			added[i] = true
			retStr = retStr .. newIndent .. MakeWallRow(data[i]) .. ",\n"
		end
	end
	
	for k, v in pairs(data) do
		if not added[k] then
			print("WARNING! Forgot to save key " .. k .. " in FormatTable")
		end
	end
	
	retStr = retStr .. indent .. "}"
	return retStr
end

function api.SaveEnvToLevelString(level)
	local wallTable = {
		width = level.width,
		height = level.height,
		segmentSize = level.segmentSize,
	}
	
	for y = 0, level.height - 1 do
		local wallRow = {}
		for x = 0, level.width - 1 do
			wallRow[#wallRow + 1] = ((LevelHandler.WallAtGrid({x, y}) and "1") or "0")
		end
		wallTable[#wallTable + 1] = wallRow
	end
	
	return FormatTable({
		gravity = level.gravity,
		wall = wallTable,
	}, {"gravity", "wall", "width", "height", "segmentSize"}, {wallFormat = true})
end

return api
