set nocompatible
filetype on
syntax enable
set t_Co=256 tabstop=2 shiftwidth=2 softtabstop=2 backspace=2
set autochdir autoread cursorline expandtab hlsearch incsearch
set noai magic number showcmd showmatch wildmenu mouse=
set tags=tags; fdm=marker scrolloff=3 laststatus=2
set encoding=utf-8 fileformat=unix
set fileencodings=ucs-bom,utf-8,latin1 fileencoding=utf-8
colorscheme my256
match Search '\s\+$'  "Search: Orange; ErrorMsg: Red; SpellBad: Pink
" indentation: (default at http://vimdoc.sourceforge.net/htmldoc/indent.html)
" changed: :0 (switch-case); ls (case-block)
set cinoptions=>s,e0,n0,f0,{0,}0,^0,L-1,:0,=s,ls,b0,gs,hs,ps,ts,is,+s,c3,C0,/0,(2s,us,U0,w0,W0,m0,j0,J0,)20,*70,#0

" Fn keys
nnoremap <silent> <F5> :NERDTreeToggle<CR>
nnoremap <silent> <F9> :TagbarToggle<CR>
nnoremap <silent> <F10> :set nu!<CR>

" disable default C-j mapping
let g:BASH_Ctrl_j = 'off'
" space: switch window
nnoremap <Space> <C-W>w

" gtags search (search symbol and open folding)
nnoremap <C-K> :GtagsCursor<CR>zO
" gtags next (next item in quickfix list and open folding)
nnoremap <C-N> :cn<CR>zO
" gtags prev (previous item in quickfix list and open folding)
nnoremap <C-P> :cp<CR>zO

" ctags: show list if more than one is found
nnoremap <C-]> g<C-]>

" disable netrw
let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1

if has('persistent_undo')
  set undodir=~/.vim/undodir undofile undolevels=1000 undoreload=10000
endif

function MyPluginOptions()
  " Tagbar
  if exists(":TagbarToggle")
    set statusline=%t%m\ [%{&fenc},%{&ff}]%y%r\ %{tagbar#currenttag('%s','','')}%=\|%c\|\ -%l/%L-\ %P
    let g:tagbar_sort = 0
    let g:tagbar_left = 1
    let g:tagbar_indent = 0
    autocmd FileType tagbar setlocal nocursorline nocursorcolumn
  endif
  " MBE
  let g:miniBufExplBuffersNeeded = 1
  let g:miniBufExplCycleArround = 1
endfunction
au VimEnter * call MyPluginOptions()

" autoexit if quickfix is the last window
au BufEnter * if &buftype=="quickfix" && winnr('$') == 1 | quit | endif

" remember last position
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
