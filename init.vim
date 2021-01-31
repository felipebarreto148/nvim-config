" curl -fLO $HOME/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


set nocompatible		"be iMproved, required
filetype off			"required

set number
set relativenumber

if has('python3')
endif

call plug#begin('~/.config/nvim/plugged')
" call plug#begin('~\AppData\Local\nvim\plugged')

"Auto complete
Plug 'valloric/youcompleteme', { 'do': './install.py --clang-completer --racer-completer --omnisharp-completer --tern-completer' }
"Plug 'neoclide/coc.nvim', {'branch': 'release'}

" editing
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-repeat'

" navigation/search files
Plug 'scrooloose/nerdtree'

" git
Plug 'tpope/vim-fugitive'

" syntax
Plug 'mattn/emmet-vim'
Plug 'w0rp/ale'

" themes/appereance
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox'
Plug 'altercation/vim-colors-solarized'

call plug#end()

colorscheme gruvbox

set background=dark

" vim-colors-solarized {{{
let g:solarized_termcolors=256
" }}}

" Ale {{{
let b:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\	'javascript': ['prettier', 'eslint'],
\}
let g:ale_completion_autoimport = 1
" }}}

" Airline {{{
" enable tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''

" enable powerline fonts
let g:airline_powerline_fonts = 1
let g:airline_left_sep = ''
let g:airline_right_sep = ''

" Switch to your current theme
let g:airline_theme = 'onedark'

" Always show tabs
set showtabline=2

" We don't need to see things like -- INSERT -- anymore
set noshowmode
" }}}



" Spaces & Tabs {{{
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4    " number of spaces to use for autoindent
set expandtab       " tabs are space
set autoindent
set copyindent      " copy indent from the previous line
" }}} Spaces & Tabs
