local status_ok, builtin = pcall(require, "telescope.builtin")
if not status_ok then
  return
end

vim.keymap.set("n", "<localleader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<localleader>fg", builtin.live_grep, { desc = "Grep" })
vim.keymap.set("n", "<localleader>fb", builtin.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<localleader>fh", builtin.help_tags, { desc = "Find help" })
vim.keymap.set("n", "<localleader>fc", builtin.git_status, { desc = "Find changes" })
vim.keymap.set("n", "<localleader>fo", builtin.oldfiles, { desc = "Find old files" })
vim.keymap.set("n", "<localleader>fa", builtin.builtin, { desc = "Find finders" })
