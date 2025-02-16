---@class Logger
local Logger = {}
Logger.__index = Logger


---Create new Logger object.
---@return Logger
function Logger.new()
	local self = setmetatable({}, Logger)
	return self
end
