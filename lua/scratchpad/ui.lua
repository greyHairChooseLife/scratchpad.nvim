---@alias ScratchpadUIData string
---
---@class ScratchpadUI
---@field win_id number
---@field bufnr number
---@field settings ScratchpadSettings
---@field buf_data ScratchpadUIData
local ScratchpadUI = {}

ScratchpadUI.__index = ScratchpadUI

local scratchpad_MENU = "__scratchpad-menu__"
local scratchpad_menu_id = math.random(1000000)

local function get_scratchpad_menu_name()
	scratchpad_menu_id = scratchpad_menu_id + 1
	return scratchpad_MENU .. scratchpad_menu_id
end

local function create_scratchpad_window(config, enter)
	if enter == nil then
		enter = false
	end

	local buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
	local win = vim.api.nvim_open_win(buf, enter or false, config)

	vim.api.nvim_win_set_option(win, "wrap", true)

	local _ = vim.api.nvim_set_option_value("winhl", "Normal:MyHighlight", {})

	if vim.api.nvim_buf_get_name(buf) == "" then
		vim.api.nvim_buf_set_name(buf, get_scratchpad_menu_name())
	end

	vim.api.nvim_set_option_value("buftype", "acwrite", { buf = buf })
	return { buf = buf, win = win }
end

local create_scratchpad_configurations = function()
	local width = math.floor(vim.o.columns * 0.80)
	local height = math.floor(vim.o.lines * 0.60)

	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	return {
		background = {
			relative = "editor",
			width = width + 2,
			height = height + 2,
			style = "minimal",
			col = col,
			row = row,
			zindex = 1,
		},
		body = {
			relative = "editor",
			width = width,
			height = height,
			style = "minimal",
			--border = { " ", " ", " ", " ", " ", " ", " ", " " },
			border = "rounded",
			title = { { "Scratch Pad" } },
			title_pos = "center",
			col = col,
			row = row,
		},
	}
end

local state = {
	floats = {},
}

local foreach_float = function(cb)
	for name, float in pairs(state.floats) do
		cb(name, float)
	end
end

local scratchpad_keymap = function(mode, key, callback)
	vim.keymap.set(mode, key, callback, {
		buffer = state.floats.body.buf,
	})
end

local create_window = function(data)
	local windows = create_scratchpad_configurations()

	--state.floats.background = create_scratchpad_window(windows.background, nil)
	state.floats.body = create_scratchpad_window(windows.body, true)

	vim.api.nvim_buf_set_lines(state.floats.body.buf, 0, -1, false, vim.split(data._data, "\n"))

	scratchpad_keymap("n", "q", function()
		vim.schedule(function()
			require("scratchpad").ui:close_menu()
		end)
	end)

	scratchpad_keymap("n", "<Esc>", function()
		vim.schedule(function()
			require("scratchpad").ui:close_menu()
		end)
	end)

	vim.api.nvim_create_autocmd("BufWriteCmd", {
		buffer = state.floats.body.buf,
		callback = function()
			vim.schedule(function()
				require("scratchpad").ui:sync()
				require("scratchpad").ui:close_menu()
			end)
		end,
	})

	vim.api.nvim_create_autocmd("BufLeave", {
		buffer = state.floats.body.buf,
		callback = function()
			vim.schedule(function()
				require("scratchpad").ui:close_menu()
			end)
		end,
	})

	--local set_win_contents = function(window)
	--  --vim.api.nvim_buf_set_lines(state.floats.body.buf, 0, -1, false, body)
	--end

	vim.api.nvim_create_autocmd("VimResized", {
		group = vim.api.nvim_create_augroup("scratchpad-resized", {}),
		callback = function()
			if not vim.api.nvim_win_is_valid(state.floats.body.win) or state.floats.body.win == nil then
				return
			end

			local updated = create_scratchpad_configurations()
			foreach_float(function(name, _)
				vim.api.nvim_win_set_config(state.floats[name].win, updated[name])
			end)

			-- Re-calculates contents
			--set_win_contents(updated)
		end,
	})
	return state.floats
end

function ScratchpadUI:close_menu()
	if self.settings.sync_on_ui_close and self.bufnr ~= nil then
		require("scratchpad").ui:sync()
	end

	if self.closing then
		return
	end

	self.closing = true

	if self.bufnr ~= nil and vim.api.nvim_buf_is_valid(self.bufnr) then
		vim.api.nvim_buf_delete(self.bufnr, { force = true })
	end

	if self.win_id ~= nil and vim.api.nvim_win_is_valid(self.win_id) then
		vim.api.nvim_win_close(self.win_id, true)
	end

	self.buf_data = nil
	self.win_id = nil
	self.bufnr = nil

	self.closing = false
	local restore = {
		cmdheight = {
			original = vim.o.cmdheight,
			scratchpad = 1,
		},
	}

	for option, config in pairs(restore) do
		vim.opt[option] = config.original
	end
end

function ScratchpadUI:sync()
	local bufnr = self.bufnr
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, true)
	--writing buffer content to scratch pad
	self.data.sync_scratch(self.data, table.concat(lines, "\n"))
end

function ScratchpadUI:new_scratchpad()
	if self.data.has_error == false then
		local workspace = create_window(self.data)

		self.bufnr = workspace.body.buf
		self.win_id = workspace.body.win

		vim.api.nvim_set_option_value("number", true, {
			win = self.win_id,
		})
	end
end

---@param settings ScratchpadSettings
---@param data ScratchpadData
function ScratchpadUI:configure(data, settings)
	self.data = data
	self.settings = settings
end

---Constructor for the ScratchpadUI class.
---@param settings table
function ScratchpadUI:new(settings)
	return setmetatable({
		win_id = nil,
		bufnr = nil,
		buf_data = nil,
		settings = settings,
	}, self)
end

return ScratchpadUI
