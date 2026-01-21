-- Prevent loading twice
if vim.g.loaded_spartan_pomo then
  return
end
vim.g.loaded_spartan_pomo = true

-- User commands
vim.api.nvim_create_user_command("SpartanStart", function()
  require("spartan-pomo").start()
end, { desc = "Start a Pomodoro session" })

vim.api.nvim_create_user_command("SpartanStop", function()
  require("spartan-pomo").stop()
end, { desc = "Stop the current Pomodoro session" })

vim.api.nvim_create_user_command("SpartanStatus", function()
  local pomo = require("spartan-pomo")
  local status = pomo.get_status()

  if status.state == "idle" then
    vim.notify("No active Pomodoro session.", vim.log.levels.INFO, { title = "Spartan Pomo" })
  else
    local state_display = status.state == "work" and "Working" or "Break"
    vim.notify(
      string.format("%s - %s remaining", state_display, status.remaining),
      vim.log.levels.INFO,
      { title = "Spartan Pomo" }
    )
  end
end, { desc = "Show current Pomodoro status" })
