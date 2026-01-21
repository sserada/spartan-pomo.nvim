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

---@type uv_timer_t|nil Auto-continue countdown timer
local _countdown_timer = nil

---Cancel auto-continue countdown
local function cancel_countdown()
  if _countdown_timer then
    local uv = vim.uv or vim.loop
    _countdown_timer:stop()
    _countdown_timer:close()
    _countdown_timer = nil
  end
end

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

-- Forward declarations
local start_work
local start_break

---Start break session
start_break = function()
  local cfg = config.get()
  timer.state = "break"

  -- Increment completed count
  timer.completed_count = timer.completed_count + 1

  -- Determine if this should be a long break
  local is_long_break = timer.completed_count % cfg.long_break_interval == 0
  local break_duration = is_long_break and cfg.long_break_time or cfg.break_time

  -- Initialize remaining time first (before showing UI)
  timer.remaining = break_duration * 60

  -- Notify based on break type
  if is_long_break then
    notify(
      string.format(cfg.messages.long_break_start, cfg.long_break_time, timer.completed_count, cfg.long_break_interval),
      vim.log.levels.WARN
    )
  else
    notify(string.format(cfg.messages.break_start, cfg.break_time), vim.log.levels.WARN)
  end

  -- Show blocker UI with emergency exit callback
  ui.show(timer.get_remaining_display(), emergency_stop)

  -- Start break timer with tick callback to update UI
  timer.start(break_duration, function(remaining)
    -- Update UI every second
    ui.update_content(timer.get_remaining_display())
  end, function()
    -- Break completed
    timer.state = "idle"

    -- Hide blocker UI
    ui.hide()

    notify(cfg.messages.break_end)

    -- Auto-continue if enabled
    if cfg.auto_continue then
      local countdown = cfg.auto_continue_delay
      local uv = vim.uv or vim.loop
      _countdown_timer = uv.new_timer()

      _countdown_timer:start(
        0,
        1000,
        vim.schedule_wrap(function()
          if countdown > 0 then
            notify(string.format(cfg.messages.auto_continue_countdown, countdown))
            countdown = countdown - 1
          else
            cancel_countdown()
            start_work()
          end
        end)
      )
    end
  end)
end

---Start work session
start_work = function()
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
    notify(
      "Pomodoro is already running! (" .. timer.state .. ": " .. timer.get_remaining_display() .. ")",
      vim.log.levels.WARN
    )
    return
  end

  start_work()
end

---Stop the current session
function M.stop()
  -- Cancel auto-continue countdown if active
  cancel_countdown()

  if not timer.is_running() and not _countdown_timer then
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

---Reset completed pomodoro count
function M.reset_count()
  timer.reset_count()
  notify("Pomodoro count reset to 0.")
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
