---@module Features.Combat.Timings.TimingContainer
local TimingContainer = require("Features.Combat.Timings.TimingContainer")

---@module Features.Combat.Timings.Timing
local Timing = require("Features.Combat.Timings.Timing")

---@class TimingSave
---@field _data TimingContainer[]
local TimingSave = {}
TimingSave.__index = TimingSave

---@alias MergeType
---| '1' # Only add new timings
---| '2' # Overwrite and add everything

---Get timing save.
---@return TimingContainer[]
function TimingSave:get()
	return self._data
end

---Merge with another TimingSave object.
---@param other TimingSave
---@param type MergeType
function TimingSave:merge(other, type)
	for idx, otherContainer in next, other._data do
		local container = self._data[idx]
		if not container then
			continue
		end

		container:merge(otherContainer, type)
	end
end

---Load from partial values.
---@param values table
function TimingSave:load(values)
	local data = self._data

	if typeof(values.animation) == "table" then
		data.animation:load(values.animation)
	end

	if typeof(values.effect) == "table" then
		data.effect:load(values.effect)
	end

	if typeof(values.part) == "table" then
		data.part:load(values.part)
	end

	if typeof(values.sound) == "table" then
		data.sound:load(values.sound)
	end

	if typeof(values.keyframe) == "table" then
		data.keyframe:load(values.keyframe)
	end
end

---Create new TimingSave object.
---@param values table?
---@return TimingSave
function TimingSave.new(values)
	local self = setmetatable({}, TimingSave)

	self._data = {
		animation = TimingContainer.new(Timing),
		effect = TimingContainer.new(Timing),
		part = TimingContainer.new(Timing),
		sound = TimingContainer.new(Timing),
		keyframe = TimingContainer.new(Timing),
	}

	if values then
		self:load(values)
	end

	return self
end

-- Return TimingSave module.
return TimingSave
