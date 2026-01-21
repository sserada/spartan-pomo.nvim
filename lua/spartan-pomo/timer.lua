---@mod spartan-pomo.timer Timer logic using vim.uv/vim.loop

local M = {}

-- Compatibility: vim.uv (0.10+) or vim.loop (0.9.x)
local uv = vim.uv or vim.loop

---@type uv_timer_t|nil
M._timer = nil

---@type number Remaining time in seconds
M.remaining = 0

---@type string Current state: "idle" | "work" | "break" | "paused"
M.state = "idle"

---@type number Completed pomodoros count
M.completed_count = 0

---@type boolean Whether timer is paused
M._is_paused = false

---@type string State before pause (to restore on resume)
M._paused_state = nil

---@type function|nil Callback for each tick
M._on_tick = nil

---@type function|nil Callback when timer completes
M._on_complete = nil

---Start the timer
---@param duration_minutes number Duration in minutes
---@param on_tick function|nil Callback for each second (receives remaining seconds)
---@param on_complete function Callback when timer completes
function M.start(duration_minutes, on_tick, on_complete)
  -- Stop any existing timer
  M.stop()

  M.remaining = duration_minutes * 60
  M._on_tick = on_tick
  M._on_complete = on_complete

  -- Create a new timer using libuv
  M._timer = uv.new_timer()

  -- Start timer: 1000ms delay, then repeat every 1000ms
  M._timer:start(
    1000,
    1000,
    vim.schedule_wrap(function()
      M.remaining = M.remaining - 1

      -- Call tick callback if provided
      if M._on_tick then
        M._on_tick(M.remaining)
      end

      -- Check if timer completed
      if M.remaining <= 0 then
        -- Save callback before stop() clears it
        local on_complete = M._on_complete
        M.stop()
        if on_complete then
          on_complete()
        end
      end
    end)
  )
end

---Stop the timer
function M.stop()
  if M._timer then
    M._timer:stop()
    M._timer:close()
    M._timer = nil
  end
  M._on_tick = nil
  M._on_complete = nil
end

---Check if timer is running
---@return boolean
function M.is_running()
  return M._timer ~= nil and M.remaining > 0
end

---Get remaining time as formatted string
---@return string
function M.get_remaining_display()
  local minutes = math.floor(M.remaining / 60)
  local seconds = M.remaining % 60
  return string.format("%02d:%02d", minutes, seconds)
end

---Get current state and remaining time for statusline
---@return table {state: string, remaining: string, remaining_seconds: number, completed_count: number}
function M.get_status()
  return {
    state = M.state,
    remaining = M.get_remaining_display(),
    remaining_seconds = M.remaining,
    completed_count = M.completed_count,
  }
end

---Reset completed count
function M.reset_count()
  M.completed_count = 0
end

---Pause the timer
function M.pause()
  if not M.is_running() or M._is_paused then
    return false
  end

  -- Stop the timer but keep callbacks and remaining time
  if M._timer then
    M._timer:stop()
    M._timer:close()
    M._timer = nil
  end

  -- Save current state and mark as paused
  M._paused_state = M.state
  M.state = "paused"
  M._is_paused = true

  return true
end

---Resume the paused timer
function M.resume()
  if not M._is_paused then
    return false
  end

  -- Restore state
  M.state = M._paused_state
  M._is_paused = false
  M._paused_state = nil

  -- Restart timer with remaining time
  local remaining_minutes = M.remaining / 60
  local on_tick = M._on_tick
  local on_complete = M._on_complete

  -- Clear callbacks temporarily to avoid stop() clearing them
  M._on_tick = nil
  M._on_complete = nil

  -- Create new timer
  M._timer = uv.new_timer()

  -- Restore callbacks
  M._on_tick = on_tick
  M._on_complete = on_complete

  -- Start timer
  M._timer:start(
    1000,
    1000,
    vim.schedule_wrap(function()
      M.remaining = M.remaining - 1

      -- Call tick callback if provided
      if M._on_tick then
        M._on_tick(M.remaining)
      end

      -- Check if timer completed
      if M.remaining <= 0 then
        -- Save callback before stop() clears it
        local complete_callback = M._on_complete
        M.stop()
        if complete_callback then
          complete_callback()
        end
      end
    end)
  )

  return true
end

---Check if timer is paused
---@return boolean
function M.is_paused()
  return M._is_paused
end

return M
