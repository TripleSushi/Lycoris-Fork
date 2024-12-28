---@class TimingContainerStack
---@field _stack TimingContainer[]
local TimingContainerStack = {}
TimingContainerStack.__index = TimingContainerStack

---Create new TimingContainerStack object.
---@return TimingContainerStack
function TimingContainerStack.new()
	local self = setmetatable({}, TimingContainerStack)
	self._stack = {}
	return self
end

---Find timing from name.
---@param name string
---@return table?
function TimingContainerStack:find(name)
	for _, container in next, self._stack do
		local timing = container:find(name)
		if not timing then
			continue
		end

		return timing
	end
end

---List all timing names.
---@return string[]
function TimingContainerStack:names()
	local names = {}

	for _, container in next, self._stack do
		for _, timing in next, container:list() do
			table.insert(names, timing.name)
		end
	end

	return names
end

---Get timing from stack.
---@param idx any
---@return table?
function TimingContainerStack:get(idx)
	for _, container in next, self._stack do
		local timing = container.timings[idx]
		if not timing then
			continue
		end

		return timing
	end
end

---Push timing container.
---@param container TimingContainer
function TimingContainerStack:push(container)
	table.insert(self._stack, container)
end

-- Return TimingContainerStack module.
return TimingContainerStack
