local Path = require("plenary.path")

local data_path = string.format("%s/scratchpad", vim.fn.stdpath("data"))
local ensured_data_path = false

local function ensure_data_path()
	if ensured_data_path then
		return
	end

	local path = Path:new(data_path)
	if not path:exists() then
		path:mkdir()
	end
	ensured_data_path = true
end

local filename = function(config)
	local project_root = vim.fs.root(0, config.default.root_patterns)
	if project_root == nil then
		project_root = vim.fn.getcwd()
	end
	return project_root
	--return config.settings.key()
end

local function hash(path)
	return vim.fn.sha256(path)
end

local function fullpath(config)
	local h = hash(filename(config))
	return string.format("%s/%s", data_path, h)
	--return string.format("%s/%s.json", data_path, h)
end

local function write_data(data, config)
	Path:new(fullpath(config)):write(data, "w")
end

--- @alias ScratchpadRawData {[string]: {[string]: string[]}}

local M = {}

function M.__dangerously_clear_data(config)
	local data = ""
	write_data(data, config)
end

function M.info()
	return {
		data_path = data_path,
	}
end

--- @class ScratchpadData
--- @field _data ScratchpadRawData
--- @field has_error boolean
--- @field config ScratchpadConfig
local Data = {}

Data.__index = Data

---@param config ScratchpadConfig
---@param provided_path string?
---return ScratchpadRawData
local function read_data(config, provided_path)
	ensure_data_path()

	provided_path = provided_path or fullpath(config)
	local path = Path:new(provided_path)
	local exists = path:exists()

	if not exists then
		write_data("", config)
	end

	local out_data = path:read()

	if not out_data or out_data == "" then
		write_data("", config)
		out_data = ""
	end

	---local data = vim.json.decode(out_data)
	---return data
	return out_data
end

---@param config ScratchpadConfig
---@return ScratchpadData
function Data:new(config)
	local ok, data = pcall(read_data, config)

	return setmetatable({
		_data = data,
		has_error = not ok,
		config = config,
	}, self)
end

---@param data ScratchpadUIData
function Data:sync_scratch(data)
	pcall(write_data, data, self.config)
end

M.Data = Data
M.test = {
	set_fullpath = function(fp)
		fullpath = fp
	end,

	read_data = read_data,
}

return M
