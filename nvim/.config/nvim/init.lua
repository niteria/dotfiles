-- probably unnecessary, but just in case
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

local Plug = vim.fn["plug#"]

vim.fn["plug#begin"]("~/.config/nvim/plugged")
-- do :PlugInstall to install the plugins
-- inkpot colorscheme
Plug("ciaranm/inkpot")
-- sensible defaults
Plug("tpope/vim-sensible")
-- complete command-line (: / etc.) from the current file
Plug("vim-scripts/CmdlineComplete")
-- Fast file navigation for VIM
Plug("wincent/command-t", {
  ["do"] = "cd ruby/command-t/ext/command-t && ruby extconf.rb && make",
})
-- :Ack command
Plug("wincent/ferret")
-- Bracketed paste
Plug("wincent/terminus")
-- Awesome git integration, :GDiff, :GBlame, etc...
Plug("tpope/vim-fugitive")
-- File browser
Plug("justinmk/vim-dirvish")
-- Show git status in the file browser
Plug("kristijanhusak/vim-dirvish-git")
-- Mercurial integration
Plug("ludovicchabant/vim-lawrencium")
-- - goes up a directory
Plug("tpope/vim-vinegar")
-- Haskell enhancements
Plug("parsonsmatt/vim2hs")
-- Undo tree
Plug("mbbill/undotree")
-- Coerce: crm - CoeRce Mixed-case, crs - CoeRce Snake-case
Plug("tpope/tpope-vim-abolish")
-- Autocompletion framework
Plug("Shougo/deoplete.nvim", {
  ["do"] = ":UpdateRemotePlugins",
})
-- Autocompletion from tmux buffers, integrates with deoplete
Plug("wellle/tmux-complete.vim")
-- [- : Move to previous line of lesser indent than the current line.
Plug("jeetsukumaran/vim-indentwise")
-- Make QuickFix window do what I want
Plug("yssl/QFEnter")
-- Ghcid - a tiny Haskell IDE
Plug("ndmitchell/ghcid", { rtp = "plugins/nvim" })
-- Typescript support
Plug("leafgarland/typescript-vim")
Plug("peitalin/vim-jsx-typescript")
-- Projectionist for .c .cpp .cc <-> .h file switching
Plug("tpope/vim-projectionist")
-- Display Github url of the current file with :GitHubURL
Plug("pgr0ss/vim-github-url")
-- Multi-entry selection UI.
Plug("junegunn/fzf")
-- Supports syntax highlighting
Plug("vim-syntastic/syntastic")
-- Syntax highlighting for Swift
Plug("keith/swift.vim")
-- Code autocompletion for Swift
Plug("keith/sourcekittendaemon.vim")
-- Nix syntax highlighting
Plug("LnL7/vim-nix")
-- Fancy Deep Learning code suggestions
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  Plug("tbodt/deoplete-tabnine", { ["do"] = "powershell.exe .\\install.ps1" })
else
  Plug("tbodt/deoplete-tabnine", { ["do"] = "./install.sh" })
end
Plug("niteria/neomake-platformio")
Plug("embear/vim-localvimrc")
Plug("neoclide/coc.nvim", { branch = "release" })
Plug("neovimhaskell/haskell-vim")
Plug("vim-autoformat/vim-autoformat")
-- vim lua autocompletion
Plug("rafcamlet/coc-nvim-lua")
Plug("lewis6991/gitsigns.nvim", { tag = "*" })
vim.fn["plug#end"]()

require("user.gitsigns")
-- use inkpot colorscheme
vim.cmd("colorscheme inkpot")

-- leader and localleader
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

-- move between tabs with Tab and Shift-Tab
vim.keymap.set("n", "<Tab>", function()
  vim.cmd("tabnext")
end)
vim.keymap.set("n", "<S-Tab>", function()
  vim.cmd("tabprev")
end)

-- backup edited files
vim.opt.backup = true
vim.opt.backupdir = { vim.fn.expand("~/.vimbackup//") }

-- persist undo
if vim.fn.has("persistent_undo") == 1 then
  vim.opt.undodir = { vim.fn.expand("~/local/.undodir/") }
  vim.opt.undofile = true
end

-- map undotree to U
vim.keymap.set("n", "U", function()
  vim.cmd("UndotreeToggle")
end)

-- This unsets the "last search pattern" register by hitting return
vim.keymap.set("n", "<CR>", function()
  vim.cmd("noh")
end, { silent = true })

-- show line numbers
vim.opt.number = true

-- behaviour of tab
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true

-- arrows move between "terminal lines" not "vim lines"
vim.keymap.set("", "<Up>", "gk", { noremap = false })
vim.keymap.set("", "<Down>", "gj", { noremap = false })

-- set up keybindings for command-t
vim.keymap.set("n", "<localleader>t", function()
  vim.cmd("CommandT")
end, { silent = true })
vim.keymap.set("n", "<localleader>b", function()
  vim.cmd("CommandTBuffer")
end, { silent = true })
vim.keymap.set("n", "<localleader>j", function()
  vim.cmd("CommandTJump")
end, { silent = true })
-- use watchman, falling back to find in CommandT
vim.g.CommandTFileScanner = "watchman"
-- make CommandT open in a new tab
vim.g.CommandTAcceptSelectionTabMap = "<CR>"
-- I might not need this
vim.g.CommandTAcceptSelectionSplitMap = ""
vim.g.CommandTAcceptSelectionVSplitMap = ""
vim.g.CommandTAcceptSelectionMap = ""
vim.g.CommandTAcceptSelectionCommand = "tabe"
vim.g.CommandTAcceptSelectionTabCommand = "tabe"
vim.g.CommandTAcceptSelectionSplitCommand = "tabe"
vim.g.CommandTAcceptSelectionVSplitCommand = "tabe"
-- to make CommandT work better
vim.opt.switchbuf = "usetab"

-- Don't use Ex mode, use Q for formatting
vim.keymap.set("", "Q", "gq", { noremap = false })

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

vim.cmd("syntax on")

-- allows cursor to be positioned "outside text" in visual mode
vim.opt.virtualedit = "block"

-- how to display whitespace
vim.opt.listchars = { tab = ">-", trail = "·", eol = "$" }
vim.opt.foldmethod = "syntax"
vim.opt.foldlevel = 10000

-- Don't remove indent even if I don't write anything on that line
vim.keymap.set("i", "<CR>", "<CR> <BS>")

-- directory for the swap file
vim.opt.directory = {
  vim.fn.expand("~/.vimswp//"),
  ".",
  vim.fn.expand("~/tmp"),
  "/var/tmp",
  "/tmp",
}

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

vim.g.autoformat_autoindent = 0
vim.g.autoformat_retab = 0
-- https://github.com/vim-autoformat/vim-autoformat#help-the-formatter-doesnt-work-as-expected
vim.g.formatdef_fourmolu = '"exec 2> /dev/null; fourmolu --no-cabal"'
vim.g.formatdef_stylish_haskell = '"stylish-haskell"'
vim.g.formatters_haskell = { "fourmolu", "stylish_haskell" }
vim.g.run_all_formatters_haskell = 1

-- We limit formatting to BUILD.bazel files because without specifying -type
-- buildifier won't sort dependencies.
-- If we wanted to extend this, we'd probably need a separate definition for
-- each bazel -type
vim.g.formatdef_buildifier = '"buildifier -type build"'

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

-- better menus?
vim.opt.wildmenu = true

-- Open gf in new tab
vim.keymap.set("n", "gF", "gf", { remap = false })
vim.keymap.set("n", "gf", "<C-w>gf", { remap = false })

-- highlight the 81st column of wide lines...
vim.opt.colorcolumn = "81"

-- increase open tab limit
vim.opt.tabpagemax = 200

-- make ctrl-a go to begining of the line in command mode
vim.keymap.set("c", "<C-A>", "<Home>", { remap = false })

-- edit-reload vimrc
vim.keymap.set("n", "<leader>ev", ":tabedit $MYVIMRC<cr>", { remap = false })
vim.keymap.set("n", "<leader>sv", ":source $MYVIMRC<cr>", { remap = false })

-- exit insert mode with jk
vim.keymap.set({ "i", "n" }, "jk", "<esc>", { remap = false })

-- always have a status line
vim.opt.laststatus = 2

vim.g.haskell_conceal = 0
vim.g.haskell_multiline_strings = 1
vim.g.haskell_conceal_enumerations = 0
vim.g.haskell_haddock = 1

-- no mouse integration from terminus
vim.g.TerminusMouse = 0

-- disable slow completion:
--   i - included files
--   t - tags
vim.opt.cpt:remove({ "t", "i" })

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

-- 7 lines of context when scrolling
vim.opt.scrolloff = 7

-- Turn on deoplete
-- vim.g['deoplete#enable_at_startup'] = 1

-- Increase memory limit for patterns from 1mb to 10mb
vim.opt.maxmempattern = 10000

-- Do :Ack with a word under cursor with K
vim.keymap.set("n", "K", "<Plug>(FerretAckWord)")
--  Do :Ack with a selected text
--    Unfortunately broken, doesn't handle spaces
--  vmap K "xy:let @x = substitute(@x, ' ', '\\ ', 'g')<CR>:Ack --literal <C-R>x<CR>

-- Don't open a QuickFix window after ,<tab>
vim.g.qfenter_enable_autoquickfix = 0

-- switching back and forth between .cpp and .h files
vim.keymap.set("n", ",s", ":A<CR>")

-- TODO: do it per filetype like
-- https://www.reddit.com/r/vim/comments/76qzoc/advanced_projectionist_templates/doiaxjd
vim.g.projectionist_heuristics = {
  ["*"] = {
    ["*.c"] = {
      alternate = "{}.h",
    },
    ["*.cc"] = {
      alternate = "{}.h",
    },
    ["*.cpp"] = {
      alternate = "{}.h",
    },
    ["*.h"] = {
      alternate = { "{}.cpp", "{}.cc", "{}.c" },
    },
  },
}

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

vim.g.syntastic_swift_swiftlint_use_defaults = 1
vim.g.syntastic_swift_checkers = { "swiftlint", "swiftpm" }
vim.g.localvimrc_sandbox = 0
vim.g.localvimrc_ask = 0

-- Give more space for displaying messages.
vim.opt.cmdheight = 2

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 300

-- Don't pass messages to |ins-completion-menu|.
vim.opt.shortmess:append("c")

-- Always show the signcolumn, otherwise it would shift the text each time
-- diagnostics appear/become resolved.
vim.opt.signcolumn = "yes"

local keyset = vim.keymap.set
-- Autocomplete
function _G.check_back_space()
  local col = vim.fn.col(".") - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
end

-- Use Tab for trigger completion with characters ahead and navigate
-- NOTE: There's always a completion item selected by default, you may want to enable
-- no select by setting `"suggest.noselect": true` in your configuration file
-- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
-- other plugins before putting this into your config
local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

-- Use <c-space> to trigger completion
keyset("i", "<c-space>", "coc#refresh()", { silent = true, expr = true })

-- Make <CR> to accept selected completion item or notify coc.nvim to format
-- <C-g>u breaks current undo, please make your own choice
keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
keyset("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })

-- GoTo code navigation
keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
keyset("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true })
keyset("n", "gr", "<Plug>(coc-references)", { silent = true })

-- Use K to show documentation in preview window
function _G.show_docs()
  local cw = vim.fn.expand("<cword>")
  if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
    vim.api.nvim_command("h " .. cw)
  elseif vim.api.nvim_eval("coc#rpc#ready()") then
    vim.fn.CocActionAsync("doHover")
  else
    vim.api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
  end
end
keyset("n", "K", "<CMD>lua _G.show_docs()<CR>", { silent = true })

-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
  group = "CocGroup",
  command = "silent call CocActionAsync('highlight')",
  desc = "Highlight symbol under cursor on CursorHold",
})

-- Symbol renaming
keyset("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })

-- Formatting selected code
keyset("x", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })
keyset("n", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })

