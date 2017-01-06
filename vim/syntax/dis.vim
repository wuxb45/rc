if exists("b:current_syntax")
    finish
endif
syn match srcloc "^/.*:\d\+$"
hi def link srcloc Type

" asm
syn match asmline "^ \+\x\+:.*$"
hi def link asmline Function

syn match entryline "^\x\+ <\w\+>:$"
hi def link entryline Label

let b:current_syntax = "cdis"
