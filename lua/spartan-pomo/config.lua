---@mod spartan-pomo.config Configuration module

local M = {}

-- Default ASCII art for break screen
local default_ascii_art = {
  "",
  "",
  "  ███████╗████████╗ ██████╗ ██████╗ ██╗",
  "  ██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗██║",
  "  ███████╗   ██║   ██║   ██║██████╔╝██║",
  "  ╚════██║   ██║   ██║   ██║██╔═══╝ ╚═╝",
  "  ███████║   ██║   ╚██████╔╝██║     ██╗",
  "  ╚══════╝   ╚═╝    ╚═════╝ ╚═╝     ╚═╝",
  "",
  "  ████████╗ █████╗ ██╗  ██╗███████╗",
  "  ╚══██╔══╝██╔══██╗██║ ██╔╝██╔════╝",
  "     ██║   ███████║█████╔╝ █████╗  ",
  "     ██║   ██╔══██║██╔═██╗ ██╔══╝  ",
  "     ██║   ██║  ██║██║  ██╗███████╗",
  "     ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝",
  "",
  "   █████╗     ██████╗ ██████╗ ███████╗ █████╗ ██╗  ██╗",
  "  ██╔══██╗    ██╔══██╗██╔══██╗██╔════╝██╔══██╗██║ ██╔╝",
  "  ███████║    ██████╔╝██████╔╝█████╗  ███████║█████╔╝ ",
  "  ██╔══██║    ██╔══██╗██╔══██╗██╔══╝  ██╔══██║██╔═██╗ ",
  "  ██║  ██║    ██████╔╝██║  ██║███████╗██║  ██║██║  ██╗",
  "  ╚═╝  ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝",
  "",
  "",
}

---@class SpartanPomoConfig
---@field work_time number Work session duration in minutes
---@field break_time number Break duration in minutes
---@field ascii_art string[] ASCII art to display during break
---@field messages table Messages for notifications
---@field emergency_key string Key sequence for emergency exit
M.defaults = {
  -- Timer settings
  work_time = 25,
  break_time = 5,

  -- UI settings
  ascii_art = default_ascii_art,

  -- Notification messages
  messages = {
    work_start = "Pomodoro started! Focus for %d minutes.",
    work_end = "Time's up! Take a break.",
    break_start = "Break time! Rest for %d minutes.",
    break_end = "Break over! Ready to work again.",
    session_stop = "Pomodoro session stopped.",
  },

  -- Emergency exit (for urgent situations only)
  emergency_key = "<Leader><Leader>q",
}

---@type SpartanPomoConfig
M.options = {}

---Setup configuration with user options
---@param opts table|nil User configuration
function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", {}, M.defaults, opts or {})
end

---Get current configuration
---@return SpartanPomoConfig
function M.get()
  if vim.tbl_isempty(M.options) then
    return M.defaults
  end
  return M.options
end

return M
