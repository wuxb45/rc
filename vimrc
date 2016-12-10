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
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-H> <C-W>h
nnoremap <C-L> <C-W>l
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

function! MyPluginOptions()
  " Tagbar
  if exists(":TagbarToggle")
    set statusline=%t[%{&fenc},%{&ff}]%m%r%y\ %{tagbar#currenttag('%s','','')}%=%c,%l/%L\ %P
    let g:tagbar_sort = 0
    let g:tagbar_left = 1
    let g:tagbar_indent = 0
    autocmd FileType tagbar setlocal nocursorline nocursorcolumn
    nnoremap <silent> <F9> :TagbarToggle<CR>
  elseif exists(":TlistToggle")
    nnoremap <silent> <F9> :TlistToggle<CR>
  endif
  nnoremap <silent> <F10> :set nu!<CR>

  " MBE
  let g:miniBufExplBuffersNeeded = 1
  let g:miniBufExplCycleArround = 1

  " advanced cscope
  if has('cscope')
    nnoremap <C-F> :call cscope#findInteractive(expand('<cword>'))<CR>
    nnoremap <C-[> :call ToggleLocationList()<CR>
  endif
endfunction

autocmd VimEnter * call MyPluginOptions()
