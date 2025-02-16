.data
# STATIC MEMORY YOU CAN LABEL AND RESERVED SPAC
  array: .data 40 # CREATE AN ARRAY THAT CONTAINS 10 WORD 40 BYTES
 
.text
  add $t1, $zero, 9 # ADD 9 IN THE REGISTER
  la $t0, array # BASE ARRAY
  sw $t1, 0($t0) # STORE 9 AT POSITION 0 BE CAREFUL AT THE BOUNDARY
  add $t1, $zero, 8 # ADD 8 IN THE REGISTER
  sw $t1, 4($t0) # STORE 8 AT POSITION 1
  lw $t2, 0($t0) # LOAD THE VALUE OF THE ARRAY AT 
  move $a0, $t2
  li $v0, 1 # SHOULD PRINT 9
  syscall 
	
  
   

