---@mod spartan-pomo Spartan Pomodoro Timer
---@brief [[
---A Spartan-style Pomodoro timer that forces you to take breaks.
---@brief ]]

local M = {}

local config = require("spartan-pomo.config")
local timer = require("spartan-pomo.timer")
local ui = require("spartan-pomo.ui")

---@type boolean Whether the plugin has been setup
M._setup_done = false

---Setup the plugin with user configuration
---@param opts table|nil User configuration
function M.setup(opts)
  config.setup(opts)
  M._setup_done = true
end

---Notify helper function
---@param msg string Message to display
---@param level number|nil Notification level (vim.log.levels)
local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = "Spartan Pomo" })
end

---Emergency stop (called from blocker)
local function emergency_stop()
  timer.stop()
  timer.state = "idle"
  ui.hide()
  notify("Emergency exit! Session stopped.", vim.log.levels.WARN)
end

---Start break session
local function start_break()
  local cfg = config.get()
  timer.state = "break"

  -- Initialize remaining time first (before showing UI)
  timer.remaining = cfg.break_time * 60

  notify(string.format(cfg.messages.break_start, cfg.break_time), vim.log.levels.WARN)

  -- Show blocker UI with emergency exit callback
  ui.show(timer.get_remaining_display(), emergency_stop)

  -- Start break timer with tick callback to update UI
  timer.start(cfg.break_time, function(remaining)
    -- Update UI every second
    ui.update_content(timer.get_remaining_display())
  end, function()
    -- Break completed
    timer.state = "idle"

    -- Hide blocker UI
    ui.hide()

    notify(cfg.messages.break_end)
  end)
end

---Start work session
local function start_work()
  local cfg = config.get()
  timer.state = "work"

  notify(string.format(cfg.messages.work_start, cfg.work_time))

  timer.start(cfg.work_time, nil, function()
    -- Work time completed, start break
    notify(cfg.messages.work_end, vim.log.levels.WARN)
    start_break()
  end)
end

---Start a Pomodoro session
function M.start()
  if not M._setup_done then
    M.setup({})
  end

  -- Don't start if already running
  if timer.is_running() then
    notify("Pomodoro is already running! (" .. timer.state .. ": " .. timer.get_remaining_display() .. ")", vim.log.levels.WARN)
    return
  end

  start_work()
end

---Stop the current session
function M.stop()
  if not timer.is_running() then
    notify("No active Pomodoro session.", vim.log.levels.WARN)
    return
  end

  timer.stop()
  timer.state = "idle"

  -- Hide blocker UI if visible
  if ui.is_visible() then
    ui.hide()
  end

  local cfg = config.get()
  notify(cfg.messages.session_stop)
end

---Get current status (for statusline integration)
---@return table {state: string, remaining: string, remaining_seconds: number}
function M.get_status()
  return timer.get_status()
end

---Get current configuration (for external use)
---@return SpartanPomoConfig
function M.get_config()
  return config.get()
end

return M
