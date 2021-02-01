" curl -fLO $HOME/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


set nocompatible		"be iMproved, required
filetype off			"required

set number
set relativenumber
set splitbelow

if has('python3')
endif

call plug#begin('~/.config/nvim/plugged')
" call plug#begin('~\AppData\Local\nvim\plugged')

"Auto complete
"Plug 'valloric/youcompleteme', { 'do': './install.py --clang-completer --racer-completer --omnisharp-completer --tern-completer' }
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" for deoplete run auto complete in python need to: pip install pynvim jedi
Plug 'zchee/deoplete-jedi'

" editing
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-repeat'
Plug 'jiangmiao/auto-pairs'
" to use auto format nedd: pip install yapf
Plug 'sbdchd/neoformat'

" navigation/search files
Plug 'scrooloose/nerdtree'

" git
Plug 'tpope/vim-fugitive'

" syntax
Plug 'mattn/emmet-vim'
Plug 'w0rp/ale'
Plug 'davidhalter/jedi-vim'

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
" }}} Spaces & Tabs"

" Deoplete config {{{
let g:deoplete#enable_at_startup = 1
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
" }}}

" Neoformat {{{
" Enable alignment
let g:neoformat_basic_format_align = 1

" Enable tab to space conversion
let g:neoformat_basic_format_retab = 1

" Enable trimmming of trailing whitespace
let g:neoformat_basic_format_trim = 1
" }}}

" jedi {{{
" disable autocompletion, because we use deoplete for completion
let g:jedi#completions_enabled = 0

" open the go-to function in split, not another buffer
let g:jedi#use_splits_not_buffers = "right"

" }}}
