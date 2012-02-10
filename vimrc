syntax on
syntax enable
set nocompatible

set tabstop=2
set shiftwidth=2
set softtabstop=2
set backspace=2

set expandtab
set noeb vb t_vb=
set fo-=r

set nu
set hlsearch
set incsearch
set ruler
set autochdir 
set autoread 

set showcmd
set sm
set tags=tags;

set noerrorbells
set novisualbell
set magic
set nolazyredraw
set wildmenu

"if MySys() == "windows"
  "set encoding=cp936
  "set nobackup
  "set nowritebackup
"elseif MySys() == "linux"
  set encoding=utf-8
"endif

set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set fileencoding=utf-8

map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

colorscheme zellner

"for .gvimrc
if has("gui_running")
  set lines=40
  set columns=90
  highlight Normal guibg=#f0f8ff
  "if MySys() == "windows"
  "  set guifont=Consolas:h15
  "elseif MySys() == "linux"
    set guifont=Bitstream\ Vera\ Sans\ Mono\ 10
    "set guifont=VL\ gothic\ 11
  "endif
endif

set undodir=~/.vim/undodir
set undofile
set undolevels=1000
set undoreload=10000
filetype on

" taglist
nnoremap <silent> <F8> :TlistToggle<CR>
let Tlist_Exit_OnlyWindow=1
let Tlist_Show_One_File=1
let Tlist_WinWidth=35

" minibuffer
" use with taglist, set this
let g:miniBufExplModSelTarget = 1
" show minibuffer if has >=2 buffers.
let g:miniBufExplorerMoreThanOne = 2

autocmd BufRead,BufNew :call UMiniBufExplorer

