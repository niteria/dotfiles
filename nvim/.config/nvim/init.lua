-- probably unnecessary, but just in case
--
vim.opt.compatible = false

--  Set up with:
--  $ pyenv virtualenv --venv-base-dir $HOME/local/virtualenvs/ neovim3
--  $ source $HOME/local/virtualenvs/neovim3/bin/activate
--  $ pip3 install neovim
local python3_path = vim.fn.expand("$HOME/local/virtualenvs/neovim3/bin/python")
if vim.fn.filereadable(python3_path) == 1 then
  vim.g.python3_host_prog = vim.fn.expand(python3_path)
end

local python2_path = vim.fn.expand("$HOME/local/virtualenvs/neovim2/bin/python")
if vim.fn.filereadable(python2_path) == 1 then
  vim.g.python2_host_prog = vim.fn.expand(python2_path)
end

-- leader and localleader
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

-- disable netrw at the very start of your init.lua (for nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- inkpot colorscheme
  "ciaranm/inkpot",
  -- sensible defaults
  "tpope/vim-sensible",
  -- common dependencies
  "nvim-lua/popup.nvim",
  "nvim-lua/plenary.nvim",
  -- complete command-line (: / etc., from the current file
  "vim-scripts/CmdlineComplete",
  -- :Ack command
  "wincent/ferret",
  -- Bracketed paste
  "wincent/terminus",
  -- Awesome git integration, :GDiff, :GBlame, etc...
  "tpope/vim-fugitive",
  -- File browser
  "justinmk/vim-dirvish",
  -- Show git status in the file browser
  "kristijanhusak/vim-dirvish-git",
  -- Mercurial integration
  "ludovicchabant/vim-lawrencium",
  -- - goes up a directory
  "tpope/vim-vinegar",
  -- Haskell enhancements
  "parsonsmatt/vim2hs",
  -- Undo tree
  "mbbill/undotree",
  -- Coerce: crm - CoeRce Mixed-case, crs - CoeRce Snake-case
  "tpope/tpope-vim-abolish",
  -- Autocompletion framework
  { "Shougo/deoplete.nvim", build = ":UpdateRemotePlugins" },
  -- Autocompletion from tmux buffers, integrates with deoplete
  "wellle/tmux-complete.vim",
  -- [- : Move to previous line of lesser indent than the current line.
  "jeetsukumaran/vim-indentwise",
  -- Make QuickFix window do what I want
  "yssl/QFEnter",
  -- Ghcid - a tiny Haskell IDE
  {
    "ndmitchell/ghcid",
    config = function(plugin)
      vim.opt.rtp:append(plugin.dir .. "/plugins/nvim")
    end,
  },
  -- Typescript support
  "leafgarland/typescript-vim",
  "peitalin/vim-jsx-typescript",
  -- Projectionist for .c .cpp .cc <-> .h file switching
  "tpope/vim-projectionist",
  -- Display Github url of the current file with :GitHubURL
  "pgr0ss/vim-github-url",
  -- Multi-entry selection UI.
  "junegunn/fzf",
  -- Supports syntax highlighting
  "vim-syntastic/syntastic",
  -- Syntax highlighting for Swift
  "keith/swift.vim",
  -- Code autocompletion for Swift
  "keith/sourcekittendaemon.vim",
  -- Nix syntax highlighting
  "LnL7/vim-nix",
  "niteria/neomake-platformio",
  "embear/vim-localvimrc",
  { "neoclide/coc.nvim", branch = "release" },
  "neovimhaskell/haskell-vim",
  "vim-autoformat/vim-autoformat",
  -- vim lua autocompletion
  "rafcamlet/coc-nvim-lua",
  { "akinsho/toggleterm.nvim", tag = "v2.7.0" },
  { "lewis6991/gitsigns.nvim", tag = "v0.6" },
  { "nvim-telescope/telescope.nvim", tag = "0.1.2" },
  -- Shows keybindings after a timeout
  {
    "folke/which-key.nvim",
    -- event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 1000
    end,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    tag = "v1.4.3",
  },
  "nvim-tree/nvim-tree.lua",
  -- { "folke/neodev.nvim", opts = {} },
})

require("user.settings")
require("user.gitsigns")
require("user.telescope")
require("user.toggleterm")
require("user.coc")
require("user.projectionist")
require("user.tmux-buffers")
require("user.autoformat")
require("user.nvim-tree")
require("user.keymaps")

-- use inkpot colorscheme
vim.cmd("colorscheme inkpot")

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
  pattern = "nix,json,cpp,bzl,haskell,python,lua",
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

-- no mouse integration from terminus
vim.g.TerminusMouse = 0

-- more comment prefixes for toggle_comment
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.vim",
  callback = function()
    vim.b.comment_prefix = '" '
  end,
})
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.ino",
  callback = function()
    vim.b.comment_prefix = "// "
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.lua",
  callback = function()
    vim.b.comment_prefix = "-- "
  end,
})

-- Turn on deoplete
-- vim.g['deoplete#enable_at_startup'] = 1

-- Don't open a QuickFix window after ,<tab>
vim.g.qfenter_enable_autoquickfix = 0

vim.g.syntastic_swift_swiftlint_use_defaults = 1
vim.g.syntastic_swift_checkers = { "swiftlint", "swiftpm" }
vim.g.localvimrc_sandbox = 0
vim.g.localvimrc_ask = 0
