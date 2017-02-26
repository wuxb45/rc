" my types
syn keyword cType u8 u16 u32 u64
syn keyword cType s8 s16 s32 s64

syn keyword cType au8 au16 au32 au64
syn keyword cType as8 as16 as32 as64
syn keyword cType abool aflag

" function
syn match cFuncCall /\w\+\s*(/me=e-1,he=e-1
hi def link cFuncCall Function
