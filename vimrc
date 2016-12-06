set nocompatible
set t_Co=256
syntax enable
set tabstop=2
set shiftwidth=2
set softtabstop=2
set backspace=2
set cursorline
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
set scrolloff=3
set laststatus=2
"set spell

colorscheme my256

set encoding=utf-8
set fileformat=unix
set fileencodings=ucs-bom,utf-8,latin1
set fileencoding=utf-8

" map keys for moving cursor between windows
let g:BASH_Ctrl_j = 'off'
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l
" switch to next window in normal mode
nmap <Space> <C-w>w

if has('persistent_undo')
  " mkdir -p ~/.vim/undodir
  set undodir=~/.vim/undodir
  set undofile
  set undolevels=1000
  set undoreload=10000
endif
filetype on

" Tagbar
set statusline=%t[%{&fenc},%{&ff}]%m%r%y\ %{tagbar#currenttag('%s','','')}%=%c,%l/%L\ %P
let g:tagbar_sort = 0
let g:tagbar_left = 1
let g:tagbar_indent = 0
nnoremap <silent> <F9> :TagbarToggle<CR>
nnoremap <silent> <F10> :set nu!<CR>

" MBE
let g:miniBufExplBuffersNeeded = 1
let g:miniBufExplCycleArround = 1

" cscope
if has("cscope")
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
" set spell spelllang=en_us
endif
