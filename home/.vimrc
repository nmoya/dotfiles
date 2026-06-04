if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'junegunn/vim-easy-align'
Plug 'https://github.com/junegunn/vim-github-dashboard.git'
Plug 'jacoborus/tender.vim'
call plug#end()

"-----------------------------------------------------
"Theme
if (has("termguicolors"))
 set termguicolors
endif
syntax enable
colorscheme tender
"-----------------------------------------------------



"-----------------------------------------------------
"Global
"Enables autocompletion
set wildmenu
"Dont try to be compatible with vi
set nocompatible
"Right margin configuration (set cc=120 also works)
set colorcolumn=120
"Set command history to max
set history=1000
"Set backspace like expected
set backspace=indent,eol,start
"Set tab to 4 spaces
set tabstop=4
set shiftwidth=4
"Set spaces when pressing tab
set expandtab
"When creating a new line, keep indentation
set smartindent
"-----------------------------------------------------


"-----------------------------------------------------
"File search
"Bult-in plugin for file browsing
filetype plugin on
"Allows file searches in subdirectories
set path+=**
set complete-=i
set wildignore+=**/node_modules/** 
set wildignore+=**/venv/**
set wildignore+=**/.idea/**
set wildignore+=**/*cache*/**
"-----------------------------------------------------



"-----------------------------------------------------
" FILE BROWSING:

" Tweaks for browsing
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'
"-----------------------------------------------------