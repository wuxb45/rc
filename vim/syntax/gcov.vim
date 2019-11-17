if exists("b:current_syntax")
  finish
endif

" (gold) uncovered
syn match srcloc "^\s*#\{5}:\s*\d\+:"
hi def link srcloc Type

" (blue) covered
syn match asmline "^\s*\d\+:\s*\d\+:"
hi def link asmline Function

let b:current_syntax = "gcov"
" set nofoldenable
