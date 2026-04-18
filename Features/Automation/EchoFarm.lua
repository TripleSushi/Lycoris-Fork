-- EchoFarm module.
---@todo: The first issue is that the farm can be broken when user gets kicked for any reason. It cannot detect that, when it should rejoin the lobby again.
---@todo: The second issue is that we don't have any proper player checks in place.
---@todo: The third issue is that we don't have any proper validity checks. For example, does the user even have a Battleaxe to swap down initially? Do we even have a 'Fort Merit' spawn before trying?
local EchoFarm = {}

---@module Features.Exploits.Exploits
local Exploits = require("Features/Exploits/Exploits")

---@module Utility.PersistentData
local PersistentData = require("Utility/PersistentData")

---@module Game.AntiAFK
local AntiAFK = require("Game/AntiAFK")

---@module Utility.Finder
local Finder = require("Utility/Finder")

---@module Game.Wipe
local Wipe = require("Game/Wipe")

---@module Features.Game.Tweening
local Tweening = require("Features/Game/Tweening")

---@module Game.ServerHop
local ServerHop = require("Game/ServerHop")

---@module Utility.TaskSpawner
local TaskSpawner = require("Utility/TaskSpawner")

---@module Game.KeyHandling
local KeyHandling = require("Game/KeyHandling")

---@module Features.Game.Interactions
local Interactions = require("Features/Game/Interactions")

---@module Utility.Maid
local Maid = require("Utility/Maid")

---@module Utility.Logger
local Logger = require("Utility/Logger")

---@module Features.Automation.AutoLoot
local AutoLoot = require("Features/Automation/AutoLoot")

---@module Features.Automation.Objects.AutoLootOptions
local AutoLootOptions = require("Features/Automation/Objects/AutoLootOptions")

---@module Features.Game.Movement
local Movement = require("Features/Game/Movement")

-- Services.
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local teleportService = game:GetService("TeleportService")

-- Constants.
local EASTERN_PLACE_ID = 6473861193
local TITUS_PLACE_ID = 8668476218
local DEBUGGING_MODE = true

-- Maid.
local echoFarmMaid = Maid.new()

-- Currently running?
local running = false

---Telemetry log.
local function telemetryLog(...)
	if not DEBUGGING_MODE then
		return
	end

	Logger.warn(...)
end

---Handle CharacterCreation state.
function EchoFarm.ccreation()
	local requests = replicatedStorage:WaitForChild("Requests")
	local characterCreator = requests:WaitForChild("CharacterCreator")
	local pickSpawn = characterCreator:WaitForChild("PickSpawn")
	local changeWeapon = characterCreator:WaitForChild("ChangeWeapon")
	local finishCreation = characterCreator:WaitForChild("FinishCreation")
	local toggleMetaModifier = requests:WaitForChild("ToggleMetaModifier")
	local playerGui = players.LocalPlayer:WaitForChild("PlayerGui")
	local characterGui = playerGui:WaitForChild("CharacterCreator")
	local gameMode = characterGui:WaitForChild("GameMode"):WaitForChild("Options")
	local standard = gameMode:WaitForChild("Standard"):WaitForChild("Element")
	local suc;

	pcall(function()
		for _ = 1, 5 do
			firesignal(standard.MouseButton1Click)
			task.wait(0.1)
		end
	end)

	for _ = 1, 10 do
		suc = pickSpawn:InvokeServer("Merit")
		if suc then
			break
		end
		task.wait(0.1)
	end

	for _ = 1, 10 do
		suc = changeWeapon:InvokeServer("Battleaxe")
		if suc then
			break
		end
		task.wait(0.1)
	end

	toggleMetaModifier:FireServer("All")

	task.spawn(function()
		finishCreation:InvokeServer()
	end)

	local choicePrompt = playerGui:WaitForChild("ChoicePrompt")
	local choice = choicePrompt:WaitForChild("Choice")

	choice:FireServer(true)
end

