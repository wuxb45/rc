set nocompatible
filetype on
syntax enable
set t_Co=256 tabstop=2 shiftwidth=2 softtabstop=2 backspace=2
set autochdir autoread cursorline expandtab hlsearch incsearch
set magic number showcmd showmatch wildmenu
set tags=tags; fdm=marker scrolloff=3 laststatus=2
set encoding=utf-8 fileformat=unix
set fileencodings=ucs-bom,utf-8,latin1 fileencoding=utf-8
colorscheme my256
match ErrorMsg '\s\+$'
" moving cursor over windows
let g:BASH_Ctrl_j = 'off'
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-H> <C-W>h
nnoremap <C-L> <C-W>l
nmap <Space> <C-w>w

if has('persistent_undo')
  set undodir=~/.vim/undodir undofile undolevels=1000 undoreload=10000
endif

function! MyPluginOptions()
  " Tagbar
  if exists(":TagbarToggle")
    set statusline=%t%m\ [%{&fenc},%{&ff}]%y%r\ %{tagbar#currenttag('%s','','')}%=%c,%l/%L\ %P
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
endfunction
autocmd VimEnter * call MyPluginOptions()
