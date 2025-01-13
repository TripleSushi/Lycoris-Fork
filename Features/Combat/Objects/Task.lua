---@module Utility.TaskSpawner
local TaskSpawner = require("Utility/TaskSpawner")

---@class Task
---@field thread thread
---@field when number A timestamp when the task will be executed.
local Task = {}
Task.__index = Task

---Check if task should block the input.
---@return boolean
function Task:blocking()
	if not (coroutine.status(self.thread) ~= "dead") then
		return false
	end

	---@note: Allow us to do inputs up until a certain amount of time (0.3s) before the task happens.
	return os.clock() >= self.when - 0.3
end

---Cancel task.
function Task:cancel()
	if coroutine.status(self.thread) ~= "suspended" then
		return
	end

	task.cancel(self.thread)
end

---Create new Task object.
---@param identifier string
---@param delay number
---@param callback function
---@vararg any
---@return Task
function Task.new(identifier, delay, callback, ...)
	local self = setmetatable({}, Task)
	self.thread = TaskSpawner.delay(identifier, delay, callback, ...)
	self.when = os.clock() + delay
	return self
end

-- Return Task module.
return Task
