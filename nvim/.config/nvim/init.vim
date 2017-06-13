" just in case
set nocompatible

" do :PlugInstall to install the plugins
call plug#begin('~/.config/nvim/plugged')
" inkpot colorscheme
Plug 'ciaranm/inkpot'
" sensible defaults
Plug 'tpope/vim-sensible'
call plug#end()

" use inkpot colorscheme
colorscheme inkpot

" move between tabs with Tab and Shift-Tab
nmap <Tab> :tabnext<enter>
nmap <S-Tab> :tabprev<enter>
