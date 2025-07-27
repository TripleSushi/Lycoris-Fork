---@type Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local distance = self:distance(self.entity)
	local action = Action.new()
	action._when = 450
	if distance >= 12 then
		action._when = 480
	end
	if distance >= 15 then
		action._when = 530
	end
	if distance >= 20 then
		action._when = 570
	end
	if distance >= 22 then
		action._when = 610
	end
	action._type = "Parry"
	action.hitbox = Vector3.new(13, 25, 40)
	action.name = string.format("(%.2f) Dynamic Lightning HB Crit Timing", distance)
	return self:action(timing, action)
end
