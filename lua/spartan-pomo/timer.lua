---@mod spartan-pomo.timer Timer logic using vim.uv

local M = {}

---@type uv_timer_t|nil
M.timer = nil

---@type number Remaining time in seconds
M.remaining = 0

---@type string Current state: "idle" | "work" | "break"
M.state = "idle"

---Start the timer
---@param duration number Duration in minutes
---@param on_tick function Callback for each second
---@param on_complete function Callback when timer completes
function M.start(duration, on_tick, on_complete)
  -- TODO: Implement with vim.uv.new_timer()
end

---Stop the timer
function M.stop()
  -- TODO: Implement
end

---Get remaining time as formatted string
---@return string
function M.get_remaining_display()
  local minutes = math.floor(M.remaining / 60)
  local seconds = M.remaining % 60
  return string.format("%02d:%02d", minutes, seconds)
end

return M
