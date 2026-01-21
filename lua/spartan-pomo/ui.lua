---@mod spartan-pomo.ui Blocker UI module

local M = {}

---@type number|nil Buffer number for the blocker window
M.buf = nil

---@type number|nil Window number for the blocker window
M.win = nil

---Show the fullscreen blocker window
---@param message string|nil Optional message to display
function M.show(message)
  -- TODO: Implement with nvim_open_win
end

---Hide the blocker window
function M.hide()
  -- TODO: Implement
end

---Update the displayed content
---@param content string[] Lines to display
function M.update_content(content)
  -- TODO: Implement
end

return M
