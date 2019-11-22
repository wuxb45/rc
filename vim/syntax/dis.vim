if exists("b:current_syntax")
  finish
endif

" Source Code Location (gold)
syn match Type "^/.*:\d\+$"
" ASM Label (pink)
syn match Label "^\x\+ <\w\+>:$"

" INSN
syn region asmline start="^\s*\x\+:" end="$" keepend contains=insnLN,insnBIN,insnASM

" address
syn match insnLN "^\s*\w\+" contained
hi def link insnLN Function

" binary
syn region insnBIN start=":\s"hs=e+1 end="\s\+\t"me=e-2,he=s-1 contained
hi def link insnBIN String

" asm
syn region insnASM start="\s\t\w\+\s"ms=s+1 end="$" contained keepend contains=insnOpc,insnOpr,insnNop

" opcode
syn match insnOpc "\t\w\+" contained
hi def link insnOpc Function

" operands
syn region insnOpr start=" " end="$" contained keepend contains=insnReg,insnConst
hi def link insnOpr Function

" register
syn match insnReg "%\w\+" contained
hi def link insnReg Number

" imm
syn region insnConst start="\W\$\=0x\x\+"ms=s+1 end="\W"me=e-1 contained
syn region insnConst start="\W\$\=\d\+"ms=s+1 end="\W"me=e-1 contained
hi def link insnConst Constant

" nop
syn match insnNop "\tnop\w.*$" contained
syn match insnNop "\txchg\s\+%ax,%ax$" contained
hi def link insnNop Comment

let b:current_syntax = "cdis"
set nofoldenable
