# gdbinit
add-auto-load-safe-path ./
set max-value-size unlimited
tui new-layout all {-horizontal {regs 1 asm 1} 2 src 3} 3 status 0 cmd 2
tui enable
