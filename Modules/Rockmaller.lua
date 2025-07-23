---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local distance = self:distance(self.entity)
	local action = Action.new()
	action._when = 400
	if distance >= 12 then
		action._when = 850
	end
	if distance >= 15 then
		action._when = 850
	end
	action._type = "Parry"
	action.hitbox = Vector3.new(15, 10, 18)
	action.name = string.format("(%.2f) Dynamic Rockmaller Crit Timing", distance)
	return self:action(timing, action)
end
