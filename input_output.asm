.data
buffer_size: .word 0
buffer: .space 1000



.text
  li $t0,  0xffff0000 # ADDRESS REGISTER DATA

  

reading:
  lw $t1 ($t0) # READ KEYBOARD REGISTER
  andi $t1, $t1, 1 # VERIFY BIT CONTROLLER REGISTER IS 1
  beq $t1, $zero, reading # IF CONDITION EXUCTION
  jal poll
# POLLING
poll:
  la $t2 buffer # BUFFER MEMORY TEMPORARY
  lw $t3, 4($t0) # LOAD CHAR ADDRESS KEYBOARD 4 BIT ONE WORD
  add $t2, $t2, $t4 # MOVE BUFFER TO THE NEXT POINTER
  sb $t3, 0($t2) # STORE THE BIT
  add $t4, $t4, 1 # ADD SIZE WORD BUFFER
  sw $t4, buffer_size # ADD NEW SIZE INSIDE THE LABEL STATIC
  jr $ra
 
  
# EXIT
exit:
  addi $v0,$zero, 10 # EXIT
  syscall
  
  
# DISABLE INTERRUPATION FROM THE KEYBOARD
disable_interruption:    
  li $t0, 0xffff0000 # ADDRESS CONTROLLER REGISTER ADDRESS INPUT
  li $t1, 0 # CLEAR INTERRUPTION SET OF REGISTER DATA ON 0 
  andi $t1, $t1, 1 # VERIFY THAT THE REGISTER DATA IS FINISH TO LISTEN BITWISE OPERATION SINGLE BIT
  beq $t1, $zero, exit


