---@type Action
local Action = getfenv().Action

---Module function.
---@param self PartDefender
---@param timing PartTiming
return function(self, timing)
	local parent = self.part.Parent
	if not parent then
		return
	end

	if not parent.Name:match("Puppet") then
		return
	end

	timing.duih = true
	timing.hitbox = Vector3.new(8, 8, 8)
	timing.fhb = false

	local action = Action.new()
	action._when = 1200
	action._type = "Parry"
	action.hitbox = Vector3.new(0, 0, 0)
	action.name = "Dynamic Shadow Puppet Timing"
	return self:action(timing, action)
end
