.data
x: .word, 2
y: .word, 3
.text
.globl main

main:
la $t1, x
la $t2, y
beq $t1, $t2, L11 # LINE JUMp  ANOTHER INSTRUCTION label
li $v0, 4
L11: