-- Only do this part when compiled with support for autocommands.
if vim.fn.has("autocmd") == 1 then
  -- Put these in an autocmd group, so that we can delete them easily.
  local vimrcExGroup = vim.api.nvim_create_augroup("vimrcEx", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "text",
    group = vimrcExGroup,
    command = "setlocal textwidth=78",
  })

  --  When editing a file, always jump to the last known cursor position.
  --  Don't do it when the position is invalid or when inside an event handler
  --  (happens when dropping a file on gvim).
  vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    group = vimrcExGroup,
    callback = function()
      local rememberedLine = vim.fn.line("'\"")
      local lastLine = vim.fn.line("$")
      if rememberedLine > 0 and rememberedLine <= lastLine then
        vim.cmd('normal! g`"')
      end
    end,
  })
end

-- manually set filetypes
vim.api.nvim_create_autocmd("BufRead", {
  pattern = "TARGETS",
  command = "setlocal filetype=python",
})

-- .prof files read better with nowrap
vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*.prof",
  command = "setlocal nowrap",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt.tabstop = 2
    vim.opt.shiftwidth = 2
    vim.opt.expandtab = true
    vim.opt.autoindent = true
    vim.opt.softtabstop = 2
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "make",
  callback = function()
    vim.opt.expandtab = false
    vim.opt.tabstop = 8
    vim.opt.shiftwidth = 8
  end,
})

-- set filetypes as typescript.tsx
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.tsx,*.jsx",
  command = "set filetype=typescript.tsx",
})

-- kill any trailing whitespace on save
vim.api.nvim_create_autocmd("FileType", {
  pattern = "c,cabal,cpp,haskell,javascript,php,python,readme,text,make,bzl,nix,vim",
  callback = function()
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = 0,
      command = ":%s/\\s\\+$//e",
    })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "nix,json,cpp,bzl,haskell,python,lua,purescript",
  callback = function()
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = 0,
      command = ":Autoformat",
    })
  end,
})

-- Add the current file's directory to the path if not already present.
-- and all parent directories until you reach ~/
-- This is useful with gf
vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*",
  callback = function()
    local tempPath = vim.fn.escape(vim.fn.escape(vim.fn.expand("%:p:h"), " "), "\\ ")
    vim.opt.path:append(tempPath)
    vim.opt.path:append(vim.fn.expand("~/"))
  end,
})
vim.opt.path:append("**")
