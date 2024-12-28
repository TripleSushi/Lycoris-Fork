---@module Features.Combat.Timings.SaveManager
local SaveManager = require("Features/Combat/Timings/SaveManager")

---@module Features.Combat.Timings.TimingContainerStack
local TimingContainerStack = require("Features/Combat/Timings/TimingContainerStack")

-- BuilderTab module.
local BuilderTab = {}

---Initialize save manager section.
---@param groupbox table
function BuilderTab.initSaveManagerSection(groupbox)
	local configName = groupbox:AddInput("ConfigName", {
		Name = "Config Name",
		Tooltip = "Name of a new configuration file.",
	})

	local configList = groupbox:AddDropdown("ConfigList", {
		Name = "Config List",
		Values = SaveManager.list(),
		AllowNull = true,
	})

	groupbox
		:AddButton("Create Config", function()
			SaveManager.create(configName.Value)
			SaveManager.refresh(configList)
		end)
		:AddButton("Load Config", {
			DoubleClick = true,
			Func = function()
				SaveManager.load(configList.Value)
			end,
		})

	groupbox:AddButton("Overwrite Config", {
		DoubleClick = true,
		Func = function()
			SaveManager.save(configList.Value)
		end,
	})

	groupbox:AddButton("Delete Config", {
		DoubleClick = true,
		Func = function()
			SaveManager.delete(configList.Value)
			SaveManager.refresh(configList)
		end,
	})

	groupbox:AddButton("Refresh List", function()
		SaveManager.refresh(configList)
	end)

	groupbox:AddButton("Set To Auto Load", function()
		SaveManager.autoload(configList.Value)
	end)
end

---Initialize merge manager section.
---@param groupbox table
function BuilderTab.initMergeManagerSection(groupbox)
	local configList = groupbox:AddDropdown("ConfigList", {
		Name = "Config List",
		Values = SaveManager.list(),
		AllowNull = true,
	})

	local mergeConfigType = groupbox:AddDropdown("MergeConfigType", {
		Name = "Merge Type",
		Values = { "Add New Timings", "Overwrite and Add Everything" },
		Default = 1,
	})

	groupbox:AddButton("Merge With Current Config", {
		DoubleClick = true,
		Func = function()
			SaveManager.merge(configList.Value, mergeConfigType.Value)
		end,
	})
end

---Initialize logger section.
---@param groupbox table
function BuilderTab.initLoggerSection(groupbox)
	groupbox:AddToggle("Show Logger Window", {
		Text = "Show Logger Window",
		Default = false,
	})
end

---Initialize builder section.
---@param groupbox table
---@param stack TimingContainerStack
function BuilderTab.initBuilderSection(groupbox, stack)
	groupbox:AddDropdown("TimingList", {
		Name = "Timing List",
		Values = stack:list(),
		AllowNull = true,
	})
end

---Initialize keyframe section.
---@param groupbox table
function BuilderTab.initKeyframeSection(groupbox) end

---Initialize animation section.
---@param groupbox table
function BuilderTab.initAnimationSection(groupbox) end

---Initialize effect section.
---@param groupbox table
function BuilderTab.initEffectSection(groupbox) end

---Initialize part section.
---@param groupbox table
function BuilderTab.initPartSection(groupbox) end

---Initialize sound section.
---@param groupbox table
function BuilderTab.initSoundSection(groupbox) end

---Initialize tab.
---@param window table
function BuilderTab.init(window)
	-- Create tab.
	local tab = window:AddTab("Builder")

	-- Get timing saves.
	local config = SaveManager.config
	local default = SaveManager.default

	-- Initialize sections.
	BuilderTab.initSaveManagerSection(tab:AddDynamicGroupbox("Save Manager"))
	BuilderTab.initMergeManagerSection(tab:AddDynamicGroupbox("Merge Manager"))
	BuilderTab.initLoggerSection(tab:AddDynamicGroupbox("Logger"))

	-- Initalize Keyframe builder stack.
	local keyframeStack = TimingContainerStack.new()
	keyframeStack:push(default:get().keyframe)
	keyframeStack:push(config:get().keyframe)

	-- Initializ Animation builder stack.
	local animationStack = TimingContainerStack.new()
	animationStack:push(default:get().animation)
	animationStack:push(config:get().animation)

	-- Initializ Effect builder stack.
	local effectStack = TimingContainerStack.new()
	effectStack:push(default:get().effect)
	effectStack:push(config:get().effect)

	-- Initializ Part builder stack.
	local partStack = TimingContainerStack.new()
	partStack:push(default:get().part)
	partStack:push(config:get().part)

	-- Initializ Sound builder stack.
	local soundStack = TimingContainerStack.new()
	soundStack:push(default:get().sound)
	soundStack:push(config:get().sound)

	-- Initalize builder sections.
	BuilderTab.initKeyframeSection(BuilderTab.initBuilderSection(tab:AddDynamicGroupbox("Keyframe"), keyframeStack))
	BuilderTab.initAnimationSection(BuilderTab.initBuilderSection(tab:AddDynamicGroupbox("Animation"), animationStack))
	BuilderTab.initEffectSection(BuilderTab.initBuilderSection(tab:AddDynamicGroupbox("Effect"), effectStack))
	BuilderTab.initPartSection(BuilderTab.initBuilderSection(tab:AddDynamicGroupbox("Part"), partStack))
	BuilderTab.initSoundSection(BuilderTab.initBuilderSection(tab:AddDynamicGroupbox("Sound"), soundStack))
end

-- Return CombatTab module.
return BuilderTab
