set nocompatible
"set spell

syntax on
syntax enable
"filetype plugin indent on

set tabstop=2
set shiftwidth=2
set softtabstop=2
set backspace=2

if has("gui_running")
  colorscheme delek
else
  colorscheme zellner
endif
"set cursorline
"highlight CursorLine cterm=NONE ctermbg=Gray guibg=Gray
"set cursorcolumn
"highlight CursorColumn cterm=NONE ctermbg=Gray guibg=Gray
"set colorcolumn=81
"highlight ColorColumn cterm=NONE ctermbg=Gray guibg=Gray

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
set showmatch
set tags=tags;

set noerrorbells
set novisualbell
set magic
set nolazyredraw
set wildmenu
set fdm=marker

"set cursorline
set scrolloff=3

"if MySys() == "windows"
  "set encoding=cp936
  "set nobackup
  "set nowritebackup
"elseif MySys() == "linux"
  set encoding=utf-8
"endif

set fileformat=unix
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set fileencoding=utf-8

" map keys for moving cursor between windows
let g:BASH_Ctrl_j = 'off'
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

" switch to next window in normal mode
nmap <Space> <C-w>w

"for .gvimrc
if has("gui_running")
  set guioptions-=T
  set lines=40
  set columns=90
  highlight Normal guibg=#f0f8ff
  "if MySys() == "windows"
  "  set guifont=Consolas:h15
  "elseif MySys() == "linux"
    set guifont=DejaVu\ Sans\ Mono\ 10
    "set guifont=VL\ gothic\ 11
  "endif
endif

if has('persistent_undo')
  " mkdir -p ~/.vim/undodir
  set undodir=~/.vim/undodir
  set undofile
  set undolevels=1000
  set undoreload=10000
endif
filetype on

" taglist
nnoremap <silent> <F9> :TlistToggle<CR>
nnoremap <silent> <F10> :set nu!<CR>
let Tlist_Exit_OnlyWindow=1
let Tlist_Show_One_File=1
let Tlist_WinWidth=35

" minibuffer
" use with taglist, set this
let g:miniBufExplModSelTarget = 1
" show minibuffer if has >=2 buffers.
let g:miniBufExplorerMoreThanOne = 2

" cscope
if has("cscope")
  " set csprg=/usr/local/bin/cscope
  set csto=1
  set cst
  set nocsverb
  " add any database in current directory
  if filereadable("cscope.out")
      cs add cscope.out
  " else add database pointed to by environment
  elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
  endif
  set csverb
endif

" find C symbol.
" nmap <C-->s :cs find s <C-R>=expand("<cword>")<CR><CR>
" find global definition.
" nmap <C-->g :cs find g <C-R>=expand("<cword>")<CR><CR>
" find functions calling this function.
" nmap <C-->c :cs find c <C-R>=expand("<cword>")<CR><CR>
" find this text string.
" nmap <C-->t :cs find t <C-R>=expand("<cword>")<CR><CR>
" find this egrep pattern.
" nmap <C-->e :cs find e <C-R>=expand("<cword>")<CR><CR>
" find this file.
" nmap <C-->f :cs find f <C-R>=expand("<cword>")<CR><CR>
" find files #including this file.
" nmap <C-->i :cs find i <C-R>=expand("<cword>")<CR><CR>
" find functions called by this function.
" nmap <C-->d :cs find d <C-R>=expand("<cword>")<CR><CR>

autocmd BufRead,BufNew :call UMiniBufExplorer

" Reference
" https://github.com/spf13/spf13-vim
" http://amix.dk/vim/vimrc.html

" Set the following lines in your ~/.vimrc or the systemwide /etc/vimrc:
" filetype plugin indent on
" set grepprg=grep\ -nH\ $*
" let g:tex_flavor = "latex"
" 
" Also, this installs to /usr/share/vim/vimfiles, which may not be in
" your runtime path (RTP). Be sure to add it too, e.g:
" set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after

" spell check, use it manually.
" set spell spelllang=en_us
