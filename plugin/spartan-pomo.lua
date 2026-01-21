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
