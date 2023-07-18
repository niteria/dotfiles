local status_ok, session_manager = pcall(require, "session_manager")
if not status_ok then
  return
end

local status_ok2, Path = pcall(require, "plenary.Path")
if not status_ok2 then
  return
end

local status_ok3, config = pcall(require, "session_manager.config")
if not status_ok2 then
  return
end

session_manager.setup({
  sessions_dir = Path:new(vim.fn.stdpath("~"), "vim_sessions"), -- The directory where the session files will be saved.
  session_filename_to_dir = session_filename_to_dir, -- Function that replaces symbols into separators and colons to transform filename into a session directory.
  dir_to_session_filename = dir_to_session_filename, -- Function that replaces separators and colons into special symbols to transform session directory into a filename. Should use `vim.loop.cwd()` if the passed `dir` is `nil`.
  autoload_mode = config.AutoloadMode.LastSession, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
  autosave_last_session = true, -- Automatically save last session on exit and on session switch.
  autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
  autosave_ignore_dirs = {}, -- A list of directories where the session will not be autosaved.
  autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
    "gitcommit",
    "gitrebase",
  },
  autosave_ignore_buftypes = {}, -- All buffers of these bufer types will be closed before the session is saved.
  autosave_only_in_session = false, -- Always autosaves session. If true, only autosaves after a session is active.
  max_path_length = 80, -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  group = config_group,
  callback = function()
    if vim.bo.filetype ~= "git" and not vim.bo.filetype ~= "gitcommit" and not vim.bo.filetype ~= "gitrebase" then
      session_manager.autosave_session()
    end
  end,
})
