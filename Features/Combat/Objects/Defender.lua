---@module Utility.Logger
local Logger = require("Utility/Logger")

---@module Game.InputClient
local InputClient = require("Game/InputClient")

---@module Features.Combat.Objects.Task
local Task = require("Features/Combat/Objects/Task")

---@class Defender
---@field tasks Task[]
local Defender = {}
Defender.__index = Defender

-- Services.
local players = game:GetService("Players")
local stats = game:GetService("Stats")

---Check if we're in a valid state to proceed with action handling. Extend me.
---@param action Action
---@return boolean
function Defender:valid(action)
	return true
end

---Logger notify.
---@param timing Timing
---@param str string
function Defender:log(timing, str, ...)
	Logger.notify("[%s] %s", timing.name, string.format(str, ...))
end

---Get ping.
---@return number
function Defender:ping()
	local network = stats:FindFirstChild("Network")
	if not network then
		return
	end

	local serverStatsItem = network:FindFirstChild("ServerStatsItem")
	if not serverStatsItem then
		return
	end

	local dataPingItem = serverStatsItem:FindFirstChild("Data Ping")
	if not dataPingItem then
		return
	end

	return dataPingItem:GetValue() / 1000
end

---Handle action.
---@param action Action
function Defender:handle(action)
	if not self:valid(action) then
		return
	end

	Logger.notify("Action type '%s' is being executed.", action._type)

	if action._type == "Parry" then
		InputClient.parry()
	end

	if action._type == "Start Block" then
		InputClient.bstart()
	end

	if action._type == "End Block" then
		InputClient.bend()
	end

	local character = players.LocalPlayer.Character
	if not character then
		return
	end

	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end

	local humanoid = character:FindFirstChildWhichIsA("Humanoid")
	if not humanoid then
		return
	end

	if action._type == "Dodge" then
		InputClient.dodge(root, humanoid)
	end
end

---Check if we have input blocking tasks.
---@return boolean
function Defender:blocking()
	for _, task in next, self.tasks do
		if not task:blocking() then
			continue
		end

		return true
	end
end

---Mark task.
---@param task Task
function Defender:mark(task)
	self.tasks[#self.tasks + 1] = task
end

---Clean up all tasks.
function Defender:clean()
	for idx, task in next, self.tasks do
		-- Cancel task.
		task:cancel()

		-- Clear in table.
		self.tasks[idx] = nil
	end
end

---Add actions from timing to defender object.
---@param timing Timing
function Defender:actions(timing)
	for _, action in next, timing.actions:get() do
		-- Get ping.
		local ping = self:ping()

		-- Add action.
		self:mark(Task.new(string.format("Action_%s", action._type), action:when() - ping, self.handle, self, action))

		-- Log.
		self:log(timing, "Added action '%s' (%.2fs) with ping '%.2f' subtracted.", action.name, action:when(), ping)
	end
end

---Create new Defender object.
function Defender.new()
	local self = setmetatable({}, Defender)
	self.tasks = {}
	return self
end

-- Return Defender module.
return Defender