---Go to the Titus fight.
---@param tdata table Fake data.
function EchoFarm.titus(tdata)
	-- Request start.
	local requests = replicatedStorage:WaitForChild("Requests")
	local startMenu = requests:WaitForChild("StartMenu")
	local start = startMenu:WaitForChild("Start")

	telemetryLog("(EchoFarm) Requesting start.")

	start:FireServer()

	local data = tdata or PersistentData.get("efdata")
	if not data then
		return error("No EchoFarm data found in PersistentData.")
	end

	local positions = {
		-- From spawn, we need to be up in the jar, so we won't be seen.
		CFrame.new(-7518.70, 4825.71, 3483.19),

		-- Then, tween above the gate.
		CFrame.new(-6877.09, 4825.71, 2829.91),

		-- Teleport ourselves down.
		CFrame.new(-6877.50, 329.94, 2829.21),
	}

	-- Humanoid root part.
	local character = players.LocalPlayer.Character or players.LocalPlayer.CharacterAdded:Wait()
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

	-- First position.
	local firstPosition = positions[1].Position

	firstPosition = Vector3.new(firstPosition.X, humanoidRootPart.Position.Y, firstPosition.Z)

	-- If we're not near the filltered first position, skip that position.
	if not Finder.near(firstPosition, 100) then
		table.remove(positions, 1)
	end

	-- Move towards each position. Don't stop when we reach the last one.
	telemetryLog("(EchoFarm) Moving to Titus gate.")

	for idx, cframe in next, positions do
		Tweening.goal(string.format("EF_TweenToGate_%i", idx), cframe, idx ~= #positions)
	end

	-- We wait until we've reached the last position.
	telemetryLog("(EchoFarm) Waiting to reach gate.")

	Tweening.wait(string.format("EF_TweenToGate_%i", #positions))

	-- Is anyone near here?
	telemetryLog("(EchoFarm) Checking if anyone is near the gate.")

	local map = workspace:WaitForChild("Map")
	local meritEntry = map:WaitForChild("MeritEntry")
	local interactPrompt = meritEntry:FindFirstChildWhichIsA("ProximityPrompt")

	-- Are we not near the gate at all?
	if not Finder.near(meritEntry.Position, 50) then
		return error("We are not near the 'MeritEntry' model.")
	end

	-- Is someone already here?
	telemetryLog("(EchoFarm) Checking if anyone is near the gate.")

	if Finder.pnear(meritEntry.Position, 100) then
		return ServerHop.hop(data.slot, true)
	end

	-- Keep trying to interact with the prompt and teleport us there.
	telemetryLog("(EchoFarm) Interacting with gate.")

	while task.wait() do
		fireproximityprompt(interactPrompt)
	end
end

---Wait for a chest to spawn on us.
---@param tdata table Fake data.
---@return Instance
function EchoFarm.wfc(tdata)
	local data = tdata or PersistentData.get("efdata")
	if not data then
		return error("No EchoFarm data found in PersistentData.")
	end

	local character = players.LocalPlayer.Character or players.LocalPlayer.CharacterAdded:Wait()
	local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
	local startTimestamp = os.clock()

	while task.wait() do
		if os.clock() - startTimestamp >= 35 then
			return ServerHop.hop(data.slot, false)
		end

		local chest = Finder.chest(humanoidRootPart.Position, 300)
		if not chest then
			continue
		end

		return chest
	end

	return nil
end

---Wait for ChoicePrompt by interacting with a chest.
---@param chest Instance
---@return Instance?
function EchoFarm.wcp(chest)
	local playerGui = players.LocalPlayer:WaitForChild("PlayerGui")
	local interactPrompt = chest:WaitForChild("InteractPrompt")

	while task.wait() do
		fireproximityprompt(interactPrompt)

		local prompt = playerGui:FindFirstChild("ChoicePrompt")
		if not prompt then
			continue
		end

		return prompt
	end

	return nil
end

---Kill titus.
---@param tdata table Fake data.
function EchoFarm.ktitus(tdata)
	-- Request start.
	local requests = replicatedStorage:WaitForChild("Requests")
	local startMenu = requests:WaitForChild("StartMenu")
	local start = startMenu:WaitForChild("Start")

	telemetryLog("(EchoFarm) Requesting start.")

	repeat
		-- Fire server.
		start:FireServer()

		-- Wait.
		task.wait()
	until #workspace:WaitForChild("Live"):GetChildren() > 0

	local data = tdata or PersistentData.get("efdata")
	if not data then
		return error("No EchoFarm data found in PersistentData.")
	end

	local serverSwim = KeyHandling.getRemote("ServerSwim")
	serverSwim:Destroy()

	-- Enable Pathfinder Breaker.
	telemetryLog("(EchoFarm) Enabling Pathfinder Breaker.")

	AutoLoot.ignore = true

	-- Is anyone with us?
	telemetryLog("(EchoFarm) Checking if anyone is in the dungeon with us.")

	if #players:GetPlayers() > 1 then
		return ServerHop.hop(data.slot, false)
	end

	local titus
	repeat task.wait() until Finder.entity("titus")
	titus = Finder.entity("titus")

	Tweening.goal("EF_Titus", titus.HumanoidRootPart.CFrame, true)
	Tweening.wait("EF_Titus")

	Movement.ATB = true
	Movement.HeightOffset = 0
	Movement.BackOffset = -0.01

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://84577348154610"

	local char = players.LocalPlayer.Character or players.LocalPlayer.CharacterAdded:Wait()
	local humanoid = char:WaitForChild("Humanoid")
	local track = humanoid:LoadAnimation(anim)

	Exploits.pfBreaker = true

	track:Play()
	track.Looped = true

	local vim = Instance.new("VirtualInputManager")
	vim:SendKeyEvent(true, Enum.KeyCode.A, false, game)
	task.wait(0.5)
	vim:SendKeyEvent(false, Enum.KeyCode.A, false, game)

	local ogY = titus.HumanoidRootPart.Position.Y
	local timeOut = os.clock()

	while math.abs(titus.HumanoidRootPart.Position.Y - ogY) < 100 and (os.clock() - timeOut) < 35 do
		task.wait()
	end

	Movement.ATB = false
	Tweening.stop("TweenToBack")

	track:Stop()
	char.HumanoidRootPart.CFrame = CFrame.new(char.HumanoidRootPart.Position.X, 0.1, char.HumanoidRootPart.Position.Z)

	-- Wait for chest to spawn near us.
	telemetryLog("(EchoFarm) Waiting for chest to spawn on us.")

	local chest = EchoFarm.wfc(tdata)
	if not chest then
		return error("No chest found on us.")
	end

	-- Keep interacting until we get a choice prompt.
	telemetryLog("(EchoFarm) Interacting with chest.")

	local choicePrompt = EchoFarm.wcp(chest)
	if not choicePrompt then
		return error("No ChoicePrompt found after interacting with chest.")
	end

	-- Process chest.
	telemetryLog("(EchoFarm) Processing chest.")

	AutoLoot.process(choicePrompt, AutoLootOptions.new(0, 0, {}, true))

	-- Wait until we're finished.
	telemetryLog("(EchoFarm) Waiting until auto loot is finished.")

	local backpack = players.LocalPlayer.Backpack
	local items = #backpack:GetChildren()

	repeat
		task.wait()
	until not AutoLoot.active()

	-- Wait until we have more items in our backpack.
	telemetryLog("(EchoFarm) Waiting until we have more items in our backpack.")

	repeat
		task.wait()
	until #backpack:GetChildren() > items

	-- Check if we have an enchant stone.
	telemetryLog("(EchoFarm) Checking for enchant stone.")

	local stone = nil
	local timestamp = os.clock()

	repeat
		-- Look for stone.
		stone = Finder.tool("Enchant Stone", false)

		-- Has it been over a second?
		if os.clock() - timestamp >= 1.0 then
			return ServerHop.hop(data.slot, false)
		end

		-- Wait.
		task.wait()
	until stone

	-- Mark a kill.
	telemetryLog("(EchoFarm) Marking Titus kill.")

	if not tdata then
		PersistentData.stf("efdata", "tkill", true)
	end

	-- Teleport to exit.
	telemetryLog("(EchoFarm) Using enchant stone.")
	EchoFarm.tkilled(tdata)
end

---End the cycle and wipe the character.
---@param tdata table Fake data.
function EchoFarm.cend(tdata)
	-- Log.
	telemetryLog("(EchoFarm) Invoking cycle end.")

	-- Invoke wipe and clear Titus kill marker.
	local data = tdata or PersistentData.get("efdata")
	if not data then
		return error("No EchoFarm data found in PersistentData.")
	end

	if not tdata then
		PersistentData.stf("efdata", "tkill", false)
	end

	Wipe.invoke(data.slot, { "Battleaxe" })
end

---Titus killed.
---@param tdata table Fake data.
function EchoFarm.tkilled(tdata)
	local data = tdata or PersistentData.get("efdata")
	if not data then
		return error("No EchoFarm data found in PersistentData.")
	end

	-- Enchant Battleaxe.
	telemetryLog("(EchoFarm) Enchanting Battleaxe.")

	pcall(function()
		replicatedStorage.Requests.Unequip:InvokeServer("Weapon", true)
	end)

	task.wait(5)

	local weapon = Finder.weweapon("Battleaxe")
	if not weapon then
		return Logger.warn("You do not have a valid Battleaxe to enchant.")
	end

	Interactions.etool(weapon)

	weapon:Activate()
	task.wait()

	local stone = Finder.tool("Enchant Stone", false)
	if not stone then
		return Logger.warn("You do not have an Enchant Stone to use.")
	end

	Interactions.utool(stone, true)

	-- Wait until it is fully enchanted. If not, it will be deemed as a duped item.
	local equipped = Finder.tool("Weapon", true)

	repeat
		task.wait()
	until equipped:GetAttribute("RichStats"):match("Enchant")

	-- Use idol if we have it.
	telemetryLog("(EchoFarm) Using Idol if we have one.")

	local idol = Finder.tool("Idol", false)
	if idol then
		Interactions.utool(idol, "Give me relief from my Flaws.")
	end

	task.wait(5)

	-- Invoke end.
	EchoFarm.cend(tdata)
end

---Start the EchoFarm module.
function EchoFarm.start()
	local localPlayer = players.LocalPlayer
	if not localPlayer then
		return
	end

	local data = PersistentData.get("efdata")
	if not data then
		return error("No EchoFarm data found in PersistentData.")
	end

	if not data.slot then
		return error("No data slot found for EchoFarm.")
	end

	if running then
		return
	end

	running = true

	PersistentData.set("efdata", data)

	AntiAFK.start("EchoFarm")

	if localPlayer:GetAttribute("GameLoaded") == "CharacterCreation" then
		data.wiped = true
	end

	if not data.wiped then
		return Wipe.invoke(data.slot, { "Battleaxe" })
	end

	if localPlayer:GetAttribute("GameLoaded") == "CharacterCreation" then
		return echoFarmMaid:mark(TaskSpawner.spawn("EchoFarm_CCreation", EchoFarm.ccreation))
	end

	if game.PlaceId == EASTERN_PLACE_ID and not data.tkill then
		return echoFarmMaid:mark(TaskSpawner.spawn("EchoFarm_Titus", EchoFarm.titus))
	end

	if game.PlaceId == TITUS_PLACE_ID then
		return echoFarmMaid:mark(TaskSpawner.spawn("EchoFarm_Dungeon_KillTitusFSM", EchoFarm.ktitus))
	end
end

---Invoke the EchoFarm module.
function EchoFarm.invoke()
	PersistentData.set("efdata", {
		-- Have we killed Titus?
		tkill = false,

		-- Have we done atleast one wipe to do initial setup?
		wiped = false,

		-- What is the current slot that we are farming on?
		slot = players.LocalPlayer:GetAttribute("DataSlot"),
	})

	EchoFarm.start()
end

---Stop the EchoFarm module.
function EchoFarm.stop()
	if not running then
		return
	end

	running = false

	-- Stop AntiAFK.
	AntiAFK.stop("EchoFarm")

	-- Clear persistent data.
	PersistentData.set("efdata", nil)

	-- Stop all tasks.
	echoFarmMaid:clean()

	-- Cancel all tweens related to EchoFarm.
	for _, data in next, Tweening.queue do
		if not data.identifier:match("EF") then
			continue
		end

		Tweening.cancel(data.identifier)
	end
end

-- Return EchoFarm module.
return EchoFarm
