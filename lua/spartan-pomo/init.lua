---@mod spartan-pomo Spartan Pomodoro Timer
---@brief [[
---A Spartan-style Pomodoro timer that forces you to take breaks.
---@brief ]]

local M = {}

local config = require("spartan-pomo.config")

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

---Start a Pomodoro session
function M.start()
  if not M._setup_done then
    M.setup({})
  end

  local cfg = config.get()
  notify(string.format(cfg.messages.work_start, cfg.work_time))
  -- TODO: Implement timer logic in Phase 2
end

---Stop the current session
function M.stop()
  local cfg = config.get()
  notify(cfg.messages.session_stop)
  -- TODO: Implement timer stop in Phase 2
end

---Get current configuration (for external use)
---@return SpartanPomoConfig
function M.get_config()
  return config.get()
end

return M
