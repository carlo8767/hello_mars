.text
main:
    lw $a0, x # load the value inside the address
    lw $a1, y # load the value inside the address
    jal sum # jump to sum function
    move $a0, $v0
    li $v0, 1 # print the value
    syscall 
    addi $v0,$zero, 10
    syscall
    
 
# FUNCTION 
sum: 
  add  $v0, $a0, $a1 # add x + y
  jr $ra

.data
x: .word 5 # declare local variable x
y: .word 9 # declare local variable y
