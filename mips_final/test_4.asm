ori  $30, $0, 30
ori  $31, $0, 31
sw   $31, 8($0)
lw   $20, 8($0)
addi $20, $20, 1
nop
nop
nop
halt
end