-- Take the list of visible buffers and put them in the tmux buffer (clipboard)
local tmuxCopyBuffers = function()
  local files = vim.api.nvim_exec("ls a", true)
  -- Regex to strip out everything from :ls but the buffer filenames
  files = vim.fn.substitute(files, '^[^"]*"', "", "g")
  files = vim.fn.substitute(files, '"[^"]*\n[^"]*"', "\n", "g")
  files = vim.fn.substitute(files, '"[^"]*$', "", "g")
  -- make space separated
  files = vim.fn.substitute(files, "\n", " ", "g")
  print(files)
  os.execute("tmux-load-buffer " .. vim.fn.shellescape(files))
end

vim.api.nvim_create_user_command("TmuxCopyBuffers", tmuxCopyBuffers, { force = true })

-- Do TmuxCopyBuffers on exit (disabled)
-- au VimLeave * call TmuxCopyBuffers()

-- Add :Q
vim.api.nvim_create_user_command("Q", function()
  tmuxCopyBuffers()
  vim.cmd("quitall")
end, { force = true })