-- Apply the most preferred quickfix action on the current line.
keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)

-- Map function and class text objects
-- NOTE: Requires 'textDocument.documentSymbol' support from the language server
keyset("x", "if", "<Plug>(coc-funcobj-i)", opts)
keyset("o", "if", "<Plug>(coc-funcobj-i)", opts)
keyset("x", "af", "<Plug>(coc-funcobj-a)", opts)
keyset("o", "af", "<Plug>(coc-funcobj-a)", opts)
keyset("x", "ic", "<Plug>(coc-classobj-i)", opts)
keyset("o", "ic", "<Plug>(coc-classobj-i)", opts)
keyset("x", "ac", "<Plug>(coc-classobj-a)", opts)
keyset("o", "ac", "<Plug>(coc-classobj-a)", opts)

-- Add `:Format` command to format current buffer
vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

-- Add (Neo)Vim's native statusline support
-- NOTE: Please see `:h coc-status` for integrations with external plugins that
-- provide custom statusline: lightline.vim, vim-airline
vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")

-- Mappings for CoCList
-- code actions and coc stuff
---@diagnostic disable-next-line: redefined-local
local opts = { silent = true, nowait = true }
-- Show commands
keyset("n", "<space>c", ":<C-u>CocList commands<cr>", opts)
-- Find symbol of current document
keyset("n", "<space>o", ":<C-u>CocList outline<cr>", opts)

-- Snippet next
vim.g.coc_snippet_next = "<tab>"
vim.g.CommandTPreferredImplementation = "lua"
