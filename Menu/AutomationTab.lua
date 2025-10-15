-- AutomationTab module.
local AutomationTab = {}

---@module Utility.Logger
local Logger = require("Utility/Logger")

---@module Features.Automation.EchoFarm
local EchoFarm = require("Features/Automation/EchoFarm")

---@module Game.ServerHop
local ServerHop = require("Game/ServerHop")

---@module Features.Game.Interactions
local Interactions = require("Features/Game/Interactions")

---@module Game.Wipe
local Wipe = require("Game/Wipe")

---@module Features.Game.Tweening
local Tweening = require("Features/Game/Tweening")

---@module Utility.Finder
local Finder = require("Utility/Finder")

-- Services.
local players = game:GetService("Players")

---Attribute section.
---@param groupbox table
function AutomationTab.initAttributeSection(groupbox)
	groupbox
		:AddToggle("AutoCharisma", {
			Text = "Auto Charisma Farm",
			Default = false,
			Tooltip = "Using the 'How To Make Friends' book, the script will automatically train the 'Charisma' attribute.",
		})
		:AddKeyPicker("AutoCharismaKeybind", {
			Default = "N/A",
			SyncToggleState = true,
			Text = "Auto Charisma Farm",
		})

	groupbox:AddInput("CharismaCap", {
		Text = "Charisma Cap",
		Tooltip = "When this cap is reached, the farm will stop training the 'Charisma' attribute.",
		Numeric = true,
		MaxLength = 3,
		Default = "75",
	})

	groupbox
		:AddToggle("AutoIntelligence", {
			Text = "Auto Intelligence Farm",
			Tooltip = "Using the 'Math Textbook' book, the script will automatically train the 'Intelligence' attribute.",
			Default = false,
		})
		:AddKeyPicker("AutoIntelligenceKeybind", {
			Default = "N/A",
			SyncToggleState = true,
			Text = "Auto Intelligence",
		})

	groupbox:AddInput("IntelligenceCap", {
		Text = "Intelligence Cap",
		Tooltip = "When this cap is reached, the farm will stop training the 'Intelligence' attribute.",
		Numeric = true,
		MaxLength = 3,
		Default = "75",
	})
end

---Initialize Fish Farm section.
---@param groupbox table
function AutomationTab.initFishFarmSection(groupbox)
	groupbox
		:AddToggle("AutoFish", {
			Text = "Auto Fish Farm",
			Tooltip = "Automatically farm fish. Non-AFKable yet. Work-in progress.",
			Default = false,
		})
		:AddKeyPicker("AutoFishKeybind", {
			Default = "N/A",
			SyncToggleState = true,
			Text = "Auto Fish Farm",
		})
end

---Initialize Auto Loot section.
---@param groupbox table
function AutomationTab.initAutoLootSection(groupbox)
	groupbox
		:AddToggle("AutoLoot", {
			Text = "Auto Loot",
			Tooltip = "Automatically loot items from choice prompts with filtering options.",
			Default = false,
		})
		:AddKeyPicker("AutoLootKeybind", {
			Default = "N/A",
			SyncToggleState = true,
			Text = "Auto Loot",
		})

	local autoLootDepBox = groupbox:AddDependencyBox()

	autoLootDepBox:AddToggle("AutoLootAll", {
		Text = "Loot All Items",
		Tooltip = "Loot all items from choice prompts. This will ignore filtering options.",
		Default = false,
	})

	local autoLootAllDepBox = autoLootDepBox:AddDependencyBox()

	autoLootAllDepBox:AddSlider("AutoLootStarsMin", {
		Text = "Minimum Stars",
		Tooltip = "The minimum number of stars an item must have to be looted.",
		Min = 0,
		Max = 3,
		Rounding = 0,
		Suffix = "★",
		Default = 0,
	})

	autoLootAllDepBox:AddSlider("AutoLootStarsMax", {
		Text = "Maximum Stars",
		Tooltip = "The maximum number of stars an item can have to be looted.",
		Min = 0,
		Max = 3,
		Rounding = 0,
		Suffix = "★",
		Default = 0,
	})

	local itemNameList = autoLootAllDepBox:AddDropdown("ItemNameList", {
		Text = "Item Name List",
		Values = {},
		SaveValues = true,
		Multi = true,
		AllowNull = true,
	})

	local itemNameInput = autoLootAllDepBox:AddInput("ItemNameInput", {
		Text = "Item Name Input",
		Placeholder = "Exact or partial names.",
	})

	autoLootAllDepBox:AddButton("Add Item Name To Filter", function()
		local itemName = itemNameInput.Value
		if #itemName <= 0 then
			return Logger.longNotify("Please enter a valid item name.")
		end

		local values = itemNameList.Values
		if not table.find(values, itemName) then
			table.insert(values, itemName)
		end

		itemNameList:SetValues(values)
		itemNameList:SetValue({})
		itemNameList:Display()
	end)

	autoLootAllDepBox:AddButton("Remove Selected Item Names", function()
		local values = itemNameList.Values
		local value = itemNameList.Value

		for selected, _ in next, value do
			local index = table.find(values, selected)
			if not index then
				continue
			end

			table.remove(values, index)
		end

		itemNameList:SetValues(values)
		itemNameList:SetValue({})
		itemNameList:Display()
	end)

	autoLootAllDepBox:SetupDependencies({
		{ Toggles.AutoLootAll, false },
	})

	autoLootDepBox:SetupDependencies({
		{ Toggles.AutoLoot, true },
	})
