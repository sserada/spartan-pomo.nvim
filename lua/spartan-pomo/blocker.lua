---@mod spartan-pomo.blocker Input blocking logic

local M = {}

local config = require("spartan-pomo.config")

---@type boolean Whether blocking is active
M._is_blocking = false

---@type number|nil Buffer where blocking is applied
M._blocked_buf = nil

---@type function|nil Emergency exit callback
M._on_emergency_exit = nil

-- Keys to block in all modes
local blocked_keys = {
  -- Movement
  "h", "j", "k", "l",
  "w", "W", "b", "B", "e", "E",
  "0", "^", "$",
  "gg", "G",
  "<C-d>", "<C-u>", "<C-f>", "<C-b>",
  "<Up>", "<Down>", "<Left>", "<Right>",
  "<PageUp>", "<PageDown>", "<Home>", "<End>",
  -- Insert mode triggers
  "i", "I", "a", "A", "o", "O",
  "s", "S", "c", "C",
  "r", "R",
  -- Visual mode
  "v", "V", "<C-v>",
  -- Editing
  "d", "D", "x", "X",
  "y", "Y", "p", "P",
  "u", "<C-r>",
  ".", "~",
  -- Search
  "/", "?", "n", "N", "*", "#",
  -- Commands
  ":", "q", "Q", "Z",
  -- Window/buffer
  "<C-w>",
  -- Escape and interrupt
  "<Esc>", "<C-c>", "<C-[>",
  -- Other
  "<CR>", "<Space>", "<Tab>", "<BS>",
  "m", "'", "`", "f", "F", "t", "T",
  ";", ",",
}

-- All modes to block
local blocked_modes = { "n", "i", "v", "x", "s", "o", "c", "t" }

---Set a <Nop> mapping for a key in the buffer
---@param buf number Buffer number
---@param mode string Mode
---@param key string Key to block
local function block_key(buf, mode, key)
  pcall(vim.api.nvim_buf_set_keymap, buf, mode, key, "<Nop>", {
    noremap = true,
    silent = true,
    nowait = true,
  })
end

---Enable input blocking on a buffer
---@param buf number Buffer number to block
---@param on_emergency_exit function|nil Callback when emergency exit is triggered
function M.enable(buf, on_emergency_exit)
  if M._is_blocking then
    return
  end

  M._blocked_buf = buf
  M._on_emergency_exit = on_emergency_exit
  M._is_blocking = true

  -- Block all keys in all modes
  for _, mode in ipairs(blocked_modes) do
    for _, key in ipairs(blocked_keys) do
      block_key(buf, mode, key)
    end

    -- Block all printable characters
    for i = 32, 126 do
      local char = string.char(i)
      -- Skip if already in blocked_keys
      if not vim.tbl_contains(blocked_keys, char) then
        block_key(buf, mode, char)
      end
    end
  end

  -- Setup emergency exit key
  local cfg = config.get()
  local emergency_key = cfg.emergency_key

  vim.api.nvim_buf_set_keymap(buf, "n", emergency_key, "", {
    noremap = true,
    silent = true,
    nowait = true,
    callback = function()
      if M._on_emergency_exit then
        M._on_emergency_exit()
      end
    end,
  })

  -- Also block trying to close the window with :q, :qa, :wq, etc.
  -- by making the buffer non-closable via autocmd
  vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
    buffer = buf,
    callback = function()
      -- If still blocking, prevent leaving
      if M._is_blocking and M._blocked_buf == buf then
        -- Return to the blocker window
        vim.schedule(function()
          local ui = require("spartan-pomo.ui")
          if ui.is_visible() and ui._win then
            pcall(vim.api.nvim_set_current_win, ui._win)
          end
        end)
        return true
      end
    end,
  })

  -- Block :quit and similar commands
  vim.api.nvim_create_autocmd("QuitPre", {
    buffer = buf,
    callback = function()
      if M._is_blocking then
        vim.notify("Cannot quit during break! Use emergency key to exit.", vim.log.levels.ERROR, { title = "Spartan Pomo" })
        return true
      end
    end,
  })
end

---Disable input blocking
function M.disable()
  M._is_blocking = false
  M._blocked_buf = nil
  M._on_emergency_exit = nil
  -- Keymaps are automatically cleaned up when buffer is deleted
end

---Check if blocking is currently active
---@return boolean
function M.is_active()
  return M._is_blocking
end

return M
