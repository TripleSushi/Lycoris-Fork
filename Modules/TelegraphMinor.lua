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
	action.hitbox = Vector3.new(30, 30, 30)
	action.name = "Gigamed Shock Timing"
	return self:action(timing, action)
end
