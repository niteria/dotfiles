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

vim.opt.termguicolors = true
vim.g.inkpot_black_background = 1

require("lazy").setup({
  -- inkpot colorscheme
  "davidstelter/inkpot",
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
  -- Use C to comment blocks
  { "numToStr/Comment.nvim", opts = {
    toggler = { line = "C" },
    opleader = { line = "C" },
  } },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = {
          "c",
          "cpp",
          "bash",
          "lua",
          "vim",
          "vimdoc",
          "javascript",
          "html",
          "diff",
          "dot",
          "elm",
          "haskell",
          "json",
          "nix",
          "python",
        },
        sync_install = false,
        highlight = { enable = false },
        indent = { enable = false },
      })
    end,
  },
  -- Show open buffers like tabs
  { "willothy/nvim-cokeline", config = true },
  -- Color matching parenthesis
  "HiPhish/rainbow-delimiters.nvim",
  -- { "folke/neodev.nvim", opts = {} },
})

require("user.settings")
require("user.gitsigns")
require("user.telescope")
require("user.toggleterm")
require("user.keymaps")
-- user.coc must happen after user.keymaps because some mappings conflict
-- TODO: debug this further
require("user.coc")
require("user.projectionist")
require("user.tmux-buffers")
require("user.autoformat")
require("user.nvim-tree")
require("user.autocommands")
require("user.rainbow-delimiters")

-- use inkpot colorscheme
vim.cmd("colorscheme inkpot")

-- no mouse integration from terminus
vim.g.TerminusMouse = 0
-- Turn on deoplete
-- vim.g['deoplete#enable_at_startup'] = 1

-- Don't open a QuickFix window after ,<tab>
vim.g.qfenter_enable_autoquickfix = 0

vim.g.syntastic_swift_swiftlint_use_defaults = 1
vim.g.syntastic_swift_checkers = { "swiftlint", "swiftpm" }
vim.g.localvimrc_sandbox = 0
vim.g.localvimrc_ask = 0
