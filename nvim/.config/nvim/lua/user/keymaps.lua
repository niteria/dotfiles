-- keymaps that don't go anywhere else

local function opts(t)
  return { noremap = true, silent = true, desc = t }
end

local keymap = vim.keymap.set

-- move between tabs with Tab and Shift-Tab
keymap("n", "<Tab>", function()
  vim.cmd("bnext")
end, opts("Next tab"))
keymap("n", "<S-Tab>", function()
  vim.cmd("bprev")
end, opts("Prev tab"))

-- map undotree to U
keymap("n", "U", function()
  vim.cmd("UndotreeToggle")
end)

-- This unsets the "last search pattern" register by hitting return
keymap("n", "<CR>", function()
  vim.cmd("noh")
end, opts("Unset last search"))

keymap("n", "<C-Up>", "<C-w><Up>", opts("Focus up window"))
keymap("n", "<C-Down>", "<C-w><Down>", opts("Focus down window"))
keymap("n", "<C-Left>", "<C-w><Left>", opts("Focus left window"))
keymap("n", "<C-Right>", "<C-w><Right>", opts("Focus right window"))

-- Don't quit visual mode when indenting
keymap("v", "<", "<gv", opts("Deindent"))
keymap("v", ">", ">gv", opts("Indent"))

-- Make R on rectangular selection name sense
keymap("v", "R", "xgvI", opts("Replace block"))

-- Move text up and down
-- This makes esc-up do the same thing as the shortcut...
-- keymap("n", "<A-Down>", ":m .+1<CR>==", opts("Move down"))
-- keymap("n", "<A-Up>", ":m .-2<CR>==", opts("Move up"))
-- keymap("v", "<A-Down>", ":m '>+1<CR>gv=gv", opts("Move down"))
-- keymap("v", "<A-Up>", ":m '<-2<CR>gv=gv", opts("Move up"))

-- paste over but don't lose the pasted thing
keymap("v", "p", '"_dP', opts("Paste"))

-- arrows move between "terminal lines" not "vim lines"
keymap("", "<Up>", "gk", { noremap = false })
keymap("", "<Down>", "gj", { noremap = false })

-- Don't use Ex mode, use Q for formatting
keymap("", "Q", "gq", { noremap = false })

-- Don't remove indent even if I don't write anything on that line
keymap("i", "<CR>", "<CR> <BS>")

-- Open gf in new tab
keymap("n", "gF", "gf", opts("Go file (buffer)"))
keymap("n", "gf", "<C-w>gf", opts("Go file (tab)"))

-- make ctrl-a go to begining of the line in command mode
keymap("c", "<C-A>", "<Home>", opts("Go to beginning of a line"))

-- edit-reload vimrc
keymap("n", "<leader>ev", ":tabedit $MYVIMRC<cr>", opts("Edit config"))
keymap("n", "<leader>sv", ":source $MYVIMRC<cr>", opts("Source config"))

-- exit insert mode with jk
keymap({ "i", "n" }, "jk", "<esc>", opts("Exit insert mode"))

-- Do :Ack with a word under cursor with K
keymap("n", "K", "<Plug>(FerretAckWord)")
--  Do :Ack with a selected text
--    Unfortunately broken, doesn't handle spaces
--  vmap K "xy:let @x = substitute(@x, ' ', '\\ ', 'g')<CR>:Ack --literal <C-R>x<CR>
