" my types
syn keyword cType i8 u8 i16 u16 i32 u32 i64 u64
syn keyword cType ai8 au8 ai16 au16 ai32 au32 ai64 au64
syn keyword cType abool aflag

" function
syn match cFuncCall /\w\+\s*(/me=e-1,he=e-1
hi def link cFuncCall Function
