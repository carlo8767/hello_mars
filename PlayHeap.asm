.data

indexHeap: .word 0
wall: .asciiz  "#"
 
.text
  
  addi $t0, $t0, 4 # ADD ALWAYS INDEX
  addi $t1, $zero, 9 # INDEX

  li $a0, 12# CREATE A SPACE OF 4 BYTE IN THE REGISTER SBRK
  li $v0, 9 # ALLOCATE THE HEAP START ADDRESS
  syscall
  move $s0, $v0
  sw $t0, ($s0) # STORE WORD
  addi $s0, $s0 , 4 # ONLY ADDRESS
  sw $t1, ($s0) # STORE WORD  AT THE NEXT ADDRESSS
  
  la $s1, wall
  lb $s1, ($s1)
  add $a0, $a0, 12
  
  jal loop_full_square_game
  
  move $a0, $v0 # move the 
  addi $v0,$zero, 10 # Exit
  syscall
 
loop_full_square_game:
 # A0 NUMBER OF LINE
 # A1 NUMBER OF COLUNT
 # A2 STORE WORD
 # A3 NEW LINE CHARACTER
 addi $sp, $sp, -4 
 sw $ra, 0($sp)
 jal begin_store
 begin_store:
   addi $sp, $sp, -4 
   sw $ra, 0($sp)
   slt $t3, $a0, $zero # ADD LINE
   beq $t3, $zero exit
   jal storing
 storing:
   sb $a2 ($s0) # STORE THE WORD
   addi $s0, $s0 , 1 # POINT THE NEXT ADDRESS
   sub $a0, $a0, -1 # REDUCTION LINE 
   la $ra 0($sp)
   addi $sp, $sp, 4 # COME BACK TO SQUARE
   jr $ra
 
 exit:
   la $ra 4($sp)
   addi $sp, $sp, 4 # COME BACK TO SQUARE
   jr $ra
  
 


  
  
  
  
  
  
  