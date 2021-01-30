" curl -fLO $HOME/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


set nocompatible		"be iMproved, required
filetype off			"required

set number
set relativenumber


call plug#begin('~/.config/nvim/plugged')
" call plug#begin('~\AppData\Local\nvim\plugged')

"Auto complete
"Plug 'valloric/youcompleteme', { 'do': './install.py --clang-completer --racer-completer --omnisharp-completer --tern-completer' }
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

" themes/appereance
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox'

call plug#end()

colorscheme gruvbox

set background=dark

" Airline {{{
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
" }}}



" Spaces & Tabs {{{
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4    " number of spaces to use for autoindent
set expandtab       " tabs are space
set autoindent
set copyindent      " copy indent from the previous line
" }}} Spaces & Tabs
