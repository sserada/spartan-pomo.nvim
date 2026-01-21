# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Long break support after configurable number of pomodoros
- `long_break_time` configuration option (default: 15 minutes)
- `long_break_interval` configuration option (default: 4 pomodoros)
- Completed pomodoro counter tracking
- `:SpartanReset` command to reset completed count
- `reset_count()` Lua API function
- Completed count in `:SpartanStatus` output and `get_status()` API
- Auto-continue feature to automatically start next session after break
- `auto_continue` configuration option (default: false)
- `auto_continue_delay` configuration option (default: 3 seconds)
- Countdown notification before auto-start
- Auto-continue can be cancelled with `:SpartanStop`
- Pause/Resume functionality for handling interruptions
- `:SpartanPause` command to pause current session
- `:SpartanResume` command to resume paused session
- `pause()` and `resume()` Lua API functions
- Paused state preserves remaining time and callbacks
- Blocker UI hides during pause and shows again on resume (for breaks)

## [1.0.0] - 2025-01-22

### Added

- Initial release
- Pomodoro timer with configurable work/break durations
- Fullscreen blocker UI during breaks
- Complete input blocking during break time
- Emergency exit key (`<Leader><Leader>q` by default)
- User commands: `:SpartanStart`, `:SpartanStop`, `:SpartanStatus`
- Lua API: `start()`, `stop()`, `get_status()`, `get_config()`
- Statusline integration support
- Customizable ASCII art and messages
- Customizable highlight groups
- Support for Neovim 0.9.0+ (vim.loop) and 0.10+ (vim.uv)
