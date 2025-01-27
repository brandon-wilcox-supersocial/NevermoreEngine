--- Utility functions involving the NumberRange structure in Roblox
-- @module NumberRangeUtils

local NumberRangeUtils = {}

function NumberRangeUtils.scale(range, scale)
	return NumberRange.new(range.Min*scale, range.Max*scale)
end

return NumberRangeUtils