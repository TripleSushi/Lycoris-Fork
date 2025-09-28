---@class DeepwokenData
---@field talents table
---@field mantras table
local DeepwokenData = {}
DeepwokenData.__index = DeepwokenData

---Get data for a specific talent or mantra.
---@param name string
function DeepwokenData:get(name)
	return self.talents[string.lower(name)] or self.mantras[string.lower(name)]
end

---Are we able to get a specified talent or mantra with the passed in attribute data?
---@param name string
---@param adata AttributeData
---@return boolean
function DeepwokenData:possible(name, adata)
	local data = self:get(name)
	if not data then
		return false
	end

	local reqs = data.reqs
	if not reqs then
		return false
	end

	---@note: Format this table for clean requirement parsing
	local formatted = {}

	for idx, value in pairs(reqs.base) do
		formatted[idx] = value
	end

	for idx, value in pairs(reqs.weapon) do
		formatted[idx] = value
	end

	for idx, value in pairs(reqs.attunement) do
		formatted[idx] = value
	end

	return adata:possible(formatted)
end

---Load from partial values.
---@param values table
function DeepwokenData:load(values)
	if typeof(values.talents) == "table" then
		self.talents = values.talents
	end

	-- Filter out "Will O' Wisp" with new forced mapping
	for idx, _ in next, self.talents do
		if not idx:match("will o' wisp") then
			continue
		end

		self.talents["will o' wisp"] = {
			name = "Will O' Wisp",
			desc = "Your mastery over the Wisps of the Song enables you to mediate the innate conflicts between your Wisps, allowing any number of Wisps to be active at a time.",
			rarity = "Advanced",
			category = "Sage of Wisps",
			reqs = {
				power = "0",
				weaponType = "None",
				from = "Wisp-type Mantra",
				base = {
					Strength = 0,
					Fortitude = 0,
					Agility = 0,
					Body = 0,
					Intelligence = 0,
					Willpower = 0,
					Charisma = 0,
					Mind = 0,
				},
				weapon = {
					["Heavy Wep."] = 0,
					["Medium Wep."] = 0,
					["Light Wep."] = 0,
				},
				attunement = {
					Flamecharm = 0,
					Frostdraw = 0,
					Thundercall = 0,
					Galebreathe = 0,
					Shadowcast = 0,
					Ironsing = 0,
					Bloodrend = 0,
				},
			},
			stats = "+1 Wisp Mantra Slot",
			dontCountTowardsTotal = false,
			vaulted = false,
		}
	end

	if typeof(values.mantras) == "table" then
		self.mantras = values.mantras
	end

	-- Filter out "Shadow Meteors" to mapping to "Shadow Meteor"
	for idx, _ in next, self.mantras do
		if not idx:match("shadow meteors") then
			continue
		end

		self.mantras["shadow meteor"] = self.mantras["shadow meteors"]
	end
end

---Create new DeepwokenData object.
---@param values table?
---@return DeepwokenData
function DeepwokenData.new(values)
	local self = setmetatable({}, DeepwokenData)

	self.talents = {}
	self.mantras = {}

	if values then
		self:load(values)
	end

	return self
end

-- Return DeepwokenData module.
return DeepwokenData
