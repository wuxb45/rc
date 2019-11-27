if exists("b:current_syntax")
  finish
endif

" (gold) uncovered "#####:" and nocode "-:"
syn match Statement "^\s*#\{5}:\s*\d\+:\zs.*$"
syn match Type "^\s*-:\s*\d\+:\zs.*$"

" (blue) covered
syn match execLine "^\s*\d\+.*$" contains=execHead,execCode keepend
syn match execHead "^\s*\d\+\*\=" contained nextgroup=execCode
hi def link execHead Comment
syn match execCode ":\s*\d\+:\zs.*$" contained
hi def link execCode Function

let b:current_syntax = "gcov"
" set nofoldenable
