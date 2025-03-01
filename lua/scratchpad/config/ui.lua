---@class ScratchpadUIConfig
---@field window table Window size and position settings
---@field border table Border style settings
---@field win_options table Window options
---@field keymaps table Keymap customization

---@type ScratchpadUIConfig
local default_ui_config = {
	window = {
		width = 0.8, -- screen width ratio
		height = 0.6, -- screen height ratio
		relative = "editor",
		row = 0.5, -- vertical position (0.5 = center)
		col = 0.5, -- horizontal position (0.5 = center)
		zindex = 1,
	},
	border = {
		style = "rounded", -- none, single, double, rounded, shadow, etc
		title = {
			text = "Scratch Pad", -- default title
			position = "center", -- left/center/right
		},
		footer = {
			text = nil, -- nil means use filename
			position = "center", -- left/center/right
		},
	},
	win_options = {
		wrap = true,
		breakindent = true,
		breakindentopt = "list:-1",
		number = true,
		winhl = "Normal:MyHighlight",
	},
	keymaps = {
		close = { "q", "<Esc>" }, -- close keymaps
		write_quit = nil, -- save and close keymap
	},
}

return default_ui_config
