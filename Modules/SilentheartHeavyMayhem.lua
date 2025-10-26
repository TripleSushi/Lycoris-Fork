---@class Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	timing.duih = true
	timing.hitbox = Vector3.new(30, 50, 30)

	local action = Action.new()
	action._when = 850
	if self.track.Speed <= 0.95 then
		action._when = 900
	end
	action._type = "Parry"
	action.hitbox = Vector3.new(30, 50, 30)
	action.name = string.format("(%.2f) Mayhem Silentheart Timing", self.track.Speed)
	self:action(timing, action)
end
