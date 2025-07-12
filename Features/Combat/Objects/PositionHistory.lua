---@class PositionHistory
---@field history table
local PositionHistory = {}
PositionHistory.__index = PositionHistory

---Add an entry to the history list.
---@param position CFrame
---@param timestamp number
function PositionHistory:add(position, timestamp)
	self.history[#self.history + 1] = {
		position = position,
		timestamp = timestamp,
	}

	while true do
		local tail = self.history[1]
		if not tail then
			break
		end

		if tick() - tail.timestamp <= 3.0 then
			break
		end

		table.remove(self.history, 1)
	end
end

---Get closest position (in time) to a timestamp.
---@param timestamp number
---@return Vector3
function PositionHistory:closest(timestamp)
	local closestDelta = nil
	local closestPosition = nil

	for _, data in next, self.history do
		local delta = timestamp - data.timestamp

		if closestDelta and delta <= closestDelta then
			continue
		end

		closestPosition = data.position
		closestDelta = delta
	end

	return closestPosition
end

---Create new PositionHistory object.
---@return PositionHistory
function PositionHistory.new()
	local self = setmetatable({}, PositionHistory)
	self.history = {}
	return self
end

-- Return PositionHistory module.
return PositionHistory
