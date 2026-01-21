# spartan-pomo.nvim

A Spartan-style Pomodoro timer for Neovim that **forces** you to take breaks.

## Features

- **Pomodoro Timer**: Default 25-minute work sessions with 5-minute breaks
- **Spartan Mode**: During breaks, a fullscreen blocker prevents all editing
- **Input Blocking**: All key inputs are disabled during break time
- **Emergency Exit**: Hidden escape mechanism for urgent situations
- **Status API**: Integration-ready for statusline plugins (lualine, etc.)

## Requirements

- Neovim >= 0.9.0

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "YOUR_USERNAME/spartan-pomo.nvim",
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
  "YOUR_USERNAME/spartan-pomo.nvim",
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
  work_time = 25,      -- Work session duration in minutes
  break_time = 5,      -- Break duration in minutes
  -- long_break_time = 15,  -- Long break duration (future feature)
  -- long_break_interval = 4,  -- Pomodoros before long break (future feature)
})
```

## Usage

### Commands

| Command | Description |
|---------|-------------|
| `:SpartanStart` | Start a Pomodoro session |
| `:SpartanStop` | Stop the current session |

### Lua API

```lua
local pomo = require("spartan-pomo")

pomo.start()  -- Start a session
pomo.stop()   -- Stop the session
```

## How It Works

1. Start a Pomodoro session with `:SpartanStart`
2. Work for 25 minutes (configurable)
3. When work time ends, a fullscreen blocker appears
4. All inputs are blocked during the 5-minute break
5. After the break, you can start a new session

## License

MIT License - see [LICENSE](LICENSE) for details.
