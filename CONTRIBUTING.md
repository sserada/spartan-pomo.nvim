# Contributing to spartan-pomo.nvim

Thank you for your interest in contributing to spartan-pomo.nvim!

## How to Contribute

### Reporting Bugs

1. Check if the issue already exists in [GitHub Issues](https://github.com/sserada/spartan-pomo.nvim/issues)
2. If not, create a new issue with:
   - Neovim version (`:version`)
   - Plugin version or commit hash
   - Steps to reproduce
   - Expected vs actual behavior
   - Relevant configuration

### Suggesting Features

1. Open an issue with the `enhancement` label
2. Describe the feature and its use case
3. If possible, include examples of how it would work

### Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test your changes thoroughly
5. Commit with clear messages (`git commit -m 'Add amazing feature'`)
6. Push to your branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## Development Setup

### Prerequisites

- Neovim >= 0.9.0
- Git

### Local Development

1. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/spartan-pomo.nvim.git
   cd spartan-pomo.nvim
   ```

2. Add the plugin to your Neovim config for testing:
   ```lua
   -- lazy.nvim
   {
     dir = "~/path/to/spartan-pomo.nvim",
     config = function(_, opts)
       require("spartan-pomo").setup(opts)
     end,
   }
   ```

3. For quick iteration, reload the plugin:
   ```lua
   -- Clear module cache
   for k in pairs(package.loaded) do
     if k:match("^spartan%-pomo") then
       package.loaded[k] = nil
     end
   end
   require("spartan-pomo").setup({})
   ```

## Code Style

- Use 2 spaces for indentation
- Follow existing code patterns
- Add type annotations where helpful
- Keep functions focused and small

## Project Structure

```
spartan-pomo.nvim/
├── lua/
│   └── spartan-pomo/
│       ├── init.lua      # Public API
│       ├── config.lua    # Configuration management
│       ├── timer.lua     # Timer logic (vim.uv/vim.loop)
│       ├── ui.lua        # Fullscreen blocker UI
│       └── blocker.lua   # Input blocking logic
├── plugin/
│   └── spartan-pomo.lua  # User commands
└── doc/
    └── spartan-pomo.txt  # Vim help documentation
```

## Testing

Currently, testing is manual. When testing changes:

1. Test with short timers:
   ```lua
   require("spartan-pomo").setup({
     work_time = 0.1,  -- 6 seconds
     break_time = 0.1, -- 6 seconds
   })
   ```

2. Verify:
   - Timer starts and counts down correctly
   - Blocker appears when work time ends
   - All keys are blocked during break
   - Emergency exit works
   - Timer ends and blocker disappears
   - Status API returns correct values

## Questions?

Feel free to open an issue for any questions about contributing.
