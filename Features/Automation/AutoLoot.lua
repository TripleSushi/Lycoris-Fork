---@module Utility.Maid
local Maid = require("Utility/Maid")

-- AutoLoot module.
local AutoLoot = {}

-- Maid.
local autoLootMaid = Maid.new()

-- The choice remote that will be used. If it is invalidated, then the entire queue will be reset.
local choiceRemote = nil

-- The queue of items to be looted from the remote.
local lootQueue = {}

---Process a choice prompt and add the items with filtering to the loot queue.
---This function will reset the queue and set a new choice remote if it is valid.
---@param prompt ScreenGui The choice prompt to process.
function AutoLoot.process(prompt)
	local remote = prompt:FindFirstChild("ChoiceRemote")
	if not remote or not remote:IsA("RemoteEvent") then
		return
	end

	choiceRemote = remote
	lootQueue = {}
end

---Initialize the AutoLoot module.
function AutoLoot.init() end

---Detach the AutoLoot module.
function AutoLoot.detach() end

-- Return the AutoLoot module.
return AutoLoot
