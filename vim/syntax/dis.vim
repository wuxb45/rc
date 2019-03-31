if exists("b:current_syntax")
    finish
endif

" Source Code Location (gold)
syn match srcloc "^/.*:\d\+$"
hi def link srcloc Type

" INSN (blue)
syn match asmline "^ \+\x\+:\s.*$"
hi def link asmline Function

" ASM Label (pink)
syn match entryline "^\x\+ <\w\+>:$"
hi def link entryline Label

let b:current_syntax = "cdis"
