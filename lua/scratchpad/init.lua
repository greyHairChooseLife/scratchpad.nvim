local Config = require("scratchpad.config")
local Ui = require("scratchpad.ui")
local Data = require("scratchpad.data")

---@class Scratchpad
---@field config ScratchpadConfig
---@field ui ScratchpadUI
---@field data ScratchpadData
---@field hooks_setup boolean
local Scratchpad = {}

Scratchpad.__index = Scratchpad

---@param scratchpad Scratchpad
local function sync_on_change(scratchpad)
	return scratchpad
end

---@return Scratchpad
function Scratchpad:new()
	local config = Config.get_default_config()

	local scratchpad = setmetatable({
		config = config,
		data = Data.Data:new(config),
		ui = Ui:new(config.settings),
		hooks_setup = false,
	}, self)
	sync_on_change(scratchpad)

	return scratchpad
end

function Scratchpad:__debug_reset()
	require("plenary.reload").reload_module("scratchpad")
end

local the_scratchpad = Scratchpad:new()

---@param self Scratchpad
---@param partial_config ScratchpadPartialConfig?
---@return Scratchpad
function Scratchpad.setup(self, partial_config)
	if self ~= the_scratchpad then
		---@diagnostic disable-next-line: cast-local-type
		partial_config = self
		self = the_scratchpad
	end
	self.config = Config.merge_config(partial_config, self.config)
	self.ui:configure(self.data, self.config.settings)

	vim.api.nvim_create_user_command("Scratch", function(_)
		if self.ui.bufnr ~= nil then
			return
		end
		self.ui:new_scratchpad()
	end, {
		bang = true,
		desc = 'require"scratch".ui:new_scratchpad(false)',
		nargs = 0,
		bar = true,
	})

	return self
end

return the_scratchpad
