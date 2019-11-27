" my types
syn keyword cType u8 u16 u32 u64
syn keyword cType s8 s16 s32 s64

syn keyword cType au8 au16 au32 au64
syn keyword cType as8 as16 as32 as64
syn keyword cType abool

syn keyword cType __m128i __m256i __m512i
syn keyword cType m128 m256 m512

" function
syn match cFuncCall "\w\+\ze\s*("
hi def link cFuncCall Function

" fix the macro defs (the lastest has the highest priority)
syn match cMacro "^\s*#\s*define\s\+\zs\w\+\ze\s*("
hi def link cMacro Macro
let c_gnu=1
let c_no_curly_error=1
