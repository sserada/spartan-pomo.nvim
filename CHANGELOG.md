# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
