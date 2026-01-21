---@mod spartan-pomo.ui Blocker UI module

local M = {}

local config = require("spartan-pomo.config")

---@type number|nil Buffer number for the blocker window
M._buf = nil

---@type number|nil Window number for the blocker window
M._win = nil

---@type number|nil Namespace for highlights
M._ns = nil

---Get or create namespace for highlights
---@return number
local function get_namespace()
  if not M._ns then
    M._ns = vim.api.nvim_create_namespace("spartan_pomo")
  end
  return M._ns
end

---Create highlight groups
local function setup_highlights()
  vim.api.nvim_set_hl(0, "SpartanPomoTitle", { fg = "#ff6b6b", bold = true })
  vim.api.nvim_set_hl(0, "SpartanPomoTimer", { fg = "#4ecdc4", bold = true })
  vim.api.nvim_set_hl(0, "SpartanPomoMessage", { fg = "#ffe66d" })
  vim.api.nvim_set_hl(0, "SpartanPomoBackground", { bg = "#1a1a2e" })
end

---Center text within a given width
---@param text string Text to center
---@param width number Total width
---@return string
local function center_text(text, width)
  local text_width = vim.fn.strdisplaywidth(text)
  if text_width >= width then
    return text
  end
  local padding = math.floor((width - text_width) / 2)
  return string.rep(" ", padding) .. text
end

---Build the content to display in the blocker window
---@param remaining_display string Remaining time as "MM:SS"
---@return string[]
local function build_content(remaining_display)
  local cfg = config.get()
  local lines = {}

  -- Get window dimensions
  local width = vim.o.columns
  local height = vim.o.lines

  -- Calculate vertical padding to center content
  local ascii_lines = cfg.ascii_art
  local content_height = #ascii_lines + 6 -- ASCII + spacing + timer + message
  local top_padding = math.floor((height - content_height) / 2)

  -- Add top padding
  for _ = 1, math.max(0, top_padding) do
    table.insert(lines, "")
  end

  -- Add ASCII art (centered)
  for _, line in ipairs(ascii_lines) do
    table.insert(lines, center_text(line, width))
  end

  -- Add spacing
  table.insert(lines, "")
  table.insert(lines, "")

  -- Add remaining time (centered)
  local timer_text = "[ " .. remaining_display .. " ]"
  table.insert(lines, center_text(timer_text, width))

  -- Add spacing
  table.insert(lines, "")

  -- Add message (centered)
  local message = "Take a break. Your eyes and mind need rest."
  table.insert(lines, center_text(message, width))

  -- Fill remaining space
  local remaining_lines = height - #lines
  for _ = 1, math.max(0, remaining_lines) do
    table.insert(lines, "")
  end

  return lines
end

---Check if the blocker window is currently visible
---@return boolean
function M.is_visible()
  return M._win ~= nil and vim.api.nvim_win_is_valid(M._win)
end

---Show the fullscreen blocker window
---@param remaining_display string|nil Initial remaining time display
function M.show(remaining_display)
  -- Don't create another window if already visible
  if M.is_visible() then
    return
  end

  setup_highlights()

  -- Create a new buffer
  M._buf = vim.api.nvim_create_buf(false, true)

  -- Set buffer options
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = M._buf })
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = M._buf })
  vim.api.nvim_set_option_value("swapfile", false, { buf = M._buf })
  vim.api.nvim_set_option_value("modifiable", false, { buf = M._buf })

  -- Get editor dimensions
  local width = vim.o.columns
  local height = vim.o.lines

  -- Create fullscreen floating window with highest z-index
  local win_opts = {
    relative = "editor",
    width = width,
    height = height,
    row = 0,
    col = 0,
    style = "minimal",
    border = "none",
    zindex = 1000, -- Highest z-index to cover everything
    focusable = true,
  }

  M._win = vim.api.nvim_open_win(M._buf, true, win_opts)

  -- Set window options
  vim.api.nvim_set_option_value("winhl", "Normal:SpartanPomoBackground", { win = M._win })
  vim.api.nvim_set_option_value("cursorline", false, { win = M._win })
  vim.api.nvim_set_option_value("number", false, { win = M._win })
  vim.api.nvim_set_option_value("relativenumber", false, { win = M._win })
  vim.api.nvim_set_option_value("signcolumn", "no", { win = M._win })

  -- Set initial content
  M.update_content(remaining_display or "05:00")

  -- Handle window resize
  vim.api.nvim_create_autocmd("VimResized", {
    buffer = M._buf,
    callback = function()
      if M.is_visible() then
        -- Update window size
        vim.api.nvim_win_set_config(M._win, {
          relative = "editor",
          width = vim.o.columns,
          height = vim.o.lines,
          row = 0,
          col = 0,
        })
      end
    end,
  })
end

---Hide the blocker window
function M.hide()
  if M._win and vim.api.nvim_win_is_valid(M._win) then
    vim.api.nvim_win_close(M._win, true)
  end
  M._win = nil

  if M._buf and vim.api.nvim_buf_is_valid(M._buf) then
    vim.api.nvim_buf_delete(M._buf, { force = true })
  end
  M._buf = nil
end

---Update the displayed content with new remaining time
---@param remaining_display string Remaining time as "MM:SS"
function M.update_content(remaining_display)
  if not M._buf or not vim.api.nvim_buf_is_valid(M._buf) then
    return
  end

  local content = build_content(remaining_display)

  -- Make buffer modifiable, set content, then lock it again
  vim.api.nvim_set_option_value("modifiable", true, { buf = M._buf })
  vim.api.nvim_buf_set_lines(M._buf, 0, -1, false, content)
  vim.api.nvim_set_option_value("modifiable", false, { buf = M._buf })
end

return M
