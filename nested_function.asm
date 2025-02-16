
.data
x: .word 9 # declare local variable x
y: .word 4 # declare local variable y



.text
main:
    lw $a0, x # load X inside the address
    lw $a1, y # load Y inside the address
    jal sum   # jump to sum function
    move $a0, $v0 # move the r+
    addi $v0,$zero, 10 # Exit
    syscall
    
 
# FUNCTION 
sum: 
  addi $sp, $sp, -8 # save space of the stack with 4 bytes for $ra
  sw $ra, 0($sp) #  save the address in the stack for the function
  sw $a1, 4($sp)
  jal  multlipication # call the multiplication
  add  $v0, $v0, $a1 # add x + y
  lw $ra, 0($sp) # return address with offsetS
  add $sp, $sp, 4  # remove space from stack
  add $sp, $sp, 4  # remove space from stack
  jr $ra #`return the address
multlipication:
  mul $v0, $a0, $a0 #  multiply x * x 
  jr $ra

  


