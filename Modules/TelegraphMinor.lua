---@type Action
local Action = getfenv().Action

---Module function.
---@param self SoundDefender
---@param timing SoundTiming
return function(self, timing)
	if not self.owner or not self.owner.Name:match("gigamed") then
		return
	end

	local action = Action.new()
	action._when = 0
	action._type = "Dodge"
	action.hitbox = self.owner.Name:match("king") and Vector3.new(75, 75, 75) or Vector3.new(30, 30, 30)
	action.name = "Gigamed Shock Timing"
	return self:action(timing, action)
end
