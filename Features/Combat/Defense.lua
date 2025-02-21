---@module Utility.Signal
local Signal = require("Utility/Signal")

---@module Utility.Maid
local Maid = require("Utility/Maid")

---@module Features.Combat.Objects.AnimatorDefender
local AnimatorDefender = require("Features/Combat/Objects/AnimatorDefender")

---@module Features.Combat.Objects.PartDefender
local PartDefender = require("Features/Combat/Objects/PartDefender")

---@module Features.Combat.Objects.SoundDefender
local SoundDefender = require("Features/Combat/Objects/SoundDefender")

---@module Features.Combat.Objects.EffectDefender
local EffectDefender = require("Features/Combat/Objects/EffectDefender")

---@module Features.Combat.Objects.EmitterDefender
local EmitterDefender = require("Features/Combat/Objects/EmitterDefender")

---@module Utility.Configuration
local Configuration = require("Utility/Configuration")

---@module Utility.Table
local Table = require("Utility/Table")

-- Handle all defense related functions.
local Defense = {}

-- Services.
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local runService = game:GetService("RunService")

-- Maids.
local defenseMaid = Maid.new()

-- Defender objects.
local defenderObjects = {}
local defenderPartObjects = {}
local defenderEmitterObjects = {}

-- Mob animations.
local mobAnimations = {}

---Iteratively find effect owner from effect data.
---@param data table
---@return Model?
local function findEffectOwner(data)
	local live = workspace:FindFirstChild("Live")
	if not live then
		return
	end

	local character = players.LocalPlayer.Character
	if not character then
		return
	end

	for _, value in next, data do
		if typeof(value) ~= "Instance" or value.Parent ~= live or value == character then
			continue
		end

		return value
	end
end

---Add animator defender.
---@param animator Animator
local function addAnimatorDefender(animator)
	defenderObjects[animator] = AnimatorDefender.new(animator, mobAnimations)
end

---Add sound defender.
---@param sound Sound
local function addSoundDefender(sound)
	---@note: If there's nothing to base the sound position off of, then I'm just gonna skip it bruh.
	local part = sound:FindFirstAncestorWhichIsA("BasePart")
	if not part then
		return
	end

	-- Add sound defender.
	defenderObjects[sound] = SoundDefender.new(sound, part)
end

---Add part defender.
---@param part BasePart
local function addPartDefender(part)
	-- Get part defender.
	local partDefender = PartDefender.new(part)
	if not partDefender then
		return
	end

	-- Link to list.
	defenderObjects[part] = partDefender
	defenderPartObjects[part] = partDefender
end

---Add emitter defender.
---@param emitter ParticleEmitter
local function addEmitterDefender(emitter)
	-- Get emitter defender.
	local emitterDefender = EmitterDefender.new(emitter)
	if not emitterDefender then
		return
	end

	-- Check if there's already a defender object under this part.
	if Table.elements(defenderEmitterObjects, function(object)
		return object.part == emitterDefender.part
	end) then
		return
	end

	-- Link to list.
	defenderObjects[emitter] = emitterDefender
	defenderEmitterObjects[emitter] = emitterDefender
end

---On game descendant added.
---@param descendant Instance
local function onGameDescendantAdded(descendant)
	if descendant:IsA("Animator") then
		return addAnimatorDefender(descendant)
	end

	if descendant:IsA("Sound") then
		return addSoundDefender(descendant)
	end

	if descendant:IsA("BasePart") then
		return addPartDefender(descendant)
	end

	if descendant:IsA("ParticleEmitter") then
		return addEmitterDefender(descendant)
	end
end

---On game descendant removed.
---@param descendant Instance
local function onGameDescendantRemoved(descendant)
	local object = defenderObjects[descendant]
	if not object then
		return
	end

	if defenderEmitterObjects[descendant] then
		defenderEmitterObjects[descendant] = nil
	end

	if defenderPartObjects[descendant] then
		defenderPartObjects[descendant] = nil
	end

	object:detach()
	object[descendant] = nil
end

---On client effect event.
---@param name string?
---@param data table?
local function onClientEffectEvent(name, data)
	if not name or not data then
		return
	end

	local owner = findEffectOwner(data)
	if not owner then
		return
	end

	defenderObjects[data] = EffectDefender.new(name, owner)
end

---Update part defenders.
local function updatePartDefenders()
	if not Configuration.expectToggleValue("EnableAutoDefense") then
		return
	end

	for _, object in next, defenderPartObjects do
		if not object.update then
			continue
		end

		object:update()
	end

	for _, object in next, defenderEmitterObjects do
		if not object.update then
			continue
		end

		object:update()
	end
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

	-- Requests.
	local requests = replicatedStorage:WaitForChild("Requests")
	local clientEffect = requests:WaitForChild("ClientEffect")

	-- Signals.
	local gameDescendantAdded = Signal.new(game.DescendantAdded)
	local gameDescendantRemoved = Signal.new(game.DescendantRemoving)
	local postSimulation = Signal.new(runService.PostSimulation)
	local clientEffectEvent = Signal.new(clientEffect.OnClientEvent)

	defenseMaid:add(gameDescendantAdded:connect("Defense_OnDescendantAdded", onGameDescendantAdded))
	defenseMaid:add(gameDescendantRemoved:connect("Defense_OnDescendantRemoved", onGameDescendantRemoved))
	defenseMaid:add(postSimulation:connect("Defense_ProjectilePostSimulation", updatePartDefenders))
	defenseMaid:add(clientEffectEvent:connect("Defense_ClientEffectEvent", onClientEffectEvent))

	for _, descendant in next, game:GetDescendants() do
		onGameDescendantAdded(descendant)
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
