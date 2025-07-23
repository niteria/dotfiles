-- Define a user command :RunPythonAuto that registers an autocommand
vim.api.nvim_create_user_command("RunPythonAuto", function()
  -- Create an augroup to keep autocommand isolated and clear previous
  local group = vim.api.nvim_create_augroup("RunPythonCurrentBuffer", { clear = true })

  -- Create the autocommand on BufWritePost event for the current buffer only
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = group,
    buffer = 0, -- 0 means current buffer where command is run
    callback = function()
      local file = vim.api.nvim_buf_get_name(0)
      -- Run Python on the current file
      vim.fn.jobstart({ "python", file }, {
        stdout_buffered = true,
        on_stdout = function(_, data)
          if data then
            print(table.concat(data, "\n"))
          end
        end,
        on_stderr = function(_, data)
          if data then
            print(table.concat(data, "\n"))
          end
        end,
      })
    end,
    desc = "Run Python on current buffer after buffer write",
  })
  print("Autocommand to run python on save registered for this buffer")
end, { desc = "Register autocommand to run python on this buffer on save" })
