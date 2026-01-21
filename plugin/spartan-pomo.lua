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
    vim.notify(
      string.format("No active session. Completed: %d pomodoros", status.completed_count),
      vim.log.levels.INFO,
      { title = "Spartan Pomo" }
    )
  elseif status.state == "paused" then
    vim.notify(
      string.format("Paused - %s remaining (Completed: %d)", status.remaining, status.completed_count),
      vim.log.levels.INFO,
      { title = "Spartan Pomo" }
    )
  else
    local state_display = status.state == "work" and "Working" or "Break"
    vim.notify(
      string.format("%s - %s remaining (Completed: %d)", state_display, status.remaining, status.completed_count),
      vim.log.levels.INFO,
      { title = "Spartan Pomo" }
    )
  end
end, { desc = "Show current Pomodoro status" })

vim.api.nvim_create_user_command("SpartanReset", function()
  require("spartan-pomo").reset_count()
end, { desc = "Reset completed Pomodoro count" })

vim.api.nvim_create_user_command("SpartanPause", function()
  require("spartan-pomo").pause()
end, { desc = "Pause the current Pomodoro session" })

vim.api.nvim_create_user_command("SpartanResume", function()
  require("spartan-pomo").resume()
end, { desc = "Resume the paused Pomodoro session" })
