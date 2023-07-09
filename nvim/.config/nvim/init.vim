lua << EOF
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

local Plug = vim.fn['plug#']

vim.fn['plug#begin']('~/.config/nvim/plugged')
-- do :PlugInstall to install the plugins
-- inkpot colorscheme
Plug 'ciaranm/inkpot'
-- sensible defaults
Plug 'tpope/vim-sensible'
-- complete command-line (: / etc.) from the current file
Plug 'vim-scripts/CmdlineComplete'
-- Fast file navigation for VIM
Plug('wincent/command-t', {
  ['do'] = 'cd ruby/command-t/ext/command-t && ruby extconf.rb && make'
})
-- :Ack command
Plug 'wincent/ferret'
-- Bracketed paste
Plug 'wincent/terminus'
-- Awesome git integration, :GDiff, :GBlame, etc...
Plug 'tpope/vim-fugitive'
-- File browser
Plug 'justinmk/vim-dirvish'
-- Show git status in the file browser
Plug 'kristijanhusak/vim-dirvish-git'
-- Mercurial integration
Plug 'ludovicchabant/vim-lawrencium'
-- - goes up a directory
Plug 'tpope/vim-vinegar'
-- Haskell enhancements
Plug 'parsonsmatt/vim2hs'
-- Undo tree
Plug 'mbbill/undotree'
-- Coerce: crm - CoeRce Mixed-case, crs - CoeRce Snake-case
Plug 'tpope/tpope-vim-abolish'
-- Autocompletion framework
Plug('Shougo/deoplete.nvim', {
  ['do'] = ':UpdateRemotePlugins'
})
-- Autocompletion from tmux buffers, integrates with deoplete
Plug 'wellle/tmux-complete.vim'
-- [- : Move to previous line of lesser indent than the current line.
Plug 'jeetsukumaran/vim-indentwise'
-- Make QuickFix window do what I want
Plug 'yssl/QFEnter'
-- Ghcid - a tiny Haskell IDE
Plug('ndmitchell/ghcid', { rtp = 'plugins/nvim' })
-- Typescript support
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
-- Projectionist for .c .cpp .cc <-> .h file switching
Plug 'tpope/vim-projectionist'
-- Display Github url of the current file with :GitHubURL
Plug 'pgr0ss/vim-github-url'
-- Multi-entry selection UI.
Plug 'junegunn/fzf'
-- Supports syntax highlighting
Plug 'vim-syntastic/syntastic'
-- Syntax highlighting for Swift
Plug 'keith/swift.vim'
-- Code autocompletion for Swift
Plug 'keith/sourcekittendaemon.vim'
-- Nix syntax highlighting
Plug 'LnL7/vim-nix'
-- Fancy Deep Learning code suggestions
if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
  Plug('tbodt/deoplete-tabnine', { ['do']  = 'powershell.exe .\\install.ps1' })
else
  Plug('tbodt/deoplete-tabnine', { ['do']  = './install.sh' })
end
Plug 'niteria/neomake-platformio'
Plug 'embear/vim-localvimrc'
Plug('neoclide/coc.nvim', { branch =  'release' })
Plug 'neovimhaskell/haskell-vim'
Plug 'vim-autoformat/vim-autoformat'
vim.fn['plug#end']()

-- use inkpot colorscheme
vim.cmd('colorscheme inkpot')

-- leader and localleader
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

-- move between tabs with Tab and Shift-Tab
vim.keymap.set('n', '<Tab>', function() vim.cmd('tabnext') end)
vim.keymap.set('n', '<S-Tab>', function() vim.cmd('tabprev') end)

-- backup edited files
vim.opt.backup = true
vim.opt.backupdir = {vim.fn.expand('~/.vimbackup//')}

-- persist undo
if vim.fn.has('persistent_undo') == 1 then
  vim.opt.undodir = {vim.fn.expand('~/local/.undodir/')}
  vim.opt.undofile = true
end

-- map undotree to U
vim.keymap.set('n', 'U', function() vim.cmd('UndotreeToggle') end)

-- This unsets the "last search pattern" register by hitting return
vim.keymap.set('n', '<CR>', function() vim.cmd('noh') end, { silent = true })

-- show line numbers
vim.opt.number = true

-- behaviour of tab
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true

-- arrows move between "terminal lines" not "vim lines"
vim.keymap.set('', '<Up>', 'gk', { noremap = false } )
vim.keymap.set('', '<Down>', 'gj', { noremap = false })

-- set up keybindings for command-t
vim.keymap.set('n', '<localleader>t', function() vim.cmd('CommandT') end, { silent = true })
vim.keymap.set('n', '<localleader>b', function() vim.cmd('CommandTBuffer') end, { silent = true })
vim.keymap.set('n', '<localleader>j', function() vim.cmd('CommandTJump') end, { silent = true })
-- use watchman, falling back to find in CommandT
vim.g.CommandTFileScanner = 'watchman'
-- make CommandT open in a new tab
vim.g.CommandTAcceptSelectionTabMap = '<CR>'
-- I might not need this
vim.g.CommandTAcceptSelectionSplitMap = ''
vim.g.CommandTAcceptSelectionVSplitMap = ''
vim.g.CommandTAcceptSelectionMap = ''
vim.g.CommandTAcceptSelectionCommand = 'tabe'
vim.g.CommandTAcceptSelectionTabCommand = 'tabe'
vim.g.CommandTAcceptSelectionSplitCommand = 'tabe'
vim.g.CommandTAcceptSelectionVSplitCommand = 'tabe'
-- to make CommandT work better
vim.opt.switchbuf = 'usetab'

-- Don't use Ex mode, use Q for formatting
vim.keymap.set('', 'Q', 'gq', { noremap = false })
EOF

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
    au!

    " For all text files set 'textwidth' to 78 characters.
    autocmd FileType text setlocal textwidth=78

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
          \ if line("'\"") > 0 && line("'\"") <= line("$") |
          \   exe "normal! g`\"" |
          \ endif

  augroup END

endif

syntax on
filetype on
filetype plugin on
filetype indent on

" allows cursor to be positioned "outside text" in visual mode
set virtualedit=block

" how to display whitespace
set listchars=tab:>-,trail:·,eol:$
set foldmethod=syntax
set foldlevel=10000

" Don't remove indent even if I don't write anything on that line
imap <CR> <CR> <BS>

" directory for the swap file
set directory=~/.vimswp//,.,~/tmp,/var/tmp,/tmp

" manually set filetypes
autocmd BufRead TARGETS setlocal filetype=python

" .prof files read better with nowrap
autocmd BufRead *.prof setlocal nowrap

autocmd FileType python set ts=2 | set shiftwidth=2 | set expandtab |
  \ set autoindent | set softtabstop=2

autocmd FileType make set noexpandtab | set tabstop=8 | set shiftwidth=8

" set filetypes as typescript.tsx
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx

" kill any trailing whitespace on save
autocmd FileType c,cabal,cpp,haskell,javascript,php,python,readme,text,make,bzl,nix
  \ autocmd BufWritePre <buffer>
  \ :%s/\s\+$//e

autocmd FileType nix autocmd BufWritePre *.nix :Autoformat
autocmd FileType json autocmd BufWritePre * :Autoformat
autocmd FileType cpp autocmd BufWritePre <buffer> :Autoformat
autocmd FileType bzl autocmd BufWritePre BUILD.bazel :Autoformat
autocmd Filetype haskell autocmd BufWritePre *.hs :Autoformat
autocmd Filetype python autocmd BufWritePre *.py :Autoformat

let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
" https://github.com/vim-autoformat/vim-autoformat#help-the-formatter-doesnt-work-as-expected
let g:formatdef_fourmolu = '"exec 2> /dev/null; fourmolu --no-cabal"'
let g:formatdef_stylish_haskell = '"stylish-haskell"'
let g:formatters_haskell = ['fourmolu', 'stylish_haskell']
let g:run_all_formatters_haskell = 1

" We limit formatting to BUILD.bazel files because without specifying -type
" buildifier won't sort dependencies.
" If we wanted to extend this, we'd probably need a separate definition for
" each bazel -type
let g:formatdef_buildifier = '"buildifier -type build"'

" Add the current file's directory to the path if not already present.
" and all parent directories until you reach ~/
" This is useful with gf
autocmd BufRead *
  \ let s:tempPath=escape(escape(expand("%:p:h"), ' '), '\ ') |
  \ exec "set path+=".s:tempPath.";~/"
set path+=**

" better menus?
set wildmenu

" Open gf in new tab
nnoremap gF gf
nnoremap gf <C-w>gf

" highlight the 81st column of wide lines...
set colorcolumn=81

" increase open tab limit
set tabpagemax=200

" make ctrl-a go to begining of the line in command mode
cnoremap <C-A> <Home>

" edit-reload vimrc
nnoremap <leader>ev :tabedit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" exit insert mode with jk
inoremap jk <esc>

" always have a status line
set laststatus=2

let g:haskell_conceal              = 0
let g:haskell_multiline_strings    = 1
let g:haskell_conceal_enumerations = 0
let g:haskell_haddock              = 1

" no mouse integration from terminus
let g:TerminusMouse=0

" disable slow completion:
"   i - included files
"   t - tags
set cpt-=t
set cpt-=i

" more comment prefixes for toggle_comment
autocmd BufReadPost *.vim    let b:comment_prefix = "\" "
autocmd BufReadPost *.ino    let b:comment_prefix = "// "

" 7 lines of context when scrolling
set scrolloff=7

" Turn on deoplete
"let g:deoplete#enable_at_startup = 1

" Increase memory limit for patterns from 1mb to 10mb
set maxmempattern=10000

" Do :Ack with a word under cursor with K
nmap K <Plug>(FerretAckWord)
" Do :Ack with a selected text
"   Unfortunately broken, doesn't handle spaces
" vmap K "xy:let @x = substitute(@x, ' ', '\\ ', 'g')<CR>:Ack --literal <C-R>x<CR>

" Don't open a QuickFix window after ,<tab>
let g:qfenter_enable_autoquickfix = 0

" switching back and forth between .cpp and .h files
nmap ,s :A<CR>
" TODO: do it per filetype like
" https://www.reddit.com/r/vim/comments/76qzoc/advanced_projectionist_templates/doiaxjd
let g:projectionist_heuristics = {
      \ '*': {
      \   '*.h': {
      \     'alternate': [ '{}.cpp', '{}.cc', '{}.c' ]
      \   },
      \   '*.cpp': {
      \     'alternate': '{}.h'
      \   },
      \   '*.c': {
      \     'alternate': '{}.h'
      \   },
      \   '*.cc': {
      \     'alternate': '{}.h'
      \   }
      \ }}

" Take the list of visible buffers and put them in the tmux buffer (clipboard)
function! TmuxCopyBuffers()
    redir => files
    :ls a
    redir END
    " Regex to strip out everything from :ls but the buffer filenames
    let files = substitute(files, '^[^"]*"', '', 'g')
    let files = substitute(files, '"[^"]*\n[^"]*"', '\n', 'g')
    let files = substitute(files, '"[^"]*$','','g')
    " make space separated
    let files = substitute(files, '\n',' ','g')
    exe '!tmux-load-buffer ' . shellescape(&t_te . files)
endfunction

function! TmuxCopyBuffersAndLeave()
    call TmuxCopyBuffers()
    quitall
endfunction

" Do TmuxCopyBuffers on exit (disabled)
"au VimLeave * call TmuxCopyBuffers()

" Add :Q
command Q :call TmuxCopyBuffersAndLeave()

let g:syntastic_swift_swiftlint_use_defaults = 1
let g:syntastic_swift_checkers = ['swiftlint', 'swiftpm']
let g:localvimrc_sandbox = 0
let g:localvimrc_ask = 0

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
"if exists('*complete_info')
"  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
"else
"  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"endif
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Snippet next
let g:coc_snippet_next = '<tab>'
let g:CommandTPreferredImplementation='lua'
