.data
.text
value: .word, 9
.globl main

main :
la $t1, value
li $t2, 9
add $a0, $t1, $t2
li $v0 , 1
syscall 