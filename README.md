# spartan-pomo.nvim

[![Neovim](https://img.shields.io/badge/Neovim-0.9%2B-green?logo=neovim&logoColor=white)](https://neovim.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A Spartan-style Pomodoro timer for Neovim that **forces** you to take breaks.

> "No retreat, no surrender. Take your break." - Spartan Pomo

## Why Spartan?

Most Pomodoro apps *suggest* you take a break. **Spartan Pomo forces it.**

When break time arrives, your entire editor is blocked with a fullscreen overlay. No editing, no scrolling, no "just one more line" - your eyes and mind get the rest they need.

## Features

- **Pomodoro Timer**: Default 25-minute work sessions with 5-minute breaks
- **Spartan Mode**: During breaks, a fullscreen blocker prevents all editing
- **Input Blocking**: All key inputs are disabled during break time
- **Emergency Exit**: Escape mechanism for urgent situations (`<Leader><Leader>q`)
- **Status API**: Integration-ready for statusline plugins (lualine, etc.)
- **Customizable**: ASCII art, messages, and timing are all configurable

## Requirements

- Neovim >= 0.9.0

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim) (Recommended)

```lua
{
  "sserada/spartan-pomo.nvim",
  cmd = { "SpartanStart", "SpartanStop", "SpartanStatus" },
  keys = {
    { "<Leader>ps", "<cmd>SpartanStart<cr>", desc = "Pomodoro Start" },
    { "<Leader>px", "<cmd>SpartanStop<cr>", desc = "Pomodoro Stop" },
    { "<Leader>pp", "<cmd>SpartanStatus<cr>", desc = "Pomodoro Status" },
  },
  opts = {
    work_time = 25,
    break_time = 5,
  },
  config = function(_, opts)
    require("spartan-pomo").setup(opts)
  end,
}
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "sserada/spartan-pomo.nvim",
  config = function()
    require("spartan-pomo").setup({
      work_time = 25,
      break_time = 5,
    })
  end,
}
```

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'sserada/spartan-pomo.nvim'

" In your init.lua or after/plugin:
lua require("spartan-pomo").setup({})
```

## Configuration

```lua
require("spartan-pomo").setup({
  -- Timer settings (in minutes)
  work_time = 25,
  break_time = 5,

  -- Emergency exit key (for urgent situations only)
  emergency_key = "<Leader><Leader>q",

  -- Notification messages (optional)
  messages = {
    work_start = "Pomodoro started! Focus for %d minutes.",
    work_end = "Time's up! Take a break.",
    break_start = "Break time! Rest for %d minutes.",
    break_end = "Break over! Ready to work again.",
    session_stop = "Pomodoro session stopped.",
  },

  -- Custom ASCII art for break screen (optional)
  -- ascii_art = { "LINE1", "LINE2", "..." },
})
```

### Default Values

| Option | Default | Description |
|--------|---------|-------------|
| `work_time` | `25` | Work session duration in minutes |
| `break_time` | `5` | Break duration in minutes |
| `emergency_key` | `<Leader><Leader>q` | Key to exit break in emergencies |

## Usage

### Commands

| Command | Description |
|---------|-------------|
| `:SpartanStart` | Start a Pomodoro session |
| `:SpartanStop` | Stop the current session |
| `:SpartanStatus` | Show current session status |

### Suggested Keymaps

```lua
vim.keymap.set("n", "<Leader>ps", "<cmd>SpartanStart<cr>", { desc = "Pomodoro Start" })
vim.keymap.set("n", "<Leader>px", "<cmd>SpartanStop<cr>", { desc = "Pomodoro Stop" })
vim.keymap.set("n", "<Leader>pp", "<cmd>SpartanStatus<cr>", { desc = "Pomodoro Status" })
```

### Lua API

```lua
local pomo = require("spartan-pomo")

pomo.start()       -- Start a session
pomo.stop()        -- Stop the session
pomo.get_status()  -- Get current status {state, remaining, remaining_seconds}
pomo.get_config()  -- Get current configuration
```

## Statusline Integration

### lualine.nvim

```lua
require("lualine").setup({
  sections = {
    lualine_x = {
      {
        function()
          local status = require("spartan-pomo").get_status()
          if status.state == "idle" then
            return ""
          end
          local icon = status.state == "work" and "󰔟 " or "󰒲 "
          return icon .. status.remaining
        end,
        cond = function()
          return require("spartan-pomo").get_status().state ~= "idle"
        end,
      },
    },
  },
})
```

### heirline.nvim

```lua
local SpartanPomo = {
  condition = function()
    return require("spartan-pomo").get_status().state ~= "idle"
  end,
  provider = function()
    local status = require("spartan-pomo").get_status()
    local icon = status.state == "work" and "󰔟 " or "󰒲 "
    return icon .. status.remaining
  end,
}
```

## How It Works

```
┌─────────────────────────────────────────────────────────────┐
│  :SpartanStart                                              │
│       │                                                     │
│       ▼                                                     │
│  ┌─────────┐    25 min    ┌─────────┐    5 min    ┌─────┐  │
│  │  WORK   │ ──────────►  │  BREAK  │ ──────────► │IDLE │  │
│  │         │              │(blocked)│             │     │  │
│  └─────────┘              └─────────┘             └─────┘  │
│       ▲                        │                     │      │
│       │                        │ emergency           │      │
│       │                        ▼ exit                │      │
│       └────────────────────────┴─────────────────────┘      │
│                          :SpartanStart                      │
└─────────────────────────────────────────────────────────────┘
```

1. Start a Pomodoro session with `:SpartanStart`
2. Work for 25 minutes (configurable)
3. When work time ends, a fullscreen blocker appears
4. **All inputs are blocked** during the break - this is the "Spartan" feature!
5. After the break ends, the blocker disappears automatically
6. Use `<Leader><Leader>q` for emergency exit if absolutely necessary

## Customization

### Highlight Groups

| Group | Default | Description |
|-------|---------|-------------|
| `SpartanPomoBackground` | `bg=#1a1a2e` | Background color of the blocker |
| `SpartanPomoTitle` | `fg=#ff6b6b` | ASCII art color |
| `SpartanPomoTimer` | `fg=#4ecdc4` | Timer display color |
| `SpartanPomoMessage` | `fg=#ffe66d` | Message text color |

Example customization:

```lua
vim.api.nvim_set_hl(0, "SpartanPomoBackground", { bg = "#000000" })
vim.api.nvim_set_hl(0, "SpartanPomoTimer", { fg = "#00ff00", bold = true })
```

### Custom ASCII Art

```lua
require("spartan-pomo").setup({
  ascii_art = {
    "",
    "  ╔══════════════════════════════╗",
    "  ║     TAKE A BREAK, HUMAN!     ║",
    "  ╚══════════════════════════════╝",
    "",
  },
})
```

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT License - see [LICENSE](LICENSE) for details.

## Acknowledgments

- Inspired by the Pomodoro Technique by Francesco Cirillo
- Built with love for the Neovim community
