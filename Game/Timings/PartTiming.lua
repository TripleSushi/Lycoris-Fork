---@module Game.Timings.Timing
local Timing = require("Game/Timings/Timing")

---@class PartTiming: Timing
---@field pname string Part name.
---@field linked string[] Linked animation IDs to filter with.
---@field hitbox Vector3 The main hitbox of the part while it moves.
local PartTiming = setmetatable({}, { __index = Timing })
PartTiming.__index = PartTiming

---Timing ID.
---@return string
function PartTiming:id()
	return self.pname
end

---Load from partial values.
---@param values table
function PartTiming:load(values)
	Timing.load(self, values)

	if typeof(values.pname) == "string" then
		self.pname = values.pname
	end

	if typeof(values.linked) == "table" then
		self.linked = values.linked
	end

	if typeof(values.hitbox) == "table" then
		self.hitbox = Vector3.new(values.hitbox.X, values.hitbox.Y, values.hitbox.Z)
	end
end

---Clone timing.
---@return PartTiming
function PartTiming:clone()
	local clone = setmetatable(Timing.clone(self), PartTiming)

	clone.pname = self.pname
	clone.linked = self.linked
	clone.hitbox = self.hitbox

	return clone
end

---Return a serializable table.
---@return PartTiming
function PartTiming:serialize()
	local serializable = Timing.serialize(self)

	serializable.pname = self.pname
	serializable.linked = self.linked
	serializable.hitbox = {
		X = self.hitbox.X,
		Y = self.hitbox.Y,
		Z = self.hitbox.Z,
	}

	return serializable
end

---Create a new part timing.
---@param values table?
---@return PartTiming
function PartTiming.new(values)
	local self = setmetatable(Timing.new(), PartTiming)

	self.pname = ""
	self.linked = {}
	self.hitbox = Vector3.zero

	if values then
		self:load(values)
	end

	return self
end

-- Return PartTiming module.
return PartTiming
