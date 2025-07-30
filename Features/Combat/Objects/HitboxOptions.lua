---@class HitboxOptions
---@note: Options for the hitbox check.
---@field part BasePart? If this is specified and it exists, it will be used for the position.
---@field cframe CFrame? Else, the part's CFrame will be used.
---@param timing Timing|EffectTiming|AnimationTiming|SoundTiming
---@field action Action?
---@field filter Instance[]
---@field spredict boolean If true, a check will run for predicted positions.
local HitboxOptions = {}
HitboxOptions.__index = HitboxOptions

---Get extrapolated position.
---@param fsecs number
---@return CFrame
HitboxOptions.extrapolate = LPH_NO_VIRTUALIZE(function(self, fsecs)
	if not self.part then
		return error("HitboxOptions.extrapolate - unimplemented for CFrame")
	end

	return self.part.CFrame * CFrame.new(self.part.Velocity * fsecs)
end)

---Get position.
---@return CFrame
HitboxOptions.pos = LPH_NO_VIRTUALIZE(function(self)
	if self.cframe then
		return self.cframe
	end

	if self.part then
		return self.part.CFrame
	end

	return error("HitboxOptions.pos - impossible condition")
end)

---Create new HitboxOptions object.
---@param target Instance|CFrame
---@param timing Timing|EffectTiming|AnimationTiming|SoundTiming
---@param filter Instance[]
---@return HitboxOptions
HitboxOptions.new = LPH_NO_VIRTUALIZE(function(target, timing, filter)
	local self = setmetatable({}, HitboxOptions)
	self.part = typeof(target) == "Instance" and target:IsA("BasePart") and target
	self.cframe = typeof(target) == "CFrame" and target
	self.timing = timing
	self.action = nil
	self.filter = filter
	self.spredict = false

	if not self.part and not self.cframe then
		return error("HitboxOptions: No part or CFrame specified.")
	end

	return self
end)

-- Return HitboxOptions module.
return HitboxOptions