end

---Initialize Effect Automation section.
---@param groupbox table
function AutomationTab.initEffectAutomation(groupbox)
	groupbox:AddToggle("AutoExtinguishFire", {
		Text = "Auto Extinguish Fire",
		Tooltip = "Attempt to remove 'Burning' effects through automatic sliding.",
		Default = false,
	})
end

---Initialize Debugging section.
---@param groupbox table
function AutomationTab.initDebuggingSection(groupbox)
	groupbox:AddButton("Start Echo Farm", EchoFarm.invoke)
	groupbox:AddButton("Stop Echo Farm", EchoFarm.stop)

	groupbox:AddButton("Server Hop (blacklist)", function()
		ServerHop.hop(players.LocalPlayer:GetAttribute("DataSlot"), true)
	end)

	groupbox:AddButton("Server Hop (no blacklist)", function()
		ServerHop.hop(players.LocalPlayer:GetAttribute("DataSlot"), false)
	end)

	groupbox:AddButton("Wipe Slot", function()
		Wipe.invoke(players.LocalPlayer:GetAttribute("DataSlot"))
	end)

	groupbox:AddButton("Wipe Slot (pass down battleaxe)", function()
		Wipe.invoke(players.LocalPlayer:GetAttribute("DataSlot"), { "Battleaxe" })
	end)

	groupbox:AddButton("Character Selection Echo Farm", function()
		EchoFarm.ccreation()
	end)

	groupbox:AddButton("Equip Weapon Test", function()
		local item = Finder.weweapon("Battleaxe")
		if not item then
			return Logger.longNotify("You do not have a valid Battleaxe to equip.")
		end

		Interactions.etool(item)
	end)

	groupbox:AddButton("Use Enchant Stone Test", function()
		local weapon = Finder.weweapon("Battleaxe")
		if not weapon then
			return Logger.longNotify("You do not have a valid Battleaxe to enchant.")
		end

		Interactions.etool(weapon)

		weapon:Activate()

		local item = Finder.tool("Enchant Stone", false)
		if not item then
			return Logger.longNotify("You do not have an Enchant Stone to use.")
		end

		Interactions.utool(item, true)

		--[[
		Battleaxe
		<font color="rgb(222,235,243)"><i>+Damage: 20 (20)</i></font>
		<font color="rgb(222,235,243)"><i>+PEN: 5%</i></font>
		<font color="rgb(222,235,243)"><i>+Weight (Posture DMG): 6</i></font>
		<font color="rgb(222,235,243)"><i>+Range: 8</i></font>
		<font color="rgb(222,235,243)"><i>+Swing Speed: 0.83x</i></font>
		+Enchant: Storm
		<font size="12"><i>Shock your foes on hit every 5s. Rain will upgrade this shock into a lightning bolt called down from above.</i></font>
		+5% PEN
		Stances: 2H
		]]
		--

		-- Wait for the RichStats of the item we are enchanting to update.
		local equipped = Finder.tool("Weapon", true)

		repeat
			task.wait()
		until equipped:GetAttribute("RichStats"):match("Enchant")

		-- Notify.
		Logger.longNotify("Successfully applied enchant to Battleaxe.")
	end)

	groupbox:AddButton("Use Idol Test", function()
		local item = Finder.tool("Idol", false)
		if not item then
			return Logger.longNotify("You do not have an Idol to use.")
		end

		Interactions.utool(item, "Give me relief from my Flaws.")
	end)

	groupbox:AddButton("Hippo Pool Interact Test", function()
		local item = Finder.tool("Weapon Manual", false)
		if not item then
			return Logger.longNotify("You do not have a Weapon Manual to pass down.")
		end

		Interactions.etool(item)

		local npcs = workspace:WaitForChild("NPCs")
		local pool = npcs:WaitForChild("Hippocampal Pool")

		Interactions.interact(pool, {
			{ choice = "[Inspect]" },
			{ choice = "[Pass down item]" },
			{ exit = true },
		}, true)
	end)

	groupbox:AddButton("Teleport Test (Fragments)", function()
		local HIPPO_POOL_POS = CFrame.new(3145.83, 1149.72, 1548.17)
		local character = players.LocalPlayer.Character or players.LocalPlayer.CharacterAdded:Wait()
		character:PivotTo(HIPPO_POOL_POS)
	end)

	groupbox:AddButton("Titus Gate (S1-EchoFarm)", function()
		EchoFarm.titus({

			-- Have we killed Titus?
			tkill = false,

			-- Have we done atleast one wipe to do initial setup?
			wiped = true,

			-- What is the current slot that we are farming on?
			slot = players.LocalPlayer:GetAttribute("DataSlot"),
		})
	end)

	groupbox:AddButton("Titus Kill (S2-EchoFarm)", function()
		EchoFarm.ktitus({
			-- Have we killed Titus?
			tkill = false,

			-- Have we done atleast one wipe to do initial setup?
			wiped = true,

			-- What is the current slot that we are farming on?
			slot = players.LocalPlayer:GetAttribute("DataSlot"),
		})
	end)

	groupbox:AddButton("After Titus Kill (S3-EchoFarm)", function()
		EchoFarm.tkilled({
			-- Have we killed Titus?
			tkill = true,

			-- Have we done atleast one wipe to do initial setup?
			wiped = true,

			-- What is the current slot that we are farming on?
			slot = players.LocalPlayer:GetAttribute("DataSlot"),
		})
	end)

	groupbox:AddButton("Dungeon Tween Test", function()
		local foo = {
			CFrame.new(621.36, 770.63, 248.15),
			CFrame.new(752.46, 770.63, 246.99),
			CFrame.new(752.46, 896.75, 246.99),
			CFrame.new(752.45, 1027.78, 246.98),
			CFrame.new(556.14, 1027.78, 231.41),
			CFrame.new(469.27, 1027.78, 215.91),
			CFrame.new(469.27, 3107.81, 215.91),
			CFrame.new(465.52, 3119.66, 858.59),
			CFrame.new(593.86, 2606.32, 899.96),
			CFrame.new(873.32, 2358.41, 818.29),
			CFrame.new(948.12, 2319.03, 404.89),
			CFrame.new(769.23, 1055.69, 348.92),
			CFrame.new(720.80, 770.63, 292.17),
			CFrame.new(751.69, 772.50, 210.73),
			CFrame.new(657.82, 770.63, 353.77),
		}

		for idx, value in next, foo do
			Tweening.goal("Dungeon_TweenTest_" .. idx, value, true)
		end
	end)
end

---Initialize tab.
---@param window table
function AutomationTab.init(window)
	-- Create tab.
	local tab = window:AddTab("Auto")

	-- Initialize sections.
	AutomationTab.initFishFarmSection(tab:AddDynamicGroupbox("Fish Farm"))
	AutomationTab.initAttributeSection(tab:AddDynamicGroupbox("Attribute Farm"))
	AutomationTab.initEffectAutomation(tab:AddDynamicGroupbox("Effect Automation"))
	AutomationTab.initAutoLootSection(tab:AddLeftGroupbox("Auto Loot"))
	AutomationTab.initDebuggingSection(tab:AddRightGroupbox("Debugging"))
end

-- Return AutomationTab module.
return AutomationTab
