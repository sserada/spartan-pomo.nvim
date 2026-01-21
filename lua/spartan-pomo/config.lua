---@mod spartan-pomo.config Configuration module

local M = {}

---@class SpartanPomoConfig
---@field work_time number Work session duration in minutes
---@field break_time number Break duration in minutes
M.defaults = {
  work_time = 25,
  break_time = 5,
}

---@type SpartanPomoConfig
M.options = {}

---Setup configuration with user options
---@param opts table|nil User configuration
function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", {}, M.defaults, opts or {})
end

return M
