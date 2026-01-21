---@mod spartan-pomo Spartan Pomodoro Timer
---@brief [[
---A Spartan-style Pomodoro timer that forces you to take breaks.
---@brief ]]

local M = {}

local config = require("spartan-pomo.config")

---Setup the plugin with user configuration
---@param opts table|nil User configuration
function M.setup(opts)
  config.setup(opts)
end

---Start a Pomodoro session
function M.start()
  -- TODO: Implement
end

---Stop the current session
function M.stop()
  -- TODO: Implement
end

return M
