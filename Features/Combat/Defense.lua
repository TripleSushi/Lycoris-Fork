---@module Utility.Signal
local Signal = require("Utility/Signal")

---@module Utility.Maid
local Maid = require("Utility/Maid")

---@module Features.Combat.Objects.AnimatorDefender
local AnimatorDefender = require("Features/Combat/Objects/AnimatorDefender")

-- Handle all defense related functions.
local Defense = {}

-- Services.
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Maids.
local defenseMaid = Maid.new()

-- Defender objects.
local defenderObjects = {}

-- Mob animations.
local mobAnimations = {}

-- On live descendant added.
local function onLiveDescendantAdded(child)
	if not child:IsA("Animator") then
		return
	end

	defenderObjects[child] = AnimatorDefender.new(child, mobAnimations)
end

-- On live descendant removed.
local function onLiveDescendantRemoved(child)
	local object = defenderObjects[child]
	if not object then
		return
	end

	object:detach()
	object[child] = nil
end

---Check if objects have blocking tasks.
---@return boolean
function Defense.blocking()
	for _, object in next, defenderObjects do
		if not object:blocking() then
			continue
		end

		return true
	end
end

---Initialize defense.
function Defense.init()
	-- Cache mob animations.
	local assetFolder = replicatedStorage:WaitForChild("Assets")
	local animationFolder = assetFolder:WaitForChild("Anims")
	local mobsAnimationFolder = animationFolder:WaitForChild("Mobs")

	for _, animation in next, mobsAnimationFolder:GetDescendants() do
		if not animation:IsA("Animation") then
			continue
		end

		mobAnimations[animation.AnimationId] = animation
	end

	-- Live folder.
	local live = workspace:WaitForChild("Live")

	-- Signals.
	local liveDescendantAdded = Signal.new(live.DescendantAdded)
	local liveDescendantRemoved = Signal.new(live.DescendantRemoving)

	defenseMaid:add(liveDescendantAdded:connect("Defense_LiveDescendantAdded", onLiveDescendantAdded))
	defenseMaid:add(liveDescendantRemoved:connect("Defense_LiveDescendantRemoved", onLiveDescendantRemoved))

	for _, descendant in next, live:GetDescendants() do
		onLiveDescendantAdded(descendant)
	end
end

---Detach defense.
function Defense.detach()
	for _, object in next, defenderObjects do
		object:detach()
	end

	defenseMaid:clean()
end

-- Return Defense module.
return Defense
