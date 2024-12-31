# scratchpad.nvim

`scratchpad.nvim` is a customizable and feature-rich Neovim plugin for managing and synchronizing scratchpad data. It provides a flexible configuration system, intuitive UI, and reliable data storage to streamline your development workflow.


https://github.com/user-attachments/assets/876d3a0a-d444-405f-b099-57d24aaf9a82
<!-- TOC -->

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)


<!-- /TOC -->

## Features

- **Customizable Configurations**: Easily extend and merge default configurations to suit your needs.
- **Data Synchronization**: Automatically save and sync scratchpad data with robust error handling.
- **Project Root Detection**: Supports a wide range of project identifiers for seamless integration.
- **Plenary Integration**: Leverages Plenary for file and path operations.

## Installation

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "athar-qadri/scratchpad.nvim",
  requires = { "nvim-lua/plenary.nvim" },
  config = function()
    require("scratchpad").setup()
  end,
}
```

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "athar-qadri/scratchpad.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("scratchpad").setup()
  end,
}
```

## Usage

### Setup

Initialize `scratchpad.nvim` with default settings or provide a custom configuration.

```lua
local scratchpad = require("scratchpad")

-- Default setup
scratchpad.setup()
--or
-- Custom setup
scratchpad.setup({
  settings = {
    sync_on_ui_close = true,
  },
  default = {
    root_patterns = { ".git", "package.json", "README.md" },
  },
})
```
### Keymap Configuration

You can set up custom key mappings for enhanced functionality. Below is an example keymap configuration:

```lua
{
  keys = {
    {
      "<Leader>es",
      function()
        local scratchpad = require("scratchpad")
        scratchpad.ui:new_scratchpad()
      end,
      desc = "open scratchpad",
    },
  },
}
```
### Easy Setup Using Lazy
```lua
return {
  "athar-qadri/scratchpad.nvim",
  opts = {},
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local scratchpad = require("scratchpad")
    scratchpad:setup({ settings = { sync_on_ui_close = true } })
  end,
  keys = {
    {
      "<Leader>es",
      function()
        local scratchpad = require("scratchpad")
        scratchpad.ui:new_scratchpad()
      end,
      desc = "show scratch pad",
    },
  },
}
```
### Example Workflow

1. **Initialize a Scratchpad**:
   The plugin detects your project root and initializes a scratchpad associated with the directory. If no project root is found, your current working directory will be consider for a unique scratchpad.

2. **Synchronize Data**:
   Changes to the scratchpad are saved automatically based on your configuration.

3. **Customize Behavior**:
   Modify setting `sync_on_ui_close` to control how data is managed.

## Configuration

Below is a detailed breakdown of the configuration options available:

### `ScratchpadConfig`

| Key             | Type              | Default Value        | Description                                     |
|------------------|-------------------|----------------------|-------------------------------------------------|
| `sync_on_ui_close`| `boolean`         | `false`              | Save data using vim commands :w / :wq                |
| `sync_on_ui_close` | `boolean`     | `true`              | Sync data when the UI is closed.               |


Refer to `config.lua` for more detailed options and comments.


## Contributing

We welcome contributions! Feel free to submit issues or pull requests to improve the plugin.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

## Acknowledgments

- Built with ❤️ using [Lua](https://www.lua.org/) and [Neovim](https://neovim.io/).
- Inspired by modern Neovim plugin design patterns.
