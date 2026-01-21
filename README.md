# spartan-pomo.nvim

A Spartan-style Pomodoro timer for Neovim that **forces** you to take breaks.

## Features

- **Pomodoro Timer**: Default 25-minute work sessions with 5-minute breaks
- **Spartan Mode**: During breaks, a fullscreen blocker prevents all editing
- **Input Blocking**: All key inputs are disabled during break time
- **Emergency Exit**: Escape mechanism for urgent situations (`<Leader><Leader>q`)
- **Status API**: Integration-ready for statusline plugins (lualine, etc.)

## Requirements

- Neovim >= 0.9.0

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "sserada/spartan-pomo.nvim",
  config = function()
    require("spartan-pomo").setup({
      -- your configuration
    })
  end,
}
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "sserada/spartan-pomo.nvim",
  config = function()
    require("spartan-pomo").setup({
      -- your configuration
    })
  end,
}
```

## Configuration

```lua
require("spartan-pomo").setup({
  -- Timer settings
  work_time = 25,      -- Work session duration in minutes
  break_time = 5,      -- Break duration in minutes

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
  -- ascii_art = { "YOUR", "CUSTOM", "ART" },
})
```

## Usage

### Commands

| Command | Description |
|---------|-------------|
| `:SpartanStart` | Start a Pomodoro session |
| `:SpartanStop` | Stop the current session |
| `:SpartanStatus` | Show current session status |

### Lua API

```lua
local pomo = require("spartan-pomo")

pomo.start()       -- Start a session
pomo.stop()        -- Stop the session
pomo.get_status()  -- Get current status {state, remaining, remaining_seconds}
pomo.get_config()  -- Get current configuration
```

### Statusline Integration

Example for lualine:

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
      },
    },
  },
})
```

## How It Works

1. Start a Pomodoro session with `:SpartanStart`
2. Work for 25 minutes (configurable)
3. When work time ends, a fullscreen blocker appears
4. **All inputs are blocked** during the break - this is the "Spartan" feature!
5. After the break ends, the blocker disappears automatically
6. Use `<Leader><Leader>q` for emergency exit if absolutely necessary

## Highlight Groups

You can customize the appearance by overriding these highlight groups:

| Group | Description |
|-------|-------------|
| `SpartanPomoBackground` | Background color of the blocker |
| `SpartanPomoTitle` | ASCII art color |
| `SpartanPomoTimer` | Timer display color |
| `SpartanPomoMessage` | Message text color |

Example:

```lua
vim.api.nvim_set_hl(0, "SpartanPomoBackground", { bg = "#000000" })
```

## License

MIT License - see [LICENSE](LICENSE) for details.
