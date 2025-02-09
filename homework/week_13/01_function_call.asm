
.data
.text
	
    li $a0, 3
    li $a1, 4
    jal double_sum
    lw $a0, $v0
    addi $v0, $zero, 1 # PRINT THE VALUE
    syscall     
    addi $v0, $zero, 10
    syscall
  sum : 
    add $v0, $a0, $a1 # ADD TWO ARGUMENT TOGHETHER
    jr $ra
    
  double_sum:
    addi $sp $sp, -8
    sw $ra, 0($sp) # SAVE ADDRESS IN THE STACK
    jal sum # CALL THE SUM FUNCTION TWO TIME
    sw $v0, 4($sp) # STORE IN THE STACK THE SUM 
    jal sum # CALL THE SUM FUNCTION TWO TIME
    lw $v1 4($sp) # LOAD IN V1 THE PREVIOUS SUM
    add $v0, $v0, $v1 # SUM TOGHETHER
    lw $ra, 0($sp) # LOAD THE ADDRESS
    add $sp, $sp, 8  # REMOVE SPACE FROM THE STACK	  
    jr $ra
 
