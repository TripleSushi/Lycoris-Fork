---@class Action
local Action = getfenv().Action

---Module function.
---@param self AnimatorDefender
---@param timing AnimationTiming
return function(self, timing)
	local distance = self:distance(self.entity)
	local hrp = self.entity:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return
	end

	if hrp:WaitForChild("REP_SOUND_15776883341", 0.1) then
		timing.pfh = true
		local action = Action.new()
		action._when = math.min(300 + distance * 8)
		action._type = "Parry"
		action.hitbox = Vector3.new(20, 15, 30)
		action.name = "Blood Scythe Timing"
		return self:action(timing, action)
	else
		timing.pfh = false
		local action = Action.new()
		action._when = 300
		action._type = "Parry"
		action.hitbox = Vector3.new(16, 12, 16)
		action.name = "Scythe Timing"
		return self:action(timing, action)
	end
end
