" curl -fLO $HOME/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"
"sudo apt-get install -y build-essential cmake python3-dev python python3
"sudo apt-get install -y python-pip python3-pip
"pip3 install pynvim
"sudo apt-get install g++-8
"sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 700 --slave /usr/bin/g++ g++ /usr/bin/g++-7
"sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 800 --slave /usr/bin/g++ g++ /usr/bin/g++-8
"
"
" verify and install python {{{
function! s:show_warning_message(hlgroup, msg)
    execute 'echohl ' . a:hlgroup
    echom a:msg | echohl None
endfunction

let s:uname = substitute(system('uname -s'), '\n', '', '')

" Specify python host (preferrably system default) for neovim.
" The 'neovim' package must be installed in that python:
" e.g. /usr/bin/pip install neovim
"  (or /usr/bin/pip3, /usr/local/bin/pip, depending environments)
" The locally installed python (e.g. homebrew) at /usr/local/bin precedes.

let g:python_host_prog  = '/usr/local/bin/python2'
if empty(glob(g:python_host_prog))
    " Fallback if not exists
    let g:python_host_prog = '/usr/bin/python2'
endif

let g:python3_host_prog = ''

if executable("python3")
  " get local python from $PATH (virtualenv/anaconda or system python)
  let s:python3_local = substitute(system("which python3"), '\n\+$', '', '')

  function! Python3_determine_pip_options()
    if system("python3 -c 'import sys; print(sys.prefix != getattr(sys, \"base_prefix\", sys.prefix))' 2>/dev/null") =~ "True"
      " This is probably a user-namespace virtualenv python. `pip` won't accept --user option.
      " See pip._internal.utils.virtualenv._running_under_venv()
      let l:pip_options = '--upgrade --ignore-installed'
    else
      " Probably system(global) or anaconda python.
      let l:pip_options = '--user --upgrade --ignore-installed'
    endif
    " mac: Force greenlet to be compiled from source due to potential architecture mismatch (pynvim#473)
    if s:uname ==? 'Darwin'
      let l:pip_options = l:pip_options . ' --no-binary greenlet'
    endif
    return l:pip_options
  endfunction

  " Detect whether neovim package is installed; if not, automatically install it
  " Since checking pynvim is slow (~200ms), it should be executed after vim init is done.
  call timer_start(0, { -> s:autoinstall_pynvim() })
  function! s:autoinstall_pynvim()
    if empty(g:python3_host_prog) | return | endif
    let s:python3_neovim_path = substitute(system(g:python3_host_prog . " -c 'import pynvim; print(pynvim.__path__)' 2>/dev/null"), '\n\+$', '', '')
    if empty(s:python3_neovim_path)
      " auto-install 'neovim' python package for the current python3 (virtualenv, anaconda, or system-wide)
      let s:pip_options = Python3_determine_pip_options()
      execute ("!" . s:python3_local . " -m pip install " . s:pip_options . " pynvim")
      if v:shell_error != 0
        call s:show_warning_message('ErrorMsg', "Installation of pynvim failed. Python-based features may not work.")
      endif
    endif
  endfunction

  " Assuming that pynvim package is available (or will be installed later), use it as a host python3
  let g:python3_host_prog = s:python3_local
else
  echoerr "python3 is not found on your system. Most features are disabled."
  let s:python3_local = ''
endif

" Fallback to system python3 (if not exists)
if empty(glob(g:python3_host_prog)) | let g:python3_host_prog = '/usr/local/bin/python3' | endif
if empty(glob(g:python3_host_prog)) | let g:python3_host_prog = '/usr/bin/python3'       | endif
if empty(glob(g:python3_host_prog)) | let g:python3_host_prog = s:python3_local          | endif

" Get and validate python version
try
  if executable('python3')
    let g:python3_host_version = split(system("python3 --version 2>&1"))[1]   " e.g. Python 3.7.0 :: Anaconda, Inc.
  else | let g:python3_host_version = ''
  endif
catch
  let g:python3_host_version = ''
endtry

" Warn users if modern python3 is not found.
" (with timer, make it shown frontmost over other warning messages)
if empty(g:python3_host_version)
  call timer_start(0, { -> s:show_warning_message('ErrorMsg',
        \ "ERROR: You don't have python3 on your $PATH. Most features are disabled.")
        \ })
elseif g:python3_host_version < '3.6.1'
  call timer_start(0, { -> s:show_warning_message('WarningMsg',
        \ printf("Warning: Please use python 3.6.1+ to enable intellisense features. (Current: %s)", g:python3_host_version))
        \ })
endif
" }}}

set nocompatible		"be iMproved, required
filetype off			"required

set number
set relativenumber
set splitbelow

call plug#begin('~/.config/nvim/plugged')
" call plug#begin('~\AppData\Local\nvim\plugged')

"Auto complete
Plug 'valloric/youcompleteme', { 'do': './install.py --all --racer-completer --omnisharp-completer --tern-completer --ts-completer' }
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
