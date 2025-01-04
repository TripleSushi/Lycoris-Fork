-- InputClient module.
local InputClient = {
	sprintFunctionCache = nil,
	rollFunctionCache = nil,
}

---@module Utility.Logger
local Logger = require("Utility/Logger")

-- Services.
local runService = game:GetService("RunService")

---Check if table has non-boolean values.
---@param tbl table
---@return boolean
local function hasNonBooleans(tbl)
	for _, value in next, tbl do
		if typeof(value) == "boolean" then
			continue
		end

		return false
	end

	return true
end

---Fetch input data.
---@return table?
function InputClient.getInputData()
	local inputData = nil

	for _, connection in next, getconnections(runService.RenderStepped) do
		local func = connection.Function
		if not func then
			continue
		end

		local consts = debug.getconstants(func)
		if consts[249] ~= ".lastHBCheck" then
			continue
		end

		local upvalues = debug.getupvalues(func)

		---@note: Only table with boolean values is the input table. Find a better way to filter this?
		for _, upvalue in next, upvalues do
			if typeof(upvalue) ~= "table" or getrawmetatable(upvalue) then
				continue
			end

			if not hasNonBooleans(upvalue) then
				continue
			end

			inputData = upvalue
			break
		end
	end

	return inputData
end

---Validate function.
---@param func function
---@return boolean
function InputClient.validate(func)
	local upvalues = debug.getupvalues(func)

	if not upvalues or #upvalues <= 0 then
		Logger.warn("Skipping function (%s) with no upvalues.", tostring(func))
		return false
	end

	return true
end

---Update cache.
---@param consts any[]
function InputClient.update(consts)
	if consts[2] ~= "wait" then
		return Logger.warn("Ignoring bad update cache call for performance.")
	end

	InputClient.cache()
end

---Cache InputClient module.
-- @note: I sold my soul to the GC gods because there's no other way. Updates are only done when needed.
function InputClient.cache()
	for _, value in next, getgc() do
		if typeof(value) ~= "function" or iscclosure(value) or isexecutorclosure(value) then
			continue
		end

		local functionName = debug.getinfo(value).name
		if not functionName then
			continue
		end

		if functionName ~= "Sprint" and functionName ~= "Roll" then
			continue
		end

		if not InputClient.validate(value) then
			continue
		end

		if functionName == "Sprint" then
			InputClient.sprintFunctionCache = value

			Logger.warn("Sprint function (%s) cache successful.", tostring(value))
		end

		if functionName == "Roll" then
			InputClient.rollFunctionCache = value

			Logger.warn("Roll function (%s) cache successful.", tostring(value))
		end

		if InputClient.sprintFunctionCache and InputClient.rollFunctionCache then
			break
		end
	end
end

-- Return InputClient module.
return InputClient
