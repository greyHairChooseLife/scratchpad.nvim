# scratchpad.nvim

`scratchpad.nvim` is a customizable and feature-rich Neovim plugin for managing and synchronizing scratchpad data. It provides a flexible configuration system, intuitive UI, and reliable data storage to streamline your development workflow.

<!--https://github.com/user-attachments/assets/876d3a0a-d444-405f-b099-57d24aaf9a82-->
<!--https://github.com/user-attachments/assets/21e7a8cc-5298-469f-b542-cbac090e4dd8-->
<!--https://github.com/user-attachments/assets/2d40274a-5545-4421-871d-0e660978a06b-->
https://github.com/user-attachments/assets/ed20ef40-8820-45c3-b06e-dc65f118b443


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
    require("scratchpad"):setup()
  end,
}
```

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "athar-qadri/scratchpad.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("scratchpad"):setup()
  end,
}
```

## Usage

### Setup

Initialize `scratchpad.nvim` with default settings or provide a custom configuration.

```lua
local scratchpad = require("scratchpad")

-- Default setup
scratchpad:setup()
--or
-- Custom setup
scratchpad:setup({
  settings = {
    sync_on_ui_close = true,
  },
  default = {
  --here you specify project root identifiers (Cargo.toml, package.json, blah-blah-blah)
  --or let your man do the job
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
  event = "VeryLazy",
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

**Run the command `:Scratch` to open Scratchpad for your current project. Use Vim motions to read/write/delete/fly within the scratchpad.**

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

| Key                | Description                                                                                   |
| ------------------ | --------------------------------------------------------------------------------------------- |
| `sync_on_ui_close` | any time the ui menu is closed then the state of the scratchpad will be sync'd back to the fs |

Refer to `config.lua` for more detailed options and comments.

## Contributing

We welcome contributions! Feel free to submit issues or pull requests to improve the plugin.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

## Acknowledgments

- Built with ❤️ using [Lua](https://www.lua.org/) and [Neovim](https://neovim.io/).
- Inspired by modern Neovim plugin design patterns.
