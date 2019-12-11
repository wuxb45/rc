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
syn match insnLN "^\s*\x\+" contained nextgroup=insnBIN
hi def link insnLN Function

" binary
"syn region insnBIN start=":\t"hs=e+1 end="\s\+\t"me=e-1,he=s-1 contained nextgroup=insnASM
syn match insnBIN ":\t[^\t]\+"hs=s+2 contained nextgroup=insnASM
hi def link insnBIN String

" asm
syn region insnASM start="\t" end="$" contained keepend contains=insnOpc,insnNop

" opcode
syn match insnOpc "\t\S\+" contained nextgroup=insnOpr
hi def link insnOpc Statement

" operands
syn region insnOpr start="\s" end="$" contained keepend contains=insnReg,insnConst
hi def link insnOpr Function

" register
syn match insnReg "%[0-9a-zA-Z.]\+" contained
hi def link insnReg Number

" imm
syn region insnConst start="\W[\$\#]-\=0x\x\+"ms=s+1 end="\W"me=e-1 contained
syn region insnConst start="\W[\$\#]-\=\d\+"ms=s+1 end="\W"me=e-1 contained
hi def link insnConst Constant

" nop
syn match insnNop "\tnop\w\=.*$" contained
syn match insnNop "\txchg\s\+%ax,%ax$" contained
hi def link insnNop Comment

let b:current_syntax = "cdis"
set nofoldenable
