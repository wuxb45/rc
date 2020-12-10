# gdbinit
add-auto-load-safe-path ./
set max-value-size unlimited
set print thread-events off
tui enable
tui new-layout two src 1 status 0 cmd 2
tui new-layout three {-horizontal src 1 asm 1} 1 status 0 cmd 1
tui new-layout four {-horizontal src 1 {regs 1 asm 1} 1} 1 status 0 cmd 1
layout two
focus cmd
