-- backup edited files
vim.opt.backup = true
vim.opt.backupdir = { vim.fn.expand("~/.vimbackup//") }

-- persist undo
if vim.fn.has("persistent_undo") == 1 then
  vim.opt.undodir = { vim.fn.expand("~/local/.undodir/") }
  vim.opt.undofile = true
end

-- show line numbers
vim.opt.number = true

-- behaviour of tab
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true

-- this used to to make CommandT work better, but I don't use CommandT...
vim.opt.switchbuf = "usetab"

vim.cmd("syntax on")

-- allows cursor to be positioned "outside text" in visual mode
vim.opt.virtualedit = "block"

-- how to display whitespace
vim.opt.listchars = { tab = ">-", trail = "·", eol = "$" }
vim.opt.foldmethod = "syntax"
vim.opt.foldlevel = 10000

-- directory for the swap file
vim.opt.directory = {
  vim.fn.expand("~/.vimswp//"),
  ".",
  vim.fn.expand("~/tmp"),
  "/var/tmp",
  "/tmp",
}

-- better menus?
vim.opt.wildmenu = true

-- highlight the 81st column of wide lines...
vim.opt.colorcolumn = "81"

-- increase open tab limit
vim.opt.tabpagemax = 200

-- always have a status line
vim.opt.laststatus = 2

-- disable slow completion:
--   i - included files
--   t - tags
vim.opt.cpt:remove({ "t", "i" })

-- 7 lines of context when scrolling
vim.opt.scrolloff = 7

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

-- Increase memory limit for patterns from 1mb to 10mb
vim.opt.maxmempattern = 10000
