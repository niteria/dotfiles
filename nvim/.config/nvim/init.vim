" just in case
set nocompatible

" Set up with:
" $ pyenv virtualenv --venv-base-dir $HOME/local/virtualenvs/ neovim3
" $ source $HOME/local/virtualenvs/neovim3/bin/activate
" $ pip3 install neovim
let python3_path = expand('$HOME/local/virtualenvs/neovim3/bin/python')
if filereadable(python3_path)
  let g:python3_host_prog = expand(python3_path)
endif
let python2_path = expand('$HOME/local/virtualenvs/neovim2/bin/python')
if filereadable(python2_path)
  let g:python_host_prog = expand(python2_path)
endif
" to get ruby working you need neovim-ruby-host somehow on path
" it gets installed with "gem install neovim"
" Here's how to disable it
" let g:loaded_ruby_provider = 1

" do :PlugInstall to install the plugins
call plug#begin('~/.config/nvim/plugged')
" inkpot colorscheme
Plug 'ciaranm/inkpot'
" sensible defaults
Plug 'tpope/vim-sensible'
" complete command-line (: / etc.) from the current file
Plug 'vim-scripts/CmdlineComplete'
" Fast file navigation for VIM
Plug 'wincent/command-t', {
  \   'do': 'cd ruby/command-t/ext/command-t && ruby extconf.rb && make'
  \ }
" :Ack command
Plug 'wincent/ferret'
" Bracketed paste
Plug 'wincent/terminus'
" Awesome git integration, :GDiff, :GBlame, etc...
Plug 'tpope/vim-fugitive'
" File browser 
Plug 'justinmk/vim-dirvish'
" Show git status in the file browser
Plug 'kristijanhusak/vim-dirvish-git'
" Mercurial integration
Plug 'ludovicchabant/vim-lawrencium'
" - goes up a directory
Plug 'tpope/vim-vinegar'
" Haskell enhancements
Plug 'parsonsmatt/vim2hs'
" Undo tree
Plug 'mbbill/undotree'
" Coerce: crm - CoeRce Mixed-case, crs - CoeRce Snake-case
Plug 'tpope/tpope-vim-abolish'
" Autocompletion framework
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Autocompletion from tmux buffers, integrates with deoplete
Plug 'wellle/tmux-complete.vim'
" [- : Move to previous line of lesser indent than the current line.
Plug 'jeetsukumaran/vim-indentwise'
" Make QuickFix window do what I want
Plug 'yssl/QFEnter'
" Ghcid - a tiny Haskell IDE
Plug 'ndmitchell/ghcid', { 'rtp': 'plugins/nvim' }
" Typescript support
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
" Projectionist for .c .cpp .cc <-> .h file switching
Plug 'tpope/vim-projectionist'
" Display Github url of the current file with :GitHubURL
Plug 'pgr0ss/vim-github-url'
" Language Server Protocol Client
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
" Multi-entry selection UI.
Plug 'junegunn/fzf'
" Supports syntax highlighting
Plug 'vim-syntastic/syntastic'
" Syntax highlighting for Swift
Plug 'keith/swift.vim'
" Code autocompletion for Swift
Plug 'keith/sourcekittendaemon.vim'

" Fancy Deep Learning code suggestions
if has('win32') || has('win64')
  Plug 'tbodt/deoplete-tabnine', { 'do': 'powershell.exe .\install.ps1' }
else
  Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' }
endif

Plug 'niteria/neomake-platformio'
Plug 'embear/vim-localvimrc'
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
Plug 'neovimhaskell/haskell-vim'
Plug 'alx741/vim-hindent' 
call plug#end()

" use inkpot colorscheme
colorscheme inkpot

" leader and localleader
let mapleader = ","
let maplocalleader = "\\"

" move between tabs with Tab and Shift-Tab
nmap <Tab> :tabnext<enter>
nmap <S-Tab> :tabprev<enter>

" backup edited files
set backup
set backupdir=~/.vimbackup//

" persist undo
if has("persistent_undo")
    set undodir=~/local/.undodir/
    set undofile
endif

" map undotree to U
nnoremap U :UndotreeToggle<cr>

" This unsets the "last search pattern" register by hitting return
nnoremap <silent><CR> :noh<CR>

" show line numbers
set number

" behaviour of tab
set shiftwidth=2
set tabstop=2
set expandtab

" arrows move between "terminal lines" not "vim lines"
map <Up> gk
map <Down> gj

" set up keybindings for command-t
nnoremap <silent> <localleader>t :CommandT<cr>
nnoremap <silent> <localleader>b :CommandTBuffer<cr>
nnoremap <silent> <localleader>j :CommandTJump<cr>
" use watchman, falling back to find in CommandT
let g:CommandTFileScanner = 'watchman'
" make CommandT open in a new tab
let g:CommandTAcceptSelectionTabMap = '<CR>'
" --- I might not need this
let g:CommandTAcceptSelectionSplitMap = ''
let g:CommandTAcceptSelectionVSplitMap = ''
let g:CommandTAcceptSelectionMap = ''
let g:CommandTAcceptSelectionCommand = 'tabe'
let g:CommandTAcceptSelectionTabCommand = 'tabe'
let g:CommandTAcceptSelectionSplitCommand = 'tabe'
let g:CommandTAcceptSelectionVSplitCommand = 'tabe'
" --- endof
" to make CommandT work better
set switchbuf=usetab

" Don't use Ex mode, use Q for formatting
map Q gq

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

autocmd FileType python set ts=4 | set shiftwidth=4 | set expandtab |
  \ set autoindent | set softtabstop=4

autocmd FileType make set noexpandtab | set tabstop=8 | set shiftwidth=8

" set filetypes as typescript.tsx
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx

" kill any trailing whitespace on save
autocmd FileType c,cabal,cpp,haskell,javascript,php,python,readme,text,make
  \ autocmd BufWritePre <buffer>
  \ :%s/\s\+$//e

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

let g:LanguageClient_serverCommands = {
    \ 'c': ['ccls', '--log-file=/tmp/cc.log'],
    \ 'cpp': ['ccls', '--log-file=/tmp/cc.log'],
    \ 'cuda': ['ccls', '--log-file=/tmp/cc.log'],
    \ 'objc': ['ccls', '--log-file=/tmp/cc.log'],
    \ }

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>

let g:LanguageClient_settingsPath='~/.config/nvim/settings.json'

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

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

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
