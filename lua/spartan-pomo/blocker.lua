---@mod spartan-pomo.blocker Input blocking logic

local M = {}

---@type table<string, string> Stored original keymaps
M.saved_maps = {}

---@type boolean Whether blocking is active
M.is_blocking = false

---Enable input blocking
function M.enable()
  -- TODO: Implement key blocking
end

---Disable input blocking
function M.disable()
  -- TODO: Implement key restoration
end

return M
