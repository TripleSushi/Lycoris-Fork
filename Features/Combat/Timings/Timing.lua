---@class Timing
---@field name string
---@field type string
---@field hitbox Vector3
---@field hitboxDelay boolean
local Timing = {}
Timing.__index = Timing

---Timing ID. Override me.
---@return string
function Timing:id()
	return nil
end

---Load from partial values.
---@param values table
function Timing:load(values)
	self.name = values.name or ""
	self.type = values.type or ""
	self.hitbox = values.hitbox or ""
	self.hitboxDelay = values.hitboxDelay or ""
end

---Create new Timing object.
---@param values table?
---@return Timing
function Timing.new(values)
	local self = setmetatable({}, Timing)

	self.name = ""
	self.type = ""
	self.hitbox = Vector3.zero
	self.hitboxDelay = false

	if values then
		self:load(values)
	end

	return self
end
